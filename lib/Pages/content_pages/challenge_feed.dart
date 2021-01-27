import 'package:SD/create_pages/create_challenge.dart';
import 'package:flutter/material.dart';
import 'package:SD/widgets/yescardContent.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:SD/widgets/provider_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:SD/models/challenge.dart';
import 'Myprofile.dart';

class Feed extends StatefulWidget {
  Feed({Key key}) : super(key: key);

  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  bool _isSearching = false;
  final _appbarController = ScrollController();
  @override
  Widget build(BuildContext context) {
    final newChallenge =
        new Challenge(null, null, null, null, null, null, null, null, null);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          child: Icon(
            Icons.add,
            color: Colors.blue[800],
          ),
          onPressed: () {
            return Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => CreateTask(challenge: newChallenge)));
          }),
      appBar: AppBar(
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
                style: TextStyle(color: Colors.blue[800]),
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
                    return ListView.builder(
                        controller: _appbarController,
                        shrinkWrap: true,
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (BuildContext context, int index) =>
                            myCardDetails(
                                context, snapshot.data.documents[index]));
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
