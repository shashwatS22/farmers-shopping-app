import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmket/models/service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class SelectServiceProviderScreen extends StatefulWidget {
  final Service service;
  final String latitude;
  final String longitude;
  SelectServiceProviderScreen(this.service, this.latitude, this.longitude);
  @override
  _SelectServiceProviderScreenState createState() =>
      _SelectServiceProviderScreenState();
}

class _SelectServiceProviderScreenState
    extends State<SelectServiceProviderScreen> {
  double findDistance(double lat1, double long1, double lat2, double long2) {
    return distanceBetween(lat1, long1, lat2, long2);
  }

  @override
  Widget build(BuildContext context) {
    print("service provider page=============== " + widget.service.name);
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("Select Service Provider"),
      ),
      body: StreamBuilder(
        stream: Firestore.instance
            .collection("service_providers")
            .where("servicesIds", arrayContains: widget.service.id)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            print("snapshot data===== " + snapshot.data.documents.toString());
          }
          if (snapshot.data.documents.length <= 0) {
            return Center(
              child: Text("No Service Provider found try another address"),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (ctx, index) {
              var docs = snapshot.data.documents;
              print("distance ==" +
                  distanceBetween(
                          double.parse(widget.latitude),
                          double.parse(widget.longitude),
                          double.parse(docs[index]['latitude']),
                          double.parse(docs[index]['longitude']))
                      .toString());

              if (distanceBetween(
                          double.parse(widget.latitude),
                          double.parse(widget.longitude),
                          double.parse(docs[index]['latitude']),
                          double.parse(docs[index]['longitude'])) /
                      1000 >
                  double.parse(docs[index]['range'])) {
                return null;
              }
              print("snapshot data service name========== " +
                  snapshot.data.documents[index]['name']);
              return Container(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(docs[index]['userId']);
                  },
                  child: Card(
                    elevation: 6,
                    margin: EdgeInsets.all(6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                docs[index]['name'],
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(5),
                              height: 80,
                              width: 80,
                              child: CachedNetworkImage(
                                imageUrl: docs[index]['imageURL'],
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) =>
                                        CircularProgressIndicator(
                                            value: downloadProgress.progress),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                        Divider(),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Address : ",
                                style: TextStyle(color: Colors.grey),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                docs[index]['address'],
                                style: TextStyle(fontSize: 14),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        Divider(),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Email :",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                            Expanded(
                                child: Text(docs[index]['email'],
                                    style: TextStyle(fontSize: 14))),
                          ],
                        ),
                        Divider(),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Distance :",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                            Expanded(
                                child: Text(
                                    (distanceBetween(
                                                    double.parse(
                                                        widget.latitude),
                                                    double.parse(
                                                        widget.longitude),
                                                    double.parse(docs[index]
                                                        ['latitude']),
                                                    double.parse(docs[index]
                                                        ['longitude'])) /
                                                1000)
                                            .toString() +
                                        " km",
                                    style: TextStyle(fontSize: 14))),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
