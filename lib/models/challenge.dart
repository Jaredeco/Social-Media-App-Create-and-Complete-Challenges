  
import 'package:cloud_firestore/cloud_firestore.dart';

class Challenge {
    String imageVal; 
    String taskName;
    String description;
    String uid;
    Timestamp timeCreated;
    List likedBy;
    List dislikedBy;
    List completedBy;
    List comments;


  Challenge(
      this.imageVal,
      this.taskName,
      this.description,
      this.uid,
      this.timeCreated,
      this.likedBy,
      this.dislikedBy,
      this.completedBy,
      this.comments,
      );

  Map<String, dynamic> toJson() => {
    'imageVal':imageVal,
    'taskName':taskName,
    'description':description,
    'likedBy':likedBy,
    'dislikedBy':dislikedBy,
    'completedBy':completedBy,
    'comments':comments,
    'uid':uid,
    'timeCreated':timeCreated,
  };
}
