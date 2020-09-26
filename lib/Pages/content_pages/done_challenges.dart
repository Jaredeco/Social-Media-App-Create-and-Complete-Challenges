import 'package:SD/create_pages/create_challenge.dart';
import 'package:flutter/material.dart';
import 'package:SD/widgets/yescardContent.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:SD/widgets/provider_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:SD/models/challenge.dart';
import 'package:scroll_app_bar/scroll_app_bar.dart';
import 'Myprofile.dart';

class DoneChallenges extends StatefulWidget {
  DoneChallenges({Key key}) : super(key: key);

  @override
  _DoneChallengesState createState() => _DoneChallengesState();
}

class _DoneChallengesState extends State<DoneChallenges> {
  bool _isSearching = false;
  final _appbarController = ScrollController(); 
  @override
  Widget build(BuildContext context) {
    final newChallenge =
        new Challenge(null, null, null, null, null, null, null, null, null);
    return Scaffold(
      appBar: ScrollAppBar(
        controller: _appbarController,
        backgroundColor: Colors.white,
        leading: _isSearching
            ? IconButton(
                onPressed: () {
                  setState(() {
                    _isSearching = false;
                  });
                },
                icon: Icon(
                  Icons.close,
                  color: Colors.blue[800],
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(10.0),
                child: InkWell(
                  customBorder: CircleBorder(),
                  splashColor: Colors.black,
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => MyProfile()));
                  },
                  child: FutureBuilder(
                      future: Provider.of(context).auth.getUserImage(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData)
                          return CachedNetworkImage(
                            imageUrl: snapshot.data,
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
                          );
                        return Container();
                      }),
                ),
              ),
        title: _isSearching
            ? TextField(
                autofocus: true,
              )
            : Text(
                "Explore",
                style: TextStyle(
                    color: Colors.blue[800]),
              ),
        actions: <Widget>[
          IconButton(
            padding: EdgeInsets.all(10.0),
            icon: Icon(Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = true;
              });
            },
            color: Colors.blue[800],
          ),
        ],
      ),
      body: _isSearching
          ? Container(
              color: Colors.white,
            )
          : Container(
              child: StreamBuilder(
                  stream: loadChallenges(context),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height - 210,
                        child: Center(
                            child: Container(
                                width: 40,
                                height: 40,
                                child: CircularProgressIndicator())),
                      );
                    return Snap(
                      controller: _appbarController.appBar,
                                          child: new ListView.builder(
                        controller: _appbarController,
                          shrinkWrap: true,
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (BuildContext context, int index) =>
                              myCardDetails(
                                  context, snapshot.data.documents[index])),
                    );
                  }),
            ),
    );
  }

  Stream<QuerySnapshot> loadChallenges(BuildContext context) async* {
    yield* Firestore.instance
        .collection('challenges')
        .orderBy('timeCreated', descending: true)
        .snapshots();
  }

  Widget searchResult() {
    return null;
  }
}
