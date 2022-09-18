import 'package:flutter_lv2_course/common/model/cursor_pagination_model.dart';
import 'package:flutter_lv2_course/common/provider/pagination_provider.dart';
import 'package:flutter_lv2_course/rating/model/rating_model.dart';
import 'package:flutter_lv2_course/rating/rating_card.dart';
import 'package:flutter_lv2_course/restaurant/repository/restaurant_rating_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// provider 생성
final restaurantRatingProvider = StateNotifierProvider.family<
    RestaurantRatingStateNotifier, CursorPaginationBase, String>(
  (ref, id) {
    final repo = ref.watch(restaurantRatingRepositoryProvider(id));

    return RestaurantRatingStateNotifier(repository: repo);
  },
);

class RestaurantRatingStateNotifier
    extends PaginationProvider<RatingModel, RestaurantRatingRepository> {
  // final RestaurantRatingRepository repository;

  RestaurantRatingStateNotifier({
    required super.repository,
  });
}
