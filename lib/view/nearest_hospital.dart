import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NearestHospital extends StatefulWidget {
  const NearestHospital({super.key});

  @override
  State<NearestHospital> createState() => _NearestHospitalState();
}

class _NearestHospitalState extends State<NearestHospital> {

  // property
  String url = "";
  late WebViewController webViewController; 
  late bool isLoading;

  @override
  void initState() {
    super.initState();
    isLoading = true;

    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onProgress: (progress) {
          isLoading = true;
          setState(() {
            
          });
        },
        onPageStarted: (url) {
          isLoading = true;
          setState(() {
            
          });
        },
        onPageFinished: (url) {
          isLoading = false;
          setState(() {
            
          });
        },
        onWebResourceError: (error) {
          isLoading = false;
          setState(() {
            
          });
        },
      ))
      ..addJavaScriptChannel(
        'onClickMarker', 
        onMessageReceived: (JavaScriptMessage message) {
          print(message.message);
          Get.snackbar("뭐에 대한 거지?", message.message);
        },
      )
      // ..addJavaScriptChannel(
      //   'onClickMarker', 
      //   onMessageReceived: (message) {
      //     Get.snackbar("뭐에 대한 거지?", message.message);
      //   } ,)
      ..runJavaScript('alert("$url")')
      ..loadRequest(Uri.parse("http://localhost:8080/kakaoMapView"));
      // ..loadRequest(Uri.parse("http://localhost:8080/Flutter/project/hospitalMap.jsp"));
      // ..loadRequest(Uri.parse("http://www.naver.com"));
      // ..loadRequest(Uri.parse("https://map.naver.com/v5/?c=15,0,0,0,dh"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('내 주변 병원 찾기'),
      ),
      body: Stack(
        children: [
          isLoading
          ? const Center(
            child: CircularProgressIndicator(),
          )
          : Stack(
            alignment: Alignment.center,
              children: [
                Expanded(
                  // width:400 ,
                  // height: 600,
                  child: WebViewWidget(
                    controller: webViewController,
                    // webViewController.runJavaScriptReturningResult(javaScript)
                  ),
                ),
              ],
          ),
          // SizedBox(
          //   width: 400,
          //   height: 600,
          //   child: WebViewWidget(
          //     controller: webViewController,
          //   ),
          // ),
          // Stack(
          //   // alignment: Alignment.bottomCenter,
          //   children: [
          //     Positioned(
          //       left: 20,
          //       top: 600,
          //       child: Container(
          //         width: 400,
          //         height: 200,
          //         color: Colors.red,
          //       ),
          //     )
          //   ],
          // )
        ],
      )
    );
  }
}