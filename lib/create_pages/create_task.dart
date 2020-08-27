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
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text('Create Challenge'),
      ),
      body: ListView(children: <Widget>[
        Builder(
          builder: (context) => Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        radius: 100,
                        backgroundColor: Color(0xff476cfb),
                        child: ClipOval(
                          child: new SizedBox(
                            width: 180.0,
                            height: 180.0,
                            child: (_image != null)
                                ? Image.file(
                                    _image,
                                    fit: BoxFit.fill,
                                  )
                                : Image.network(
                                    "https://www.levelupsneakers.com/public/themes/default/backend/images/default-img.png",
                                    fit: BoxFit.fill,
                                  ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 60.0),
                      child: IconButton(
                        icon: Icon(
                          Icons.camera_alt,
                          size: 30.0,
                        ),
                        onPressed: () {
                          getImage();
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 320,
                      child: TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(10.0),
                            ),
                          ),
                          labelText: 'Name',
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Container(
                        width: 320,
                        child: TextField(
                          controller: _descriptionController,
                          maxLines: 8,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(  
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(10.0),
                              ),
                            ),
                            labelText: 'Description',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    RaisedButton(
                      color: Color(0xff476cfb),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      elevation: 4.0,
                      splashColor: Colors.blueGrey,
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: Colors.white, fontSize: 16.0),
                      ),
                    ),
                    RaisedButton(
                      color: Color(0xff476cfb),
                      onPressed: () async {
                        if (_image != null){
                          await uploadPic(context);
                          widget.challenge.taskName = _nameController.text;
                          widget.challenge.description =
                              _descriptionController.text;
                          widget.challenge.imageVal = imageUrl;
                          widget.challenge.numberDislikes = 0;
                          widget.challenge.numberLikes = 0;
                          widget.challenge.numberViews = 0;
                          final uid =
                              await Provider.of(context).auth.getCurrentUID();
                          await db
                              .collection("userData")
                              .document(uid)
                              .collection("challenges")
                              .add(widget.challenge.toJson());
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Home(
                                    page_index: 0,
                                  )));
                        } else {
                          Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text("Please, upload the picture!"),
                          ));
                        }
                      },
                      elevation: 4.0,
                      splashColor: Colors.blueGrey,
                      child: Text(
                        'Submit',
                        style: TextStyle(color: Colors.white, fontSize: 16.0),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
