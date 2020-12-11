import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TotalPriceText extends StatefulWidget {
  final String id;
  TotalPriceText(this.id);
  @override
  _TotalPriceTextState createState() => _TotalPriceTextState();
}

class _TotalPriceTextState extends State<TotalPriceText> {
  String totalAmount;
  bool gotTotal = false;
  void getTotal() async {
    final doc = await Firestore.instance
        .collection('users')
        .document(widget.id)
        .get()
        .whenComplete(() {
      setState(() {
        gotTotal = true;
      });
    });
    totalAmount = doc['currentCartTotal'];
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTotal();
  }

  @override
  Widget build(BuildContext context) {
    return gotTotal
        ? Text(
            "\u20B9 $totalAmount",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 27),
          )
        : CircularProgressIndicator();
  }
}
