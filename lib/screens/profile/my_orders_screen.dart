import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmket/models/user.dart';
import 'package:farmket/widgets/profile/my_order_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../home_screen.dart';

class MyOrdersScreen extends StatefulWidget {
  @override
  _MyOrdersScreenState createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
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
      appBar: AppBar(
        title: Text("My Orders"),
        backgroundColor: Colors.white,
      ),
      body: gotUser
          ? StreamBuilder(
              stream: Firestore.instance
                  .collection('orders')
                  .where('userId', isEqualTo: currentUser.userId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.data.documents.length < 1) {
                  return Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.4,
                            child:
                                Image.asset("lib/assets/images/emptycart.png"),
                          ),
                          Text(
                            "No orders till now!",
                            style: TextStyle(fontSize: 25),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                            child: Container(
                                margin: EdgeInsets.all(10),
                                width: MediaQuery.of(context).size.width * 0.6,
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(8)),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Shop Now",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                )),
                            onTap: () {
                              Navigator.of(context)
                                  .pushReplacement(MaterialPageRoute(
                                builder: (context) => HomeScreen(),
                              ));
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }
                final docs = snapshot.data.documents;
                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    return MyOrderCard(docs[index], currentUser.userId);
                  },
                );
              },
            )
          : CircularProgressIndicator(),
    );
  }
}
