import 'package:flutter/material.dart';
import 'package:SD/widgets/provider_widget.dart';
import 'package:SD/services/auth_service.dart';
import 'package:SD/Pages/content_pages/create_task.dart';
import 'package:SD/models/challenge.dart';

class MyAppBar extends StatelessWidget {
  final double barHeight = 66.0;

  const MyAppBar();

  @override
  
  Widget build(BuildContext context) {
    final newChallenge = new Challenge(null, null, null, null, null, null);
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          RawMaterialButton(
            onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateTask(challenge:newChallenge)),);
            },
            fillColor: Colors.lightGreen,
            child: Icon(
              Icons.add,
              size: 20.0,
            ),
            shape: CircleBorder(),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Seek Discomfort',
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
            ),
          ),
          RawMaterialButton(
            elevation: 3,
            onPressed: () async {
              try {
                AuthService auth = Provider.of(context).auth;
                await auth.signOut();
              } catch (e) {
                print(e);
              }
            },
            fillColor: Colors.redAccent,
            child: Icon(
              Icons.exit_to_app,
              size: 20.0,
            ),
            shape: CircleBorder(),
          ),
        ],
      ),
    );
  }
}
