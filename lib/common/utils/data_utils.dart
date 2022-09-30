import 'dart:convert';

import 'package:flutter_lv2_course/common/const/data.dart';

class DataUtils {
  static String imagePath(String value) {
    return 'https://$ip$value';
  }

  static List<String> listImagePaths(List paths) {
    return paths.map((e) => imagePath(e)).toList();
  }

  static String plainToBase64(String plain) {
    Codec<String, String> stringToBase64 = utf8.fuse(base64);

    String encoded = stringToBase64.encode(plain);

    return encoded;
  }

  static DateTime stringToDateTime(String value) {
    return DateTime.parse(value);
  }
}
