class UserInfo {
    String userImage; 
    String userName;
    String bio;
    String uid;
    List completed;
    List inProgress;
    List followers;
    List following;
  UserInfo(
      this.userImage,
      this.userName,
      this.bio,
      this.uid,
      this.completed,
      this.inProgress,
      this.followers,
      this.following,
      );

  Map<String, dynamic> toJson() => {
    'userImage':userImage,
    'userName':userName,
    'bio':bio,
    'uid':uid,
    'completed':completed,
    'followers':followers,
    'following':following,
    'inProgress':inProgress,
  };
}
