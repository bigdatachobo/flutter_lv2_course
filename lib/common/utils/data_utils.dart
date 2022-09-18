import 'package:flutter_lv2_course/common/const/data.dart';

class DataUtils {
  static String imagePath(String value) {
    return 'https://$ip$value';
  }

  static List<String> listImagePaths(List paths) {
    return paths.map((e) => imagePath(e)).toList();
  }
}
