import 'package:flutter/material.dart';
import 'package:flutter_lv2_course/common/view/splash_screen.dart';
// import 'package:flutter_lv2_course/user/view/login_screen.dart';

void main() {
  runApp(const _App());
}

class _App extends StatelessWidget {
  const _App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'NotoSans', // 폰트 설정
      ),

      debugShowCheckedModeBanner: false, // debug 표시 제거
      home: const SplashScreen(),
    );
  }
}
