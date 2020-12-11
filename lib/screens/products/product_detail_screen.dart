import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmket/models/product.dart';
import 'package:farmket/screens/orders/cart_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  ProductDetailScreen(this.product);
  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int count = 1;
  void addToCart() async {
    final user = await FirebaseAuth.instance.currentUser();
    Firestore.instance
        .collection('users')
        .document(user.uid)
        .collection('cart')
        .add({
      'name': widget.product.name,
      'customerId': user.uid,
      'productId': widget.product.id,
      'quantity': count,
      'unit': widget.product.unit,
      'price': widget.product.price,
      'amount': int.parse(widget.product.price) * count,
      'imageURL': widget.product.imageURL,
      'type': widget.product.type,
      'serviceProviderId': '',
    }).whenComplete(
            () => Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => CartScreen(),
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Order",
          style: TextStyle(fontSize: 20),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => CartScreen(),
              ));
            },
          )
        ],
      ),
      body: ListView(children: [
        SizedBox(height: 15.0),
        Padding(
          padding: EdgeInsets.only(left: 20.0),
          child: Text(widget.product.category,
              style: TextStyle(
                  fontFamily: 'Varela',
                  fontSize: 42.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.green)),
        ),
        SizedBox(height: 15.0),
        Container(
            child: Image.network(widget.product.imageURL,
                height: MediaQuery.of(context).size.height * 0.32,
                width: MediaQuery.of(context).size.width * 0.8,
                fit: BoxFit.contain)),
        SizedBox(height: 20.0),
        Center(
          child: Text(
              "\u20B9 ${widget.product.price} /${widget.product.quantity}",
              style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.lightGreen)),
        ),
        SizedBox(height: 10.0),
        Center(
          child: Text(widget.product.name,
              style: TextStyle(
                  color: Color(0xFF575E67),
                  fontFamily: 'Varela',
                  fontSize: 24.0)),
        ),
        SizedBox(height: 20.0),
        Center(
          child: Container(
            width: MediaQuery.of(context).size.width - 50.0,
            child: Text(widget.product.description,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Varela',
                    fontSize: 16.0,
                    color: Color(0xFFB4B8B9))),
          ),
        ),
        SizedBox(height: 20.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.add_circle_outline,
                  color: Colors.green,
                  size: 30,
                ),
                onPressed: () {
                  setState(() {
                    count++;
                  });
                }),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.05,
            ),
            Text(
              count.toString(),
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.05,
            ),
            IconButton(
              icon: Icon(
                Icons.remove_circle_outline,
                color: Colors.green,
                size: 30,
              ),
              onPressed: () {
                setState(() {
                  if (count > 0) {
                    count--;
                  }
                  if (count == 0) {
                    count--;
                    count = 0;
                  }
                });
              },
            )
          ],
        ),
        SizedBox(height: 20.0),
        Center(
            child: GestureDetector(
          onTap: addToCart,
          child: Container(
              width: MediaQuery.of(context).size.width - 50.0,
              height: 50.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.0),
                  color: Colors.green),
              child: Center(
                  child: Text(
                'Add to cart',
                style: TextStyle(
                    fontFamily: 'Varela',
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ))),
        ))
      ]),
    );
  }
}
