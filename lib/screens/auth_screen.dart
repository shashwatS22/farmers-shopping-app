import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/auth/auth_form.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  var _isLoading = false;
  final _auth = FirebaseAuth.instance;

  void _submitAuthForm(String email, String username, String password,
      bool isLogin, BuildContext ctx) async {
    AuthResult authResult;
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        print("create user");
        authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        await Firestore.instance
            .collection('users')
            .document(authResult.user.uid)
            .setData({
          'name': username,
          'email': email,
          'numbers': [],
          'addresses': [],
          'imageURL': '',
          'location': [],
          'userId': authResult.user.uid.toString(),
          'timestamp': DateTime.now().toString(),
          'latitude': [],
          "longitude": [],
          'userType': 'CUSTOMER',
        });
        print("Data added to firebase");
      }
    } catch (err) {
      var message = 'An error has occured please check your credentials';
      if (err.message != null) {
        message = err.message;
      }
      Scaffold.of(ctx).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).errorColor,
      ));
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: AuthForm(_submitAuthForm, _isLoading),
    );
  }
}
