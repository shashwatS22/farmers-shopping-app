import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmket/models/user.dart';
import 'package:farmket/screens/profile/add_address_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ManageAddressesScreen extends StatefulWidget {
  @override
  _ManageAddressesScreenState createState() => _ManageAddressesScreenState();
}

class _ManageAddressesScreenState extends State<ManageAddressesScreen> {
  User currentUser;
  bool gotUser = false;
  bool isDeleting = false;

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

  void delete(int index) {
    var addresses = new List.from(currentUser.addresses);
    List numbers = new List.from(currentUser.numbers);
    List locations = new List.from(currentUser.location);
    List longitudes = new List.from(currentUser.longitude);
    List latitudes = new List.from(currentUser.latitude);

    addresses.removeAt(index);
    numbers.removeAt(index);
    locations.removeAt(index);
    longitudes.removeAt(index);
    latitudes.removeAt(index);

    Firestore.instance
        .collection('users')
        .document(currentUser.userId)
        .updateData({
      'addresses': addresses,
      'numbers': numbers,
      'location': locations,
      'latitude': latitudes,
      'longitude': longitudes,
    }).whenComplete(() async {
      setState(() {
        isDeleting = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text("Manage Addresses"),
        backgroundColor: Colors.white,
      ),
      body: !isDeleting
          ? gotUser
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
                            "Manage delivery addresses",
                            style: GoogleFonts.roboto(
                                fontSize: 25,
                                letterSpacing: 1,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: 20, right: 20, bottom: 20),
                            child: ListView.builder(
                              itemBuilder: (context, index) {
                                return Card(
                                  key: ValueKey(index + 100),
                                  margin: EdgeInsets.all(0.2),
                                  child: ListTile(
                                    contentPadding: EdgeInsets.all(5),
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            FlatButton(
                                              onPressed: () {
                                                setState(() {
                                                  delete(index);
                                                  isDeleting = true;
                                                });
                                              },
                                              child: Text("Delete"),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
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
              : Center(child: CircularProgressIndicator())
          : Center(
              child: CircularProgressIndicator(),
            ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text(
          "Add Address",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        icon: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.green,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AddAddressScreen(),
          ));
        },
      ),
    );
  }
}
