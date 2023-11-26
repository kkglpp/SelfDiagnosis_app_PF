import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/route_manager.dart';
import 'package:team3_flutter_project_self_diagnosis_app/model/qna.dart';
import 'package:team3_flutter_project_self_diagnosis_app/view/ajw_qnainsert.dart';

import '../model/qna_maessage.dart';
import 'ajw_qnadpage.dart';

class QnaPage extends StatefulWidget {
  const QnaPage({Key? key}) : super(key: key);

  @override
  State<QnaPage> createState() => _QnaPageState();
}

class _QnaPageState extends State<QnaPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            // 중앙 정렬
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    'Q&A',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    'If you have any questions, please leave a message below',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 10,
                    ),
                  ),
                  Text(
                    " Only author of text modification.",
                    style: TextStyle(
                        fontSize: 11,
                        // fontWeight: FontWeight.bold,
                        color: Colors.grey),
                  ),
                ],
              ),
            ),
          ), //
          // Image.asset(
          //   'assets/your_image_asset.png', // 이미지 에셋 경로 추가
          //   height: 150,
          //   width: double.infinity,
          //   fit: BoxFit.cover,
          // ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('qnaboard')
                  .orderBy('code', descending: true) // 'code' 필드 기준으로 오름차순 정렬
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final documents = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    return _buildItemWidget(documents[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(InsertPage());
        },
        child: const Icon(Icons.add_box),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildItemWidget(DocumentSnapshot doc) {
    final qna = Qna(
      code: doc['code'],
      title: doc['title'],
      content: doc['content'],
      date: doc['date'],
      userid: doc['userId'],
    );

    // final hasComments = qna.userid != null && qna.userid.isNotEmpty;
    return GestureDetector(
      onTap: () {
        QnaMaessage.id = doc.id;
        QnaMaessage.title = doc['title'];
        QnaMaessage.content = doc['content'];
        QnaMaessage.date = doc['date'];
        QnaMaessage.userid = doc['userId'];
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return Dpage();
            },
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
        ),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 10,
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                child: FittedBox(
                  child: Text(
                    '${qna.code}',
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                ' ${qna.title}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                'Writer: ${qna.userid}',
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Date: ${qna.date}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('comments')
                    .where('postId', isEqualTo: doc.id)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  final comments = snapshot.data!.docs;
                  if (comments.isEmpty) {
                    return const SizedBox.shrink(); // 댓글이 없을 때 'ok' 숨기기
                  } else {
                    return const Text(
                      'ok', // 댓글이 있을 때 'ok' 표시
                      style: TextStyle(
                        color: Colors.green,
                      ),
                    );
                  }
                },
              ),
              const Divider(
                height: 30,
                color: Colors.grey,
                thickness: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
