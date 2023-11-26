import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:webview_flutter/webview_flutter.dart';

class News extends StatefulWidget {
  const News({super.key});

  @override
  State<News> createState() => _NewsState();
}

class _NewsState extends State<News> {
  // property
  late WebViewController controller;
  late bool isLoading;
  //isLoading이 true이면 값을 받아오는 중이고, false면 값을 모두 다 받아온상태
  late String siteName;
  late TextEditingController address;


@override
  void initState() {
    super.initState();

    isLoading = true;
    siteName = "www.bbc.com/korean/topics/c95y3gpd895t";
    address = TextEditingController(text: "http://");

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted) // JS code 제한x
      ..setNavigationDelegate(NavigationDelegate(
				onProgress: (progress) {
        isLoading = true;
        setState(() {});
      }, onPageStarted: (url) {
        isLoading = true;
        setState(() {});
      }, onPageFinished: (url) {
        isLoading = false;
        setState(() {});
      }, onWebResourceError: (error) {
        isLoading = false;
        setState(() {});
      }))
      ..loadRequest(Uri.parse("http://$siteName"));
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              SizedBox(
                width: 230,
                child: TextField(
                  controller: address,
                  decoration: const InputDecoration(
                    labelText: "이동할 페이지의 주소를 입력하세요.", 
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                  minimumSize: const Size(50, 30)
                ),
                
                    onPressed: () {
                      move();
                    },
                    child: const Text(
                      "Go",
                    ),
                  ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : const Stack(),
          WebViewWidget(controller: controller),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black54,
        foregroundColor: Colors.white,
        onPressed: () => backProcess(context),
        child: const Icon(Icons.arrow_back),
        ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }


// functions

// 페이지 이동
  move(){
    controller.loadRequest(Uri.parse("${address.text.trim()}"));
    address.text = "http://";
    setState(() {
      
    });
  }


// 뒤로가기
  backProcess(BuildContext context) async{
    // async 방식을 사용하면서 컨트롤러가 뒤로가기가 가능하면 컨트롤러가 뒤로가기하고 아니면 스낵바를 띄운다.
    if(await controller.canGoBack()){
      controller.goBack();
    }else{
      errorSnackBar();
    }
  }


    errorSnackBar() {
     Get.snackbar(
        "Fail", // title
        "더 이상 뒤로 갈 페이지가 없습니다.", // content
        snackPosition: SnackPosition.TOP, // 스낵바위치
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.red,
        colorText: Colors.white
        );
  }
}
