import 'package:flutter/material.dart';
import 'package:flutter_lv2_course/common/provider/go_router.dart';
import 'package:flutter_lv2_course/common/view/splash_screen.dart';
import 'package:flutter_lv2_course/user/provider/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_lv2_course/user/view/login_screen.dart';

void main() {
  runApp(ProviderScope(
    child: _App(),
  ));
}

class _App extends ConsumerWidget {
  const _App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      theme: ThemeData(
        fontFamily: 'NotoSans', // 폰트 설정
      ),

      debugShowCheckedModeBanner: false, // debug 표시 제거
      routerDelegate: router.routerDelegate,
      routeInformationParser: router.routeInformationParser,
      routeInformationProvider: router.routeInformationProvider,
    );
  }
}
