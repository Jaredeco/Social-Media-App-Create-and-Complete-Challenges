import 'package:SD/Pages/content_pages/done_challenges.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:SD/Pages/content_pages/challenge_feed.dart';
import 'package:SD/Pages/content_pages/posts.dart';

class Home extends StatefulWidget {
  int page_index;
  Home({Key key, @required this.page_index}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Key keyFeed = PageStorageKey("pageFeed");
  final Key keyPosts = PageStorageKey("pagePosts");
  GlobalKey _bottomNavigationKey = GlobalKey();
  int _activePage = 0;
  @override
  void initState() {
    _activePage = widget.page_index;
  }

  Widget build(BuildContext context) {
    final List<Widget> _tabItems = [Feed(), Posts(), DoneChallenges()];
    return Scaffold(
        bottomNavigationBar: CurvedNavigationBar(
          color: Colors.white,
          buttonBackgroundColor: Colors.grey[300],
          backgroundColor: Colors.blue[800],
          animationDuration: Duration(milliseconds: 250),
          index: _activePage,
          animationCurve: Curves.bounceInOut,
          key: _bottomNavigationKey,
          height: 55,
          items: <Widget>[
            Icon(Icons.explore, size: 25),
            Icon(Icons.bookmark, size: 25),
            Icon(Icons.done, size: 25),
          ],
          onTap: (index) {
            if (index != _activePage){
              setState(() {
                _activePage = index;
              });}
          },
        ),
        body: _tabItems[_activePage]);
  }
}
