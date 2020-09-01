import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:SD/models/user_info.dart';
import 'package:SD/widgets/provider_widget.dart';

Widget myCardDetails(BuildContext context, DocumentSnapshot challenge) {
  return myCard(
      context,
      challenge["imageVal"],
      challenge["taskName"],
      challenge["description"],
      challenge["numberViews"],
      challenge["numberLikes"],
      challenge["numberDislikes"],
      challenge["uid"]);
}

Widget myCard(
    BuildContext context,
    String imageVal,
    String taskName,
    String description,
    int numberViews,
    int numberLikes,
    int numberDislikes,
    String uid) {
  UserInfo _userInfo = UserInfo(null, null, null, null, null, null, null);
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
      _userInfo.numberFollowers = result.data['numberFollowers'];
      _userInfo.numberFollowing = result.data['numberFollowing'];
      _userInfo.completed = result.data['completed'];
    });
  }

  return FutureBuilder(
      future: _getProfileData(uid),
      builder: (context1, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: 200,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(imageVal), fit: BoxFit.cover)),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    taskName,
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Category",
                    style: TextStyle(
                        color: Colors.blue[800],
                        fontSize: 16,
                        fontWeight: FontWeight.w800),
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
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      _userInfo.userName,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                        description,
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  rowItem(Icons.arrow_upward, numberLikes.toString()),
                  rowItem(Icons.arrow_downward, numberDislikes.toString()),
                  rowItem(Icons.done, "0"),
                  rowItem(Icons.comment, "0"),
                  rowItem(Icons.remove_red_eye, numberViews.toString()),
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
                    onPressed: () {},
                    color: Colors.white,
                    textColor: Colors.blue[800],
                    child:
                        Text("Yes".toUpperCase(), style: TextStyle(fontSize: 20)),
                  ),
                ),
              ),
              Container(
                height: 15,
                color: Colors.grey[200],
              ),
            ],
          );
        } else {
          return Container();
        }
      });
}

Widget rowItem(IconData dataIcon, String data) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      children: [
        Icon(
          dataIcon,
          color: Colors.blue[800],
        ),
        SizedBox(width: 5),
        Text(data),
      ],
    ),
  );
}
