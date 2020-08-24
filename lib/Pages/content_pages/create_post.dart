import 'package:SD/Pages/content_pages/posts.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:SD/models/post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:SD/widgets/provider_widget.dart';

class CreatePost extends StatefulWidget {
  final Post post;
  CreatePost({Key key, @required this.post}) : super(key: key);

  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
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
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text('Create Post'),
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
                        if (_image != null) {
                          widget.post.userName = _nameController.text;
                          widget.post.userImage = "";
                          widget.post.postText = _descriptionController.text;
                          widget.post.postImage = _image.path;
                          widget.post.numberLikes = 0;
                          widget.post.numberComments = 0;
                          uploadPic(context);
                          final uid =
                              await Provider.of(context).auth.getCurrentUID();
                          await db
                              .collection("userData")
                              .document(uid)
                              .collection("posts")
                              .add(widget.post.toJson());
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => Posts()));
                        }else{
                          Scaffold.of(context).showSnackBar(
                            SnackBar(content: Text("Please, upload the picture!"),)
                          );
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
