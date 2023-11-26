import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:team3_flutter_project_self_diagnosis_app/model/message.dart';

class BMI extends StatefulWidget {
  const BMI({super.key});

  @override
  State<BMI> createState() => _BMIState();
}

class _BMIState extends State<BMI> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late String userId;
  late String password;
  late String height;
  late String weight;
  double bmi = 0;
  String bmiText = "";
  late Color bmiColor;
  double swim = 0;
  double walking = 0;
  double jumping = 0;
  late List<double> desc;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _animationController.repeat();
    userId = "";
    password = "";
    height = "";
    weight = "";
    desc = [];
    bmiColor = Colors.black;
    initSharedPreferences().then((_) {
      // initSharedPreferences() 함수가 완료된 후에 getBMIinfo() 함수를 호출합니다.
      getBMIinfo();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "BMI",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                bmiText,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: bmiColor,
                ),
              ),
              SizedBox(
                width: 310,
                height: 5,
                child: Divider(                         // 줄 긋기
                height: 5,                    // 줄이 차지하는 크기
                color:bmiColor,             // 색상
                thickness: 5,                  // 줄 두께
              ),
              ),
              SfRadialGauge(
                axes: <RadialAxis>[
                  RadialAxis(
                      radiusFactor: 1, // 차트크기
                      minimum: 10, // 시작값
                      maximum: 45, // 끝값
                      startAngle: 180, // 시작각도
                      endAngle: 0, // 끝각도
                      interval: 5, // 간격
                      canScaleToFit: false, // 크기맞추기
                      canRotateLabels: true, // 눈금이 각도대로맞춰지기
                      showFirstLabel: true, // 시작값보이기 시계에서 0일때 false
                      showLastLabel: true,
                      isInversed: false, // 좌우대칭
                      showLabels: true,
                      showAxisLine: false,
                      labelsPosition: ElementsPosition.outside,
                      // axisLineStyle: AxisLineStyle(
                      //   thickness: 0.1, // 축 두께
                      //   cornerStyle: CornerStyle.bothCurve,//축 끝에 둥글게하기
                      //   //color: Colors.blue,
                      //   dashArray: <double>[5,5],// 눈금분할하기
                      // ),
                      pointers: <GaugePointer>[
                        NeedlePointer(
                          value: bmi,
                          enableAnimation: true,
                          animationDuration: 1500,
                          needleStartWidth: 0,
                          needleEndWidth: 10,
                        ),
                      ],
                      ranges: [
                        GaugeRange(
                          startValue: 10,
                          endValue: 18.5,
                          color: Colors.blue,
                          startWidth: 0,
                          endWidth: 10,
                        ),
                        GaugeRange(
                          startValue: 18.5,
                          endValue: 25,
                          color: Colors.green,
                          startWidth: 10,
                          endWidth: 20,
                        ),
                        GaugeRange(
                          startValue: 25,
                          endValue: 30,
                          color: Colors.yellow,
                          startWidth: 20,
                          endWidth: 30,
                        ),
                        GaugeRange(
                          startValue: 30,
                          endValue: 35,
                          color: Colors.orange,
                          startWidth: 30,
                          endWidth: 40,
                        ),
                        GaugeRange(
                          startValue: 35,
                          endValue: 45,
                          color: Colors.red,
                          startWidth: 40,
                          endWidth: 50,
                        ),
                      ],
                      annotations: <GaugeAnnotation>[
                        GaugeAnnotation(
                            widget: Text(
                              '$bmi',
                              style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            angle: 90,
                            positionFactor: 0.5)
                      ]),
                ],
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("exercise") // table
                    .snapshots(), // 가져오기
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  final documents = snapshot.data!.docs;
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: documents.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot doc = documents[index];
                      Map<String, dynamic> data =
                          doc.data() as Map<String, dynamic>;
                      String itemDesc =
                          "10분당 ${desc.length > index ? desc[index] : 0} Kcal 소모됩니다.";
                      return Card(
                        color: index % 2 == 1
                            ? Colors.cyanAccent
                            : Colors.lightGreenAccent,
                        child: Row(
                          children: [
                            Lottie.asset(
                              "images/${data["imageName"]}",
                              controller: _animationController,
                              width: 100,
                              height: 100,
                            ),
                            Column(
                              children: [
                                Text(
                                  "${data["exerciseName"]}",
                                ),
                                Text(itemDesc),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

//-- functions---

// Shared Preferneces

// 로그인 할 때, 넘겨준 아이디 받기
  initSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString("p_userId")!; // null check
    password = prefs.getString("p_password")!;
    print(userId);
    print(password);
    setState(() {});
  }

// 로그인한 아이디에 해당하는 키몸무게 가져오기
  Future<void> getBMIinfo() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("user")
        .where("uid", isEqualTo: userId)
        .where("upassword", isEqualTo: password)
        .get();

    int count = querySnapshot.size;
    if (count >= 1) {
      // 아이디 비번 일치
      if (querySnapshot.docs.isNotEmpty) {
        Message.id = querySnapshot.docs[0].id;
        height = querySnapshot.docs[0].get("height");
        weight = querySnapshot.docs[0].get("weight");

        bmi = double.parse(weight) /
            ((double.parse(height) * 0.01) * (double.parse(height) * 0.01));
        bmi = (bmi * 100).round() / 100;

        switch (bmi) {
          case >= 35:
            bmiText = "Extremely Obese";
            bmiColor=Colors.red;
            break;
          case >= 30:
            bmiText = "Obese";
            bmiColor=Colors.orange;
            break;
          case >= 25:
            bmiText = "Overweight";
            bmiColor=Colors.yellow;
            break;
          case >= 18.5:
            bmiText = "Normal";
            bmiColor=Colors.green;
            break;
          case < 18.5:
            bmiText = "Underwight";
            bmiColor=Colors.blue;
            break;
        }
        calcKcal();
      }
    } else {
      print("파이어베이스없음");
    }
    setState(() {});
  }

// 10분당 소모 칼로리 계산
  calcKcal() {
    // 수영  kcal/10min
    swim = 155 * double.parse(weight) / 100;
    // 걷기
    walking = 67 * double.parse(weight) / 100;
    // 줄넘기
    jumping = 175 * double.parse(weight) / 100;
    desc.add(jumping);
    desc.add(walking);
    desc.add(swim);
  }
}
