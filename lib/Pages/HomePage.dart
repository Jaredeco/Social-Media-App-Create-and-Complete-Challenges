import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:SD/Pages/content_pages/feed.dart';
import 'package:SD/Pages/content_pages/posts.dart';
import 'package:SD/Pages/content_pages/profile.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Widget> _tabItems = [Feed(), Posts(), Profile()];
  int _activePage = 0;
  GlobalKey _bottomNavigationKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        buttonBackgroundColor: Colors.blue,
        color: Colors.blue,
        backgroundColor: Colors.transparent,
        animationDuration: Duration(milliseconds: 250),
        index: 0,
        animationCurve: Curves.bounceInOut,
        key: _bottomNavigationKey,
        height: 55,
        items: <Widget>[
          Icon(Icons.assignment, size: 25),
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
