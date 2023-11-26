import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:team3_flutter_project_self_diagnosis_app/view_model/realhome.dart';

class CardiovascularDisease extends StatefulWidget {
  const CardiovascularDisease({super.key});

  @override
  State<CardiovascularDisease> createState() => _CardiovascularDiseaseState();
}

class _CardiovascularDiseaseState extends State<CardiovascularDisease> {
  
  // property - 로그인한 유저 아이디 받기
  late String userId;

  // property - 사용자로부터 입력받을 컨트롤러들 (키, 몸무게, 콜레스테롤, 혈당, 최고혈압, 최저혈압)
  late TextEditingController ageController;
  late TextEditingController heightController;
  late TextEditingController weightController;
  late TextEditingController cholesterolController;
  late TextEditingController glucoseController;
  late TextEditingController maxBloodPressureController;
  late TextEditingController minBloodPressureController;

  // property - 사용자로부터 입력받은 값 trim 정리해서 할당할 변수(욱)
  late String age;
  late String height;
  late String weight;
  late String maxP;
  late String minP;
  late String cholesterol;
  late String glucose;

  // property - 사용자가 입력한 콜레스테롤, 혈당 계산후 할당할 변수(욱))
  late int cholesterolValue;
  late int glucoseValue;

  // property - page builder와 관련된 변수들
  late int pageCount; // 전체 페이지 개수
  late PageController _pageController; // 현재 페이지 관리하는 컨트롤러

  // property - 리스트 형태들
  late List data;                   // 맨 처음 데이터베이스에서 받아온 데이터들 넣어둘 리스트
  late List inputControllerList;    // pagebuilder로 만든 페이지마다 띄워줄 textEditingController 리스트
  late List<String> tempAnswer;     // pagebuilder로 만든 페이지마다 사용자가 입력한 데이터들을 임시로 저장해 둘 리스트
  // late List tempInputAnswer;        // 사용자가 입력한 데이터의 공백을 제거하여 임시로 저장할 리스트


  // bmi
  double bmi = 0;
  late bool extremlyobese;
  late bool obese;
  late bool overweight;
  late bool normal;
  late bool underweight;

  // 연령구분
  late bool thirties;
  late bool forties;
  late bool fifties;
  late bool sixties;

// 생년월일에서 사용되는 변수
  DateTime? selectedDate;
  late int difference;
  late int ageYEAR;
  late int ageYEAR_2;

  late String result;     // 예측 결과
  late int aResult;       // 예측 결과 숫자로 바꾸기

