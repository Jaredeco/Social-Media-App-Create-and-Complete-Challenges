  
class Challenge {
    String imageVal; 
    String taskName;
    String description;
    int numberViews;
    int numberLikes; 
    int  numberDislikes;
    String uid;

  Challenge(
      this.imageVal,
      this.taskName,
      this.description,
      this.numberViews,
      this.numberLikes,
      this.numberDislikes,
      this.uid,
      );

  Map<String, dynamic> toJson() => {
    'imageVal':imageVal,
    'taskName':taskName,
    'description':description,
    'numberViews':numberViews,
    'numberLikes':numberLikes,
    'numberDislikes':numberDislikes,
    'uid':uid,
  };
}
