import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lv2_course/common/const/data.dart';
import 'package:flutter_lv2_course/common/dio/dio.dart';
import 'package:flutter_lv2_course/common/layout/default_layout.dart';
import 'package:flutter_lv2_course/product/component/product_card.dart';
import 'package:flutter_lv2_course/restaurant/component/restaurant_card.dart';
import 'package:flutter_lv2_course/restaurant/model/restaurant_detail_model.dart';
import 'package:flutter_lv2_course/restaurant/repository/restaurant_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RestaurantDetailScreen extends ConsumerWidget {
  final String id;
  const RestaurantDetailScreen({
    required this.id,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultLayout(
        title: '불타는 떡볶이',
        child: FutureBuilder<RestaurantDetailModel>(
            future: ref
                .watch(restaurantRepositoryProvider)
                .getRestaurantDetail(id: id),
            builder: (_, AsyncSnapshot<RestaurantDetailModel> snapshot) {
              print(snapshot.data);
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return CustomScrollView(
                slivers: [
                  renderTop(model: snapshot.data!),
                  renderLabel(),
                  renderProduct(products: snapshot.data!.products),
                ],
              );
            }));
  }

  SliverPadding renderLabel() {
    return const SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverToBoxAdapter(
          child: Text(
        '메뉴',
        style: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w500,
        ),
      )),
    );
  }

  SliverPadding renderProduct({
    required List<RestaurantProductModel> products,
  }) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
        (context, index) {
          final model = products[index];

          return Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: ProductCard.fromModel(
              model: model,
            ),
          );
        },
        childCount: products.length,
      )),
    );
  }

  SliverToBoxAdapter renderTop({
    required RestaurantDetailModel model,
  }) {
    return SliverToBoxAdapter(
      // 일반 위젯을 넣기위한 위젯
      child: RestaurantCard.fromModel(
        model: model,
        isDetail: true,
      ),
    );
  }
}