import 'package:flutter_lv2_course/common/model/cursor_pagination_model.dart';
import 'package:flutter_lv2_course/common/model/pagination_params.dart';
import 'package:flutter_lv2_course/restaurant/model/restaurant_model.dart';
import 'package:flutter_lv2_course/restaurant/repository/restaurant_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final restaurantProvider =
    StateNotifierProvider<RestaurantStateNotifier, CursorPaginationBase>(
  (ref) {
    final repository = ref.watch(restaurantRepositoryProvider);
    final notifier = RestaurantStateNotifier(repository: repository);

    return notifier;
  },
);

class RestaurantStateNotifier extends StateNotifier<CursorPaginationBase> {
  final RestaurantRepository repository;

  RestaurantStateNotifier({
    required this.repository,
  }) : super(CursorPaginationLoading()) {
    // 이 클래스가 인스턴스화 되는 순간 paginate() 함수가 실행됨.
    paginate();
  }

  // 홈 화면 페이지 데이터 가져오는 함수
  paginate({
    int fetchCount = 20,
    bool fetchMore =
        false, // 추가로 데이터 더 가져오기 - true(더 가져옴), false(새로고침, 현재상태 덮어씌움)
    // 강제로 다시 로딩하기
    // true - CursorPaginationLoading()
    // false -
    bool forceRefetch = false,
  }) async {
    try {
      // 5가지 가능성
      // state의 상태( CursorPaginationBase를 상속하는 클래스 숫자)
      // [상태가]
      // 1) CursorPagination - 정상적으로 데이터가 있는 상태
      // 2) CursorPaginationLoading - 데이터가 로딩중인 상태( 현재 캐시 없음)
      // 3) CursorPaginationError - 에러가 있는 상태
      // 4) CursorPaginationRefetching - 첫번째 페이지부터 다시 데이터를 가져올때
      // 5) CursorPaginationFetchMore - 추가 데이터를 paginate 해오라는 요청을 받았을때

      // 바로 반환하는 상황
      // 1) hasMore가 false 일때,(기존 상태에서 추가 데이터가 없다는 값을 들고있다면)
      // 2) 로딩중 - fetchMore : true 일때
      //         fetchMore가 아닐때 - 새로고침의 의도가 있을 수 있다.
      if (state is CursorPagination && !forceRefetch) {
        // casting
        final pState = state as CursorPagination;

        if (!pState.meta.hasMore) {
          // pState.meta.hasMore = false 일때 return
          // 더 이상 새로운 데이터가 없을때
          return;
        }
      }

      // fetchMore가 true 일때의 3가지 로딩 상태
      final isLoading = state is CursorPaginationLoading; // 완전 처음 로딩
      final isRefetching = state is CursorPaginationRefetching; // 새로고침 로딩
      final isFetchingMore = state is CursorPaginationFetchingMore;

      // 2번 반환 상황
      if (fetchMore && (isLoading || isRefetching || isFetchingMore)) {
        return;
      }

      // PaginationParams 생성
      PaginationParams paginationParams = PaginationParams(
        count: fetchCount,
      );

      // fetchMore = true일때
      // 데이터를 추가로 더 가져오는 상황
      if (fetchMore) {
        final pState = state as CursorPagination;

        state =
            CursorPaginationFetchingMore(meta: pState.meta, data: pState.data);

        paginationParams = paginationParams.copyWith(
          after: pState.data.last.id,
        );
      }
      // 데이터를 처음부터 가져오는 상황
      else {
        // 만약에 데이터가 있는 상황이라면
        // 기존 데이터를 보존한채로 fetch(api 요청)를 진행
        if (state is CursorPagination && !forceRefetch) {
          final pState = state as CursorPagination;

          state = CursorPaginationRefetching(
            meta: pState.meta,
            data: pState.data,
          );
        }
        // 나머지 상황
        // 데이터를 유지할 필요가 없는 상황
        else {
          state = CursorPaginationLoading();
        }
      }

      // 서버에 새로운 데이터 요청 보냄
      final resp = await repository.paginate(
        // after 변수에 리스트 맨 마지막 id 보내서 그 이후의 데이터를 가져오게 된다.
        paginationParams: paginationParams,
      );

      if (state is CursorPaginationFetchingMore) {
        final pState = state as CursorPaginationFetchingMore;

        // 기존 데이터에
        // 새로운 데이터 추가
        state = resp.copyWith(data: [
          ...pState.data, // 기존 데이터
          ...resp.data, // 새로 불러온 데이터
        ]);
      } else {
        // 1) CursorPaginationLoading 이거나
        // 2) CursorPaginationRefetching 이면,
        // 3) after 값을 변경하지 않은 상태

        // 처음 가져온 20개의 데이터를 그대로 보여줌.
        state = resp;
      }
    } catch (e) {
      state = CursorPaginationError(message: '데이터를 가져오지 못 했습니다.');
    }
  }
}
