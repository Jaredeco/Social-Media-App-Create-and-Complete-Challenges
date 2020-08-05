import 'package:flutter/material.dart';
import 'package:SD/widgets/post_card.dart';

class Posts extends StatefulWidget {
  Posts({Key key}) : super(key: key);

  @override
  _PostsState createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: <Widget>[
        Container(
          height: 120,
          child: Row(
            children: <Widget>[
              SizedBox(width: 7),
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
        
            makeFeed(
                userName: "User",
                userImage: "assets/jupyter_logo.png",
                feedTime: "1hr ago",
                feedText: "Nice place",
                feedImage: "assets/jupyter_logo.png"),
            makeFeed(
                userName: "User",
                userImage: "assets/jupyter_logo.png",
                feedTime: "1hr ago",
                feedText: "Nice place",
                feedImage: "assets/jupyter_logo.png"),
            makeFeed(
                userName: "User",
                userImage: "assets/jupyter_logo.png",
                feedTime: "1hr ago",
                feedText: "Nice place",
                feedImage: "assets/jupyter_logo.png"),
          ],
        ),
      );
  }
}
