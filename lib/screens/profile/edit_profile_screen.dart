import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmket/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  User currentUser;
  final auth = FirebaseAuth.instance;
  String uid;

  void getCurrentUSer() async {
    final FirebaseUser user = await auth.currentUser();
    uid = user.uid;
    final doc =
        await Firestore.instance.collection('users').document(uid).get();
    currentUser = User.fromDocument(doc);
  }

  @override
  Widget build(BuildContext context) {
    getCurrentUSer();
    final _scaffoldKey = GlobalKey<ScaffoldState>();
    final _formKey = GlobalKey<FormState>();
    String address;
    String number;
    Position location;

    String imageURL;
    File image;

    void pickImage() async {
      final picker = ImagePicker();
      final pickedImage = await picker.getImage(
        source: ImageSource.gallery,
        imageQuality: 100,
      );
      final pickedImageFile = File(pickedImage.path);

      image = pickedImageFile;
    }

    void submit() async {
      final form = _formKey.currentState;
      if (form.validate()) {
        form.save();

        var addresses = new List.from(currentUser.addresses);
        List numbers = new List.from(currentUser.numbers);
        List locations = new List.from(currentUser.location);
        List longitudes = new List.from(currentUser.longitude);
        List latitudes = new List.from(currentUser.latitude);
        final ref = FirebaseStorage.instance
            .ref()
            .child('user_profile_images')
            .child(uid + '.jpg');
        StorageUploadTask uploadTask = ref.putFile(image);
        var dowurl = await (await uploadTask.onComplete).ref.getDownloadURL();
        final url = dowurl.toString();
        imageURL = url;

        addresses.add(address);
        numbers.add(number);
        locations.add(location.toString());
        longitudes.add(location.longitude.toString());
        latitudes.add(location.latitude.toString());
        print(addresses);
        print(numbers);
        print(locations);
        print(latitudes);
        print(longitudes);
        addresses.removeWhere((element) => element == null);
        numbers.removeWhere((element) => element == null);
        locations.removeWhere((element) => element == null);
        latitudes.removeWhere((element) => element == null);
        longitudes.removeWhere((element) => element == null);
        Firestore.instance.collection('users').document(uid).updateData({
          'addresses': addresses,
          'numbers': numbers,
          'location': locations,
          'latitude': latitudes,
          'longitude': longitudes,
          'imageURL': imageURL,
        }).whenComplete(() => Navigator.of(context).pop());
      }
    }

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
                      "Enter your number",
                      style: TextStyle(fontSize: 25.0),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    validator: (val) {
                      if (val.trim().length != 10) {
                        return "Enter Valid Number";
                      } else if (val.isEmpty) {
                        return "Enter a number";
                      } else {
                        return null;
                      }
                    },
                    onSaved: (val) => number = val,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Phone Number",
                      labelStyle: TextStyle(fontSize: 15.0),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Center(
                    child: Text(
                      "Enter your address",
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
                        return "Address cannot be empty";
                      } else {
                        return null;
                      }
                    },
                    onSaved: (val) => address = val,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Enter Address",
                      labelStyle: TextStyle(fontSize: 15.0),
                    ),
                  ),
                ),
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
          Row(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.my_location),
                color: Colors.red,
                onPressed: () async {
                  Position currentPosition = await getCurrentPosition(
                      desiredAccuracy: LocationAccuracy.best);

                  print(currentPosition);

                  location = currentPosition;
                },
              ),
              SizedBox(
                width: 10,
              ),
              Text("Get current location"),
            ],
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
