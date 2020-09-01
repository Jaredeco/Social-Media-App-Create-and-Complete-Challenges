import 'package:SD/create_pages/update_profile_pic.dart';
import 'package:flutter/material.dart';
import 'package:SD/models/user_info.dart';
import 'package:SD/widgets/provider_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MyProfile extends StatefulWidget {
  var pushedUrl;
  MyProfile({Key key, this.pushedUrl}) : super(key: key);
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  UserInfo _userInfo = UserInfo("", "", "", 0, 0, 0, "");
  TextEditingController _userBioController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Profile", style: TextStyle(color:Colors.black),),
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            padding: EdgeInsets.all(10.0),
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop();
            },
            color: Colors.blue[800],
          ),
        ],
      ),
      body: FutureBuilder(
          future: _getProfileData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return ListView(children: <Widget>[
                Container(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: new Stack(
                          fit: StackFit.loose,
                          children: <Widget>[
                            new Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                new Container(
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
                                padding:
                                    EdgeInsets.only(top: 90.0, right: 100.0),
                                child: new Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    InkWell(
                                      customBorder: CircleBorder(),
                                      onTap: () {
                                        _awaitReturnValueFromSecondScreen(
                                            context);
                                      },
                                      child: new CircleAvatar(
                                        backgroundColor: Colors.blue[800],
                                        radius: 25.0,
                                        child: new Icon(
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
                        padding: const EdgeInsets.only(top:20.0),
                        child: Text(_userInfo.userName, style: TextStyle(fontWeight:FontWeight.bold, fontSize: 30),
                      ),),
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
                                        color: Colors.black,
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(
                                      "${_userInfo.completed}",
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
                                        color: Colors.black,
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(
                                      "${_userInfo.numberFollowers}",
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
                                        color: Colors.black,
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(
                                      "${_userInfo.numberFollowing}",
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        color: Colors.black,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ))
                    ],
                  ),
                )
              ]);
            } else {
              return Container();
              // child: Center(child: CircularProgressIndicator())
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
      _userInfo.numberFollowers = result.data['numberFollowers'];
      _userInfo.numberFollowing = result.data['numberFollowing'];
      _userInfo.completed = result.data['completed'];
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
                    Text("Update Profile"),
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.cancel),
                      color: Colors.orange,
                      iconSize: 25,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: TextField(
                          controller: _userBioController,
                          decoration: InputDecoration(
                            helperText: "Bio",
                          ),
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
                      color: Colors.green,
                      textColor: Colors.white,
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
