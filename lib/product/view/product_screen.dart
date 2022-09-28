import 'package:flutter/material.dart';
import 'package:flutter_lv2_course/common/component/pagination_list_view.dart';
import 'package:flutter_lv2_course/common/model/cursor_pagination_model.dart';
import 'package:flutter_lv2_course/common/provider/pagination_provider.dart';
import 'package:flutter_lv2_course/product/component/product_card.dart';
import 'package:flutter_lv2_course/product/provider/product_provider.dart';
import 'package:flutter_lv2_course/restaurant/view/restaurant_detail_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProductScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PaginationListView(
        provider: productProvider,
        itemBuilder: <ProductModel>(_, index, model) {
          return GestureDetector(
              onTap: () {
                context.goNamed(RestaurantDetailScreen.routeName, params: {
                  'rid': model.restaurant.id,
                });
              },
              child: ProductCard.fromProductModel(model: model));
        });
  }
}
