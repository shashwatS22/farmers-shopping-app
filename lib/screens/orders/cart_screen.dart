import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmket/models/cart_item.dart';
import 'package:farmket/models/order.dart';
import 'package:farmket/models/user.dart';
import 'package:farmket/screens/orders/payment_screen.dart';
import 'package:farmket/screens/orders/select_user_details_screen.dart';
import 'package:farmket/screens/profile/my_orders_screen.dart';
import 'package:farmket/widgets/cart/cart_card.dart';
import 'package:farmket/widgets/cart/empty_cart.dart';
import 'package:farmket/widgets/cart/total.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  double finalAmount = 0;
  bool isAddressSelected = false;
  User currentUser;
  bool gotUser = false;
  List details;
  String cartLocation;

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

  void checkout(List<Order> currentOrders, List details) async {
    bool isPaymentSuccess = false;

    isPaymentSuccess = await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) {
        return PaymentScreen(double.parse(getTotalAmount(currentOrders)));
      },
    ));
    if (isPaymentSuccess) {
      currentOrders.forEach((order) async {
        //  order.address = d[0];
        //  order.location = d[1];
        //  order.userNumber = d[2];
        //  order.latitude = d[3];
        //  order.longitude = d[4];
        if (order.type == 'Product') {
          bool isUploaded = false;
          DocumentReference doc =
              await Firestore.instance.collection('orders').add({
            'productName': order.productName,
            'productId': order.productId,
            'address': details[0],
            'category': order.category,
            'email': order.email,
            'imageURL': order.imageUrl,
            'latitude': details[3],
            'location': details[1],
            'longitude': details[4],
            'quantity': order.quantity,
            'timeStamp': DateTime.now().toString(),
            'type': order.type,
            'unit': order.unit,
            'userId': order.userId,
            'userName': order.userName,
            'userNumber': details[2],
            'warehouseId': order.warehouseId,
            'amount': order.amount,
            'status': order.status,
            'deliveryDate': order.deliveryDate,
          }).whenComplete(() {
            isUploaded = true;
          });
          if (isUploaded) {
            await Firestore.instance
                .collection('orders')
                .document(doc.documentID)
                .updateData({'orderId': doc.documentID});
          }
        }
        // if (order.location.toString() != cartLocation&&order.type=='Services') {
        //     setState(() {
        //       isAddressSelected = false;
        //     });
        //     SnackBar snackbar = SnackBar(
        //                   content: Text(
        //                     "Delivery address does not match the service addresss. Please select different address",
        //                     style: TextStyle(color: Colors.white),
        //                   ),
        //                   backgroundColor: Colors.red,
        //                 );
        //                 _scaffoldKey.currentState.showSnackBar(snackbar);
        //   }

        if (
            //order.location.toString() != cartLocation &&
            order.type == 'Services') {
          bool isUploaded = false;
          DocumentReference doc =
              await Firestore.instance.collection('orders').add({
            'serviceName': order.serviceName,
            'serviceId': order.serviceId,
            'address': details[0],
            'category': order.category,
            'email': order.email,
            'imageURL': order.imageUrl,
            'latitude': details[3],
            'location': details[1],
            'longitude': details[4],
            'quantity': order.quantity,
            'timeStamp': DateTime.now().toString(),
            'type': order.type,
            'unit': order.unit,
            'userId': order.userId,
            'userName': order.userName,
            'userNumber': details[2],
            'serviceProviderId': order.serviceProviderId,
            'amount': order.amount,
            'status': order.status,
            'deliverDate': order.deliveryDate,
          }).whenComplete(() {
            isUploaded = true;
          });
          if (isUploaded) {
            Firestore.instance
                .collection('orders')
                .document(doc.documentID)
                .updateData({'orderId': doc.documentID});
          }
        }
      });
      Firestore.instance
          .collection('users')
          .document(currentUser.userId)
          .collection('cart')
          .getDocuments()
          .then((snapshot) {
        for (DocumentSnapshot ds in snapshot.documents) {
          ds.reference.delete();
        }
      });
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) {
          return MyOrdersScreen();
        },
      ));
    } else if (!isPaymentSuccess) {
      SnackBar snackbar = SnackBar(
        content: Text(
          "Payment Unsuccessful. Please try another mode of payment",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      );
      _scaffoldKey.currentState.showSnackBar(snackbar);
    }
  }

  void setCartTotal(String totalAmount) async {
    await Firestore.instance
        .collection('users')
        .document(currentUser.userId)
        .updateData({
      'currentCartTotal': totalAmount,
    }).whenComplete(() {});
  }

  String getTotalAmount(List<Order> currentOrders) {
    double price = 0;
    currentOrders.forEach((order) {
      price += double.parse(order.amount);
    });

    return price.toString();
  }

  @override
  Widget build(BuildContext context) {
    List<Order> currentOrders = [];
    String totalAmount;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Cart"),
      ),
      body: gotUser
          ? StreamBuilder(
              stream: Firestore.instance
                  .collection('users')
                  .document(currentUser.userId)
                  .collection('cart')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (!gotUser) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.data.documents.length < 1) {
                  return Center(
                    child: EmptyCart(),
                  );
                }

                final docs = snapshot.data.documents;
                //cartLocation = docs['location'];
                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: docs.length,
                        itemBuilder: (context, index) {
                          if (docs[index]['type'] == "Services") {
                            Order order = Order(
                              orderId: "",
                              amount: docs[index]['amount'].toString(),
                              userId: docs[index]['customerId'],
                              imageUrl: docs[index]['imageURL'],
                              serviceName: docs[index]['name'],
                              quantity: docs[index]['quantity'].toString(),
                              serviceProviderId: docs[index]
                                  ['serviceProviderId'],
                              type: docs[index]['type'],
                              unit: docs[index]['unit'],
                              userName: currentUser.name,
                              address: "",
                              category: "",
                              serviceId: docs[index]["productId"],
                              timeStamp: "",
                              userNumber: "",
                              productId: "",
                              warehouseId: "",
                              email: currentUser.email,
                              latitude: "",
                              location: "",
                              longitude: "",
                              productName: "",
                              status: "PENDING",
                              deliveryDate: "",
                            );
                            currentOrders.add(order);
                          }
                          if (docs[index]['type'] == "Product") {
                            Order order = Order(
                              orderId: "",
                              amount: docs[index]['amount'].toString(),
                              userId: docs[index]['customerId'],
                              imageUrl: docs[index]['imageURL'],
                              productName: docs[index]['name'],
                              quantity: docs[index]['quantity'].toString(),
                              serviceProviderId: "",
                              type: docs[index]['type'],
                              unit: docs[index]['unit'],
                              userName: currentUser.name,
                              address: "",
                              category: "",
                              serviceId: "",
                              timeStamp: "",
                              userNumber: "",
                              productId: docs[index]["productId"],
                              warehouseId: "",
                              email: currentUser.email,
                              latitude: "",
                              location: "",
                              longitude: "",
                              serviceName: "",
                              status: "PENDING",
                              deliveryDate: DateTime.now()
                                  .add(Duration(days: 5))
                                  .toIso8601String()
                                  .substring(0, 10),
                            );
                            currentOrders.add(order);
                          }

                          print("number of orders====" +
                              currentOrders.length.toString());
                          CartItem cartItem =
                              CartItem.fromDocument(docs[index]);

                          totalAmount = getTotalAmount(currentOrders);
                          setCartTotal(totalAmount);
                          print("total amount = " + totalAmount);
                          return CartCard(
                            cartItem: cartItem,
                            userId: currentUser.userId,
                          );
                        },
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.1,
                      width: MediaQuery.of(context).size.width,
                      child: Card(
                        elevation: 4,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TotalPriceText(currentUser.userId),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.4,
                            ),
                            !isAddressSelected
                                ? GestureDetector(
                                    child: Container(
                                        margin: EdgeInsets.all(10),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.3,
                                        decoration: BoxDecoration(
                                            color: Colors.green,
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            "Select Address",
                                            style: GoogleFonts.manrope(
                                                color: Colors.white,
                                                fontSize: 16),
                                          ),
                                        )),
                                    onTap: () async {
                                      List d = await Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) {
                                          return SelectUserDetailsScreen();
                                        },
                                      ));

                                      setState(() {
                                        isAddressSelected = true;
                                      });
                                      print(d);
                                      details = List.from(d);
                                    },
                                  )
                                : GestureDetector(
                                    child: Container(
                                        margin: EdgeInsets.all(10),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.3,
                                        decoration: BoxDecoration(
                                            color: Colors.green,
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            "Checkout",
                                            style: GoogleFonts.manrope(
                                                color: Colors.white,
                                                fontSize: 16),
                                          ),
                                        )),
                                    onTap: () {
                                      print("Final Price======= " +
                                          getTotalAmount(currentOrders));
                                      finalAmount = double.parse(
                                          getTotalAmount(currentOrders));
                                      checkout(currentOrders, details);
                                    },
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
