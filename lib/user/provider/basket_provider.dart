import 'package:flutter_lv2_course/product/model/product_model.dart';
import 'package:flutter_lv2_course/user/model/basket_item_model.dart';
import 'package:flutter_lv2_course/user/model/patch_basket_body.dart';
import 'package:flutter_lv2_course/user/repository/user_me_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';

final basketProvider =
    StateNotifierProvider<BasketProvider, List<BasketItemModel>>((ref) {
  final repository = ref.watch(userMeRepositoryProvider);
  return BasketProvider(
    repository: repository,
  );
});

class BasketProvider extends StateNotifier<List<BasketItemModel>> {
  final UserMeRepository repository;

  BasketProvider({
    required this.repository,
  }) : super([]);

  // 장바구니 요청보내기
  Future<void> patchBasket() async {
    await repository.patchBasket(
      body: PatchBasketBody(
        basket: state
            .map((e) => PatchBasketBodyBasket(
                  productId: e.product.id,
                  count: e.count,
                ))
            .toList(),
      ),
    );
  }

  Future<void> addToBasket({
    required ProductModel product,
  }) async {
    // 지금까진
    // 요청을 먼저 보내고
    // 응답이 오면
    // 캐시를 업데이트 했다.

    // 1) 아직 장바구니에 해당되는 상품이 없다면
    //    장바구니에 상품을 추가한다.
    // 2) 만약에 이미 들어있다면
    //    장바구니에 잇는 값에 +1을 한다.

    // 상품이 들어있는지 아닌지 확인
    // 첫번째 값이 있거나, 없으면 null 반환.
    // null 아닐때 존재한다고 가정.
    final exists =
        state.firstWhereOrNull((e) => e.product.id == product.id) != null;

    if (exists) {
      state = state
          .map(
            (e) =>
                e.product.id == product.id ? e.copyWith(count: e.count + 1) : e,
          )
          .toList();
    } else {
      state = [...state, BasketItemModel(product: product, count: 1)];
    }

    // Optimistic Response (긍정적 응답)
    // 응답이 성공할거라고 가정하고 상태를 먼저 업데이트함.
    await patchBasket();
  }

  Future<void> removeFromBasket({
    required ProductModel product,
    bool isDelete = false, // true면 count와 상관없이 강제 삭제.
  }) async {
    // 1) 장바구니에 상품이 존재할때는
    //    1-1) 상품의 카운트가 1보다 크면 -1한다.
    //    1-2) 상품의 카운트가 1이면 삭제한다.

    // 2) 상품이 존재하지 않을때
    //    즉시 함수를 반환하고 아무것도 하지 않는다.

    final exists =
        state.firstWhereOrNull((e) => e.product.id == product.id) != null;

    // 애초에 상품이 없을때 그냥 반환함.
    if (!exists) {
      return;
    }

    // 상품이 있을때
    final existingProduct = state.firstWhere((e) => e.product.id == product.id);

    if (existingProduct.count == 1 || isDelete) {
      // 상품 카운트가 1일때, 필터링을 한다.
      // 삭제하려고하는 상품이 아닌것만 걸러서
      // state에 다시 넣어준다.
      // 즉, 삭제하려는 상품을 삭제하는 로직
      // 혹은 isDelete이 true이면 삭제한다.
      state = state
          .where(
            (e) => e.product.id != product.id,
          )
          .toList();
    } else {
      // count가 1 이상일때
      state = state
          .map(
            (e) =>
                e.product.id == product.id ? e.copyWith(count: e.count - 1) : e,
          )
          .toList();
    }
    // 요청 보내기
    await patchBasket();
  }
}
