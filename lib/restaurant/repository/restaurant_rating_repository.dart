import 'package:flutter_lv2_course/common/const/data.dart';
import 'package:flutter_lv2_course/common/dio/dio.dart';
import 'package:flutter_lv2_course/common/model/cursor_pagination_model.dart';
import 'package:flutter_lv2_course/common/model/pagination_params.dart';
import 'package:flutter_lv2_course/common/repository/base_pagination_repository.dart';
import 'package:flutter_lv2_course/rating/model/rating_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart' hide Headers;

part 'restaurant_rating_repository.g.dart';

final restaurantRatingRepositoryProvider =
    Provider.family<RestaurantRatingRepository, String>((ref, id) {
  final dio = ref.watch(dioProvider);
  return RestaurantRatingRepository(dio,
      baseUrl: 'https://$ip/restaurant/$id/rating');
});

// https://ip/restaurant/:rid/rating
@RestApi()
abstract class RestaurantRatingRepository
    implements IBasePaginationRepository<RatingModel> {
  factory RestaurantRatingRepository(Dio dio, {String baseUrl}) =
      _RestaurantRatingRepository;

  @GET('/')
  @Headers({
    'accessToken': 'true',
  })
  Future<CursorPagination<RatingModel>> paginate({
    //  쿼리 추가할때
    @Queries() PaginationParams? paginationParams = const PaginationParams(),
  });
}
