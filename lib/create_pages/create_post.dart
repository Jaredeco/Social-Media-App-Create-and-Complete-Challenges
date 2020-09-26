import 'package:SD/Pages/HomePage.dart';
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
  var imageUrl;
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
        automaticallyImplyLeading: false,
        title: Text(
          "Create a new post",
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
                      labelStyle: TextStyle(color:Colors.blue[800]),
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
                        await uploadPic(context);
                        final uid =
                            await Provider.of(context).auth.getCurrentUID();
                        widget.post.uid = uid.toString();
                        widget.post.postText = _descriptionController.text;
                        widget.post.postImage = imageUrl;
                        widget.post.numberLikes = 0;
                        widget.post.numberComments = 0;
                        widget.post.timeCreated = Timestamp.now();
                        await db
                            .collection("posts")
                            .add(widget.post.toJson());
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
