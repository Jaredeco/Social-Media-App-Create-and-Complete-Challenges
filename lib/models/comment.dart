import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  String text;
  String uid;
  Timestamp timeCreated;

  Comment(
    this.text,
    this.uid,
    this.timeCreated,
    );

  Map<String, dynamic> toJson() => {
    'text':text,
    'uid':uid,
    'timeCreated':timeCreated,
  };
}
