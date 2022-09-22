import 'package:flutter/material.dart';
import 'package:flutter_lv2_course/common/component/pagination_list_view.dart';
import 'package:flutter_lv2_course/restaurant/component/restaurant_card.dart';
import 'package:flutter_lv2_course/restaurant/provider/restaurant_provider.dart';
import 'package:flutter_lv2_course/restaurant/view/restaurant_detail_screen.dart';

class RestaurantScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PaginationListView(
      provider: restaurantProvider,
      itemBuilder: <RestaurantModel>(_, index, model) {
        return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => RestaurantDetailScreen(
                        id: model.id,
                      )));
            },
            child: RestaurantCard.fromModel(model: model));
      },
    );
  }
}
