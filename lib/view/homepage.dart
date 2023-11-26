import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:team3_flutter_project_self_diagnosis_app/view/kkg_RSlist.dart';
import 'package:team3_flutter_project_self_diagnosis_app/view/kkg_news.dart';
import 'package:team3_flutter_project_self_diagnosis_app/view/setting.dart';
import 'package:team3_flutter_project_self_diagnosis_app/view_model/realhome.dart';

import 'ajw_board.dart';

// tabbar 구성입니다.

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  //property
  late TabController controller;
  late String userId;
  late String password;

  @override
  void initState() {
    super.initState();
    userId = "";
    password = "";
    initSharedPreferences();
    controller = TabController(length: 4, vsync: this);
    //length : tab의 갯수 vsync : 어느페이지 가더라도 탭바를 항상 가지고다닌다.
  }

  @override
  void dispose() {
    controller.dispose(); // 메모리에서 controller지우기
    super.dispose(); // 앱이 죽음, 앱이 죽은 후 메모리에서 지우기는 불가능하므로 super를 항상 마지막
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: controller,
        children: [
          const RealHome(),
          const News(),
          RSlist(),
          const SettingPage(),
        ],
      ),
      // 의사 연결 채팅
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Get.to(() => Board());
          Get.to(Board(), arguments: userId);
        },
        backgroundColor: Colors.black54,
        foregroundColor: Colors.white,
        child: const Icon(Icons.chat_sharp),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      // 하단 탭바 설정
      bottomNavigationBar: Container(
        color: Colors.white,
        height: 80,
        child: TabBar(
          controller: controller,
          labelColor: Colors.blue,
          indicatorColor: Colors.blue,
          indicatorWeight: 3,
          indicatorSize: TabBarIndicatorSize.label,
          tabs: const [
            Tab(
              icon: Icon(
                Icons.home,
              ),
              text: "Home",
            ),
            Tab(
              icon: Icon(
                Icons.newspaper,
              ),
              text: "News",
            ),
            Tab(
              icon: Icon(
                Icons.inventory_rounded,
              ),
              text: "Result",
            ),
            Tab(
              icon: Icon(
                Icons.settings,
              ),
              text: "Settings",
            ),
          ],
        ),
      ),
    );
  }

  initSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString("p_userId")!; // null check
    password = prefs.getString("p_password")!;
    print(userId);
    print(password);
    setState(() {});
  }
}
