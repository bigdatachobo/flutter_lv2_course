import 'package:flutter_lv2_course/common/const/data.dart';
import 'package:flutter_lv2_course/common/utils/data_utils.dart';
import 'package:json_annotation/json_annotation.dart';

part 'restaurant_model.g.dart';

enum RestaurantPriceRange { expensive, medium, cheap }

@JsonSerializable()
class RestaurantModel {
  final String id; // id
  final String name; // 레스토랑 이름

  @JsonKey(fromJson: DataUtils.imagePath)
  final String thumbUrl; // 이미지 url

  final List<String> tags; // 레스토랑 태그
  final RestaurantPriceRange priceRange; // 가격대
  final double ratings; // 평균 평점
  final int ratingsCount; // 평점 갯수
  final int deliveryTime; // 배송 시간
  final int deliveryFee; // 배송 비용

  // 생성자
  RestaurantModel(
      {required this.id,
      required this.name,
      required this.thumbUrl,
      required this.tags,
      required this.priceRange,
      required this.ratings,
      required this.ratingsCount,
      required this.deliveryTime,
      required this.deliveryFee});

  // Json에서 Parsing 할때
  factory RestaurantModel.fromJson(Map<String, dynamic> json) =>
      _$RestaurantModelFromJson(json);
  // Parsing에서 Json으로 변환할때
  Map<String, dynamic> toJson() => _$RestaurantModelToJson(this);

  // factory 모델
  // factory RestaurantModel.fromJson({
  //   required Map<String, dynamic> json,
  // }) {
  //   return RestaurantModel(
  //     id: json['id'],
  //     name: json['name'],
  //     thumbUrl: 'http://$ip${json['thumbUrl']}',
  //     tags: List<String>.from(json['tags']),
  //     priceRange: RestaurantPriceRange.values
  //         .firstWhere((e) => e.name == json['priceRange']),
  //     ratings: json['ratings'],
  //     ratingsCount: json['ratingsCount'],
  //     deliveryTime: json['deliveryTime'],
  //     deliveryFee: json['deliveryFee'],
  //   );
  // }
}
