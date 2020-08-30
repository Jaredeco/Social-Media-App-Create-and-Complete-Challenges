class UserInfo {
    String userImage; 
    String userName;
    String bio;
    int numberFollowers;
    int numberFollowing;
    int completed;
    String uid;
    // List<String> followers;
    // List<String> following;
  UserInfo(
      this.userImage,
      this.userName,
      this.bio,
      this.numberFollowers,
      this.numberFollowing,
      this.completed,
      this.uid,
      );

  Map<String, dynamic> toJson() => {
    'userImage':userImage,
    'userName':userName,
    'bio':bio,
    'numberFollowers':numberFollowers,
    'numberFollowing':numberFollowing,
    'completed':completed,
    'uid':uid,
  };
}
