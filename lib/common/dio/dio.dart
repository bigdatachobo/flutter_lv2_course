import 'package:dio/dio.dart';
import 'package:flutter_lv2_course/common/const/data.dart';
import 'package:flutter_lv2_course/common/secure_storage/secure_storage.dart';
import 'package:flutter_lv2_course/user/provider/auth_provider.dart';
import 'package:flutter_lv2_course/user/provider/user_me_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();

  final storage = ref.watch(secureStorageProvider);

  dio.interceptors.add(
    CustomInterceptor(
      storage: storage,
      ref: ref,
    ),
  );

  return dio;
});

class CustomInterceptor extends Interceptor {
  final FlutterSecureStorage storage;
  final Ref ref;

  CustomInterceptor({
    required this.storage,
    required this.ref,
  });

  // 1) 요청 보낼때
  // 요청이 보내질때마다
  // 만약 요청의 Header에 accessToken: true 라는 값이 있다면
  // 실제 토큰을 가져와서 (storage에서) authorization : bearer $token으로
  // 헤더를 변경한다.
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    print('[REQ] [${options.method}] ${options.uri}');

    // accessToken
    if (options.headers['accessToken'] == 'true') {
      // 헤더 삭제(요청 헤더 인터셉트 부분)
      options.headers.remove('accessToken');
      // storage에서 토큰 가져오는 부분
      final token = await storage.read(key: ACCESS_TOKEN_KEY);

      // 실제 토큰 헤더에 삽입
      options.headers.addAll({
        'authorization': 'Bearer $token',
      });
    }
    // refreshToken
    if (options.headers['refreshToken'] == 'true') {
      // 헤더 삭제
      options.headers.remove('refreshToken');

      final token = await storage.read(key: REFRESH_TOKEN_KEY);

      // 실제 토큰 삽입
      options.headers.addAll({
        'authorization': 'Bearer $token',
      });
    }

    return super.onRequest(options, handler);
  }

  // 2) 응답을 받을때
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print(
        '[RES] [${response.requestOptions.method}] ${response.requestOptions.uri}');

    return super.onResponse(response, handler);
  }

  // 3) 에러가 났을때
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    print('[ERR] [${err.requestOptions.method}] ${err.requestOptions.uri}');

    // 401(토큰이 잘못되었을때) 에러가 났을때(status code)
    // 토큰을 재발급 받는 시도를하고 토큰이 재발급되면
    // 다시 새로운 토큰으로 요청을 한다.
    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);

    // refreshToken 아예 없으면
    // 당연히 에러를 던진다.
    if (refreshToken == null) {
      // 에러를 던질때는 handler.reject를 사용한다.
      return handler.reject(err);
    }

    // 토큰이 잘못되었다는 에러 반환
    final isStatus401 = err.response?.statusCode == 401;

    //token을 refresh하려다가 에러가 났는지 아닌지 확인
    // True일때, 에러 원인의 path가 토큰 리프레시 path 였다는것은
    // refreshToken에 문제가 있다는 것을 의미함.
    final isPathRefresh = err.requestOptions.path == '/auth/token';

    // 401 에러이면서 토큰 레프레시할 예정이 없었는데도 에러가 났다면
    // refreshToken을 보내서 새로운 AccessToken을 다시 발급 받는다.
    if (isStatus401 && !isPathRefresh) {
      final dio = Dio();

      try {
        // refreshToken 재발급
        final resp = await dio.post(
          'https://$ip/auth/token',
          options: Options(
            headers: {
              'authorization': 'Bearer $refreshToken',
            },
          ),
        );

        // 다시 발급받은 accessToken
        final accessToken = resp.data['accessToken'];

        // 에러를 발생시킨 모든 요청(json)들을 options에 저장
        final options = err.requestOptions;

        // 토큰 변경하기
        options.headers.addAll({
          'authorization': 'Bearer $accessToken',
        });

        await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);

        // 요청 재전송
        final response = await dio.fetch(options);
        // 요청 성공 반환
        return handler.resolve(response);
      } on DioError catch (e) {
        // circular dependency error
        // A, B
        // A -> B의 친구
        // B -> A의 친구
        // A는 B의 친구구나
        // A -> B -> A -> B.....

        // ump -> dio -> ump -> dio -> ump -> dio...
        // 이런 문제(순환 종속성 문제)에 빠진다면 상위에 객체를 하나 더 만든다.
        ref.read(authProvider.notifier).logout();
        // 요청 실패 에러 반환
        return handler.reject(err);
      }
    }

    return handler.reject(err);
  }
}
