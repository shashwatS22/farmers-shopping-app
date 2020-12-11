import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyOrderCard extends StatelessWidget {
  final DocumentSnapshot doc;
  final String userId;
  MyOrderCard(this.doc, this.userId);
  @override
  Widget build(BuildContext context) {
    final _media = MediaQuery.of(context).size;
    return Container(
      key: ValueKey(doc['orderId']),
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
                          doc['type'] == "Services"
                              ? doc['serviceName']
                              : doc['productName'],
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
                      int.parse(doc['quantity']) > 1
                          ? Text(
                              "Quantity : ${doc['quantity']} ${doc['unit']}s",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14.0,
                              ),
                            )
                          : Text(
                              "Quantity : ${doc['quantity']} ${doc['unit']}",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14.0,
                              ),
                            ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        'Type : ${doc['type']}',
                        style: TextStyle(color: Colors.grey, fontSize: 14.0),
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
                                    '\u20B9 ${doc['amount']}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 23.0,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: Text(
                                      '\u20B9 ${int.parse(doc['amount']) + 0.2 * int.parse(doc['amount'])}',
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
                              if (doc['status'] == "PENDING")
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Text(
                                    "${doc['status']}",
                                    overflow: TextOverflow.fade,
                                    style: TextStyle(
                                      color: Colors.orange[400],
                                      fontSize: 20.0,
                                    ),
                                  ),
                                ),
                              if (doc['status'] == "CONFIRMED")
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Text(
                                    "${doc['status']}",
                                    overflow: TextOverflow.fade,
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 20.0,
                                    ),
                                  ),
                                ),
                              if (doc['status'] == "REJECTED")
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Text(
                                    "${doc['status']}",
                                    overflow: TextOverflow.fade,
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 20.0,
                                    ),
                                  ),
                                ),
                              if (doc['status'] == "COMPLETED")
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Text(
                                    "${doc['status']}",
                                    overflow: TextOverflow.fade,
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 20.0,
                                    ),
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
                                doc['imageURL'],
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
            Text(
              "Address : ${doc['address']}",
              overflow: TextOverflow.fade,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14.0,
              ),
            ),
            SizedBox(
              height: 5,
            ),
          ],
        ),
      ),
    );
  }
}
