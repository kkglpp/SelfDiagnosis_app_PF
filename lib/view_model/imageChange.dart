import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ImageChanger extends StatefulWidget {
  const ImageChanger({super.key});

  @override
  State<ImageChanger> createState() => _ImageChangerState();
}

class _ImageChangerState extends State<ImageChanger> {
  // property
  late List imageFile;
  late int currentPage;
  late Timer _timer;


  @override
  void initState() {
    super.initState();
    imageFile = [];
    currentPage = 0;
    getAD();
    // Timer 구동
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      changeImage();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (imageFile.isEmpty) {
      // 이미지가 없는 경우에 대한 처리 (예: 로딩 중 표시 등)
      return const CircularProgressIndicator(); // 예시로 로딩 인디케이터를 표시
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 50, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "광고문의 Settings",
                  style: TextStyle(
                    fontSize: 10,
                  ),
                )
              ],
            ),
          ),
          Image.network(
            "${imageFile[currentPage]}",
            width: 300,
            height: 200,
          ),
        ],
      );
    }
  }

// functions
  changeImage() {
    // index number change
    currentPage++;
    if (currentPage >= imageFile.length) {
      currentPage = 0;
    }
    setState(() {});
  }

  // 파이어베이스에서 image가져오기
  Future<void> getAD() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection("advertisement")
        .orderBy("dateTime", descending: true)
        .get();

    for (QueryDocumentSnapshot<Map<String, dynamic>> document
        in querySnapshot.docs) {
      String imageName = document.get("image");
      imageFile.add(imageName);
      print("@@$imageName");
    }

    setState(() {});
  }
} // end
