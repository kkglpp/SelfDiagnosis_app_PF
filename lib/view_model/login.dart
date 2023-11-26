import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:team3_flutter_project_self_diagnosis_app/model/message.dart';
import 'package:team3_flutter_project_self_diagnosis_app/view/homepage.dart';
import 'package:team3_flutter_project_self_diagnosis_app/view/signup.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with WidgetsBindingObserver {
  bool _passwordVisible = false;
  TextEditingController upasswordController = TextEditingController();
  TextEditingController uidController = TextEditingController();
  bool _visibility = true;

  late AppLifecycleState _lastLifeCycleState;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    _initSharedPreferences(); // Shared Preference 초기화
  }

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
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          Visibility(
            visible: !_visibility,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 50, 8, 8),
                  child: SizedBox(
                    width: 250,
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      controller: uidController,
                      decoration: InputDecoration(
                        labelText: 'ID',
                        hintText: 'Enter your ID',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        // 이것이 핵심 아이디어이다
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 250,
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      controller: upasswordController,
                      obscureText: !_passwordVisible, //이것은 텍스트를 동적으로 가리게 할 것이다
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: 'Enter your password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            // passwordVisible 상태에 따라 아이콘을 선택한다
                            _passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            // 상태를 업데이트한다. 즉, passwordVisible 변수의 상태를 토글한다.
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      login();
                      _visibility = !_visibility;
                      setState(() {});
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple, // 버튼 배경색
                      foregroundColor: Colors.white, // 버튼 글씨색
                      shape: RoundedRectangleBorder(
                        //  버튼 모양 깎기
                        borderRadius: BorderRadius.circular(10), // 10은 파라미터
                      ),
                    ),
                    child: const Text(
                      "Log In",
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _visibility = !_visibility;
                    setState(() {});
                  },
                  child: const Text(
                    "회원가입을 하시겠습니까 ?",
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: _visibility,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 150, 8, 8),
                  child: ElevatedButton(
                    onPressed: () {
                      Get.to(() => const SignUp());
                      setState(() {});
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple, // 버튼 배경색
                      foregroundColor: Colors.white, // 버튼 글씨색
                      minimumSize: Size(300, 50),
                      shape: RoundedRectangleBorder(
                        //  버튼 모양 깎기
                        borderRadius: BorderRadius.circular(30), // 10은 파라미터
                      ),
                    ),
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                OutlinedButton(
                  onPressed: () {
                    _visibility = !_visibility;
                    setState(() {});
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.purple,
                    minimumSize: const Size(300, 50),
                    side: const BorderSide(
                      // 테두리
                      color: Colors.purple, // 테두리 색상
                      width: 2.7, // 테두리 두께
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text(
                    "Log In",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      kakao();
                      setState(() {});
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow, // 버튼 배경색
                      foregroundColor: Colors.black, // 버튼 글씨색
                      minimumSize: Size(300, 50),
                      shape: RoundedRectangleBorder(
                        //  버튼 모양 깎기
                        borderRadius: BorderRadius.circular(30), // 10은 파라미터
                      ),
                    ),
                    child: const Text(
                      "Kakao Login",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

// ---------------- functions----------

// Shared Preferneces

  _initSharedPreferences() async {
    final preference = await SharedPreferences.getInstance();
    uidController.text =
        preference.getString("p_userId") ?? ""; // null 이면 빈문자를 넣는다.
    upasswordController.text = preference.getString("p_password") ?? "";

    // 메모리에 결과값이 남아있는지 테스트
    // 앱을 종료하고 다시 실행하면 Shared Preference에 남아 있으므로
    // 앱을 종료시 정리하여야 한다.

    print(uidController.text);
    print(upasswordController.text);
  }

  _saveSharedPreferences() async {
    // ID PW 를 저장함
    final prefernece = await SharedPreferences.getInstance();
    prefernece.setString("p_userId", uidController.text.trim());
    prefernece.setString("p_password", upasswordController.text.trim());
  }

  _disposeSharedPreferences() async {
    // 저장된 ID PW를 지우기
    final prefernece = await SharedPreferences.getInstance();
    prefernece.clear();
  }

  // --------------------------------------------------------------
  // Alert

// 로그인 성공
  _showDialog() {
    Get.defaultDialog(
      title: "로그인 성공",
      middleText: "로그인 성공되었습니다.",
      //backgroundColor: Colors.amber,
      barrierDismissible: false,
      actions: [
        TextButton(
          onPressed: () {
            _saveSharedPreferences();
            Get.back();
            Get.to(() => HomePage());
          },
          child: const Text(
            "OK",
          ),
        ),
      ],
    );
  }

// 탈퇴된 회원일때
  _deletedAlert() {
    // _를 처음에 사용하면 private
    Get.defaultDialog(
      title: "Error",
      middleText: "탈퇴된 회원입니다.",
      //backgroundColor: Colors.amber,
      barrierDismissible: false,
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text(
                "OK",
              ),
            ),
          ],
        ),
      ],
    );
  }

// 아이디 비번이 일치하지 않을때
  _FailAlert() {
    Get.defaultDialog(
      title: "Fail",
      middleText: "ID와 Password 를 확인해주세요",
      barrierDismissible: false,
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text(
                "OK",
              ),
            ),
          ],
        ),
      ],
    );
  }

