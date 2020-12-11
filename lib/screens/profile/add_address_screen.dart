import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmket/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class AddAddressScreen extends StatefulWidget {
  @override
  _AddAddressScreenState createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  String address;
  String number;
  Position location;
  bool isLocationSelected = false;

  User currentUser;
  bool gotUser = false;

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

  void submit() async {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();

      var addresses = new List.from(currentUser.addresses);
      List numbers = new List.from(currentUser.numbers);
      List locations = new List.from(currentUser.location);
      List longitudes = new List.from(currentUser.longitude);
      List latitudes = new List.from(currentUser.latitude);

      addresses.add(address);
      numbers.add(number);
      locations.add(location.toString());
      longitudes.add(location.longitude.toString());
      latitudes.add(location.latitude.toString());

      addresses.removeWhere((element) => element == null);
      numbers.removeWhere((element) => element == null);
      locations.removeWhere((element) => element == null);
      latitudes.removeWhere((element) => element == null);
      longitudes.removeWhere((element) => element == null);
      Firestore.instance
          .collection('users')
          .document(currentUser.userId)
          .updateData({
        'addresses': addresses,
        'numbers': numbers,
        'location': locations,
        'latitude': latitudes,
        'longitude': longitudes,
      }).whenComplete(() => Navigator.of(context).pop());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Add address"),
      ),
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
                isLocationSelected
                    ? GestureDetector(
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
                      )
                    : SizedBox(
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
                        setState(() {
                          isLocationSelected = true;
                        });

                        SnackBar snackbar = SnackBar(
                          content: Text(
                            "Got your location",
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Theme.of(context).primaryColor,
                        );
                        _scaffoldKey.currentState.showSnackBar(snackbar);
                      },
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Get current location"),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
