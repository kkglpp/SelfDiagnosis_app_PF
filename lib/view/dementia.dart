import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class Dementia extends StatefulWidget {
  const Dementia({super.key});

  @override
  State<Dementia> createState() => _DementiaState();
}

class _DementiaState extends State<Dementia> {

  // property
  late int pageCount;
  late PageController _pageController;

  late List data; 

  late int _radioGender;
  late DateTime birthday;

  @override
  void initState() {
    super.initState();
    pageCount = 0;
    _pageController = PageController(initialPage: 0);

    _radioGender = 0;
    birthday  = DateTime.now();

    data = [];
    getSurvey();
    
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
        // physics: const NeverScrollableScrollPhysics(),
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
                  Text(
                    '문항 ${index + 1}',
                    style: const TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: 350,
                    height: 100,
                    child: Text(
                      '${data[index]['question']}',
                      style: const TextStyle(
                        fontSize: 30
                      ), 
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_pageController.page == 0)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Radio(
                              value: 0, 
                              groupValue: _radioGender, 
                              onChanged: (value) {
                                _radioGender = value!;
                                setState(() {
                                  
                                });
                              },
                            ),
                            const Text(
                              '여성',
                              style: TextStyle(fontSize: 20),
                              ),
                            const SizedBox(width: 30,),
                            Radio(
                              value: 1, 
                              groupValue: _radioGender, 
                              onChanged: (value) {
                                _radioGender = value!;
                                setState(() {
                                  
                                });
                              },
                            ),
                            const Text(
                              '남성',
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                      if (_pageController.page == 1)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 400,
                              height: 300,
                              child: CupertinoDatePicker(
                                mode: CupertinoDatePickerMode.date,
                                initialDateTime: birthday,
                                minimumDate: DateTime(1900, 1, 1),
                                maximumDate: DateTime.now(),
                                // dateOrder: DatePickerDateOrder.ymd,
                                onDateTimeChanged: (DateTime newDate) {
                                  birthday = newDate;
                                  setState(() {
                                    
                                  });
                                },
                              ),
                            ),
                          ],
                        )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
                        child: Text('${index + 1} / ${data.length}'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: ElevatedButton(
                          onPressed: () {
                            moveNextPage();
                          }, 
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)
                            )
                          ),
                          child: const Text('다음'),
                        ),
                      ),
                    ],
                  ),
                  if (_pageController.page == pageCount - 1)
                    Padding(
                      padding: const EdgeInsets.all(100.0),
                      child: ElevatedButton(
                        onPressed: () {
                          // checkField();
                        }, 
                        style: ElevatedButton.styleFrom(
                          maximumSize: const Size(300, 100),
                          minimumSize: const Size(300, 80),
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


  // --------- functions ---------
  // 1. 치매 설문 내용 받아오기 (완료)
  getSurvey() async{
    var url = Uri.parse(
      'http://localhost:8080/Flutter/project/select_survey_category_3.jsp'
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




} // END