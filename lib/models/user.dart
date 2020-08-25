class Post {
    String userImage; 
    String userName;
    String postText;
    String postImage;
    int numberLikes;
    int numberComments;
  Post(
      this.userImage,
      this.userName,
      this.postText,
      this.postImage,
      this.numberLikes,
      this.numberComments,
      );

  Map<String, dynamic> toJson() => {
    'userImage':userImage,
    'userName':userName,
    'postText':postText,
    'postImage':postImage,
    'numberLikes':numberLikes,
    'numberComments':numberComments,
  };
}
