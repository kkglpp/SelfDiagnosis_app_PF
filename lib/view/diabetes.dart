import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:team3_flutter_project_self_diagnosis_app/view_model/realhome.dart';

class Diabetes extends StatefulWidget {
  const Diabetes({super.key});

  @override
  State<Diabetes> createState() => _DiabetesState();
}

class _DiabetesState extends State<Diabetes> {

  // property - 로그인 한 유저 아이디 받기
  late String userId;

  // property - page builder와 관련된 변수들
  late int pageCount;                       // 전체 페이지 개수
  late PageController _pageController;      // 현재 페이지 관리하는 컨트롤러

  // property - 사용자로부터 입력받을 컨트롤러 (나이, 키, 몸무게, 음주량)
  late TextEditingController ageController1;
  late TextEditingController heightController2;
  late TextEditingController weightController3;
  late TextEditingController drinkController9;

  // property - 사용자로부터 입력받을 값들
  late int _radioGender0;                     // 성별
  late int _radioColes4;                      // 콜레스테롤 측정 여부 내력
  late int _radioCardio5;                     // 심혈관 진단 여부 내력
  late int _radioExercise6;                   // 운동 여부
  late int _radioFruit7;                      // 과일 섭취 여부
  late int _radioVege8;                       // 채소 섭취 여부
  late int selectHealthy10;                   // 건강 상태 수준
  late int _radioWalk11;                      // 걷거나 계단 오르내렸을 때 불편함 여부
  late int _radioDiagnoseHBP12;               // 고혈압 진단 여부
  late int selectedMentalPicker13;              // 정신적으로 힘든 날 수     
  late int selectedPhysicalPicker14;            // 육체적으로 힘든 날 수

  // property - 리스트
  late List data;                     // 맨 처음 데이터베이스에서 받아온 데이터들 넣어둘 리스트
  late List<String> inputValueList;           // pagebuilder로 만든 페이지마다 사용자가 입력한 데이터들을 모아둔 리스트
  late List<String> tempAnswer;       // pagebuilder로 만든 페이지마다 사용자가 입력한 데이터들을 임시로 저장해 둘 리스트

  // property - bmi 계산 결과 받을 변수 & bmi 계산에 필요한 변수 & 주량
  double bmiDouble = 0;
  int bmi = 0;
  late String height;
  late String weight;
  late String drinkCount;
  int drink = 0;
  int mental = 0;
  int physical = 0;
  late String result;
  late int aResult;

  // 생년월일에서 사용되는 변수
  DateTime? selectedDate;
  late int difference;
  late int ageYEAR;
  late int ageYEAR_2;
  late int ageGrade;

