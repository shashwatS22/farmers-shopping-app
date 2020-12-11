import 'package:flutter/material.dart';

// ignore: must_be_immutable
class PaymentScreen extends StatefulWidget {
  double amount;
  PaymentScreen(this.amount);
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Amount : ${widget.amount}"),
            Row(
              children: [
                RaisedButton(
                  child: Text("Payment Successful"),
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                ),
                SizedBox(
                  width: 20,
                ),
                RaisedButton(
                  child: Text("Payment Unsuccessful"),
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
