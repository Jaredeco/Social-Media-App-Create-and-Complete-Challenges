import 'package:SD/Pages/content_pages/Myprofile.dart';
import 'package:flutter/material.dart';
import 'package:SD/widgets/post_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:SD/widgets/provider_widget.dart';
import '../../create_pages/create_post.dart';
import 'package:SD/models/post.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Posts extends StatefulWidget {
  Posts({Key key}) : super(key: key);

  @override
  _PostsState createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  @override
  Widget build(BuildContext context) {
    final newPost = new Post(null, null, null, null, null);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.all(10.0),
          child: InkWell(
            customBorder: CircleBorder(),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => MyProfile()));
            },
            child: CachedNetworkImage(
              imageUrl:
                  "https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
              imageBuilder: (context, imageProvider) => Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image:
                      DecorationImage(image: imageProvider, fit: BoxFit.cover),
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
        title: Text(
          "Posts",
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
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          child: Icon(
            Icons.add,
            color: Colors.blue[800],
          ),
          onPressed: () {
            return Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => CreatePost(post: newPost)));
          }),
      body: ListView(
        children: <Widget>[
          Container(
            child: StreamBuilder(
                stream: loadPosts(context),
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

  Stream<QuerySnapshot> loadPosts(
      BuildContext context) async* {
    final uid = await Provider.of(context).auth.getCurrentUID();
    yield* Firestore.instance
        .collection('userData')
        .document(uid)
        .collection('posts')
        .snapshots();
  }
}
