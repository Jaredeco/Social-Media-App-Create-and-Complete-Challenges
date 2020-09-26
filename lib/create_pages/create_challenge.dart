import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:SD/models/challenge.dart';
import 'package:SD/Pages/HomePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:SD/widgets/provider_widget.dart';

class CreateTask extends StatefulWidget {
  final Challenge challenge;
  CreateTask({Key key, @required this.challenge}) : super(key: key);

  @override
  _CreateTaskState createState() => _CreateTaskState();
}

class _CreateTaskState extends State<CreateTask> {
  var imageUrl;
  final db = Firestore.instance;
  File _image;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Future getImage() async {
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);
      setState(() {
        _image = image;
      });
    }

    Future uploadPic(BuildContext context) async {
      String fileName = basename(_image.path);
      StorageReference firebaseStorageRef =
          FirebaseStorage.instance.ref().child(fileName);
      StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
      var _downurl = await (await uploadTask.onComplete).ref.getDownloadURL();
      var _url = _downurl.toString();
      setState(() {
        imageUrl = _url;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Create a new challenge",
          style: TextStyle(color: Colors.blue[800]),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          padding: EdgeInsets.all(10.0),
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.blue[800],
        ),
      ),
      body: ListView(children: <Widget>[
        Builder(
          builder: (context) => Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.40,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: (_image != null)
                              ? FileImage(
                                  _image,
                                )
                              : AssetImage(
                                  "assets/empty_image.png",
                                ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.edit,
                        size: 30.0,
                      ),
                      onPressed: () {
                        getImage();
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.95,
                  child: TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(10.0),
                          ),
                          borderSide: BorderSide(color: Colors.blue[800])),
                      border: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(10.0),
                        ),
                      ),
                      labelStyle: TextStyle(color: Colors.blue[800]),
                      labelText: 'Title',
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.95,
                  child: TextField(
                    controller: _descriptionController,
                    maxLines: 8,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(10.0),
                          ),
                          borderSide: BorderSide(color: Colors.blue[800])),
                      border: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(10.0),
                        ),
                      ),
                      labelStyle: TextStyle(color: Colors.blue[800]),
                      labelText: 'Description',
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                ButtonTheme(
                  minWidth: 120,
                  height: 50,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    color: Colors.white,
                    onPressed: () async {
                      if (_image != null) {
                        final uid =
                            await Provider.of(context).auth.getCurrentUID();
                        await uploadPic(context);
                        widget.challenge.taskName = _nameController.text;
                        widget.challenge.description =
                            _descriptionController.text;
                        widget.challenge.imageVal = imageUrl;
                        widget.challenge.likedBy = [];
                        widget.challenge.dislikedBy = [];
                        widget.challenge.completedBy = [];
                        widget.challenge.comments = [];
                        widget.challenge.uid = uid;
                        widget.challenge.timeCreated = Timestamp.now();
                        await db
                            .collection("challenges")
                            .add(widget.challenge.toJson());
                        Navigator.pop(context);
                      } else {
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text("Please, upload the picture!"),
                        ));
                      }
                    },
                    elevation: 4.0,
                    splashColor: Colors.blue[800],
                    child: Text(
                      'Submit',
                      style: TextStyle(
                          color: Colors.blue[800],
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(
                  height: 35,
                )
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
