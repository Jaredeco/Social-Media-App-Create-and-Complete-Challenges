import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
    String uid; 
    String postText;
    String postImage;
    int numberLikes;
    int numberComments;
    Timestamp timeCreated;
  Post(
      this.uid,
      this.postText,
      this.postImage,
      this.numberLikes,
      this.numberComments,
      this.timeCreated,
      );

  Map<String, dynamic> toJson() => {
    'uid':uid,
    'postText':postText,
    'postImage':postImage,
    'numberLikes':numberLikes,
    'numberComments':numberComments,
    'timeCreated':timeCreated,
  };
}
