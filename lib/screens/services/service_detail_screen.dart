import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmket/models/service.dart';
import 'package:farmket/screens/orders/cart_screen.dart';
import 'package:farmket/screens/orders/select_user_details_screen.dart';
import 'package:farmket/screens/services/select_service_provider_screen.dart';
import 'package:farmket/widgets/home/drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ServiceDetailScreen extends StatefulWidget {
  final Service service;
  ServiceDetailScreen(this.service);
  @override
  _ServiceDetailScreenState createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  int count = 1;
  bool isServiceProviderSelected = false;
  bool isAddressSelected = false;
  List details;
  String serviceProviderId;
  void selectServiceProvider() async {
    print("detials latitude + longitude" + details[3] + " " + details[4]);
    serviceProviderId = await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) {
        return SelectServiceProviderScreen(
            widget.service, details[3], details[4]);
      },
    ));
    setState(() {
      isServiceProviderSelected = true;
    });
  }

  void selectAddress() async {
    List d = await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) {
        return SelectUserDetailsScreen();
      },
    ));
    print("User latitude + longitude" + d[3] + " " + d[4]);
    setState(() {
      isAddressSelected = true;
    });
    print(d);
    details = List.from(d);
  }

  void addToCart() async {
    final user = await FirebaseAuth.instance.currentUser();
    print("service provider id " + serviceProviderId);

    Firestore.instance
        .collection('users')
        .document(user.uid)
        .collection('cart')
        .add({
      'name': widget.service.name,
      'customerId': user.uid,
      'productId': widget.service.id,
      'serviceProviderId': serviceProviderId,
      'quantity': count,
      'unit': widget.service.unit,
      'price': widget.service.price,
      'amount': int.parse(widget.service.price) * count,
      'imageURL': widget.service.imageURL,
      'type': widget.service.type,
      'userName': user.displayName,
      'location': details[1].toString(),
    }).whenComplete(() => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => CartScreen(),
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
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
          child: Text(widget.service.category,
              style: TextStyle(
                  fontFamily: 'Varela',
                  fontSize: 42.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.green)),
        ),
        SizedBox(height: 15.0),
        Container(
            child: Image.network(widget.service.imageURL,
                height: MediaQuery.of(context).size.height * 0.32,
                width: MediaQuery.of(context).size.width * 0.8,
                fit: BoxFit.contain)),
        SizedBox(height: 20.0),
        Center(
          child: Text("\u20B9 ${widget.service.price} /${widget.service.unit}",
              style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.lightGreen)),
        ),
        SizedBox(height: 10.0),
        Center(
          child: Text(widget.service.name,
              style: TextStyle(
                  color: Color(0xFF575E67),
                  fontFamily: 'Varela',
                  fontSize: 24.0)),
        ),
        SizedBox(height: 20.0),
        Center(
          child: Container(
            width: MediaQuery.of(context).size.width - 50.0,
            child: Text(widget.service.description,
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
        isServiceProviderSelected
            ? Center(
                child: GestureDetector(
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
                onTap: addToCart,
              ))
            : isAddressSelected
                ? Center(
                    child: GestureDetector(
                    child: Container(
                        width: MediaQuery.of(context).size.width - 50.0,
                        height: 50.0,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25.0),
                            color: Colors.green),
                        child: Center(
                            child: Text(
                          'Select Service Provider',
                          style: TextStyle(
                              fontFamily: 'Varela',
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ))),
                    onTap: selectServiceProvider,
                  ))
                : Center(
                    child: GestureDetector(
                    child: Container(
                        width: MediaQuery.of(context).size.width - 50.0,
                        height: 50.0,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25.0),
                            color: Colors.green),
                        child: Center(
                            child: Text(
                          'Select Address',
                          style: TextStyle(
                              fontFamily: 'Varela',
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ))),
                    onTap: selectAddress,
                  ))
      ]),
    );
  }
}
