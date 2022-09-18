import 'dart:math';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lv2_course/common/const/data.dart';
import 'package:flutter_lv2_course/common/dio/dio.dart';
import 'package:flutter_lv2_course/common/model/cursor_pagination_model.dart';
import 'package:flutter_lv2_course/common/utils/pagination_utils.dart';
import 'package:flutter_lv2_course/restaurant/component/restaurant_card.dart';
import 'package:flutter_lv2_course/restaurant/model/restaurant_model.dart';
import 'package:flutter_lv2_course/restaurant/provider/restaurant_provider.dart';
import 'package:flutter_lv2_course/restaurant/repository/restaurant_repository.dart';
import 'package:flutter_lv2_course/restaurant/view/restaurant_detail_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RestaurantScreen extends ConsumerStatefulWidget {
  const RestaurantScreen({super.key});

  @override
  ConsumerState<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends ConsumerState<RestaurantScreen> {
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();

    controller.addListener(scrollListener);
  }

  void scrollListener() {
    PaginationUtils.paginate(
      controller: controller,
      provider: ref.read(restaurantProvider.notifier),
    );
  }
  // 현재 위치가
  // 최대 길이보다 조금 덜되는 위치까지 왔다면
  // 새로운 데이터를 추가요청
  // if (controller.offset > controller.position.maxScrollExtent - 300) {
  //   ref.read(restaurantProvider.notifier).paginate(
  //         fetchMore: true,
  //       );
  // }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(restaurantProvider);

    // 완전 처음 로딩일때
    if (data is CursorPaginationLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // 에러
    if (data is CursorPaginationError) {
      return Center(
        child: Text(data.message),
      );
    }

    // 나머지 상태 클래스들은 CursorPagination의 child임
    // CursorPagination
    // CursorPaginationFetchingMore extends CursorPagination
    // CursorPaginationRefetching extends CursorPagination

    final cp = data as CursorPagination;

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView.separated(
          controller: controller,
          itemCount:
              cp.data.length + 1, // 마지막 스크롤 부분에 데이터 불러올때 로딩화면 보여주기 위해 +1을 더함
          itemBuilder: (_, index) {
            if (index == cp.data.length) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Center(
                  child: data is CursorPaginationFetchingMore
                      ? const CircularProgressIndicator()
                      : const Text('마지막 데이터 입니다. ㅠㅜ'),
                ),
              );
            }

            final pItem = cp.data[index];

            return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => RestaurantDetailScreen(
                            id: pItem.id,
                          )));
                },
                child: RestaurantCard.fromModel(model: pItem));
          },
          separatorBuilder: (_, index) {
            return const SizedBox(height: 16.0);
          },
        ));
  }
}
