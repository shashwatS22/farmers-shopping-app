import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmket/models/cart_item.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CartCard extends StatefulWidget {
  final CartItem cartItem;
  final String userId;

  CartCard({this.cartItem, this.userId});
  @override
  _CartCardState createState() => _CartCardState();
}

class _CartCardState extends State<CartCard> {
  @override
  Widget build(BuildContext context) {
    final _media = MediaQuery.of(context).size;
    return Container(
      child: Card(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.only(left: 10.0, top: 10.0, bottom: 5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: _media.height * 0.2,
                        child: Text(
                          widget.cartItem.name.toString(),
                          maxLines: 2,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      widget.cartItem.quantity > 1
                          ? Text(
                              "Quantity : ${widget.cartItem.quantity.toString()} ${widget.cartItem.unit}s",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14.0,
                              ),
                            )
                          : Text(
                              "Quantity : ${widget.cartItem.quantity.toString()} ${widget.cartItem.unit}",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14.0,
                              ),
                            ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            'Seller: Farmket',
                            style:
                                TextStyle(color: Colors.grey, fontSize: 14.0),
                          ),
                          Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 15.0,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    '\u20B9 ${widget.cartItem.amount}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 23.0,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: Text(
                                      '\u20B9 ${widget.cartItem.amount + 0.2 * widget.cartItem.amount}',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          decoration:
                                              TextDecoration.lineThrough),
                                    ),
                                  ),
                                  SizedBox(width: 5.0),
                                  Text(
                                    "20 " + '%off',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Text(
                                  "Expected delivery by ${DateTime.now().add(Duration(days: 5)).toIso8601String().substring(0, 10)}",
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, right: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        color: Colors.white,
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: _media.width * 0.2,
                              height: _media.height * 0.16,
                              child: Image.network(
                                widget.cartItem.imageURL,
                                fit: BoxFit.cover,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  child: Container(
                    height: _media.height * 0.08,
                    width: _media.width * 0.979,
                    child: Card(
                      elevation: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.delete,
                            size: 25.0,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text('Remove',
                              style: GoogleFonts.roboto(
                                  fontSize: 18, color: Colors.grey[600])),
                        ],
                      ),
                    ),
                  ),
                  onTap: () async {
                    var doc = await Firestore.instance
                        .collection('users')
                        .document(widget.userId)
                        .get();

                    await Firestore.instance
                        .collection('users')
                        .document(widget.userId)
                        .collection('cart')
                        .document(widget.cartItem.cartItemId)
                        .delete()
                        .whenComplete(() async {
                      await Firestore.instance
                          .collection('users')
                          .document(widget.userId)
                          .updateData({
                        'currentCartTotal':
                            (double.parse(doc['currentCartTotal']) -
                                    widget.cartItem.amount)
                                .toString(),
                      }).whenComplete(() {});
                    });
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
