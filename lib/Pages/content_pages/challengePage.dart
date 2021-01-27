import 'package:flutter/material.dart';
import 'package:SD/widgets/provider_widget.dart';
import 'package:SD/models/challenge.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:SD/models/user_info.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:SD/Pages/content_pages/userProfile.dart';
import 'package:SD/widgets/comment_bottomsheet.dart';
import 'package:SD/Pages/content_pages/Myprofile.dart';
import 'package:like_button/like_button.dart';

class ChallengePage extends StatefulWidget {
  var challengeId;
  ChallengePage({Key key, @required this.challengeId}) : super(key: key);

  @override
  _ChallengePageState createState() => _ChallengePageState();
}

class _ChallengePageState extends State<ChallengePage> {
  UserInfo _userInfo = UserInfo(null, null, null, null, null, null, null, null);
  Challenge _challenge =
      Challenge(null, null, null, null, null, null, null, null, null);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: FutureBuilder(
          future: _getChalName(widget.challengeId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Text(
                _challenge.taskName,
                style: TextStyle(color: Colors.blue[800]),
              );
            } else {
              return Container();
            }
          },
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.blue[800]),
            onPressed: () => Navigator.of(context).pop()),
      ),
      body: ListView(children: [
        FutureBuilder(
            future: _getChallengeData(widget.challengeId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return FutureBuilder(
                    future: _getProfileData(_challenge.uid),
                    builder: (context, snapshot1) {
                      if (snapshot1.connectionState == ConnectionState.done) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              height: 270,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(_challenge.imageVal),
                                      fit: BoxFit.cover)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, top: 20, right: 20),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  _challenge.taskName,
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20, top: 20),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    width: 50,
                                    height: 50,
                                    child: InkWell(
                                      customBorder: CircleBorder(),
                                      onTap: () async {
                                        final _currUID =
                                            await Provider.of(context)
                                                .auth
                                                .getCurrentUID();
                                        if (_userInfo.uid != _currUID) {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      UserProfile(
                                                          postUID:
                                                              _userInfo.uid)));
                                        } else {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      MyProfile()));
                                        }
                                      },
                                      child: CachedNetworkImage(
                                        imageUrl: _userInfo.userImage,
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          width: 80.0,
                                          height: 80.0,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover),
                                          ),
                                        ),
                                        placeholder: (context, url) =>
                                            Container(
                                          decoration: BoxDecoration(
                                            color: Colors.grey[400],
                                            border: Border.all(
                                                color: Colors.grey[400]),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      final _currUID =
                                          await Provider.of(context)
                                              .auth
                                              .getCurrentUID();
                                      if (_userInfo.uid != _currUID) {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    UserProfile(
                                                        postUID:
                                                            _userInfo.uid)));
                                      } else {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MyProfile()));
                                      }
                                    },
                                    child: Text(
                                      _userInfo.userName,
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      _challenge.description,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                LikeButton(
                                  
                                  likeCount: _challenge.likedBy.length,
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: ButtonTheme(
                                minWidth: 300,
                                height: 55,
                                child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  onPressed: () async {
                                    final _uid = await Provider.of(context)
                                        .auth
                                        .getCurrentUID();
                                    Future<DocumentSnapshot> docSnapshot =
                                        Provider.of(context)
                                            .db
                                            .collection('challenges')
                                            .document(widget.challengeId)
                                            .get();
                                    DocumentSnapshot doc = await docSnapshot;
                                    if (doc["completedBy"].contains(_uid)) {
                                      await Provider.of(context)
                                          .db
                                          .collection('challenges')
                                          .document(widget.challengeId)
                                          .updateData({
                                        "completedBy":
                                            FieldValue.arrayRemove([_uid])
                                      });
                                    } else {
                                      await Provider.of(context)
                                          .db
                                          .collection('challenges')
                                          .document(widget.challengeId)
                                          .updateData({
                                        "completedBy":
                                            FieldValue.arrayUnion([_uid])
                                      });
                                    }
                                  },
                                  color: Colors.grey[200],
                                  textColor: Colors.blue[800],
                                  child: Text("Let's do it!",
                                      style: TextStyle(fontSize: 20)),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            )
                          ],
                        );
                      } else {
                        return Container();
                      }
                    });
              } else {
                return Container();
              }
            }),
      ]),
    );
  }

  _getChalName(String challengeId) async {
    await Provider.of(context)
        .db
        .collection('challenges')
        .document(challengeId)
        .get()
        .then((result) {
      _challenge.taskName = result.data['taskName'];
    });
  }

  _getProfileData(uid) async {
    await Provider.of(context)
        .db
        .collection('userData')
        .document(uid)
        .get()
        .then((result) {
      _userInfo.userName = result.data['userName'];
      _userInfo.userImage = result.data['userImage'];
      _userInfo.bio = result.data['bio'];
      _userInfo.uid = result.data['uid'];
      _userInfo.completed = result.data['completed'];
      _userInfo.inProgress = result.data['inProgress'];
      _userInfo.followers = result.data['followers'];
      _userInfo.following = result.data['following'];
    });
  }

  _getChallengeData(String challengeId) async {
    await Provider.of(context)
        .db
        .collection('challenges')
        .document(challengeId)
        .get()
        .then((result) {
      _challenge.taskName = result.data['taskName'];
      _challenge.description = result.data['description'];
      _challenge.imageVal = result.data['imageVal'];
      _challenge.uid = result.data['uid'];
      _challenge.completedBy = result.data['completedBy'];
      _challenge.likedBy = result.data['likedBy'];
      _challenge.dislikedBy = result.data['dislikedBy'];
      _challenge.comments = result.data['comments'];
      _challenge.timeCreated = result.data['timeCreated'];
    });
  }

  Future<bool> onLikeButtonTapped(String document) async {
    bool isLiked;
    String document;
    if (document != "comment") {
      final _uid = await Provider.of(context).auth.getCurrentUID();
      Future<DocumentSnapshot> docSnapshot = Provider.of(context)
          .db
          .collection('challenges')
          .document(widget.challengeId)
          .get();
      DocumentSnapshot doc = await docSnapshot;
      isLiked = doc[document].contains(_uid);
      if (isLiked) {
        await Provider.of(context)
            .db
            .collection('challenges')
            .document(widget.challengeId)
            .updateData({
          document: FieldValue.arrayRemove([_uid])
        });
      } else {
        await Provider.of(context)
            .db
            .collection('challenges')
            .document(widget.challengeId)
            .updateData({
          document: FieldValue.arrayUnion([_uid])
        });
        setState(() {});
      }
    } else {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => CommentPage(challengeId: widget.challengeId)));
    }
    return !isLiked;
  }
}
