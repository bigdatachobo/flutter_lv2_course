import 'package:flutter_lv2_course/common/model/cursor_pagination_model.dart';
import 'package:flutter_lv2_course/common/model/pagination_params.dart';
import 'package:flutter_lv2_course/common/provider/pagination_provider.dart';
import 'package:flutter_lv2_course/restaurant/model/restaurant_model.dart';
import 'package:flutter_lv2_course/restaurant/repository/restaurant_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';

final restaurantDetailProvider =
    Provider.family<RestaurantModel?, String>((ref, id) {
  final state = ref.watch(restaurantProvider);

  // is! -> is not
  if (state is! CursorPagination) {
    return null;
  }

  return state.data.firstWhereOrNull((element) => element.id == id);
});

final restaurantProvider =
    StateNotifierProvider<RestaurantStateNotifier, CursorPaginationBase>(
  (ref) {
    final repository = ref.watch(restaurantRepositoryProvider);
    final notifier = RestaurantStateNotifier(repository: repository);

    return notifier;
  },
);

// PaginationProvider가 이미 StateNotifier를 상속받고 있기 때문에
// 따로 상속받지 않아도 된다.
class RestaurantStateNotifier
    extends PaginationProvider<RestaurantModel, RestaurantRepository> {
  // final RestaurantRepository repository;
  // PaginationProvider를 상속받고 있기에 repository가 필요없게됨.
  // 아래 생성자에서 상위 class로 repository를 보내버리면 되기에 이 클래스에선 삭제.

  RestaurantStateNotifier({
    required super.repository,
  });

  void getDetail({
    required String id,
  }) async {
    // 만약에 아직 데이터가 하나도 없는 상태라면 (CursorPagination이 아니라면)
    // 데이터를 가져오는 시도를 한다.
    if (state is! CursorPagination) {
      await this.paginate();
    }

    // 위에서 paginate()를 했는데도,
    // state가 CursorPagination이 아닐때 그냥 null return
    // 상세값을 가져올 수 없는 상태(서버 에러)
    if (state is! CursorPagination) {
      return;
    }

    // 이 단계부터는 무조건 CursorPagination이라고 볼 수 있다.
    final pState = state as CursorPagination;

    final resp = await repository.getRestaurantDetail(id: id);

    // [ RestaurantModel(1), RestaurantModel(2), RestaurantModel(3) ]
    // 요청 id: 10
    // list.where((e) => e.id == 10) 데이터 X
    // 데이터가 없을때는 그냥 캐시의 끝에다가 데이터를 추가해버린다.
    // [ RestaurantModel(1), RestaurantModel(2), RestaurantModel(3),
    // RestaurantDetailModel(10) ]
    if (pState.data.where((e) => e.id == id).isEmpty) {
      state = pState.copyWith(data: <RestaurantModel>[
        ...pState.data,
        resp,
      ]);
    } else {
      // [ RestaurantModel(1), RestaurantModel(2), RestaurantModel(3) ]
      // id : 2 인 친구의 Detail 모델을 가져와라
      // getDetail(id:2);
      // [ RestaurantModel(1), RestaurantDetailModel(2), RestaurantModel(3) ]
      state = pState.copyWith(
        data: pState.data
            .map<RestaurantModel>((e) => e.id == id ? resp : e)
            .toList(),
      );
    }
  }
}
