import 'package:flutter/material.dart';
import 'package:flutter_lv2_course/common/const/colors.dart';
import 'package:flutter_lv2_course/common/layout/default_layout.dart';
import 'package:flutter_lv2_course/restaurant/view/restaurant_screen.dart';

class RootTab extends StatefulWidget {
  const RootTab({super.key});

  @override
  State<RootTab> createState() => _RootTabState();
}

class _RootTabState extends State<RootTab> with SingleTickerProviderStateMixin {
  late TabController controller;
  int index = 0;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 4, vsync: this);
    controller.addListener(tabListener);
  }

  @override
  void dispose() {
    controller.removeListener(tabListener);
    super.dispose();
  }

  void tabListener() {
    setState(() {
      index = controller
          .index; // controller의 index를 index(bottomNavigationBar) 변수에 집어넣어준다.
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '코팩 딜리버리',
      child: TabBarView(
          physics: const NeverScrollableScrollPhysics(), // 좌우 스크롤 막음.
          controller: controller,
          children: [
            RestaurantScreen(),
            Center(child: Container(child: Text('음식'))),
            Center(child: Container(child: Text('주문'))),
            Center(child: Container(child: Text('프로필'))),
          ]),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: primaryColor,
        unselectedItemColor: bodyTextColor,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          controller.animateTo(index); // TabBarView와 연동
        },
        currentIndex: index,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: '홈'),
          BottomNavigationBarItem(
              icon: Icon(Icons.fastfood_outlined), label: '음식'),
          BottomNavigationBarItem(
              icon: Icon(Icons.receipt_outlined), label: '주문'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outlined), label: '프로필'),
        ],
      ),
    );
  }
}
