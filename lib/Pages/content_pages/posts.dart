import 'package:flutter/material.dart';
import 'package:SD/widgets/post_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:SD/widgets/provider_widget.dart';
import 'create_post.dart';
import 'package:SD/models/post.dart';

class Posts extends StatefulWidget {
  Posts({Key key}) : super(key: key);

  @override
  _PostsState createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  @override
  Widget build(BuildContext context) {
    final newPost = new Post(null, null, null, null, null, null);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            return Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => CreatePost(post: newPost)));
          }),
      body: ListView(
        children: <Widget>[
          Container(
            height: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SizedBox(width: 15),
                Expanded(
                    child: Container(
                  padding: EdgeInsets.only(left: 21),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.grey[200]),
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.grey),
                      hintText: "Search",
                    ),
                  ),
                )),
                RawMaterialButton(
                  onPressed: () {},
                  fillColor: Colors.blue,
                  child: Icon(
                    Icons.search,
                    size: 23.0,
                  ),
                  padding: EdgeInsets.all(10.0),
                  shape: CircleBorder(),
                ),
              ],
            ),
          ),
          Container(
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
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (BuildContext context, int index) =>
                        makeFeed(context, snapshot.data.documents[index]),
                  );
                }),
          ),
        ],
      ),
    );
  }

  Stream<QuerySnapshot> getUsersTripsStreamSnapshots(
      BuildContext context) async* {
    final uid = await Provider.of(context).auth.getCurrentUID();
    yield* Firestore.instance
        .collection('userData')
        .document(uid)
        .collection('posts')
        .snapshots();
  }
}
