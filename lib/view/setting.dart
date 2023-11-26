import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:team3_flutter_project_self_diagnosis_app/view/advertise.dart';
import 'package:team3_flutter_project_self_diagnosis_app/view/mypage.dart';
//import 'package:url_launcher/url_launcher_string.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  late Color containerColor;
  late Color textColor;
  late String modecolor;

  @override
  void initState() {
    super.initState();
    containerColor = Colors.white;
    textColor = Colors.black;
    modecolor = "Dark";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: GestureDetector(
                onTap: () => Get.to(const MyPage()),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 2, color: Colors.black),
                    color: containerColor,
                  ),
                  width: 350,
                  height: 40,
                  child: Row(
                    children: [
                      Icon(
                        Icons.person,
                        color: textColor,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        "Profile",
                        style: TextStyle(
                          color: textColor,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.keyboard_arrow_right_outlined,
                        color: textColor,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: GestureDetector(
                onTap: () => showVersion(),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 2, color: Colors.black),
                    color: containerColor,
                  ),
                  width: 350,
                  height: 40,
                  child: Row(
                    children: [
                      Icon(
                        Icons.verified_user_rounded,
                        color: textColor,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        "Version",
                        style: TextStyle(
                          color: textColor,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.keyboard_arrow_right_outlined,
                        color: textColor,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: GestureDetector(
                onTap: () => changeMode(),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 2, color: Colors.black),
                    color: containerColor,
                  ),
                  width: 350,
                  height: 40,
                  child: Row(
                    children: [
                      Icon(
                        Icons.circle_rounded,
                        color: textColor,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        "$modecolor Mode",
                        style: TextStyle(
                          color: textColor,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.keyboard_arrow_right_outlined,
                        color: textColor,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: GestureDetector(
                onTap: () {
                  // 와이파이 설정열기
                  //_openWiFiSettings();
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 2, color: Colors.black),
                    color: containerColor,
                  ),
                  width: 350,
                  height: 40,
                  child: Row(
                    children: [
                      Icon(
                        Icons.wifi,
                        color: textColor,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        "Wifi",
                        style: TextStyle(
                          color: textColor,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.keyboard_arrow_right_outlined,
                        color: textColor,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: GestureDetector(
                onTap: () {
                  Get.to(const AddAD());
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 2, color: Colors.black),
                    color: containerColor,
                  ),
                  width: 350,
                  height: 40,
                  child: Row(
                    children: [
                      Icon(
                        Icons.picture_in_picture_rounded,
                        color: textColor,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        "Advertise",
                        style: TextStyle(
                          color: textColor,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.keyboard_arrow_right_outlined,
                        color: textColor,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: GestureDetector(
                onTap: () {
                  logout();
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 2, color: Colors.black),
                    color: containerColor,
                  ),
                  width: 350,
                  height: 40,
                  child: Row(
                    children: [
                      Icon(
                        Icons.logout,
                        color: textColor,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        "Log Out",
                        style: TextStyle(
                          color: textColor,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.keyboard_arrow_right_outlined,
                        color: textColor,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  showVersion() {
    Get.defaultDialog(
      title: "Version",
      middleText: "Alpha version 입니다.",
      barrierDismissible: false,
      radius: 15,
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: const Text(
            "EXIT",
          ),
        ),
      ],
    );
  }

  changeMode() {
    Get.defaultDialog(
      title: "MODE",
      middleText: "배경색상을 변경하시겠습니까 ?",
      barrierDismissible: false,
      radius: 15,
      actions: [
        TextButton(
          onPressed: () {
            changeColor();
            setState(() {});
          },
          child: const Text(
            "YES",
          ),
        ),
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: const Text(
            "NO",
          ),
        ),
      ],
    );
  }

// log out alert
  logout() {
    Get.defaultDialog(
      title: "",
      middleText: "로그아웃됩니다.",
      barrierDismissible: false,
      radius: 15,
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
            Get.back();
          },
          child: const Text(
            "OK",
          ),
        ),
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: const Text(
            "Cancel",
          ),
        ),
      ],
    );

    // // Wi-Fi 설정 열기
    // void _openWiFiSettings() async {
    //   const url = 'App-Prefs:root=WIFI';  // iOS의 Wi-Fi 설정 URL 스킴
    //   if (await canLaunchUrlString(url)) {
    //     await launchUrlString(url);
    //   } else {
    //     // 설정을 열 수 없는 경우 처리
    //     print('Wi-Fi 설정을 열 수 없습니다.');
    //   }
    // }
  }

  void changeColor() {
    if (containerColor == Colors.white) {
      containerColor = Colors.black;
      textColor = Colors.white;
      modecolor = "White";
    } else {
      containerColor = Colors.white;
      textColor = Colors.black;
      modecolor = "Dark";
    }
    Get.back();
  }
}
