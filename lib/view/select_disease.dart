import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:team3_flutter_project_self_diagnosis_app/view/cardiovascular_disease.dart';
import 'package:team3_flutter_project_self_diagnosis_app/view/dementia.dart';
import 'package:team3_flutter_project_self_diagnosis_app/view/diabetes.dart';
import 'package:team3_flutter_project_self_diagnosis_app/view_model/realhome.dart';

class SelectDisease extends StatelessWidget {
  const SelectDisease({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '진단하실 질환을 선택해 주세요',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // const Padding(
            //   padding: EdgeInsets.all(20.0),
            //   child: Text(
            //     '진단하실 질환을 선택해 주세요',
            //     style: TextStyle(
            //       fontSize: 25,
            //       fontWeight: FontWeight.bold
            //     ),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.all(50.0),
              child: ElevatedButton(
                onPressed: () => Get.to(const CardiovascularDisease()), 
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[50],
                  minimumSize: const Size(100, 80),
                  maximumSize: const Size(350, 80),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)
                  )
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '심혈관 질환',
                          style: TextStyle(
                            fontSize:35,
                            color: Colors.blueGrey[800]
                          ),
                        ),
                        const SizedBox(width: 30,),
                      ],
                    ),
                    Positioned(
                      right: 0,
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white
                        ),
                        child: Center(
                          child: Icon(
                            Icons.chevron_right,
                            size: 50,
                            color: Colors.red[100],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(50.0),
              child: ElevatedButton(
                onPressed: () => Get.to(const Diabetes()), 
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[50],
                  minimumSize: const Size(100, 80),
                  maximumSize: const Size(350, 80),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)
                  )
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '당뇨',
                          style: TextStyle(
                            fontSize:35,
                            color: Colors.blueGrey[800]
                          ),
                        ),
                        const SizedBox(width: 30,),
                      ],
                    ),
                    Positioned(
                      right: 0,
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white
                        ),
                        child: Center(
                          child: Icon(
                            Icons.chevron_right,
                            size: 50,
                            color: Colors.green[100],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(50.0),
              child: ElevatedButton(
                onPressed: () {
                  _showDialog(context);
                  // Get.to(const Dementia());
                }, 
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan[50],
                  minimumSize: const Size(100, 80),
                  maximumSize: const Size(350, 80),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)
                  )
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '치매',
                          style: TextStyle(
                            fontSize:35,
                            color: Colors.blueGrey[800]
                          ),
                        ),
                        const SizedBox(width: 30,),
                      ],
                    ),
                    Positioned(
                      right: 0,
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white
                        ),
                        child: Center(
                          child: Icon(
                            Icons.chevron_right,
                            size: 50,
                            color: Colors.cyan[100],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "ERROR ! ",
          ),
          content: const Text(
            "죄송합니다. 현재 서비스를 준비중 입니다.",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
                // Get.off(const RealHome());
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

} // END