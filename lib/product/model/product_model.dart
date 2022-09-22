import 'package:flutter_lv2_course/common/model/model_with_id.dart';
import 'package:flutter_lv2_course/common/utils/data_utils.dart';
import 'package:flutter_lv2_course/restaurant/model/restaurant_model.dart';

import 'package:json_annotation/json_annotation.dart';

part 'product_model.g.dart';

@JsonSerializable()
class ProductModel implements IModelWithId {
  final String id;
  final String name; // 상품이름
  final String detail; // 상품 상세 정보
  @JsonKey(fromJson: DataUtils.imagePath)
  final String imgUrl; // 이미지 URL
  final int price; // 상품 가격
  final RestaurantModel restaurant;

  ProductModel({
    required this.id,
    required this.name,
    required this.detail,
    required this.imgUrl,
    required this.price,
    required this.restaurant,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);
}
