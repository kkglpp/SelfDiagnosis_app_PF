import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/borad_message.dart';

class ChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Board(),
    );
  }
}

class Board extends StatefulWidget {
  const Board({Key? key}) : super(key: key);

  @override
  State<Board> createState() => _BoardState();
}

class _BoardState extends State<Board> {
  final reference = FirebaseFirestore.instance.collection('messages');
  TextEditingController _messageController = TextEditingController();
  List<BoardMessage> messages = [];
  late String userId;
  late String password;

  @override
  void initState() {
    super.initState();
    initSharedPreferences().then((_) {
      if (userId.isNotEmpty) {
        reference
            .orderBy('timestamp') // 채팅 순서대로 정렬
            .snapshots()
            .listen((querySnapshot) {
          setState(() {
            messages = querySnapshot.docs
                .map((doc) => BoardMessage.fromJson(doc.data()))
                .toList();
          });
        });
      }
    });
  }

  void _addMessage(String text, Timestamp dateTime, String userId) {
    var message = BoardMessage(text, dateTime: dateTime, userId: userId);
    reference.add(message.toJson());
  }

  void _addReply(String text, String userId) {
    var reply = BoardMessage(
      text,
      isReply: true,
      dateTime: Timestamp.now(),
      userId: userId,
    );
    reference.add(reply.toJson());
  }

  Widget _buildChatMessageList() {
    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (context, index) {
        var message = messages[index];
        // Check if the message is from the doctor
        bool isDoctorMessage = message.userId == 'doctor';

        return Padding(
          padding: const EdgeInsets.all(3.0),
          child: Column(
            crossAxisAlignment: isDoctorMessage
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: isDoctorMessage
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.end,
                children: [
                  Text(
                    "${message.dateTime.toDate().hour}시 ${message.dateTime.toDate().minute}분",
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    message.userId, // 작성자 ID 표시
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  color: isDoctorMessage ? Colors.grey[300] : Colors.green[300],
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Text(message.message),
              ),
              const SizedBox(height: 8), // 작성자 ID와 말풍선 사이의 간격
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(child: _buildChatMessageList()),
          _buildChatInputArea(),
        ],
      ),
    );
  }

  Widget _buildChatInputArea() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                controller: _messageController,
                decoration: const InputDecoration(
                  hintText: '메시지를 입력하세요…',
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              if (_messageController.text.isNotEmpty) {
                if (userId == 'doctor') {
                  // 'doctor' 사용자만 답장 가능
                  _addReply(_messageController.text, userId);
                } else {
                  _addMessage(_messageController.text, Timestamp.now(), userId);
                }
                _messageController.clear();
              }
            },
          ),
        ],
      ),
    );
  }

  initSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString("p_userId")!;
    password = prefs.getString("p_password")!;
    setState(() {});
  }
}
