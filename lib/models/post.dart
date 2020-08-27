class Post {
    String uid; 
    String postText;
    String postImage;
    int numberLikes;
    int numberComments;
  Post(
      this.uid,
      this.postText,
      this.postImage,
      this.numberLikes,
      this.numberComments,
      );

  Map<String, dynamic> toJson() => {
    'uid':uid,
    'postText':postText,
    'postImage':postImage,
    'numberLikes':numberLikes,
    'numberComments':numberComments,
  };
}
