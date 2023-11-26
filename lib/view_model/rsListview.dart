import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:team3_flutter_project_self_diagnosis_app/view/kkg_RSdetail.dart';
import 'package:http/http.dart' as http;

class RsListView extends StatefulWidget {
  const RsListView({super.key});

  @override
  State<RsListView> createState() => _RsListViewState();
}

class _RsListViewState extends State<RsListView> {
  late List cardio_List;
  late List diabetes_List;
  late List diamentia_List;
  bool list1 = false; //심혈관질환 리스트 on/off
  bool list2 = false; //당뇨 리스트 on/off
  bool list3 = false; //치매 리스트 on/off
  bool list4 = false; //BMI 리스트 on/off
  String uid = "";

  @override
  void initState() {
    cardio_List = [];
    diabetes_List = [];
    diamentia_List = [];

    _getList();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // -----------1111111111111111111111111111111111111111111111111111111111111111-----
        // 심혈관 자가진단 내역.
        Card(
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                width: 20,
                height: 50,
              ),
              const SizedBox(width: 150, child: Text('심혈관 자가진단 내역')),
              const SizedBox(
                width: 150,
              ),
              IconButton(
                  onPressed: () {
                    list1 = list1 ? false : true;
                    list2 = false;
                    list3 = false;
                    list4 = false;
                    setState(() {});
                  },
                  icon: list1
                      ? const Icon(Icons.arrow_circle_up)
                      : const Icon(Icons.arrow_circle_down))
            ],
          ),
        ),
        //심혈관 자가진단 내역 리스트. 버튼 누르면 보이고, 또누르면 감추고.
        Visibility(
          visible: list1,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(45, 0, 0, 0),
            child: SizedBox(
              width: 350,
              height: (10 + 70 * cardio_List.length).toDouble(),
              child: Card(
                color: const Color.fromARGB(255, 233, 233, 233),
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(15, 15, 5, 5),
                  itemCount: cardio_List.length,
                  itemBuilder: (context, index) {
                    if (cardio_List.isEmpty) {
                      // 리스트가 비어있는 경우에 빈 화면을 반환
                      return const SizedBox();
                    } else {
                      return Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              elevation: 3,
                              foregroundColor: Colors.black,
                              backgroundColor: cardio_List[index]
                                          ['cardio_rs'] ==
                                      0
                                  ? const Color.fromARGB(255, 157, 216, 255)
                                  : const Color.fromARGB(255, 255, 150, 185)),
                          onPressed: () {
                            Get.to(const RSdetail(), arguments: [
                              cardio_List[index]['cardio_insertdate'],
                              1,
                              cardio_List[index]['cardio_rs']
                            ]);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                // ignore: prefer_interpolation_to_compose_strings
                                "검사 시간 :    " +
                                    cardio_List[index]['cardio_insertdate']!,
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ),
        ),
        // -----------2222222222222222222222222222222222222222222-----
        // 당뇨 자가진단 내역.
        Card(
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                width: 20,
                height: 50,
              ),
              const SizedBox(width: 150, child: Text('당뇨 자가진단 내역')),
              const SizedBox(
                width: 150,
              ),
              IconButton(
                  onPressed: () {
                    list1 = false;
                    list2 = !list2;
                    list3 = false;
                    list4 = false;
                    setState(() {});
                  },
                  icon: list2
                      ? Icon(Icons.arrow_circle_up)
                      : Icon(Icons.arrow_circle_down))
            ],
          ),
        ),
        //당뇨 자가진단 내역 리스트. 버튼 누르면 보이고, 또누르면 감추고.
        Visibility(
          visible: list2,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(45, 0, 0, 0),
            child: SizedBox(
              height: (75 * diabetes_List.length).toDouble(),
              child: Card(
                color: Color.fromARGB(255, 233, 233, 233),
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(15, 15, 5, 5),
                  itemCount: diabetes_List.length,
                  itemBuilder: (context, index) {
                    if (diabetes_List.length == 0 || diabetes_List.isEmpty) {
                      // 리스트가 비어있는 경우에 빈 화면을 반환
                      return SizedBox();
                    } else {
                      return Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              elevation: 3,
                              foregroundColor: Colors.black,
                              backgroundColor:
                                  diabetes_List[index]['diabetes_rs'] == 0
                                      ? const Color.fromARGB(255, 157, 216, 255)
                                      : Color.fromARGB(255, 255, 150, 185)),
                          onPressed: () {
                            Get.to(const RSdetail(), arguments: [
                              diabetes_List[index]['diabetes_insertdate'],
                              1,
                              diabetes_List[index]['diabetes_rs']
                            ]);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              // ignore: prefer_interpolation_to_compose_strings
                              Text("검사 시간 :    " +
                                  diabetes_List[index]['diabetes_insertdate']!),
                            ],
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ),
        ),
        // -----------3333333333333333333333333333333333333333333333-----
        // 치매 자가진단 내역.
        Card(
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                width: 20,
                height: 50,
              ),
              const SizedBox(
                width: 150,
                child: Text('치매 자가진단 내역'),
              ),
              const SizedBox(
                width: 150,
              ),
              IconButton(
                  onPressed: () {
                    list1 = false;
                    list2 = false;
                    list3 = !list3;
                    list4 = false;
                    setState(() {});
                  },
                  icon: list3
                      ? Icon(Icons.arrow_circle_up)
                      : Icon(Icons.arrow_circle_down))
            ],
          ),
        ),
        //치매 자가진단 내역 리스트. 버튼 누르면 보이고, 또누르면 감추고.
        Visibility(
          visible: list3,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(45, 0, 0, 0),
            child: SizedBox(
              height: (75 * diamentia_List.length).toDouble(),
              child: Card(
                color: Color.fromARGB(255, 233, 233, 233),
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(15, 15, 5, 5),
                  itemCount: diamentia_List.length,
                  itemBuilder: (context, index) {
                    if (diamentia_List.length == 0 || diamentia_List.isEmpty) {
                      // 리스트가 비어있는 경우에 빈 화면을 반환
                      return SizedBox();
                    } else {
                      return Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              elevation: 3,
                              foregroundColor: Colors.black,
                              backgroundColor:
                                  diamentia_List[index]['diamentia_rs'] == 0
                                      ? const Color.fromARGB(255, 157, 216, 255)
                                      : Color.fromARGB(255, 255, 150, 185)),
                          onPressed: () {
                            Get.to(const RSdetail(), arguments: [
                              diamentia_List[index]['diamentia_insertdate'],
                              1,
                              diamentia_List[index]['diamentia_rs']
                            ]);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                // ignore: prefer_interpolation_to_compose_strings
                                "검사 시간 :   " +
                                    diamentia_List[index]
                                        ['diamentia_insertdate']!,
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 100,
        ),
      ],
    ); // 항목별 자가진단 내역 보기. 버튼 누르면 활성화. 안누르면 감추기.
  } //function

// ----------Function -------------

  _getUid() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    uid = pref.getString('p_userId')!;
  }

  _getList() async {
    _getUid();

    cardio_List.clear();
    diabetes_List.clear();
    diamentia_List.clear();

    // 심혈관질환 자가진단 내역 가져오기.
    var url_cardio = Uri.parse("http://localhost:8080/.cardioList?uid=iu");
    var response_cardio = await http.get(url_cardio);

    // 원래 하던대로.
    var dataConvertedJSON = json.decode(utf8.decode(response_cardio.bodyBytes));
    List result_cardio = dataConvertedJSON['cardio'] ?? [];
    cardio_List.addAll(result_cardio ?? []);

    List result_diabetes = dataConvertedJSON['diabetes'] ?? [];
    diabetes_List.addAll(result_diabetes ?? []);

    List result_diamentia = dataConvertedJSON['diamentia'] ?? [];
    diamentia_List.addAll(result_diamentia ?? []);

    setState(() {});
  }
}//end