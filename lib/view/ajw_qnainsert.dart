import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/message.dart';
import '../model/qna_maessage.dart';
import 'ajw_qna.dart';

class InsertPage extends StatefulWidget {
  const InsertPage({super.key});

  @override
  State<InsertPage> createState() => _InsertPageState();
}

class _InsertPageState extends State<InsertPage> {
  late TextEditingController titleController;
  late TextEditingController contentController;
  late String userId;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    contentController = TextEditingController();
    initSharedPreferences().then((_) {
      if (userId.isNotEmpty) {
        // 사용자 아이디를 Message.id에 할당
        Message.id = userId;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "To make an inquiry",
                    style: TextStyle(
                        fontSize: 30,
                        // fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  const Text(
                    "1. Please write down the exact problem.",
                    style: TextStyle(
                        fontSize: 11,
                        // fontWeight: FontWeight.bold,
                        color: Colors.grey),
                  ),
                  const Text(
                    "2. Please write down what you want to solve",
                    style: TextStyle(
                        fontSize: 11,
                        // fontWeight: FontWeight.bold,
                        color: Colors.grey),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: "Write a title",
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: contentController,
                    maxLines: 10,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.content_copy_outlined),
                      labelText: "Please enter your content",
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(2)),
                        borderSide: BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      QuerySnapshot qnaboardSnapshot = await FirebaseFirestore
                          .instance
                          .collection('qnaboard')
                          .get();
                      int nextCode = qnaboardSnapshot.size + 1; // code 자동생성
                      DateTime now = DateTime.now(); // date 입력날짜 자동생성
                      String formattedDate =
                          "${now.year}-${now.month}-${now.day} ${now.hour}:${now.minute}";
                      DocumentReference docRef = FirebaseFirestore.instance
                          .collection('qnaboard')
                          .doc();
                      await docRef.set({
                        'code': nextCode,
                        'userId': Message.id, // 로그인 된 사용자 아이디
                        'title': titleController.text,
                        'content': contentController.text,
                        'date': formattedDate,
                      });
                      _showDialog(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5), // 버튼 모서리를 둥글게!
                      ),
                    ),
                    child: const Text('OK'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  initSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString("p_userId")!;
    setState(() {});
  }

  _showDialog(BuildContext context) {
    Get.defaultDialog(
      title: "입력 결과",
      content: const Text("입력이 완료 되었습니다."),
      barrierDismissible: false,
      actions: [
        ElevatedButton(
          onPressed: () {
            Get.back();
            Get.back();
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
