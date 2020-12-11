import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmket/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SelectUserDetailsScreen extends StatefulWidget {
  @override
  _SelectUserDetailsScreenState createState() =>
      _SelectUserDetailsScreenState();
}

class _SelectUserDetailsScreenState extends State<SelectUserDetailsScreen> {
  int selectedRadioTile;
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
    print(currentUser.name);
    print(currentUser.userId);
    print(gotUser);
  }

  @override
  void initState() {
    super.initState();
    selectedRadioTile = 999;
    getUser();
  }

  setSelectedRadioTile(int val, List details) {
    setState(() {
      selectedRadioTile = val;
    });

    Navigator.of(context).pop(details);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("Select Address"),
      ),
      body: gotUser
          ? StreamBuilder(
              stream: Firestore.instance
                  .collection('users')
                  .document(currentUser.userId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (!snapshot.hasData) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("No items in cart"),
                    ],
                  );
                }
                final doc = snapshot.data;
                List addresses = doc['addresses'];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 15.0, right: 20, left: 20, bottom: 15),
                      child: Text(
                        "Select a delivery address",
                        style: GoogleFonts.roboto(
                            fontSize: 25,
                            letterSpacing: 1,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding:
                            EdgeInsets.only(left: 20, right: 20, bottom: 20),
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            return Card(
                              margin: EdgeInsets.all(0.2),
                              child: RadioListTile(
                                groupValue: selectedRadioTile,
                                value: index,
                                onChanged: (val) {
                                  print(val.toString());
                                  setSelectedRadioTile(val, [
                                    doc['addresses'][index],
                                    doc['location'][index],
                                    doc['numbers'][index],
                                    doc['latitude'][index],
                                    doc['longitude'][index]
                                  ]);
                                },
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      addresses[index],
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18),
                                    ),
                                    Text(doc['name']),
                                    Text(doc['numbers'][index]),
                                  ],
                                ),
                                //Text(addresses[index]),
                                //subtitle: Text(doc['location'][index]),
                                selected: false,
                              ),
                            );
                          },
                          itemCount: addresses.length,
                        ),
                      ),
                    ),
                  ],
                );
              },
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
