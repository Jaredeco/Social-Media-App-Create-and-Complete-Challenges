class UserInfo {
    String userImage; 
    String userName;
    String bio;
    int followers;
    int following;
    String uid;
  UserInfo(
      this.userImage,
      this.userName,
      this.bio,
      this.followers,
      this.following,
      this.uid,
      );

  Map<String, dynamic> toJson() => {
    'userImage':userImage,
    'userName':userName,
    'bio':bio,
    'followers':followers,
    'following':following,
    'uid':uid,
  };
}