  @override
  void initState() {
    super.initState();
    // 초기화 - 사용자로부터 입력받을 컨트롤러
    ageController = TextEditingController();
    heightController = TextEditingController();
    weightController = TextEditingController();
    cholesterolController = TextEditingController();
    glucoseController = TextEditingController();
    maxBloodPressureController = TextEditingController();
    minBloodPressureController = TextEditingController();

    // 초기화 - page builder와 관련된 변수들
    pageCount = 0;
    _pageController = PageController(initialPage: 0);

    // 초기화 - 리스트로 저장해둘 데이터들
    data = [];
    inputControllerList = [ageController, heightController, weightController, cholesterolController, glucoseController, maxBloodPressureController, minBloodPressureController];
    tempAnswer = ['', '', '', '', '', '', ''];

    // 초기 수행될 함수 - 데이터 베이스에서 데이터 불러오기
    getSurvey();

    // 텍스트필드 간단하게하기
    age = "";
    height = "";
    weight = "";
    maxP = "";
    minP = "";
    cholesterol = "";
    glucose = "";

    // rds로 넘겨줄 콜레스테롤 혈당 값 변환
    cholesterolValue = 0;
    glucoseValue = 0;

    // day 받아서 나이로 바꿔주기
    difference = 0;
    ageYEAR = 0;
    ageYEAR_2 = 0;

    // bmi
    extremlyobese = false;
    obese = false;
    overweight = false;
    normal = false;
    underweight = false;

    // 연령구분
    thirties = false;
    forties = false;
    fifties = false;
    sixties = false;

    result = "all";
    aResult = 2;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('신체 및 건강 정보 입력'),
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: data.length,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        '문항 ${index + 1}',
                        style: const TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
  // ----------- 데이터베이스에서 질문 불러오기
                    SizedBox(
                      width: 350,
                      height: 100,
                      child: Text(
                        '${data[index]['question']}',
                        style: const TextStyle(fontSize: 30),
                      ),
                    ),
  // ----------- 사용자가 응답 입력할 텍스트 필드  
                    if (_pageController.page == 0)
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 200,
                              child: TextField(
                                readOnly: true,
                                textAlign: TextAlign.center,
                                controller: TextEditingController(
                                  text: selectedDate != null
                                    ? "${selectedDate!.year}-${selectedDate!.month}-${selectedDate!.day}"
                                    : '', // 선택한 날짜가 있으면 해당 날짜를 보여줍니다.
                                ),
                                style: const TextStyle(fontSize: 30),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: ElevatedButton(
                                onPressed: () => _selectDate(context),
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ), 
                                child: const Text('입력하기'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (_pageController.page != 0)
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 150,
                              child: TextField(
                                controller: inputControllerList[index],
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 30),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
  // ------------------ 필드별 보여줄 단위 등                          
                          if (_pageController.page == 1)
                            const Text(
                              '(cm)',
                              style: TextStyle(fontSize: 30),
                            ),
                          if (_pageController.page == 2)
                            const Text(
                              '(kg)',
                              style: TextStyle(fontSize: 30),
                            ),
                          if (_pageController.page == 3 || _pageController.page == 4)
                            const Text(
                              '(mg/dl)',
                              style: TextStyle(fontSize: 30),
                            ),
                          if (_pageController.page == 5 || _pageController.page == 6)
                            const Text(
                              '(mmHg)',
                              style: TextStyle(fontSize: 30),
                            ),
                        ],
                      ),
                    ),
  // ------------ 페이지 넘길 '이전', '다음' & 예측할 '진단하기' 버튼들                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_pageController.page == 0)
                          const Padding(
                            padding: EdgeInsets.all(15.0),
                            child: SizedBox(    // 공간 구성 맞추기 용
                              width: 75,
                              height: 40,
                            )
                          ),
                        if (_pageController.page! > 0)
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: ElevatedButton(
                              onPressed: () {
                                moveBeforePage();
                              },
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8))),
                              child: const Text('이전'),
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            '${index + 1} / ${data.length}',
                            style: const TextStyle(
                              fontSize: 20
                            ),
                          ),
                        ),
                        if (_pageController.page! < pageCount - 1)
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: ElevatedButton(
                              onPressed: () {
                                
                                if (ageYEAR < 40 || ageYEAR >= 60) {
                                  Get.snackbar(
                                    'Error!', "진단 대상 나이가 아닙니다",
                                    snackPosition: SnackPosition.BOTTOM,
                                    duration: const Duration(seconds: 2),
                                    backgroundColor: Colors.red[400]
                                  );
                                } else {
                                  addToTempAnswer(index);
                                  moveNextPage();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8))),
                              child: const Text('다음'),
                            ),
                          ),
                        if (_pageController.page == pageCount - 1)
                          const Padding(
                            padding: EdgeInsets.all(15.0),
                            child: SizedBox(
                              width: 75,
                              height: 40,
                            )
                          ),
                      ],
                    ),
                    if (_pageController.page == pageCount - 1)
                      Padding(
                        padding: const EdgeInsets.all(100.0),
                        child: ElevatedButton(
                          onPressed: () {
                            checkField(index);
                            // predictCardio();
                            // calc();
                            // getJSONData();
                            // 진단 결과 보여주는 페이지로 넘기기 => 진단결과 창 꾸미기!!
                          },
                          style: ElevatedButton.styleFrom(
                              maximumSize: const Size(300, 100),
                              minimumSize: const Size(300, 80),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8))),
                          child: const Text(
                            '진단하기',
                            style: TextStyle(fontSize: 30),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // --------- functions --------

  // 1. 심혈관 설문 내용 받아오기 (완료)
  getSurvey() async {
    var url = Uri.parse(
        'http://localhost:8080/Flutter/project/select_survey_category_1.jsp');
        // 'http://localhost:8080/getCardioSurvey');
    var response = await http.get(url);
    data.clear();
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    List result = dataConvertedJSON["results"];
    data.addAll(result);
    pageCount = data.length; // pageView의 총 page 수
    setState(() {});
  }

  // 2. '이전' 버튼 클릭시 이전 문항 보여주기 (완료)
  moveBeforePage() {
    if (_pageController.page! > 0) {
      _pageController.previousPage(
        duration: const Duration(microseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  // 3. '다음' 버튼 클릭시 다음 문항 보여주기 (완료)
  moveNextPage() {
    if (_pageController.page! < pageCount - 1) {
      _pageController.nextPage(
        duration: const Duration(microseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  // 4. '진단하기' 버튼 - 사용자가 입력하지 않은 값 확인 후 공란 없을 시 데이터 베이스에 추가 (완료)
  checkField(int index) {
    if (heightController.text.trim().isEmpty) {
      Get.snackbar("Error!", "키 (cm)를 입력해 주세요 (1번 문항)",
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.red[400],
          colorText: Colors.white);
    } else if (weightController.text.trim().isEmpty) {
      Get.snackbar("Error!", "몸무게 (Kg)를 입력해 주세요 (2번 문항)",
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.red[400],
          colorText: Colors.white);
    } else if (cholesterolController.text.trim().isEmpty) {
      Get.snackbar("Error!", "콜레스테롤 수치(mg/dl)를 입력해 주세요 (3번 문항)",
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.red[400],
          colorText: Colors.white);
    } else if (glucoseController.text.trim().isEmpty) {
      Get.snackbar("Error!", "혈당 수치 (mg/dl)를 입력해 주세요 (4번 문항)",
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.red[400],
          colorText: Colors.white);
    } else if (maxBloodPressureController.text.trim().isEmpty) {
      Get.snackbar("Error!", "최고 혈압 (mmHg)을 입력해 주세요 (5번 문항)",
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.red[400],
          colorText: Colors.white);
    } else if (minBloodPressureController.text.trim().isEmpty) {
      Get.snackbar("Error!", "최저 혈압 (Kg)를 입력해 주세요 (6번 문항)",
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.red[400],
          colorText: Colors.white);
    } else {
      print("예측 전 결고ㅏ : ${aResult}");
      predictCardio();
      calc();
      getJSONData();
      // result == "높습니다." ? aResult = 1 : aResult = 0;
      addToTempAnswer(index);
      // for (int i = 0; i < data.length; i++) {
      //   print(tempAnswer[i]);
      //   insertAnswer((i + 1), tempAnswer[i]);
      //   // inputControllerList[i].text = '';
      // }
      // print("결과 : ${aResult}");
    }
  }

  // 5. 사용자가 입력한 값 임시 리스트(tempAnswer)에 저장하기 (완료)
  addToTempAnswer(int index) {
    if (index == 0) {
      tempAnswer[0] = "${difference}";
      print("임시 인서트 : $difference");
    } else {
      tempAnswer[index] = inputControllerList[index].text.trim();
    }
    setState(() {});
  }

  // ⭐️⭐️⭐️ 6. 설문조사 응답 내용 데이터 베이스에 insert
  insertAnswer(int sSeq, String answer) async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString("p_userId")!;
    var url = Uri.parse(
        'http://localhost:8080/Flutter/project/insert_answer.jsp?uid=${userId}&sSeq=${sSeq}&category=1&answer=${answer}&aResult=${aResult}');
    var response = await http.get(url);
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    var result = dataConvertedJSON["result"];
    // setState(() {});
  }

  // 사용자로부터 입력받은 컨트롤러 공백 제거후 벼

  //////// 욱현오빠 functions
  predictCardio() {
    age = ageController.text.trim();
    height = heightController.text.trim();
    weight = weightController.text.trim();
    maxP = maxBloodPressureController.text.trim();
    minP = minBloodPressureController.text.trim();
    cholesterol = cholesterolController.text.trim();
    glucose = glucoseController.text.trim();
  }

  calc() {
    // 콜레스테롤 계산
    cholesterol = cholesterolController.text.trim();
    if (int.parse(cholesterol) >= 160) {
      cholesterolValue = 3;
    } else if (int.parse(cholesterol) >= 130) {
      cholesterolValue = 2;
    } else {
      cholesterolValue = 1;
    }

    // 혈당 계산
    glucose = glucoseController.text.trim();
    if (int.parse(glucose) >= 126) {
      glucoseValue = 3;
    } else if (int.parse(glucose) >= 100) {
      glucoseValue = 2;
    } else {
      glucoseValue = 1;
    }

    // bmi 계산
    weight = weightController.text.trim();
    height = heightController.text.trim();
    bmi = double.parse(weight) /
        ((double.parse(height) * 0.01) * (double.parse(height) * 0.01));
    bmi = (bmi * 100).round() / 100;

    // 생년월일 받은 것으로 나이계산
    // ageYEAR 사용

    // ageYEAR = 48 이면 40으로 나타내기위해 몫을 구하고 * 10을하기
    ageYEAR_2 = ((ageYEAR / 10).truncate()) * 10;

    // bmi 로 판단
    switch (bmi) {
      case >= 30:
        extremlyobese = true;
        break;
      case >= 25:
        obese = true;
        break;
      case >= 23:
        overweight = true;
        break;
      case >= 18.5:
        normal = true;
        break;
      case >= 0:
        underweight = true;
        break;
    }

    // ageYEAR_2 로 판단
    switch (ageYEAR_2) {
      case >= 60:
        sixties = true;
        break;
      case >= 50:
        fifties = true;
        break;
      case >= 40:
        forties = true;
        break;
      case >= 30:
        thirties = true;
        break;
    }
  }

  getJSONData() async {
    var url = Uri.parse(
        
        "http://localhost:8080/Rserve/response_cardio.jsp?age=$difference&height=$height&weight=$weight&max=$maxP&min=$minP&cholesterol=$cholesterolValue&glucose=$glucoseValue&ageYEAR=$ageYEAR&bmi=$bmi&ageYEAR_2=$ageYEAR_2"
        );
    var response = await http.get(url);
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    result = dataConvertedJSON["result"];
    if (result == "O") {
      result = "높습니다.";
      aResult = 1;
    } else {
      result = "낮습니다.";
      aResult = 0;
    }
    setState(() {});
    _showDialog();
  }

  _showDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "심혈관질환 예측 결과",
          ),
          content: Text(
            "당신은 심혈관질환이 있을 가능성이 $result",
          ),
          actions: [
            TextButton(
              onPressed: () {
                for (int i = 0; i < data.length; i++) {
                  print(tempAnswer[i]);
                  insertAnswer((i + 1), tempAnswer[i]);
                  inputControllerList[i].text = '';
                }
                print("결과 : ${aResult}");
                Get.back();
                Get.back();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  // data picker 함수
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      // 선택한 날짜와 오늘 날짜 사이의 차이 계산
      difference = (picked.difference(DateTime.now()).inDays.toInt() * -1);           // 선택한 날 ~ 오늘 까지 일자 차이
      ageYEAR = (DateTime.now().difference(picked).inDays / 365).toInt();             // 선택한 날 ~ 오늘 까지의 연도 차이
      print("Selected date: $selectedDate");
      print("Difference in days: $difference");
      print("year in days: $ageYEAR");
    }
  }


} // END