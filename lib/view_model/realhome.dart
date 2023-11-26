import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:team3_flutter_project_self_diagnosis_app/model/message.dart';
import 'package:team3_flutter_project_self_diagnosis_app/view/ajw_qna.dart';
import 'package:team3_flutter_project_self_diagnosis_app/view/bmi.dart';
import 'package:team3_flutter_project_self_diagnosis_app/view/kwh_location.dart';
import 'package:team3_flutter_project_self_diagnosis_app/view/select_disease.dart';
import 'package:team3_flutter_project_self_diagnosis_app/view_model/imageChange.dart';


// Home 화면입니다

class RealHome extends StatelessWidget {
  const RealHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 80, 0, 0),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              const Text(
                'BTY hospital',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Colors.blueGrey,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.supervised_user_circle,
                  ),
                  Text(
                    // 추 후 로그인 기능 구현되면 수정
                    ' ${Message.name}님 Hi',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Colors.blueGrey,
                    ),
                  ),
                ],
              ),
              const Text(
                'Have a healthy day today',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 10,
                ),
              ),
              // const SizedBox(height: 20),
              // const Divider(
              //   // html에서 div
              //   height: 30,
              //   color: Colors.grey,
              //   thickness: 2,
              // ),
              const SizedBox(
                width: 450,
                child: ImageChanger(),
              ),
              const SizedBox(
                height: 15,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    // 띄어쓰기 건들지 말 것
                    '       What are you looking for?',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.blueGrey,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    // BMI 버튼
                    onTap: () {
                      // 욱현이 BMI 계산 페이지
                      Get.to(() => const BMI());
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20), // 모서리를 둥글!
                      child: ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          Colors.white.withOpacity(0.1),
                          BlendMode.srcATop,
                        ),
                        child: Image.asset(
                          "images/bmi.png",
                          width: 150,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  InkWell(
                    // 자가진단 버튼
                    onTap: () => Get.to(const SelectDisease()),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20), // 모서리를 둥글!
                      child: ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          Colors.white.withOpacity(0.1),
                          BlendMode.srcATop,
                        ),
                        child: Image.asset(
                          "images/my.png",
                          width: 150,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '        Bmi',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                    // 띄어쓰기 건들지 말것
                  ),
                  SizedBox(
                    width: 100,
                  ),
                  Text(
                    'Self-diagnosis',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    // 내 주변 병원찾기 페이지
                    onTap: () => Get.to(const GpsShow()),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20), // 모서리를 둥글!
                      child: ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          Colors.white.withOpacity(0.1),
                          BlendMode.srcATop,
                        ),
                        child: Image.asset(
                          "images/hospitar.png",
                          width: 150,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  InkWell(
                    // 게시판
                    onTap: () {
                      Get.to(const QnaPage());
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20), // 모서리 둥글!
                      child: ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          Colors.white.withOpacity(0.1),
                          BlendMode.srcATop,
                        ),
                        child: Image.asset(
                          "images/qa.png",
                          width: 150,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'hospital',
                    // 띄어쓰기 건들지 말것
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(
                    width: 100,
                  ),
                  Text(
                    '      Q&A ',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
