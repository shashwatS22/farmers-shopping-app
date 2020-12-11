import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmket/models/user.dart';
import 'package:farmket/screens/home_screen.dart';
import 'package:farmket/screens/products/products_screen.dart';
import 'package:farmket/screens/profile/my_orders_screen.dart';
import 'package:farmket/screens/profile/profile_screen.dart';
import 'package:farmket/screens/services/services_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
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
    return gotUser
        ? Drawer(
            child: ListView(
              children: [
                UserAccountsDrawerHeader(
                  decoration: new BoxDecoration(
                    color: Colors.green[700],
                  ),
                  accountEmail: Text(currentUser.email),
                  accountName: Text(currentUser.name),
                  currentAccountPicture: currentUser.imageURL.isNotEmpty
                      ? CircleAvatar(
                          backgroundColor: Colors.grey,
                          backgroundImage: NetworkImage(currentUser.imageURL),
                        )
                      : CircleAvatar(
                          backgroundColor: Colors.grey,
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                        ),
                ),
                InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => HomeScreen(),
                      ));
                    },
                    child: ListTile(
                      title: Text('Home'),
                      leading: Icon(
                        Icons.home,
                        color: Colors.deepOrange,
                      ),
                    )),
                Divider(),
                InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ProductsScreen(),
                      ));
                    },
                    child: ListTile(
                      title: Text('Products'),
                      leading: Icon(
                        Icons.fastfood,
                        color: Colors.blueAccent,
                      ),
                    )),
                Divider(),
                InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ServicesScreen(),
                      ));
                    },
                    child: ListTile(
                      title: Text('Services'),
                      leading: Icon(
                        Icons.room_service,
                        color: Colors.orange,
                      ),
                    )),
                Divider(),
                InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => MyOrdersScreen(),
                      ));
                    },
                    child: ListTile(
                      title: Text('My Orders'),
                      leading: Icon(
                        Icons.shopping_basket,
                        color: Colors.black87,
                      ),
                    )),
                Divider(),
                InkWell(
                    onTap: () {},
                    child: ListTile(
                      title: Text('Contact Us'),
                      leading: Icon(
                        Icons.call,
                        color: Colors.blue,
                      ),
                    )),
                Divider(),
                InkWell(
                    onTap: () {
                      FirebaseAuth.instance.signOut();
                    },
                    child: ListTile(
                      title: Text('Logout'),
                      leading: Icon(
                        Icons.arrow_back,
                        color: Colors.grey,
                      ),
                    )),
                Divider(),
              ],
            ),
          )
        : Center(
            child: CircularProgressIndicator(),
          );
  }
}
