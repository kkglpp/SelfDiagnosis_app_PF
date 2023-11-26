import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import '../model/qna_maessage.dart';
import 'ajw_qna.dart';

class UpdatePage extends StatefulWidget {
  const UpdatePage({super.key});

  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  //Property
  //Property // 텍스트 // 전역변수
  late TextEditingController codeController;
  late TextEditingController titleController;
  late TextEditingController contentController;
  late TextEditingController dateController;
  late String userId;

  @override
  void initState() {
    super.initState();
    codeController = TextEditingController();
    titleController = TextEditingController();
    contentController = TextEditingController();
    dateController = TextEditingController();

    titleController.text = QnaMaessage.title;
    contentController.text = QnaMaessage.content;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        // 휴대폰마다 크기가 다르기떄문에 사용한다.
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "To modify",
                  style: TextStyle(
                      fontSize: 30,
                      // fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                const Text(
                  "If you modify the text, the contents of the answer may be different.",
                  style: TextStyle(
                      fontSize: 11,
                      // fontWeight: FontWeight.bold,
                      color: Colors.grey),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: "Title Update.",
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: contentController,
                  maxLines: 10,
                  decoration: const InputDecoration(
                    labelText: "Content Update.",
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
                  onPressed: () {
                    FirebaseFirestore.instance
                        .collection('qnaboard')
                        .doc(QnaMaessage.id)
                        .update({
                      // 'code': codeController.text,
                      'title': titleController.text,
                      'content': contentController.text,
                      // 'date': dateController.text
                    });
                    _showDialog(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black, // 기존 색상 변경을 위한 임시 설정
                    foregroundColor: Colors.white,
                    // 텍스트 색상을 지정
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5), // 버튼 모서리를 둥글게 설정
                    ),
                  ),
                  child: const Text('수정'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _showDialog(BuildContext context) {
    Get.defaultDialog(
      title: "수정 결과",
      content: const Text("수정이 완료 되었습니다."),
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
