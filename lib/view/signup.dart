import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:team3_flutter_project_self_diagnosis_app/model/message.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> with WidgetsBindingObserver {
  late TextEditingController uidController;
  late TextEditingController upasswordController;
  late TextEditingController upasswordController2;
  late TextEditingController unameController;
  late TextEditingController uemailController;
  late TextEditingController uphoneController;
  late TextEditingController height;
  late TextEditingController weight;
  late String _passCheck;

  // shared preferneces ID PW 지우기  (1)
  late AppLifecycleState _lastLifeCycleState;

  @override
  void initState() {
    super.initState();

    uidController = TextEditingController(text: Message.id);
    upasswordController = TextEditingController();
    upasswordController2 = TextEditingController();
    unameController = TextEditingController();
    uemailController = TextEditingController(text: Message.id);
    height = TextEditingController();
    weight = TextEditingController();
    uphoneController = TextEditingController(text: "010");
    _passCheck = "";

 // shared preferneces ID PW 지우기  (2)
    WidgetsBinding.instance.addObserver(this);
  }


 // shared preferneces ID PW 지우기  (3)
  //  ID PW 지우기    앱상태로 프린트찍기  => Observer
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.detached:
        print("detached");
        break;
      case AppLifecycleState.resumed:
        print("resume");
        break;
      case AppLifecycleState.inactive:
       // shared preferneces ID PW 지우기  (4) 아래 함수 control click 
        _disposeSharedPreferences();
        print("inactive");
        break;
      case AppLifecycleState.paused:
        print("paused");
        break;
      default :
        print("default");

        break;        
    }
    _lastLifeCycleState = state;
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                SizedBox(
                  height: 600,
                  width: 400,
                  child: Row(
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(50, 0, 0, 0),
                            child: Column(
                              children: [
                                SizedBox(
                                  width: 250,
                                  child: TextField(
                                    controller: uidController,
                                    decoration: const InputDecoration(
                                      labelText: "아이디를 입력하세요",
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 250,
                                  child: TextField(
                                    controller: unameController,
                                    decoration: const InputDecoration(
                                      labelText: "이름을 입력하세요",
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 250,
                                  child: TextField(
                                    controller: upasswordController,
                                    onChanged: (value) => passwordCheck(),
                                    obscureText: true,
                                    decoration: const InputDecoration(
                                      labelText: "비밀번호를 입력하세요",
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 250,
                                  child: TextField(
                                    controller: upasswordController2,
                                    onChanged: (value) => passwordCheck(),
                                    obscureText: true,
                                    decoration: const InputDecoration(
                                      labelText: "비밀번호 확인",
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 250,
                                  child: TextField(
                                    controller: uphoneController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      labelText: "전화번호를 입력하세요(숫자만입력)",
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 250,
                                  child: TextField(
                                    controller: uemailController,
                                    decoration: const InputDecoration(
                                      labelText: "이메일을 입력하세요",
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 115,
                                      child: TextField(
                                        controller: height,
                                        keyboardType:
                                            const TextInputType.numberWithOptions(
                                                decimal: true),
                                        decoration: const InputDecoration(
                                          labelText: "키(cm)",
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    SizedBox(
                                      width: 115,
                                      child: TextField(
                                        controller: weight,
                                        keyboardType:
                                            const TextInputType.numberWithOptions(
                                                decimal: true),
                                        decoration: const InputDecoration(
                                          labelText: "몸무게(kg)",
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: IconButton(
                                  onPressed: () {
                                    checkID();
                                    //Get.dialog(Calendar());
                                  },
                                  icon: const Icon(Icons.check_circle)),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 140, 0, 0),
                              child: Text(
                                _passCheck,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      insertAction();
                      insertActionFirebase();
                      Get.back();
                      setState(() {});
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple, // 버튼 배경색
                      foregroundColor: Colors.white, // 버튼 글씨색
                      minimumSize: const Size(300, 35),
                      shape: RoundedRectangleBorder(
                        //  버튼 모양 깎기
                        borderRadius: BorderRadius.circular(5), // 5 파라미터
                      ),
                    ),
                    child: const Text(
                      "회원가입",
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
// funtions  --------------------------------------------

// 비밀번호 일치 여부 확인
  passwordCheck() {
    upasswordController.text.trim() == upasswordController2.text.trim()
        ? _passCheck = "일치"
        : _passCheck = "불일치";

    setState(() {});
  }


// Shared Prefernece

 // shared preferneces ID PW 지우기  (4)
  _disposeSharedPreferences() async {
    // 저장된 ID PW를 지우기
    final prefernece = await SharedPreferences.getInstance();
    prefernece.clear();
  }





//  Alert ------------------------------------------------------

//중복메세지 스낵바
  snackBarFunction() {
     Get.snackbar(
        "", // title
        "중복된 ID 입니다.", // content
        snackPosition: SnackPosition.TOP, // 스낵바위치
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.red,
        colorText: Colors.white
        );
  }


//아이디 사용가능 스낵바
  snackBarsFunction() {
     Get.snackbar(
        "", // title
        "사용가능한 ID입니다.", // content
        snackPosition: SnackPosition.TOP, // 스낵바위치
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.green,
        colorText: Colors.white
        );
  }



// 회원정보를 받아서 가입승인 alert
  _showDialog() {
    Get.defaultDialog(
                  title: "회원가입완료",
                  middleText: " ${unameController.text}님의 가입을 축하드립니다 !",
                  backgroundColor: Colors.white,
                  barrierDismissible: false,
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
                  ],
                );
  }

  errorSnackBar() {
     Get.snackbar(
        "회원가입실패", // title
        "정보를 확인해주세요", // content
        snackPosition: SnackPosition.BOTTOM, // 스낵바위치
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.red,
        colorText: Colors.white
        );
  }



// --------------------------------------------------------


//중복체크
  checkID() async {
    var url = Uri.parse(
        //"http://localhost:8080/Flutter/project/select_schdule_dupcheck_flutter.jsp?uid=${uidController.text.trim()}");
        "http://localhost:8080/dupCheck?uid=${uidController.text.trim()}");
    var response = await http.get(url);
    // json은 dart가 모르기때문에 decode해야함
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    var result = dataConvertedJSON["result"];
    if (result == "OK") {
      // 아이디가 중복일때
      snackBarFunction();
    } else {
      // 아이디가 중복아닐때
      snackBarsFunction();
    }
    setState(() {});
  }



// insert into mySQL
  insertAction() async {
    if (uidController.text.trim().isNotEmpty &&
    upasswordController.text.trim().isNotEmpty &&
    unameController.text.trim().isNotEmpty &&
    uphoneController.text.trim().isNotEmpty &&
    uemailController.text.trim().isNotEmpty &&
    height.text.trim().isNotEmpty &&
    weight.text.trim().isNotEmpty &&
    upasswordController.text.trim() == upasswordController2.text.trim()) {
      var url = Uri.parse(
          //"http://localhost:8080/Flutter/project/insert_schedule_user_register.jsp?uid=${uidController.text.trim()}&upassword=${upasswordController.text.trim()}&uname=${unameController.text.trim()}&weight=${weight.text.trim()}&height=${height.text.trim()}&uemail=${uemailController.text.trim()}&uphone=${uphoneController.text.trim()}");
          "http://localhost:8080/insertUser?uid=${uidController.text.trim()}&upassword=${upasswordController.text.trim()}&uname=${unameController.text.trim()}&weight=${weight.text.trim()}&height=${height.text.trim()}&uemail=${uemailController.text.trim()}&uphone=${uphoneController.text.trim()}");
      await http.get(url);
      _showDialog();
    } else {
      errorSnackBar();
    }
  }





// 파이어베이스 DB에 user 정보 추가
  insertActionFirebase() {
    if (uidController.text.trim().isNotEmpty &&
    upasswordController.text.trim().isNotEmpty &&
    unameController.text.trim().isNotEmpty &&
    uphoneController.text.trim().isNotEmpty &&
    uemailController.text.trim().isNotEmpty &&
    height.text.trim().isNotEmpty &&
    weight.text.trim().isNotEmpty &&
    upasswordController.text.trim() == upasswordController2.text.trim()) {
      // 현재 시간 생성
      Timestamp now = Timestamp.now();

      FirebaseFirestore.instance.collection("user").add({
        "uid": uidController.text.trim(),
        "upassword": upasswordController.text.trim(),
        "uname": unameController.text.trim(),
        "uphone": uphoneController.text.trim(),
        "uemail": uemailController.text.trim(),
        "weight": weight.text.trim(),
        "height": height.text.trim(),
        "uinsertdate": now,
        "udeleted": 0,
        "ucardio": 0,
        "udemetia": 0,
        "udiabetes": 0
      });
      _showDialog();

    } else {
      errorSnackBar();
    }

    setState(() {});
  }
}//end