//-------------------------------------------------------------

// 로그인 함수

  login() async {
    var url = Uri.parse(
        "http://localhost:8080/.login?uid=${uidController.text.trim()}&upassword=${upasswordController.text.trim()}");
    //"http://localhost:8080/Flutter/project/login_schdule_flutter.jsp?uid=${uidController.text.trim()}&upassword=${upasswordController.text.trim()}");
    var response = await http.get(url);
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    List result = dataConvertedJSON["results"];
    print(result[0]["udeleted"]);
    print(result);
    if (result.isNotEmpty &&
        result[0]["count"] == 1 &&
        result[0]["udeleted"] == 0) {
      // 로그인 가능할때
      //_SuccessAlert(result);
      String name = result[0]["uname"];
      Message.name = name;
      _showDialog();
    } else {
      // 탈퇴된 회원
      if (result.isNotEmpty && result[0]["udeleted"] == 1) {
        _deletedAlert();
      } else {
        // 아이디 비번이 일치하지 않을때
        _FailAlert();
      }
    }
  }

// kakao login
  kakao() async {
    try {
      bool isInstalled = await isKakaoTalkInstalled();

      OAuthToken token = isInstalled
          ? await UserApi.instance.loginWithKakaoTalk()
          : await UserApi.instance.loginWithKakaoAccount();

      final url = Uri.https('kapi.kakao.com', '/v2/user/me');

      final response = await http.get(
        url,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${token.accessToken}'
        },
      );

      final profileInfo = json.decode(response.body);
      print(profileInfo.toString());
      print(profileInfo["id"]);
      print(profileInfo["kakao_account"]);

      try {
        User user = await UserApi.instance.me();
        print('사용자 정보 요청 성공'
            '\n회원번호: ${user.id}'
            '\n닉네임: ${user.kakaoAccount?.profile?.nickname}'
            '\n이메일: ${user.kakaoAccount?.email}');

        //  이메일이 회원가입이 되어있는지 아닌지 확인하기
        Future<int> rsNum = kakaoLoginAction(user.kakaoAccount?.email);
        int rs = await rsNum;
        if (rs == 1) {
          _showDialog();
        } else {
          toSignUp(user.kakaoAccount?.email);
        }
      } catch (error) {
        print('사용자 정보 요청 실패 $error');
      }
    } catch (error) {
      print('카카오톡으로 로그인 실패 $error');
    }
  }

// kakao sign up page로 보내기
  toSignUp(String? id) {
    Message.id = id.toString();
    Get.to(() => const SignUp());
  }

// kakao 회원가입 되어있으면 로그인하기
  Future<int> kakaoLoginAction(String? email) async {
    var url = Uri.parse("http://localhost:8080/kakaoLogin?uid=$email");
    var response = await http.get(url);
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    List result = dataConvertedJSON["results"];
    if (result.isNotEmpty &&
        result[0]["count"] == 1 &&
        result[0]["udeleted"] == 0) {
      // 로그인 가능할때
      String name = result[0]["uname"];
      Message.name = name;
      return 1;
    } else {
      return 0;
    }
  }

} // end 
