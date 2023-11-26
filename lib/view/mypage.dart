import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:team3_flutter_project_self_diagnosis_app/view/home.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  //property
  late TextEditingController uidController;
  late TextEditingController upasswordController;
  late TextEditingController upasswordController2;
  late TextEditingController unameController;
  late TextEditingController uphoneController;
  late TextEditingController uemailController;
  late TextEditingController uinsertdateController;
  late TextEditingController height;
  late TextEditingController weight;

  late String _passCheck;

  //shared preference
  late String userId;
  late String password;

  // shared 로 id 받아서 db에서 아이디에해당하는 유저정보가져와서 넣기위한 리스트
  late List data;

  @override
  void initState() {
    super.initState();

    // shared ID
    userId = "";
    password = "";

    _passCheck = "";

    data = [];
    uidController = TextEditingController();
    upasswordController = TextEditingController();
    upasswordController2 = TextEditingController();
    unameController = TextEditingController();
    uphoneController = TextEditingController();
    uemailController = TextEditingController();
    uinsertdateController = TextEditingController();
    height = TextEditingController();
    weight = TextEditingController();

    initSharedPreferences().then((_) {
      getJSONDataUser().then((_) {
        initValueTF();
      });
    });
  }
// init end

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(
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
                                      readOnly: true,
                                      controller: uidController,
                                      decoration: const InputDecoration(
                                        labelText: "아이디",
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
                                  SizedBox(
                                    width: 250,
                                    child: TextField(
                                      controller: uinsertdateController,
                                      decoration: const InputDecoration(
                                        labelText: "가입날짜",
                                      ),
                                      readOnly: true,
                                    ),
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
                                      snackBarFunction();
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
                    child: Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            updateAction();
                            updateFirebase();
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
                            "회원정보 수정",
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            deleteAlert();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red, // 버튼 배경색
                            foregroundColor: Colors.white, // 버튼 글씨색
                            minimumSize: const Size(300, 35),
                            shape: RoundedRectangleBorder(
                              //  버튼 모양 깎기
                              borderRadius: BorderRadius.circular(5), // 5 파라미터
                            ),
                          ),
                          child: const Text(
                            "회원탈퇴",
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

// function

// delete alert
deleteAlert(){
  Get.defaultDialog(
                  title: "DELETE",
                  middleText: " 탈퇴하시면 ${unameController.text}님의 ID로 \n 100일동안 재가입이 불가능합니다. \n 그래도 탈퇴를 진행하시겠습니까 ?",
                  barrierDismissible: false,
                  radius: 15,
                  actions: [
                    TextButton(
                      onPressed: () {
                        deleteAction();
                        deleteFirebase();
                        Get.to(const Home());
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



// 회원정보를 받아서 정보수정 alert
  _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text(
            "회원정보",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            " ${unameController.text}님의 정보가 변경되었습니다.",
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text("OK")),
          ],
        );
      },
    );
  }

//functions ---------------------------------------------


 // Shared Preferneces  로 받아온 아이디값으로 유저정보보여주기위해 아이디 받아옴
  initSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString("p_userId")!; // null check
    password = prefs.getString("p_password")!;
    print(userId);
    print(password);
    setState(() {});
  }


// Alert 


// 회원탈퇴시 
  deletesnackBarsFunction() {
     Get.snackbar(
        "", // title
        "탈퇴되었습니다.", // content
        snackPosition: SnackPosition.BOTTOM, // 스낵바위치
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.red,
        colorText: Colors.white
        );
  }


//아이디 중복메세지 스낵바  그러나 ID PK라서 변경불가한다고 보여줌 로직은 중복체크로 되어있음
  snackBarFunction() {
     Get.snackbar(
        "Error", // title
        "아이디는 변경이 불가능합니다.", // content
        snackPosition: SnackPosition.BOTTOM, // 스낵바위치
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.red,
        colorText: Colors.white
        );
  }



  errorSnackBar() {
     Get.snackbar(
        "Fail", // title
        "회원정보를 다시 확인해주세요", // content
        snackPosition: SnackPosition.BOTTOM, // 스낵바위치
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.red,
        colorText: Colors.white
        );
  }


// ---------------------------------------------

// logic 

//user info 변경
  updateAction() async {
    var url = Uri.parse(
        //"http://localhost:8080/Flutter/project/update_userinfo.jsp?uid=$userId&upassword=${upasswordController.text.trim()}&uname=${unameController.text.trim()}&height=${height.text.trim()}&weight=${weight.text.trim()}&uemail=${uemailController.text.trim()}&uphone=${uphoneController.text.trim()}");
        "http://localhost:8080/updateInfo?uid=$userId&upassword=${upasswordController.text.trim()}&uname=${unameController.text.trim()}&height=${height.text.trim()}&weight=${weight.text.trim()}&uemail=${uemailController.text.trim()}&uphone=${uphoneController.text.trim()}");
    var response = await http.get(url);
    // json은 dart가 모르기때문에 decode해야함
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    var result = dataConvertedJSON["result"];
    if (result == "OK") {
      _showDialog();
    } else {
      errorSnackBar();
    }
    setState(() {});
  }
  
// firebase update
  updateFirebase(){
FirebaseFirestore.instance.collection("user")
    .where("uid", isEqualTo: userId)  // userId가 특정 값과 일치하는 문서 선택
    .get()
    .then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        var docId = querySnapshot.docs[0].id;  // 선택한 문서의 ID 가져오기
        FirebaseFirestore.instance.collection("user").doc(docId).update({
          "upassword" : upasswordController.text.trim(),
          "uname" : unameController.text.trim(),
          "uphone" : uphoneController.text.trim(),
          "height" : height.text.trim(),
          "weight" : weight.text.trim(),
          "uemail" : uemailController.text.trim(),
          "uupdatedate" : DateTime.now(),
        });
      }
    });

  }


