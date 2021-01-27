import 'package:SD/Pages/content_pages/Myprofile.dart';
import 'package:SD/Pages/content_pages/challengePage.dart';
import 'package:SD/Pages/content_pages/userProfile.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:SD/models/user_info.dart';
import 'package:SD/widgets/provider_widget.dart';
import 'package:like_button/like_button.dart';

Widget myCardDetails(BuildContext context, DocumentSnapshot challenge) {
  return myCard(
      context,
      challenge["imageVal"],
      challenge["taskName"],
      challenge["description"],
      challenge["likedBy"].length,
      challenge["dislikedBy"].length,
      challenge["completedBy"].length,
      challenge["comments"].length,
      challenge["uid"],
      challenge.documentID);
}

Widget myCard(
  BuildContext context,
  String imageVal,
  String taskName,
  String description,
  int numberLikes,
  int numberDislikes,
  int numberCompleted,
  int numberCommments,
  String uid,
  String challengeId,
) {
  UserInfo _userInfo = UserInfo(null, null, null, null, null, null, null, null);
  _getProfileData(uid) async {
    final _curuid = await Provider.of(context).auth.getCurrentUID();
    Future<DocumentSnapshot> docSnapshot = Provider.of(context)
        .db
        .collection('challenges')
        .document(challengeId)
        .get();
    DocumentSnapshot doc = await docSnapshot;
    bool isLiked = doc["likedBy"].contains(_curuid);
    bool isDisliked = doc["likedBy"].contains(_curuid);
    bool isCompleted = doc["likedBy"].contains(_curuid);
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
      return [isLiked, isDisliked, isCompleted];
  }
  _updateLikes(bool isLiked, String document)async{
    final _uid = await Provider.of(context).auth.getCurrentUID();
    if (isLiked) {
      await Provider.of(context)
          .db
          .collection('challenges')
          .document(challengeId)
          .updateData({
        document: FieldValue.arrayRemove([_uid])
      });
    } else {
      await Provider.of(context)
          .db
          .collection('challenges')
          .document(challengeId)
          .updateData({
        document: FieldValue.arrayUnion([_uid])
      });
    }
  }

  Future<bool> onLikeButtonTapped(bool isLiked) async {
    _updateLikes(isLiked, "likedBy");
    return !isLiked;
  }

  return InkWell(
    onTap: () {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ChallengePage(challengeId: challengeId)));
    },
    child: FutureBuilder(
        future: _getProfileData(uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: 270,
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
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
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
                                await Provider.of(context).auth.getCurrentUID();
                            if (_userInfo.uid != _currUID) {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      UserProfile(postUID: _userInfo.uid)));
                            } else {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => MyProfile()));
                            }
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
                              await Provider.of(context).auth.getCurrentUID();
                          if (_userInfo.uid != _currUID) {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    UserProfile(postUID: _userInfo.uid)));
                          } else {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => MyProfile()));
                          }
                        },
                        child: Text(
                          _userInfo.userName,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
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
                    LikeButton(
                      isLiked: snapshot.data[0],
                      likeCount: numberLikes,
                      likeBuilder: (bool isLiked) {
                        return Icon(
                          isLiked ? Icons.favorite : Icons.favorite_border,
                          color: isLiked ? Colors.blue[800] : Colors.grey,
                        );
                      },
                      onTap: onLikeButtonTapped,
                    ),

                    // LikeButton(likeCount: numberDislikes,),
                    // LikeButton(likeCount: numberCompleted),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            );
          } else {
            return Container();
          }
        }),
  );
}
