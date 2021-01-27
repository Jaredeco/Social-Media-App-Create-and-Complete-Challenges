import 'package:SD/Pages/content_pages/userProfile.dart';
import 'package:SD/models/user_info.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:SD/widgets/provider_widget.dart';
import 'package:SD/models/comment.dart';

class CommentPage extends StatefulWidget {
  String challengeId;
  CommentPage({Key key, this.challengeId}) : super(key: key);

  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  TextEditingController _commentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    getComments() async {
      List _comments;
      await Provider.of(context)
          .db
          .collection("challenges")
          .document(widget.challengeId)
          .get()
          .then((result) {
        _comments = result.data["comments"];
      });
      return _comments;
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Comments",
          style: TextStyle(color: Colors.blue[800]),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
          color: Colors.blue[800],
        ),
      ),
      body: FutureBuilder(
        future: getComments(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              children: [
                Expanded(
                    child: ListView(children: [
                  for (var com in snapshot.data)
                    commentCard(
                        context, com["text"], com["uid"], com["timeCreated"]),
                ])),
                Divider(
                  color: Colors.blue[800],
                  height: 0,
                ),
                TextField(
                  controller: _commentController,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hasFloatingPlaceholder: false,
                      labelText: "Comment...",
                      suffixIcon: IconButton(
                        icon: Icon(Icons.send, color: Colors.blue[800]),
                        onPressed: () async {
                          final _currentUID =
                              await Provider.of(context).auth.getCurrentUID();
                          Comment _comment = Comment(_commentController.text,
                              _currentUID, Timestamp.now());
                          if (_comment.text != "") {
                            await Provider.of(context)
                                .db
                                .collection('challenges')
                                .document(widget.challengeId)
                                .updateData({
                              "comments":
                                  FieldValue.arrayUnion([_comment.toJson()])
                            });
                            FocusManager.instance.primaryFocus.unfocus();
                            _commentController.clear();
                            setState(() {});
                          } else {
                            return null;
                          }
                        },
                      ),
                      labelStyle: TextStyle(color: Colors.black),
                      contentPadding: EdgeInsets.only(left: 10)),
                ),
                SizedBox(
                  height: 3,
                ),
              ],
            );
          } else {
            return Container(
                child: Center(
              child: CircularProgressIndicator(),
            ));
          }
        },
      ),
    );
  }
}

Widget commentCard(BuildContext context, String commentText, String commentUID,
    Timestamp timeCreated) {
  UserInfo _userInfo = UserInfo(null, null, null, null, null, null, null, null);
  _getProfileData() async {
    await Provider.of(context)
        .db
        .collection('userData')
        .document(commentUID)
        .get()
        .then((result) {
      _userInfo.userName = result.data['userName'];
      _userInfo.userImage = result.data['userImage'];
    });
  }

  return FutureBuilder(
      future: _getProfileData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return ListTile(
            title: Text(
              commentText,
              style: TextStyle(color: Colors.black),
            ),
            leading: Padding(
              padding: const EdgeInsets.all(10.0),
              child: InkWell(
                customBorder: CircleBorder(),
                splashColor: Colors.black,
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => UserProfile(postUID: null)));
                },
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
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          );
        } else {
          return Container();
        }
      });
}
