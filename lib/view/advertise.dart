import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:team3_flutter_project_self_diagnosis_app/model/storage.dart';


class AddAD extends StatefulWidget {
  const AddAD({super.key});

  @override
  State<AddAD> createState() => _AddADState();
}

class _AddADState extends State<AddAD> {
  XFile? _image; // 이미지를 담을 변수
  final ImagePicker picker = ImagePicker(); // ImagePicker 초기화

  // shared preferneces
  late String userId;
  late String password;

//이미지 파어이스에 저장하기위해 사용할 변수
  List<UploadTask> _uploadTasks = [];

  @override
  void initState() {
    super.initState();
    userId = "";
    password = "";
    initSharedPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 100,
            ),
            _buildPhotoArea(),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      getImage(
                        ImageSource.camera,
                      ); //getImage 함수를 호출해서 카메라로 찍은 사진 가져오기
                    },
                    child: const Text(
                      "카메라",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      getImage(
                        ImageSource.gallery,
                      ); //getImage 함수를 호출해서 갤러리에서 사진 가져오기
                    },
                    child: const Text("사진"),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                dbAction(_image);
              },
              child: const Text("광고 미리보기"),
            ),
          ],
        ),
      ),
    );
  }

// 이미지 보여줄 공간 위젯
  Widget _buildPhotoArea() {
    return _image != null
        ? Container(
            width: 300,
            height: 400,
            child: Image.file(File(_image!.path)), //가져온 이미지를 화면에 띄워주는 코드
          )
        : Container(
            width: 300,
            height: 400,
            color: Colors.grey,
          );
  }

  //이미지를 가져오는 함수
  Future getImage(ImageSource imageSource) async {
    //pickedFile에 ImagePicker로 가져온 이미지가 담긴다.
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile != null) {
      setState(() {
        _image = XFile(pickedFile.path); //가져온 이미지를 _image에 저장
      });
    }
  }

  // storage에 그림 넣기
  Future<Map<String, String>> addPicture(XFile? image) async {
    if (image == null) {
      print("No image selected.");
      return {};
    }

    String fileName = 'images/${DateTime.now().millisecondsSinceEpoch}.jpg';

    File imageFile = File(image.path);

    await FirebaseStorage.instance.ref(fileName).putFile(imageFile);

    final String _urlString =
        await FirebaseStorage.instance.ref(fileName).getDownloadURL();
    return {
      "image": _urlString,
      "path": fileName,
    };
  }

  // Firebase storage에서 Firestore로 이미지 옮겨주기
  // 이유는 Storage는 단지 저장소이며, 데이터베이스가 아니다. 시간지연, 리소스에 이슈발생 생길 수 있음
  // storage => firestore
  dbAction(XFile? image) async {
    Map<String, String>? _images = await addPicture(image);
    if (image != null) {
      await _toFirestore(_images);
    }
    await confirmAD();
  }

  // firestore 테이블 생성해주기
  Future<void> _toFirestore(Map<String, String> images) async {
    try {
      DocumentReference<Map<String, dynamic>> _reference =
          FirebaseFirestore.instance.collection("advertisement").doc();
      await _reference.set(Storage(
        uid: "iu",
        docId: _reference.id,
        image: images["image"].toString(),
        path: images["path"].toString(),
        dateTime: Timestamp.now(),
      ).toFirestore());
    } on FirebaseException catch (error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.message ?? "")));
    }
  }

  confirmAD() {
    Get.defaultDialog(
      title: "광고확인",
      middleText: "Home탭에서 광고를 확인하세요.",
      barrierDismissible: false,
      radius: 15,
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
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
        ),
      ],
    );
  }



  // 로그인 할 때, 넘겨준 아이디 받기 
  initSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString("p_userId")!; // null check
    password = prefs.getString("p_password")!;
    setState(() {});
  }

}//end