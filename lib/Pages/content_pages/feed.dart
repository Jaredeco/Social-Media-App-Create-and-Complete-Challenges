import 'package:SD/widgets/myAppbar.dart';
import 'package:SD/widgets/myFlexibleAppbar.dart';
import 'package:flutter/material.dart';
import 'package:SD/widgets/yescardContent.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:SD/widgets/provider_widget.dart';

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
            automaticallyImplyLeading: false,
            title: MyAppBar(),
            pinned: true,
            expandedHeight: 210,
            flexibleSpace: FlexibleSpaceBar(background: MyFlexibleAppBar()),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              <Widget>[
            Container(
              child: StreamBuilder(
                  stream: getUsersTripsStreamSnapshots(context),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height - 210,
                      child: Center(child: Container(width:40, height:40, child: CircularProgressIndicator())),
                    );
                    return new ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (BuildContext context, int index) =>
                            myCardDetails(
                                context, snapshot.data.documents[index]));
                  }),
            ),],),
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
        .collection('challenges')
        .snapshots();
  }
}
