import 'package:flutter/material.dart';

import 'dart:convert';

import 'package:get/route_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:team3_flutter_project_self_diagnosis_app/model/message.dart';

class RSdetail_Viewmodel extends StatefulWidget {
  const RSdetail_Viewmodel({super.key});


  @override
  State<RSdetail_Viewmodel> createState() => _RSdetail_ViewmodelState();
}

class _RSdetail_ViewmodelState extends State<RSdetail_Viewmodel> {

  late var value = Get.arguments ?? '';
  late String uid;
  late String insertdate;
  late int result;
  late int category;
  late List answerList;
  @override
  void initState() {
    super.initState();
    uid = '';
    insertdate = value[0].toString() ?? ' ';
    result = value[2] ?? '';
    category = value[1] ?? ' ';
    answerList = [];
    catID();
  }






  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 10),
              child: Text(
                '${Message.name} 님의 자가 진단 내용입니다.',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SizedBox(
                height: 520,
                //color: Colors.grey,
                child: ListView.builder(
                  itemCount: answerList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                      child: Card(
                        elevation: 10,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 230,
                                  height: 70,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [

                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(30,0,0,0),
                                            child: SizedBox(
                                              width:200 ,
                                              child: Text(
                                                answerList[index]['question'],
                                                maxLines: 2,
                                                
                                                style: const TextStyle(fontSize: 13),
                                                overflow: TextOverflow.ellipsis
                                                
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.fromLTRB(20,0,0,0),
                                  child: SizedBox(
                                    width: 70,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          answerList[index]['answer'].toString() == '0'
                                              ? '아니오'
                                              : answerList[index]['answer']
                                                          .toString() ==
                                                      '1'
                                                  ? '예'
                                                  : answerList[index]['answer']
                                                      .toString(),
                                          style: const TextStyle(fontSize: 15),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(
              width: 380,
              height: 70,
              child: Card(
                color: result == 0
                    ? Color.fromARGB(255, 157, 216, 255)
                    : const Color.fromARGB(255, 255, 160, 191),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _setresult(),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      );
  }

    // function
  catID() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();

    uid = pref.getString('p_userId')!;
    setState(() {});

    answerList.clear();

    var url_QnA = Uri.parse(
        "http://localhost:8080/detailList?uid=$uid&insertdate=$insertdate");
    var response_QnA = await http.get(url_QnA);

    var dataConvertedJSON = json.decode(utf8.decode(response_QnA.bodyBytes));

    List result_QnA = dataConvertedJSON["detailList"];

    answerList.addAll(result_QnA);

    setState(() {});
  }

  String _setresult() {
    switch (result) {
      case 1:
        switch (category) {
          case 1:
            return '심혈관질환이 심각히 우려됩니다.';
          case 2:
            return '당뇨가 심각히 우려됩니다.';
          case 3:
            return ' 치매가 심각히 우려 됩니다.';
        }

      case 0:
        switch (category) {
          case 1:
            return '심혈관질환 가능성이 낮습니다.';
          case 2:
            return '당뇨 가능성이 낮습니다.';
          case 3:
            return ' 치매가 가능성이 낮습니다.';
        }
    }
    return '';
  }
}