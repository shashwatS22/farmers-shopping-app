// ignore: avoid_web_libraries_in_flutter

import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String name;
  List addresses;
  List numbers;
  List location;
  List latitude;
  List longitude;
  String email;
  String imageURL;
  String userId;
  String timestamp;
  String userType;

  User({
    this.addresses,
    this.email,
    this.name,
    this.imageURL,
    this.location,
    this.numbers,
    this.userId,
    this.timestamp,
    this.latitude,
    this.longitude,
    this.userType,
  });
  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
      name: doc['name'],
      email: doc['email'],
      numbers: doc['numbers'],
      addresses: doc['addresses'],
      imageURL: doc['imageURL'],
      location: doc['location'],
      userId: doc['userId'],
      timestamp: doc['timestamp'],
      latitude: doc['latitude'],
      longitude: doc['longitude'],
      userType: doc['userType'],
    );
  }
}
