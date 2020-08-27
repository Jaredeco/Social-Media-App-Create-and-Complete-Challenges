class UserInfo {
    String userImage; 
    String userName;
    String bio;
    int followers;
    int following;
    int completed;
    String uid;
  UserInfo(
      this.userImage,
      this.userName,
      this.bio,
      this.followers,
      this.following,
      this.completed,
      this.uid,
      );

  Map<String, dynamic> toJson() => {
    'userImage':userImage,
    'userName':userName,
    'bio':bio,
    'followers':followers,
    'following':following,
    'completed':completed,
    'uid':uid,
  };
}
