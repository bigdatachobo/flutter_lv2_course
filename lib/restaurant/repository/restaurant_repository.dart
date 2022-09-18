import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_lv2_course/common/const/data.dart';
import 'package:flutter_lv2_course/common/dio/dio.dart';
import 'package:flutter_lv2_course/common/model/cursor_pagination_model.dart';
import 'package:flutter_lv2_course/common/model/pagination_params.dart';
import 'package:flutter_lv2_course/common/repository/base_pagination_repository.dart';
import 'package:flutter_lv2_course/restaurant/model/restaurant_detail_model.dart';
import 'package:flutter_lv2_course/restaurant/model/restaurant_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/http.dart';

part 'restaurant_repository.g.dart';

final restaurantRepositoryProvider = Provider<RestaurantRepository>((ref) {
  final dio = ref.watch(dioProvider);

  final repository =
      RestaurantRepository(dio, baseUrl: 'https://$ip/restaurant');

  return repository;
});

@RestApi()
abstract class RestaurantRepository
    implements IBasePaginationRepository<RestaurantModel> {
  // https://$ip/restaurant
  factory RestaurantRepository(Dio dio, {String baseUrl}) =
      _RestaurantRepository;

  // https://$ip/restaurant/
  @GET('/')
  @Headers({
    'accessToken': 'true',
  })
  Future<CursorPagination<RestaurantModel>> paginate({
    //  쿼리 추가할때
    @Queries() PaginationParams? paginationParams = const PaginationParams(),
  });

  // https://$ip/restaurant/:id/
  @GET('/{id}')
  @Headers({
    'accessToken': 'true',
  })
  Future<RestaurantDetailModel> getRestaurantDetail({
    @Path() required String id,
  });
}
