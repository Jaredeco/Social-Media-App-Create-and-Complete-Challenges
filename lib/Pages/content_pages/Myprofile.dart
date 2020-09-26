import 'package:SD/create_pages/update_profile_pic.dart';
import 'package:flutter/material.dart';
import 'package:SD/models/user_info.dart';
import 'package:SD/widgets/provider_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:SD/widgets/yescardContent.dart';
import 'package:SD/widgets/post_card.dart';
import 'package:scroll_app_bar/scroll_app_bar.dart';

class MyProfile extends StatefulWidget {
  var pushedUrl;
  MyProfile({Key key, this.pushedUrl}) : super(key: key);
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  final _appbarController = ScrollController();
  UserInfo _userInfo = UserInfo("", "", "", "", [], [], [], []);
  TextEditingController _userBioController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: ScrollAppBar(
        controller: _appbarController,
        title: Text(
          "Profile",
          style: TextStyle(color: Colors.blue[800]),
        ),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.blue[800],
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            padding: EdgeInsets.all(10.0),
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              Provider.of(context).auth.signOut();
            },
            color: Colors.red,
          ),
        ],
      ),
      body: FutureBuilder(
          future: _getProfileData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Snap(
                controller: _appbarController.appBar,
                child: SingleChildScrollView(
                  controller: _appbarController,
                  child: Column(children: [
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: Stack(
                        fit: StackFit.loose,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                width: 140.0,
                                height: 140.0,
                                child: CachedNetworkImage(
                                  imageUrl: widget.pushedUrl == null
                                      ? _userInfo.userImage
                                      : widget.pushedUrl,
                                  imageBuilder: (context, imageProvider) =>
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
                                      CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                              padding: EdgeInsets.only(top: 90.0, right: 100.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  InkWell(
                                    customBorder: CircleBorder(),
                                    onTap: () {
                                      _awaitReturnValueFromSecondScreen(
                                          context);
                                    },
                                    child: CircleAvatar(
                                      backgroundColor: Colors.blue[800],
                                      radius: 25.0,
                                      child: Icon(
                                        Icons.camera_alt,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                ],
                              )),
                        ],
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
                    Wrap(
                      children: [
                        FlatButton.icon(
                          padding: EdgeInsets.only(left: 8),
                          onPressed: () {
                            _userEditBottomSheet(context);
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0))),
                          label: Text(
                            'Edit Bio',
                            style: TextStyle(
                                color: Colors.blue[800], fontSize: 17),
                          ),
                          icon: Icon(
                            Icons.edit,
                            color: Colors.blue[800],
                          ),
                          color: Colors.white,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 12, right: 12),
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
                            horizontal: 8.0, vertical: 19.0),
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
                    Divider(
                      color: Colors.blue[800],
                      height: 0,
                    ),
                    BottomProfileFeed(),
                  ]),
                ),
              );
            } else {
              return Container();
            }
          }),
    );
  }

  _getProfileData() async {
    final uid = await Provider.of(context).auth.getCurrentUID();
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

  void _userEditBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0, top: 15.0),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      "Update Bio",
                      style: TextStyle(color: Colors.blue[800]),
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                          onTap: () => Navigator.of(context).pop(),
                          child: Icon(Icons.close, color: Colors.blue[800])),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 15.0, bottom: 15),
                        child: TextField(
                          controller: _userBioController,
                          decoration: InputDecoration(),
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                      child: Text('Save'),
                      color: Colors.white,
                      textColor: Colors.blue[800],
                      onPressed: () async {
                        _userInfo.bio = _userBioController.text;
                        setState(() {
                          _userBioController.text = _userInfo.bio;
                        });
                        final uid =
                            await Provider.of(context).auth.getCurrentUID();
                        await Provider.of(context)
                            .db
                            .collection('userData')
                            .document(uid)
                            .setData(_userInfo.toJson());
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _awaitReturnValueFromSecondScreen(BuildContext context) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UpdateProfPic(
            userInfo: _userInfo,
          ),
        ));
    setState(() {
      widget.pushedUrl = result;
    });
  }
}

class BottomProfileFeed extends StatefulWidget {
  BottomProfileFeed({Key key}) : super(key: key);

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
                  stream: loadChalleges(context),
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
                  stream: loadPosts(context),
                  builder: (context, snapshot1) {
                    if (!snapshot1.hasData)
                      return Container(
                        child: Center(child: CircularProgressIndicator()),
                        height: 200,
                        color: Colors.blue,
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

  Stream<QuerySnapshot> loadChalleges(BuildContext context) async* {
    final _uid = await Provider.of(context).auth.getCurrentUID();
    yield* Firestore.instance
        .collection('challenges')
        .where("uid", isEqualTo: _uid)
        .snapshots();
  }

  Stream<QuerySnapshot> loadPosts(BuildContext context) async* {
    final _uid = await Provider.of(context).auth.getCurrentUID();
    yield* Firestore.instance
        .collection('posts')
        .where("uid", isEqualTo: _uid)
        .snapshots();
  }
}
