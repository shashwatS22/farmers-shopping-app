import 'package:farmket/screens/home_screen.dart';
import 'package:flutter/material.dart';

class EmptyCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              child: Image.asset("lib/assets/images/emptycart.png"),
            ),
            Text(
              "Your cart is empty!",
              style: TextStyle(fontSize: 25),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Add items to it now",
              style: TextStyle(fontSize: 15, color: Colors.grey),
            ),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              child: Container(
                  margin: EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: MediaQuery.of(context).size.height * 0.05,
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(8)),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Shop Now",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  )),
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => HomeScreen(),
                ));
              },
            ),
          ],
        ),
      ),
    );
  }
}
