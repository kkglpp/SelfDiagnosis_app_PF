import 'package:cloud_firestore/cloud_firestore.dart';

class Storage{


  final String uid;
  final String docId;
  final String image;
  final String path;
  final Timestamp dateTime;


  Storage({
    required this.uid,
    required this.docId,
    required this.image,
    required this.path,
    required this.dateTime,
  });


  factory Storage.fromFirestore(Map<String, dynamic> json) {
    return Storage(
      uid: json["uid"],
      docId: json["docId"],
      image: json["image"],
      path: json["path"],
      dateTime: json["dateTime"],
    );
  }


    Map<String, dynamic> toFirestore() => {
        "uid": uid,
        "docId": docId,
        "image": image,
        "path": path,
        "dateTime": dateTime,
      };
}