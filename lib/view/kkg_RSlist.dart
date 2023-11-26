import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:team3_flutter_project_self_diagnosis_app/view_model/rsListview.dart';
import 'package:team3_flutter_project_self_diagnosis_app/view_model/tableCalendar.dart';

class RSlist extends StatefulWidget {
  RSlist({super.key});

  @override
  State<RSlist> createState() => _RSlistState();
}

class _RSlistState extends State<RSlist> {
  late bool wholeList_bool = false;
  late bool Calendar_bool = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 80,
              ),
              Visibility(
                visible: Calendar_bool,
                child: Container(
                  width: 400,
                  height: 670,
                  color: Colors.amber,
                  child: tableCalendar_summary(),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                color: Colors.blue[100],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        fixedSize: const Size(
                          400, 50)
                        
                      ),
                      onPressed: () {
                        Calendar_bool = !Calendar_bool;
                        wholeList_bool = !wholeList_bool;
                        print(Calendar_bool);
                        print(wholeList_bool);
                        setState(() {});
                      },
                      
                      child: Text(
                        !wholeList_bool? "전체보기 (클릭)" : "달력으로 보기 (클릭)",
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w900
                        
                        ),
                        
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: wholeList_bool,
                child: Container(
                    width: 400,
                    height: 700,
                    child: RsListView()),
              ),
            ],
          ),
        ),
      ),
    );
  }
} // end
