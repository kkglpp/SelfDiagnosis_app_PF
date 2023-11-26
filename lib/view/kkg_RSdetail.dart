import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:team3_flutter_project_self_diagnosis_app/model/message.dart';
import 'package:team3_flutter_project_self_diagnosis_app/view_model/rsDetail_viewmodel.dart';

class RSdetail extends StatefulWidget {
  const RSdetail({super.key});

  @override
  State<RSdetail> createState() => _RSdetailState();
}

class _RSdetailState extends State<RSdetail> {
  late var value = Get.arguments ?? '';
  late String insertdate;
  late int result;
  late int category;

  @override
  void initState() {
    super.initState();

    insertdate = value[0].toString() ?? ' ';
    result = value[2] ?? '';
    category = value[1] ?? ' ';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            '자가 진단 기록',
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
          foregroundColor: Colors.white,
          backgroundColor: result == 0
              ? const Color.fromARGB(255, 157, 216, 255)
              : const Color.fromARGB(255, 255, 160, 191),
        ),
        body: const RSdetail_Viewmodel());
  }
}//end