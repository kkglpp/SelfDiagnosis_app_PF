import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/route_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:team3_flutter_project_self_diagnosis_app/model/qna.dart';
import 'package:team3_flutter_project_self_diagnosis_app/model/qna_maessage.dart';

import '../model/message.dart';
import 'ajw_qnaupdate.dart';

class Dpage extends StatefulWidget {
  const Dpage({super.key});

  @override
  State<Dpage> createState() => _DpageState();
}

class _DpageState extends State<Dpage> {
  late TextEditingController codeController;
  late TextEditingController titleController;
  late TextEditingController contentController;
  late TextEditingController dateController;
  late TextEditingController commentController;
  late Stream<QuerySnapshot> commentsStream;
  late String uid = '';

  bool hasComments = false; // 댓글 여부 변수 추가

  @override
  void initState() {
    super.initState();
    codeController = TextEditingController();
    titleController = TextEditingController();
    contentController = TextEditingController();
    dateController = TextEditingController();
    commentController = TextEditingController();
    commentsStream = FirebaseFirestore.instance
        .collection('comments')
        .where('postId', isEqualTo: QnaMaessage.id)
        .snapshots();

    print('Message.id: ${Message.id}');
    print('QnaMaessage.userId: ${QnaMaessage.userid}');

    // codeController.text = QnaMaessage.code;
    titleController.text = QnaMaessage.title;
    contentController.text = QnaMaessage.content;
    dateController.text = QnaMaessage.date;

    initSharedPreferences().then((_) {
      if (uid.isNotEmpty) {
        // 사용자 아이디를 Message.id에 할당
        Message.id = uid;
      }
    });

    // 댓글 데이터 가져와서 댓글 여부 확인
    commentsStream.listen((snapshot) {
      final comments = snapshot.docs;
      setState(() {
        hasComments = comments.isNotEmpty; // 댓글이 있으면 true, 없으면 false
      });
    });
  }

  void addComment() {
    if (commentController.text.isNotEmpty) {
      FirebaseFirestore.instance.collection('comments').add({
        'content': commentController.text,
        'author': Message.id, // 사용자 ID를 가져와서 'author' 필드에 저장
        'date': DateTime.now().toString(),
        'postId': QnaMaessage.id,
      });
      commentController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                ' Detailed page',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              const Text(
                "Modifications can only be made by the author.",
                style: TextStyle(
                    fontSize: 11,
                    // fontWeight: FontWeight.bold,
                    color: Colors.grey),
              ),
              const SizedBox(height: 20),
              Text(
                '${QnaMaessage.title}',
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              const Divider(
                height: 30,
                color: Colors.grey,
                thickness: 2,
              ),
              const Text(
                'Content',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
              ),
              const SizedBox(height: 8),
              Text(
                '${QnaMaessage.content}',
                style: const TextStyle(fontSize: 13),
              ),
              const SizedBox(height: 100),
              Text(
                'Date: ${QnaMaessage.date}',
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: commentController,
                maxLines: 7,
                decoration: const InputDecoration(
                  labelText: "Commnet?",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (uid == QnaMaessage.userid)
                    ElevatedButton(
                      onPressed: () {
                        Get.to(UpdatePage());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(5), // 버튼 모서리를 둥글게 설정
                        ),
                      ),
                      child: const Text('수정'),
                    ),
                  const SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                    onPressed: addComment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(5), // 버튼 모서리를 둥글게 설정
                      ),
                    ),
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              if (hasComments) // 댓글이 있는 경우에만 'ok' 표시
                const Text(
                  'ok',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: commentsStream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    final comments = snapshot.data!.docs;
                    return ListView.builder(
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        final comment = comments[index];
                        return ListTile(
                          title: Text(comment['content']),
                          subtitle: Text(
                            '${comment['author']} - ${DateTime.parse(comment['date']).toLocal().toString().split('.')[0]} ',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  initSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    uid = prefs.getString("p_userId")!;
    setState(() {});
  }
}

void main() {
  runApp(const MaterialApp(
    home: Dpage(),
  ));
}
