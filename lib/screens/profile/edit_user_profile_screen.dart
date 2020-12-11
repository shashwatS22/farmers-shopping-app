import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmket/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

class EditUserProfileScreen extends StatefulWidget {
  @override
  _EditUserProfileScreenState createState() => _EditUserProfileScreenState();
}

class _EditUserProfileScreenState extends State<EditUserProfileScreen> {
  User currentUser;
  bool gotUser = false;
  bool isImagePicked = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  String name;
  String imageURL;
  File image;
  void getUser() async {
    var user = await FirebaseAuth.instance.currentUser();
    final doc = await Firestore.instance
        .collection('users')
        .document(user.uid)
        .get()
        .whenComplete(() {
      setState(() {
        gotUser = true;
      });
    });
    currentUser = User.fromDocument(doc);
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  void pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(
      source: ImageSource.gallery,
      imageQuality: 100,
    );
    final pickedImageFile = File(pickedImage.path);

    image = pickedImageFile;
    SnackBar snackbar = SnackBar(
      content: Text(
        "Image Picked!",
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Theme.of(context).primaryColor,
    );
    _scaffoldKey.currentState.showSnackBar(snackbar);
    setState(() {
      isImagePicked = true;
    });
  }

  void submit() async {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();

      final ref = FirebaseStorage.instance
          .ref()
          .child('user_profile_images')
          .child(currentUser.userId + '.jpg');
      StorageUploadTask uploadTask = ref.putFile(image);
      var dowurl = await (await uploadTask.onComplete).ref.getDownloadURL();
      final url = dowurl.toString();
      imageURL = url;

      Firestore.instance
          .collection('users')
          .document(currentUser.userId)
          .updateData({
        'name': name,
        'imageURL': imageURL,
      }).whenComplete(() => Navigator.of(context).pop());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
      ),
      key: _scaffoldKey,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Form(
            key: _formKey,
            autovalidate: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Center(
                    child: Text(
                      "Enter Name",
                      style: TextStyle(fontSize: 25.0),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    keyboardType: TextInputType.multiline,
                    validator: (val) {
                      if (val.trim().isEmpty) {
                        return "Name cannot be empty";
                      } else {
                        return null;
                      }
                    },
                    onSaved: (val) => name = val,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Enter Name",
                      labelStyle: TextStyle(fontSize: 15.0),
                    ),
                  ),
                ),
                if (isImagePicked)
                  GestureDetector(
                    onTap: submit,
                    child: Container(
                      height: 50.0,
                      width: 350.0,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(7.0),
                      ),
                      child: Center(
                        child: Text(
                          "Submit",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          RaisedButton(
            child: Text("Upload Profile pic"),
            onPressed: pickImage,
          ),
        ],
      ),
    );
  }
}
