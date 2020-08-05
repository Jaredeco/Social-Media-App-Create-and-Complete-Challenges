import 'package:SD/widgets/myAppbar.dart';
import 'package:SD/widgets/myFlexibleAppbar.dart';
import 'package:flutter/material.dart';
import 'package:SD/widgets/yescardContent.dart';

class Feed extends StatefulWidget {
  Feed({Key key}) : super(key: key);

  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          title: MyAppBar(),
          pinned: true,
          expandedHeight: 210,
          flexibleSpace: FlexibleSpaceBar(background: MyFlexibleAppBar()),
        ),
        SliverList(
            delegate: SliverChildListDelegate(
          <Widget>[
            myCardDetails('assets/jupyter_logo.png', 'Jump from cliff', "4702",
                "2000", "100"),
            myCardDetails('assets/jupyter_logo.png', 'Take a cold shower', "4702",
            "2000", "100"),
            myCardDetails('assets/jupyter_logo.png', 'Travel to another country', "4702",
            "2000", "100"),
            myCardDetails('assets/jupyter_logo.png', 'Jump ton pool', "4702",
            "2000", "100"),
            myCardDetails('assets/jupyter_logo.png', 'Go running', "4702",
            "2000", "100"),
            myCardDetails('assets/jupyter_logo.png', 'Play foootball', "4702",
            "2000", "100"),
          ],
        ))
      ],
    ));
  }
}
