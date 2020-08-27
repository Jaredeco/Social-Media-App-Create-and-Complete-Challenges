import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:SD/widgets/provider_widget.dart';
import 'package:SD/models/user_info.dart';
import 'package:path/path.dart';

class UpdateProfPic extends StatefulWidget {
  UserInfo userInfo;
  UpdateProfPic({Key key, @required this.userInfo}) : super(key: key);

  @override
  _UpdateProfPicState createState() => _UpdateProfPicState();
}

class _UpdateProfPicState extends State<UpdateProfPic> {
  var imageUrl;
  final db = Firestore.instance;
  File _image;
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
      appBar: AppBar(title: Text("Update Picture")),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, top: 15.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Row(
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
                                    widget.userInfo.userImage,
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
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    child: Text('Save'),
                    color: Colors.green,
                    textColor: Colors.white,
                    onPressed: () async {
                      if (_image != null) {
                        await uploadPic(context);
                        widget.userInfo.userImage = imageUrl;
                        final uid =
                            await Provider.of(context).auth.getCurrentUID();
                        await Provider.of(context)
                            .db
                            .collection('userData')
                            .document(uid)
                            .setData(widget.userInfo.toJson());
                        Navigator.pop(context, imageUrl);
                      }
                    },
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
