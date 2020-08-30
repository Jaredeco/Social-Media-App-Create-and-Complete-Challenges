import 'package:SD/create_pages/update_profile_pic.dart';
import 'package:flutter/material.dart';
import 'package:SD/models/user_info.dart';
import 'package:SD/widgets/provider_widget.dart';

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
      body: FutureBuilder(
          future: _getProfileData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return ListView(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [Colors.redAccent, Colors.blue])),
                          child: Container(
                            width: double.infinity,
                            height: 350.0,
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Align(
                                        alignment: Alignment.center,
                                        child: CircleAvatar(
                                          backgroundImage: widget.pushedUrl != null ?
                                          NetworkImage(
                                            widget.pushedUrl):
                                          NetworkImage(
                                            "${_userInfo.userImage}",
                                          ),
                                          radius: 50.0,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 60.0),
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.edit,
                                            size: 30.0,
                                          ),
                                          onPressed: () {    
                                            _awaitReturnValueFromSecondScreen(context);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Center(
                                    child: Text(
                                      "${_userInfo.userName}",
                                      style: TextStyle(
                                        fontSize: 22.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Card(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 5.0),
                                    clipBehavior: Clip.antiAlias,
                                    color: Colors.white,
                                    elevation: 5.0,
                                    child: Padding(
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
                                                    color: Colors.redAccent,
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
                                                    color: Colors.pinkAccent,
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
                                                    color: Colors.redAccent,
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
                                                    color: Colors.pinkAccent,
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
                                                    color: Colors.redAccent,
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
                                                    color: Colors.pinkAccent,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 30.0, horizontal: 16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(bottom: 20),
                                    width: 120.00,
                                    child: RaisedButton(
                                        onPressed: () {},
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(80.0)),
                                        elevation: 0.0,
                                        padding: EdgeInsets.all(0.0),
                                        child: Ink(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                                begin: Alignment.centerRight,
                                                end: Alignment.centerLeft,
                                                colors: [
                                                  Colors.redAccent,
                                                  Colors.pinkAccent
                                                ]),
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                          ),
                                          child: Container(
                                            constraints: BoxConstraints(
                                                maxWidth: 300.0,
                                                minHeight: 50.0),
                                            alignment: Alignment.center,
                                            child: Text(
                                              "Follow",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 19.0,
                                                  fontWeight: FontWeight.w300),
                                            ),
                                          ),
                                        )),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(bottom: 20),
                                    width: 120.00,
                                    child: RaisedButton(
                                        onPressed: () {
                                          _userEditBottomSheet(context);
                                        },
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(80.0)),
                                        elevation: 0.0,
                                        padding: EdgeInsets.all(0.0),
                                        child: Ink(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                                begin: Alignment.centerRight,
                                                end: Alignment.centerLeft,
                                                colors: [
                                                  Colors.redAccent,
                                                  Colors.pinkAccent
                                                ]),
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                          ),
                                          child: Container(
                                            constraints: BoxConstraints(
                                                maxWidth: 300.0,
                                                minHeight: 50.0),
                                            alignment: Alignment.center,
                                            child: Text(
                                              "Update Profile",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 19.0,
                                                  fontWeight: FontWeight.w300),
                                            ),
                                          ),
                                        )),
                                  ),
                                ],
                              ),
                              Text(
                                "Bio:",
                                style: TextStyle(
                                    color: Colors.redAccent,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 28.0),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                "${_userInfo.bio}",
                                style: TextStyle(
                                  fontSize: 22.0,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black,
                                  letterSpacing: 2.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
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
          builder: (context) => UpdateProfPic(userInfo: _userInfo,),
        ));
    setState(() {
      widget.pushedUrl = result;
    });
  }
}
