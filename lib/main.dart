import 'package:farmket/temp/add_data_screen.dart';
import 'package:farmket/temp/edit_service_screen.dart';
import 'package:google_fonts/google_fonts.dart';

import './screens/pages_screen.dart';

import './screens/auth_screen.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import './screens/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Farmket",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: TextTheme(
          title: GoogleFonts.sourceCodePro(fontSize: 26),
        ),
        primaryColor: Color.fromARGB(255, 119, 177, 34),
        backgroundColor: Color.fromARGB(255, 119, 177, 34),
        accentColor: Colors.greenAccent,
        appBarTheme: AppBarTheme(
          color: Colors.white,
        ),
        accentColorBrightness: Brightness.dark,
        buttonTheme: ButtonTheme.of(context).copyWith(
          buttonColor: Color.fromARGB(255, 119, 177, 34),
          textTheme: ButtonTextTheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      home: //AddDataScreen()
          StreamBuilder(
              stream: FirebaseAuth.instance.onAuthStateChanged,
              builder: (ctx, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return SplashScreen();
                }

                if (userSnapshot.hasData) {
                  return PagesScreen();
                }
                return AuthScreen();
              }),
    );
  }
}