  ////////////////////
  // initstate - 초기화
  @override
  void initState() {
    super.initState();
    // 초기화 - page builder와 관련된 변수들
    pageCount = 0;
    _pageController = PageController(initialPage: 0);

    // 초기화 - 사용자로부터 입력받을 컨트롤러
    ageController1 = TextEditingController();
    heightController2 = TextEditingController();
    weightController3 = TextEditingController();
    drinkController9 = TextEditingController();

    // 초기화 - 사용자로부터 입력받을 값들
    // radioTest = 0;
    _radioGender0 = 0;
    _radioColes4 = 0;
    _radioCardio5 = 0;
    _radioExercise6 = 0;
    _radioFruit7 = 0;
    _radioVege8 = 0;
    selectHealthy10 = 3;
    _radioWalk11= 0;
    _radioDiagnoseHBP12 = 0;
    selectedMentalPicker13 = 1;
    selectedPhysicalPicker14 = 1;

    // 초기화 - 리스트로 저장해둘 데이터들
    data = [];
    inputValueList = [_radioGender0.toString(), ageController1.text.trim(), heightController2.text.trim(), weightController3.text.trim(), _radioColes4.toString(), _radioCardio5.toString(), _radioExercise6.toString(), _radioFruit7.toString(), _radioVege8.toString(), drinkController9.text.trim(), selectHealthy10.toString(), _radioWalk11.toString(), _radioDiagnoseHBP12.toString(), selectedMentalPicker13.toString(), selectedPhysicalPicker14.toString()];
    tempAnswer = ['', '', '', '', '', '', '', '', '', '', '', '', '', '', ''];

    // bmi, 주량 초기화
    height = '';
    weight = '';
    drinkCount = '';
    result = '';
    aResult = 2;

    // day 받아서 나이로 바꿔주기
    difference = 0;
    ageYEAR = 0;
    ageYEAR_2 = 0;
    ageGrade = 0;

    // 초기 수행될 함수 - 데이터 베이스에서 데이터 불러오기
    getSurvey();
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
        title: const Text(
          '신체 및 건강 정보 입력'
        ),
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
  // ---------- 데이터베이스에서 질문 불러오기                  
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SizedBox(
                      width: 400,
                      height: 130,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          '${data[index]['question']}',
                          style: const TextStyle(
                            fontSize: 30
                          ), 
                        ),
                      ),
                    ),
                  ),
  // ----------- 사용자가 응답 입력할 텍스트 필드 / 라디오 버튼 / 슬라이드 등                  
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SizedBox(
                      width: 400,
                      height: 80,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
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
                          if (_pageController.page == 1)  // 성별
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Radio(
                                  value: 0, 
                                  groupValue: _radioGender0, 
                                  // groupValue: radioTest, 
                                  onChanged: (value) {
                                    // radioTest = 0;
                                    _radioGender0 = 0;
                                    print(_radioGender0);
                                    setState(() {
                                      
                                    });
                                  },
                                ),
                                const Text(
                                  '남성',
                                  style: TextStyle(fontSize: 20),
                                  ),
                                const SizedBox(width: 30,),
                                Radio(
                                  value: 1, 
                                  groupValue: _radioGender0, 
                                  // groupValue: radioTest, 
                                  onChanged: (value) {
                                    // radioTest = 1;
                                    _radioGender0 = 1;
                                    print(_radioGender0);
                                    setState(() {
                                      
                                    });
                                  },
                                ),
                                const Text(
                                  '여성',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          if (_pageController.page == 2) 
                            Row(
                              children: [
                                SizedBox(
                                  width: 150,
                                  child: TextField(
                                    // controller: inputValueList[index],
                                    controller: heightController2,
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 30),
                                  ),
                                ),
                                const SizedBox(width: 20,),
                                const Text(
                                  '(cm)',
                                  style: TextStyle(
                                    fontSize: 30
                                  ),
                                ),
                              ],
                            ),
                          if (_pageController.page == 3)
                            Row(
                              children: [
                                SizedBox(
                                  width: 150,
                                  child: TextField(
                                    // controller: inputValueList[index],
                                    controller: weightController3,
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 30),
                                  ),
                                ),
                                const SizedBox(width: 20,),
                                const Text(
                                  '(kg)',
                                  style: TextStyle(
                                    fontSize: 30
                                  ),
                                ),
                              ],
                            ),
                          if (_pageController.page == 4)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Radio(
                                  value: 0, 
                                  groupValue: _radioColes4, 
                                  onChanged: (value) {
                                    // _radioColes4 = value!;
                                    _radioColes4 = 0;
                                    print(_radioColes4);
                                    setState(() {
                                      
                                    });
                                  },
                                ),
                                const Text(
                                  '아니오',
                                  style: TextStyle(fontSize: 20),
                                  ),
                                const SizedBox(width: 30,),
                                Radio(
                                  value: 1, 
                                  groupValue: _radioColes4, 
                                  onChanged: (value) {
                                    // _radioColes4 = value!;
                                    _radioColes4 = 1;
                                    print(_radioColes4);
                                    setState(() {
                                      
                                    });
                                  },
                                ),
                                const Text(
                                  '예',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          if (_pageController.page == 5)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Radio(
                                  value: 0, 
                                  groupValue: _radioCardio5, 
                                  onChanged: (value) {
                                    // _radioCardio5 = value!;
                                    _radioCardio5 = 0;
                                    setState(() {
                                      
                                    });
                                  },
                                ),
                                const Text(
                                  '아니오',
                                  style: TextStyle(fontSize: 20),
                                  ),
                                const SizedBox(width: 30,),
                                Radio(
                                  value: 1, 
                                  groupValue: _radioCardio5, 
                                  onChanged: (value) {
                                    // _radioCardio5 = value!;
                                    _radioCardio5 = 1;
                                    setState(() {
                                      
                                    });
                                  },
                                ),
                                const Text(
                                  '예',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          if (_pageController.page == 6)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Radio(
                                  value: 0, 
                                  groupValue: _radioExercise6, 
                                  onChanged: (value) {
                                    // _radioExercise6 = value!;
                                    _radioExercise6 = 0;
                                    setState(() {
                                      
                                    });
                                  },
                                ),
                                const Text(
                                  '아니오',
                                  style: TextStyle(fontSize: 20),
                                ),
                                const SizedBox(width: 30,),
                                Radio(
                                  value: 1, 
                                  groupValue: _radioExercise6, 
                                  onChanged: (value) {
                                    // _radioExercise6 = value!;
                                    _radioExercise6 = 1;
                                    setState(() {
                                      
                                    });
                                  },
                                ),
                                const Text(
                                  '예',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          if (_pageController.page == 7)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Radio(
                                  value: 0, 
                                  groupValue: _radioFruit7, 
                                  onChanged: (value) {
                                    // _radioFruit7 = value!;
                                    _radioFruit7 = 0;
                                    setState(() {
                                      
                                    });
                                  },
                                ),
                                const Text(
                                  '아니오',
                                  style: TextStyle(fontSize: 20),
                                ),
                                const SizedBox(width: 30,),
                                Radio(
                                  value: 1, 
                                  groupValue: _radioFruit7, 
                                  onChanged: (value) {
                                    // _radioFruit7 = value!;
                                    _radioFruit7 = 1;
                                    setState(() {
                                      
                                    });
                                  },
                                ),
                                const Text(
                                  '예',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          if (_pageController.page == 8)
                            Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Radio(
                                value: 0, 
                                groupValue: _radioVege8, 
                                onChanged: (value) {
                                  // _radioVege8 = value!;
                                  _radioVege8 = 0;
                                  setState(() {
                                    
                                  });
                                },
                              ),
                              const Text(
                                '아니오',
                                style: TextStyle(fontSize: 20),
                              ),
                              const SizedBox(width: 30,),
                              Radio(
                                value: 1, 
                                groupValue: _radioVege8, 
                                onChanged: (value) {
                                  // _radioVege8 = value!;
                                  _radioVege8 = 1;
                                  setState(() {
                                    
                                  });
                                },
                              ),
                              const Text(
                                '예',
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                          if (_pageController.page == 9)
                            Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                '소주',
                                style: TextStyle(fontSize: 15),
                              ),
                              const SizedBox(width: 20,),
                              SizedBox(
                                width: 80,
                                child: TextField(
                                  // controller: inputValueList[index],
                                  controller: drinkController9,
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              const Text('잔')
                            ],
                          ),
                          if (_pageController.page == 10)
                            Column(
                              children: [
                              const Text(
                                '(안 좋다, 그저 그렇다, 좋다, 매우 좋다, 완벽하다)',
                                style: TextStyle(
                                  fontSize: 19
                                ),
                                ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text('안 좋다'),
                                  Slider(
                                    value: selectHealthy10.toDouble(), 
                                    min: 1,
                                    max: 5,
                                    divisions: 4,
                                    onChanged: (value) {
                                      selectHealthy10 = value.toInt();
                                      setState(() {
                                        
                                      });
                                    },
                                    label: '',
                                  ),
                                  const Text('완벽하다')
                                ],
                              ),
                              ],
                            ),
                          if (_pageController.page == 11)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Radio(
                                  value: 0, 
                                  groupValue: _radioWalk11, 
                                  onChanged: (value) {
                                    // _radioWalk11 = value!;
                                    _radioWalk11 = 0;
                                    setState(() {
                                      
                                    });
                                  },
                                ),
                                const Text(
                                  '아니오',
                                  style: TextStyle(fontSize: 20),
                                ),
                                Radio(
                                  value: 1, 
                                  groupValue: _radioWalk11, 
                                  onChanged: (value) {
                                    // _radioWalk11 = value!;
                                    _radioWalk11 = 1;
                                    setState(() {
                                      
                                    });
                                  },
                                ),
                                const Text(
                                  '예',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          if (_pageController.page == 12)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Radio(
                                  value: 0, 
                                  groupValue: _radioDiagnoseHBP12, 
                                  onChanged: (value) {
                                    // _radioDiagnoseHBP12 = value!;
                                    _radioDiagnoseHBP12 = 0;
                                    setState(() {
                                      
                                    });
                                  },
                                ),
                                const Text(
                                  '아니오',
                                  style: TextStyle(fontSize: 20),
                                ),
                                Radio(
                                  value: 1, 
                                  groupValue: _radioDiagnoseHBP12, 
                                  onChanged: (value) {
                                    // _radioDiagnoseHBP12 = value!;
                                    _radioDiagnoseHBP12 = 1;
                                    setState(() {
                                      
                                    });
                                  },
                                ),
                                const Text(
                                  '예',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          if (_pageController.page == 13)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 100,
                                  height: 100,
                                  child: CupertinoPicker(
                                    itemExtent: 40,       // pickerView 보여주는 높이
                                    scrollController: FixedExtentScrollController(initialItem: 0),
                                    onSelectedItemChanged: (index) {
                                      selectedMentalPicker13 = index;
                                      // 선택한 날짜 다음 페이지로 넘겨서 계산시키기 (혹은 계산하고 넘기기)
                                      setState(() {
                                        
                                      });
                                    }, 
                                    children: List.generate(
                                      31, 
                                      (index) => Center(
                                        child: Text(
                                          '${index}'
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const Text('일')
                              ],
                            ),
                          if (_pageController.page == 14)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 100,
                                  height: 100,
                                  child: CupertinoPicker(
                                    itemExtent: 40, 
                                    scrollController: FixedExtentScrollController(initialItem: 0),
                                    onSelectedItemChanged: (index) {
                                      selectedPhysicalPicker14 = index;
                                      // 선택한 날짜 다음 페이지로 넘겨서 계산시키기 (혹은 계산하고 넘기기)
                                      // print(selectedPhysicalPicker14);
                                      setState(() {
                                        
                                      });
                                    }, 
                                    children: List.generate(
                                      31, 
                                      (index) => Center(
                                        child: Text(
                                          '${index}'
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const Text('일')
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
  // ------------ 페이지 넘길 '이전', '다음' & 예측할 '진단하기' 버튼들                
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
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
                                borderRadius: BorderRadius.circular(8)
                              )
                            ),
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
                              checkField(index);
                              // if (ageYEAR < 18) {
                              //   Get.snackbar(
                              //       'Error!', "진단 대상 나이가 아닙니다",
                              //       snackPosition: SnackPosition.BOTTOM,
                              //       duration: const Duration(seconds: 2),
                              //       backgroundColor: Colors.red[400]
                              //   );
                              // } else {
                              //   addToTempAnswer(index);
                              //   print("현재 입력값 : ${inputValueList[index]}");
                              //   moveNextPage();
                              //   setState(() {
                                  
                              //   });
                              // }
                             
                            }, 
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)
                              )
                            ),
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
                ),
                if (_pageController.page == pageCount - 1)
                  Padding(
                    padding: const EdgeInsets.all(100.0),
                    child: ElevatedButton(
                      onPressed: () {
                        cal();
                        sendToRServe();
                        setState(() {
                          
                        });
                      }, 
                      style: ElevatedButton.styleFrom(
                        maximumSize: Size(300, 100),
                        minimumSize: Size(300, 80),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)
                        )
                      ),
                      child: const Text(
                        '진단하기',
                        style: TextStyle(
                          fontSize: 30
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ---------- functions ---------

  // 1. 당뇨 설문 내용 받아오기 (완료)
  getSurvey() async{
    var url = Uri.parse(
      'http://localhost:8080/Flutter/project/select_survey_category_2.jsp'
    );
    var response = await http.get(url);
    data.clear();
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    List result = dataConvertedJSON["results"];
    data.addAll(result);
    pageCount = data.length;    // pageView의 총 page 수
    setState(() {
      
    });
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

  // 4. '진단하기' 버튼 - 사용자가 입력하지 않은 값 확인 후 공란 없을 시 데이터 베이스에 추가 => 간단하게 정리할것 (특히 insert 파트)
  checkField(int index) {
    if (selectedDate == null) {
      Get.snackbar(
        "Error!", 
        "생년월일을 입력해 주세요 (1번 문항)",
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.red[400],
        colorText: Colors.white
      );
    } else if (ageYEAR < 18) {
        Get.snackbar(
            'Error!', "진단 대상 나이가 아닙니다",
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.red[400]
        );
    } else if (ageYEAR >= 18) {
      moveNextPage();
    } else if (heightController2.text.trim().isEmpty) {
      Get.snackbar(
        "Error!", 
        "키 (cm)를 입력해 주세요 (3번 문항)",
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.red[400],
        colorText: Colors.white
      );
    } else if (heightController2.text.trim().isNotEmpty) {
      moveNextPage();
    } else if (weightController3.text.trim().isEmpty) {
      Get.snackbar(
        "Error!", 
        "몸무게 (Kg)를 입력해 주세요 (4번 문항)",
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.red[400],
        colorText: Colors.white
      );
    } else if (weightController3.text.trim().isNotEmpty) {
      moveNextPage();
    } else if (drinkController9.text.trim().isEmpty) {
        Get.snackbar(
          "Error!", 
          "음주량을 작성해 주세요 (10번 문항)",
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.red[400],
          colorText: Colors.white
        );
    } else if (drinkController9.text.trim().isNotEmpty) {
      moveNextPage();
    } else {
      // addToTempAnswer(index);
      // for (int i = 0; i < data.length; i++) {
      //   print("${i+1}번째 항목은 ${tempAnswer[i]}");
      //   // insertAnswer((i + 1), tempAnswer[i]);
      //   // if (i == 0 || i == 1 || i == 2 || i == 7)
      //   // inputValueList[i].text = '';
      // }
      addToTempAnswer(index);  
      // print("현재 입력값 : ${inputValueList[index]}");
      // moveNextPage();
      // setState(() {
        
      // });

        // insertAnswer(8, _radioGender0.toString());
        // insertAnswer(9, "${ageGrade}");
        // insertAnswer(10, heightController2.text.trim());
        // insertAnswer(11, weightController3.text.trim());
        // insertAnswer(12, _radioColes4.toString());
        // insertAnswer(13, _radioCardio5.toString());
        // insertAnswer(14, _radioExercise6.toString());
        // insertAnswer(15, _radioFruit7.toString());
        // insertAnswer(16, _radioVege8.toString());
        // insertAnswer(17, drinkController9.text.trim());
        // insertAnswer(18, selectHealthy10.toString());
        // insertAnswer(19, _radioWalk11.toString());
        // insertAnswer(20, _radioDiagnoseHBP12.toString());
        // insertAnswer(21, selectedMentalPicker13.toString());
        // insertAnswer(22, selectedPhysicalPicker14.toString());
    }
  } 

  // 5. 사용자가 입력한 값 임시 리스트(tempAnswer)에 저장하기 (다시 해보기)
  addToTempAnswer(int index) {
    if (index == 1) {
      tempAnswer[index] = "${ageYEAR}";
    // } else  if (index == 2 || index == 3 || index == 9) {
    //   tempAnswer[index] = inputValueList[index];
    // }
    } else {
      // tempAnswer[index] = "${inputValueList[index]}";
      tempAnswer[index] = inputValueList[index];
    }
    setState(() {
      
    });
  }

  // ⭐️⭐️⭐️ 6. 설문조사 응답 내용 데이터 베이스에 insert => ⭐️⭐️⭐️ userid 부분 확인하기!!!!!
  insertAnswer(int sSeq, String answer) async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString("p_userId")!;
    var url = Uri.parse(
      'http://localhost:8080/Flutter/project/insert_answer.jsp?uid=${userId}&sSeq=${sSeq}&category=2&answer=${answer}&aResult=${aResult}');
    var response = await http.get(url);
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    var result = dataConvertedJSON["result"];
  }

  // data picker 함수 - 생년 월일로 나이 등급 계산 (완료)
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

      ageYEAR >= 81 ? ageGrade = 13
      : ageYEAR >= 76 ? ageGrade = 12
      : ageYEAR >= 71 ? ageGrade = 11
      : ageYEAR >= 66 ? ageGrade = 10
      : ageYEAR >= 61 ? ageGrade = 9
      : ageYEAR >= 56 ? ageGrade = 8
      : ageYEAR >= 51 ? ageGrade = 7
      : ageYEAR >= 46 ? ageGrade = 6
      : ageYEAR >= 41 ? ageGrade = 5
      : ageYEAR >= 36 ? ageGrade = 4
      : ageYEAR >= 31 ? ageGrade = 3
      : ageYEAR >= 26 ? ageGrade = 2
      : ageYEAR >= 18 ? ageGrade = 1
      : ageGrade = 0;

    }
  }

  // bmi 계산하기
  cal() {
    // bmi
    weight = weightController3.text.trim();
    height = heightController2.text.trim();
    bmiDouble = double.parse(weight) / ((double.parse(height) * 0.01) * (double.parse(height) * 0.01));
    bmi = bmi.round();

    // drink
    drinkCount = drinkController9.text.trim();
    if (_radioGender0 == 0) {     // 남자
      int.parse(drinkCount) >= 14? drink = 1 : drink = 0;
    } else if (_radioGender0 == 1) {      // 여자
      int.parse(drinkCount) >= 7 ? drink = 1 : drink = 0;
    }  

    // mental
    selectedMentalPicker13 > 0 ? mental = 1 : mental = 0;

    // physical
    selectedPhysicalPicker14 >= 28 ? physical = 6
    : selectedPhysicalPicker14 >= 23 ? physical = 5
    : selectedPhysicalPicker14 >= 18 ? physical = 4
    : selectedPhysicalPicker14 >= 13 ? physical = 3
    : selectedPhysicalPicker14 >= 8 ? physical = 2
    : selectedPhysicalPicker14 >= 1 ? physical = 1 
    : physical = 0;
  }


  sendToRServe() async {
    var url = Uri.parse(
      "http://localhost:8080/Rserve/response_diabetes.jsp?ageGrade=$ageGrade&gender=$_radioGender0&cholesterol=$_radioColes4&bmi=$bmi&cardio=$_radioCardio5&exercise=$_radioExercise6&fruit=$_radioFruit7&vege=$_radioVege8&drink=$drink&health=$selectHealthy10&walk=$_radioWalk11&highBP=$_radioDiagnoseHBP12&mental=$mental&physical=$physical"
      // "http://localhost:8080/Rserve/response_diabetes.jsp?ageGrade=3&gender=1&cholesterol=1&bmi=26&cardio=0&exercise=1&fruit=1&vege=1&drink=1&health=4&walk=0&highBP=0&mental=1&physical=2"
    );
    var response = await http.get(url);
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    result = dataConvertedJSON["result"];
    print("결과 : ${result}");
    if (result == "당뇨") {
      result = '높습니다.';
      aResult = 1;
    } else {
      result = '낮습니다.';
      aResult = 0;
    }
    setState(() {
      
    });
    _showDialog();
  }

  _showDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "당뇨 예측 결과",
          ),
          content: Text(
            "당신은 당뇨일 가능성이 $result",
          ),
          actions: [
            TextButton(
              onPressed: () {
                insertAnswer(8, "${ageGrade}");
                insertAnswer(9, _radioGender0.toString());
                insertAnswer(10, heightController2.text.trim());
                insertAnswer(11, weightController3.text.trim());
                insertAnswer(12, _radioColes4.toString());
                insertAnswer(13, _radioCardio5.toString());
                insertAnswer(14, _radioExercise6.toString());
                insertAnswer(15, _radioFruit7.toString());
                insertAnswer(16, _radioVege8.toString());
                insertAnswer(17, drinkController9.text.trim());
                insertAnswer(18, selectHealthy10.toString());
                insertAnswer(19, _radioWalk11.toString());
                insertAnswer(20, _radioDiagnoseHBP12.toString());
                insertAnswer(21, selectedMentalPicker13.toString());
                insertAnswer(22, selectedPhysicalPicker14.toString());
                print("결과 : ${aResult}");
                Get.back();
                Get.back();
                // Get.off(const RealHome());
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }



} // END