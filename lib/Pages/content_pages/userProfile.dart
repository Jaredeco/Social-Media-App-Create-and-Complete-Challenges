import 'package:flutter/material.dart';
import 'package:SD/models/user_info.dart';
import 'package:SD/widgets/provider_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:SD/widgets/yescardContent.dart';
import 'package:SD/widgets/post_card.dart';

class UserProfile extends StatefulWidget {
  var postUID;
  UserProfile({Key key, @required this.postUID}) : super(key: key);
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final _appbarController = ScrollController();
  UserInfo _userInfo = UserInfo("", "", "", "", [], [], [], []);

  @override
  Widget build(BuildContext context) {
    _getProfileData(String uid) async {
      final cUID = await Provider.of(context).auth.getCurrentUID();
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
      return cUID;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Profile",
          style: TextStyle(color: Colors.blue[800]),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          padding: EdgeInsets.all(10.0),
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
          color: Colors.blue[800],
        ),
      ),
      body: FutureBuilder(
          future: _getProfileData(widget.postUID),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return ListView(controller: _appbarController, children: <Widget>[
                Container(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: Container(
                          width: 140.0,
                          height: 140.0,
                          child: CachedNetworkImage(
                            imageUrl: _userInfo.userImage,
                            imageBuilder: (context, imageProvider) => Container(
                              width: 80.0,
                              height: 80.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: imageProvider, fit: BoxFit.cover),
                              ),
                            ),
                            placeholder: (context, url) => Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[400],
                                border: Border.all(color: Colors.grey[400]),
                                shape: BoxShape.circle,
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Text(
                          _userInfo.userName,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 30),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: ButtonTheme(
                          minWidth: 150,
                          height: 40,
                          child: !_userInfo.followers.contains(snapshot.data)
                              ? RaisedButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  color: Colors.blue[800],
                                  onPressed: () async {
                                    final _curUID = await Provider.of(context)
                                        .auth
                                        .getCurrentUID();
                                    await Provider.of(context)
                                        .db
                                        .collection('userData')
                                        .document(_curUID)
                                        .updateData({
                                      "following":
                                          FieldValue.arrayUnion([_userInfo.uid])
                                    });
                                    await Provider.of(context)
                                        .db
                                        .collection('userData')
                                        .document(_userInfo.uid)
                                        .updateData({
                                      "followers":
                                          FieldValue.arrayUnion([_curUID])
                                    });
                                    setState(() {});
                                  },
                                  elevation: 4.0,
                                  splashColor: Colors.blue[800],
                                  child: Text(
                                    'Follow',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                )
                              : RaisedButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  color: Colors.blue[800],
                                  onPressed: () async {
                                    final _curUID = await Provider.of(context)
                                        .auth
                                        .getCurrentUID();
                                    await Provider.of(context)
                                        .db
                                        .collection('userData')
                                        .document(_curUID)
                                        .updateData({
                                      "following": FieldValue.arrayRemove(
                                          [_userInfo.uid])
                                    });
                                    await Provider.of(context)
                                        .db
                                        .collection('userData')
                                        .document(_userInfo.uid)
                                        .updateData({
                                      "followers":
                                          FieldValue.arrayRemove([_curUID])
                                    });
                                    setState(() {});
                                  },
                                  elevation: 4.0,
                                  splashColor: Colors.blue[800],
                                  child: Text(
                                    'Unfollow',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      Wrap(
                        children: [
                          Padding(
                            padding:
                                EdgeInsets.only(left: 12, right: 12, top: 10),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  _userInfo.bio,
                                  style: TextStyle(fontSize: 20),
                                )),
                          ),
                        ],
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 22.0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      "Completed",
                                      style: TextStyle(
                                        color: Colors.blue[800],
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(
                                      "${_userInfo.completed.length}",
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        color: Colors.black,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      "Followers",
                                      style: TextStyle(
                                        color: Colors.blue[800],
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(
                                      "${_userInfo.followers.length}",
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        color: Colors.black,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      "Following",
                                      style: TextStyle(
                                        color: Colors.blue[800],
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(
                                      "${_userInfo.following.length}",
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        color: Colors.black,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
                Divider(
                  color: Colors.blue[800],
                  height: 0,
                ),
                BottomProfileFeed(
                  postUID: widget.postUID,
                ),
              ]);
            } else {
              return Container();
            }
          }),
    );
  }
}

class BottomProfileFeed extends StatefulWidget {
  var postUID;
  BottomProfileFeed({Key key, @required this.postUID}) : super(key: key);

  @override
  _BottomProfileFeedState createState() => _BottomProfileFeedState();
}

class _BottomProfileFeedState extends State<BottomProfileFeed> {
  int tab_index = 0;
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          FlatButton(
            splashColor: Colors.white,
            color: Colors.white,
            shape: tab_index == 0
                ? RoundedRectangleBorder(
                    side: BorderSide(
                        color: Colors.blue[800],
                        width: 2,
                        style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(50))
                : RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
            onPressed: () {
              setState(
                () {
                  tab_index = 0;
                },
              );
            },
            child:
                Text("Challenges", style: TextStyle(color: Colors.blue[800])),
          ),
          FlatButton(
            splashColor: Colors.white,
            color: Colors.white,
            shape: tab_index == 1
                ? RoundedRectangleBorder(
                    side: BorderSide(
                        color: Colors.blue[800],
                        width: 2,
                        style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(50))
                : RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
            onPressed: () {
              setState(
                () {
                  tab_index = 1;
                },
              );
            },
            child: Text(
              "Posts",
              style: TextStyle(color: Colors.blue[800]),
            ),
          ),
        ],
      ),
      tab_index == 0
          ? Container(
              child: StreamBuilder(
                  stream: loadChalleges(context, widget.postUID),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return Container(
                        child: Center(child: CircularProgressIndicator()),
                        height: 200,
                      );
                    return new ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (BuildContext context, int index) =>
                            myCardDetails(
                                context, snapshot.data.documents[index]));
                  }),
            )
          : Container(
              child: StreamBuilder(
                  stream: loadPosts(context, widget.postUID),
                  builder: (context, snapshot1) {
                    if (!snapshot1.hasData)
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height - 210,
                        child: Center(
                            child: Container(
                                width: 40,
                                height: 40,
                                child: CircularProgressIndicator())),
                      );
                    return new ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot1.data.documents.length,
                      itemBuilder: (BuildContext context, int index) =>
                          makeFeed(context, snapshot1.data.documents[index]),
                    );
                  }),
            ),
    ]);
  }

  Stream<QuerySnapshot> loadChalleges(BuildContext context, String uid) async* {
    yield* Firestore.instance
        .collection('challenges')
        .where("uid", isEqualTo: uid)
        .snapshots();
  }

  Stream<QuerySnapshot> loadPosts(BuildContext context, String uid) async* {
    yield* Firestore.instance
        .collection('posts')
        .where("uid", isEqualTo: uid)
        .snapshots();
  }
}
