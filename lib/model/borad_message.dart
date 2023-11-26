import 'package:cloud_firestore/cloud_firestore.dart';

class BoardMessage {
  String message;
  bool isReply;
  Timestamp dateTime;
  String userId;

  BoardMessage(this.message,
      {this.isReply = false, required this.dateTime, required this.userId})
      : assert(dateTime != null);

  factory BoardMessage.fromJson(Map<String, dynamic> json) {
    return BoardMessage(
      json['message'],
      isReply: json['isReply'] ?? false,
      dateTime: json['timestamp'],
      userId: json['userId'], // userId 파라미터에 값을 전달
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['message'] = message;
    data['isReply'] = isReply;
    data['timestamp'] = Timestamp.now();
    data['userId'] = userId;

    return data;
  }
}
