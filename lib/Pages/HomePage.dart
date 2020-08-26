import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:SD/Pages/content_pages/feed.dart';
import 'package:SD/Pages/content_pages/posts.dart';
import 'package:SD/Pages/content_pages/Myprofile.dart';
import 'package:SD/models/user_info.dart';

class Home extends StatefulWidget {
  int page_index; 
  Home({Key key, @required this.page_index}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Widget> _tabItems = [Feed(), Posts(), MyProfile()];
  GlobalKey _bottomNavigationKey = GlobalKey();
  int _activePage = 0;
  @override
  void initState() {
    _activePage = widget.page_index;
  }
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        buttonBackgroundColor: Colors.blue,
        color: Colors.blue,
        backgroundColor: Colors.transparent,
        animationDuration: Duration(milliseconds: 250),
        index: _activePage,
        animationCurve: Curves.bounceInOut,
        key: _bottomNavigationKey,
        height: 55,
        items: <Widget>[
          Icon(Icons.explore, size: 25),
          Icon(Icons.bookmark, size: 25),
          Icon(Icons.account_circle, size: 25),
        ],
        onTap: (index) {
          setState(() {
            _activePage = index;
          });
        },
      ),
      body: _tabItems[_activePage]
    );
  }
}
