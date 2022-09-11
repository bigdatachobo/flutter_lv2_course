import 'package:flutter/material.dart';
import 'package:flutter_lv2_course/common/const/colors.dart';
import 'package:flutter_lv2_course/restaurant/model/restaurant_detail_model.dart';
import 'package:flutter_lv2_course/restaurant/model/restaurant_model.dart';

class RestaurantCard extends StatelessWidget {
  // 이미지
  final Widget image;
  // 레스토랑 이름
  final String name;
  // 레스토랑 태그
  final List<String> tags;
  // 평점 갯수
  final int ratingsCount;
  // 배송 시간
  final int deliveryTime;
  // 배송 비용
  final int deliveryFee;
  // 평균 평점
  final double ratings;
  // 상세 카드 여부
  final bool isDetail;
  // 상세 내용
  final String? detail;

  const RestaurantCard({
    required this.image,
    required this.name,
    required this.tags,
    required this.ratingsCount,
    required this.deliveryTime,
    required this.deliveryFee,
    required this.ratings,
    this.isDetail = false,
    this.detail,
    Key? key,
  }) : super(key: key);

  factory RestaurantCard.fromModel({
    required RestaurantModel model,
    bool isDetail = false,
  }) {
    return RestaurantCard(
      image: Image.network(
        model.thumbUrl,
        fit: BoxFit.cover,
      ),
      name: model.name,
      tags: model.tags,
      ratingsCount: model.ratingsCount,
      deliveryTime: model.deliveryTime,
      deliveryFee: model.deliveryFee,
      ratings: model.ratings,
      isDetail: isDetail,
      detail: model is RestaurantDetailModel ? model.detail : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (isDetail) image,
        if (!isDetail)
          ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: image,
          ),
        const SizedBox(height: 16.0),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: isDetail ? 16.0 : 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                name,
                style: const TextStyle(
                    fontSize: 20.0, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8.0),
              Text(
                tags.join(' · '),
                style: const TextStyle(color: bodyTextColor, fontSize: 14.0),
              ),
              Row(
                children: [
                  _IconText(icon: Icons.star, label: ratings.toString()),
                  const Text(' · '),
                  _IconText(
                      icon: Icons.receipt, label: ratingsCount.toString()),
                  const Text(' · '),
                  _IconText(
                      icon: Icons.timelapse_outlined, label: '$deliveryTime 분'),
                  const Text(' · '),
                  _IconText(
                      icon: Icons.monetization_on,
                      label: deliveryFee == 0 ? '무료' : deliveryFee.toString())
                ],
              ),
              if (detail != null && isDetail)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(detail!),
                )
            ],
          ),
        )
      ],
    );
  }
}

class _IconText extends StatelessWidget {
  final IconData icon;
  final String label;
  const _IconText({required this.icon, required this.label, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: primaryColor,
          size: 14.0,
        ),
        const SizedBox(height: 8.0),
        Text(
          label,
          style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.w500),
        )
      ],
    );
  }
}
