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
  @override
  Widget build(BuildContext context) {
    final newChallenge = new Challenge(null, null, null, null, null, null, null);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
          child: Icon(Icons.add, color: Colors.blue[800],),
          onPressed: () {
            return Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => CreateTask(challenge: newChallenge)));
          }),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.all(10.0),
          child: InkWell(
            customBorder: CircleBorder(),
            splashColor: Colors.black,
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MyProfile()));
            },
            child: CachedNetworkImage(
              imageUrl: "https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
              imageBuilder: (context, imageProvider) => Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                ),
              ),
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
        ),
        title: Text(
          "Explore",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22),
        ),
        actions: <Widget>[
          IconButton(
            padding: EdgeInsets.all(10.0),
            icon: Icon(Icons.search),
            onPressed: () {},
            color: Colors.blue[800],
          ),
        ],
      ),
      body: Container(
        child: StreamBuilder(
            stream: getUsersTripsStreamSnapshots(context),
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
              return new ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (BuildContext context, int index) =>
                      myCardDetails(context, snapshot.data.documents[index]));
            }),
      ),
    );
  }

  Stream<QuerySnapshot> getUsersTripsStreamSnapshots(
      BuildContext context) async* {
    final uid = await Provider.of(context).auth.getCurrentUID();
    yield* Firestore.instance
        .collection('userData')
        .document(uid)
        .collection('challenges')
        .snapshots();
  }
}
