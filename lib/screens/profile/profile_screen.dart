import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmket/models/user.dart';
import 'package:farmket/screens/orders/cart_screen.dart';
import 'package:farmket/screens/profile/manage_addresses_screen.dart';
import 'package:farmket/screens/profile/my_orders_screen.dart';
import 'package:farmket/widgets/home/drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

import './edit_profile_screen.dart';
import 'package:flutter/material.dart';

import 'edit_user_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: Text(
          "Profile",
          style: Theme.of(context).textTheme.title,
        ),
        backgroundColor: Colors.white,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => CartScreen(),
              ));
            },
          ),
        ],
      ),
      body: gotUser
          ? SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(3),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.2,
                    child: Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10, top: 2),
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage:
                                  NetworkImage(currentUser.imageURL),
                            ),
                          ),
                          Text(
                            currentUser.name,
                            style: GoogleFonts.montserrat(
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(3),
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Card(
                            elevation: 0,
                            child: ListTile(
                              leading: Icon(Icons.shopping_cart),
                              title: Text("My Orders"),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => MyOrdersScreen(),
                                ));
                              },
                            ),
                          ),
                          Divider(),
                          Card(
                            elevation: 0,
                            child: ListTile(
                              leading: Icon(Icons.location_city),
                              title: Text("Manage Addresses"),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ManageAddressesScreen(),
                                ));
                              },
                            ),
                          ),
                          Divider(),
                          Card(
                            elevation: 0,
                            child: ListTile(
                              leading: Icon(Icons.person),
                              title: Text("Edit Profile"),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => EditUserProfileScreen(),
                                ));
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(3),
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      child: Column(
                        children: [
                          Card(
                            elevation: 0,
                            child: ListTile(
                              leading: Icon(Icons.arrow_back),
                              title: Text("Logout"),
                              onTap: () {
                                FirebaseAuth.instance.signOut();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
