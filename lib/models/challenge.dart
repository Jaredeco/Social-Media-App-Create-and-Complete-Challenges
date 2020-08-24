  
class Challenge {
    String imageVal; 
    String taskName;
    String description;
    int numberViews;
    int numberLikes; 
    int  numberDislikes;

  Challenge(
      this.imageVal,
      this.taskName,
      this.description,
      this.numberViews,
      this.numberLikes,
      this.numberDislikes,
      );

  Map<String, dynamic> toJson() => {
    'imageVal':imageVal,
    'taskName':taskName,
    'description':description,
    'numberViews':numberViews,
    'numberLikes':numberLikes,
    'numberDislikes':numberDislikes,
  };
}