// delete 회원탈퇴 지만 삭제하지않고 udeleted를 1로 바꿈
  deleteAction() async {
    var url = Uri.parse(
        //"http://localhost:8080/Flutter/project/delete_user.jsp?uid=$userId");
        "http://localhost:8080/deleteUser?uid=$userId");
    await http.get(url);

    deletesnackBarsFunction();
    setState(() {});
  }


  
// firebase delete
  deleteFirebase(){
FirebaseFirestore.instance.collection("user")
    .where("uid", isEqualTo: userId)  // userId가 특정 값과 일치하는 문서 선택
    .get()
    .then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        var docId = querySnapshot.docs[0].id;  // 선택한 문서의 ID 가져오기
        FirebaseFirestore.instance.collection("user").doc(docId).update({
          "udeleted" : 1,
          "udeletedate" : DateTime.now()
        });
      }
    });

  }


//비번 일치불일치
  passwordCheck() {
    upasswordController.text.trim() == upasswordController2.text.trim()
        ? _passCheck = "일치"
        : _passCheck = "불일치";

    setState(() {});
  }

// Shared 로 ID 받아서  정보가져오기
  getJSONDataUser() async {
    var url = Uri.parse(
        //"http://localhost:8080/Flutter/project/select_userinfo.jsp?uid=$userId");
        "http://localhost:8080/userDetails?uid=$userId");
    var response = await http.get(url); // 데이터불러오기전에 화면이 켜지는 것 방지. await
    data.clear();
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    List result = dataConvertedJSON["results"];
    data.addAll(result);
    setState(() {});
  }

// 텍스트필드에 초기값 넣어주기
  initValueTF() async{
    uidController.text =await data[0]["uid"];
    upasswordController.text =await data[0]["upassword"];
    upasswordController2.text =await data[0]["upassword"];
    unameController.text =await data[0]["uname"];
    uphoneController.text =await data[0]["uphone"];
    uemailController.text = await data[0]["uemail"];
    uinsertdateController.text = await data[0]["uinsertdate"];
    height.text = await data[0]["height"].toString();
    weight.text = await data[0]["weight"].toString();
    setState(() {});
  }
} //end
