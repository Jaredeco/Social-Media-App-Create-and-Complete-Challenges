import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:SD/models/challenge.dart';

Widget myCardDetails(BuildContext context, DocumentSnapshot challenge) {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Material(
      color: Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: Color(0x802196F3),
      child: InkWell(
        onTap: () {
        },
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: myCurrencies(
              challenge["imageVal"], challenge["taskName"], challenge["numberViews"], challenge["numberLikes"], challenge["numberDislikes"]),
        ),
      ),
    ),
  );
}

Center myCurrencies(String imageVal, String taskName, int numberViews,
    int numberLikes, int numberDislikes) {
  return Center(
      child: Column(
    children: <Widget>[
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          myLeadingDetails(imageVal, taskName),
          yesButton(),
          myTaskDetails(numberViews, numberLikes, numberDislikes),
        ],
      )
    ],
  ));
}

Widget myLeadingDetails(String imageVal, String taskName) {
  return Container(
      child: Row(
    children: <Widget>[
      Container(
        child: Image(
          height: 50.0,
          image: AssetImage(imageVal),
        ),
      ),
      SizedBox(
        width: 10.0,
      ),
      SizedBox(
        width: 90,
        child: Text(
          taskName,
          overflow: TextOverflow.fade,
          maxLines: 1,
          softWrap: false,
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16.0),
        ),
      ),
    ],
  ));
}

Widget yesButton() {
  return Column(children: <Widget>[
    RaisedButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
          side: BorderSide(color: Colors.white, width: 3)),
      color: Colors.lightGreen,
      elevation: 3,
      onPressed: () {
        print("pressed");
      },
      child: Padding(
        padding: EdgeInsets.all(2),
        child: Text(
          "Yes",
          style: TextStyle(
              color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
    ),
  ]);
}

Widget myTaskDetails(
    int numberViews, int numberLikes, int numberDislikes) {
  return Container(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
        Container(
          child: Row(children: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 8),
                child: Icon(Icons.remove_red_eye)),
            Text(numberViews.toString(),
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w800,
                    fontSize: 20.0)),
          ]),
        ),
        Container(
            child: Row(children: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 8), child: Icon(Icons.thumb_up)),
          Text(numberLikes.toString(),
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ))
        ])),
        Container(
            child: Row(children: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 8),
              child: Icon(Icons.thumb_down)),
          Text(numberLikes.toString(),
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ))
        ]))
      ]));
}
