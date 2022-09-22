import 'package:flutter/material.dart';
import 'package:flutter_lv2_course/common/const/colors.dart';
import 'package:flutter_lv2_course/product/model/product_model.dart';
import 'package:flutter_lv2_course/restaurant/model/restaurant_detail_model.dart';

class ProductCard extends StatelessWidget {
  final Image image;
  final String name;
  final String detail;
  final int price;

  const ProductCard({
    required this.image,
    required this.name,
    required this.detail,
    required this.price,
    Key? key,
  }) : super(key: key);

  factory ProductCard.fromProductModel({
    required ProductModel model,
  }) {
    return ProductCard(
      image: Image.network(
        model.imgUrl,
        width: 110,
        height: 110,
        fit: BoxFit.cover,
      ),
      name: model.name,
      detail: model.detail,
      price: model.price,
    );
  }

  factory ProductCard.fromRestaurantProductModel({
    required RestaurantProductModel model,
  }) {
    return ProductCard(
      image: Image.network(
        model.imgUrl,
        width: 110,
        height: 110,
        fit: BoxFit.cover,
      ),
      name: model.name,
      detail: model.detail,
      price: model.price,
    );
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(
            8.0,
          ),
          child: image,
        ),
        const SizedBox(width: 16.0),
        Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 18.0,
                ),
              ),
              Text(
                detail,
                overflow: TextOverflow.ellipsis, // 문장이 화면을 넘어가면 ...을 보임
                maxLines: 2,
                style: const TextStyle(
                  color: bodyTextColor,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '₩$price',
                textAlign: TextAlign.right,
                style: const TextStyle(
                  color: primaryColor,
                  fontSize: 12.0,
                  fontWeight: FontWeight.w500,
                ),
              )
            ]))
      ]),
    );
  }
}
