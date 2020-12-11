import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmket/screens/orders/cart_screen.dart';
import 'package:farmket/screens/services/service_category_screen.dart';
import 'package:farmket/widgets/home/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';

class ServicesScreen extends StatefulWidget {
  @override
  _ServicesScreenState createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: Text(
          "Services",
          style: Theme.of(context).textTheme.title,
        ),
        backgroundColor: Colors.white,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => CartScreen(),
              ));
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: Firestore.instance.collection('services_list').snapshots(),
        builder: (context, servicesnapshot) {
          if (servicesnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final servicesDocs = servicesnapshot.data.documents;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(9.0),
                child: Text(
                  "Categories",
                  style: GoogleFonts.playfairDisplaySc(
                      fontSize: 32, letterSpacing: 4),
                ),
              ),
              Expanded(
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: servicesnapshot.data.documents.length,
                    itemBuilder: (ctx, index) {
                      print("document id=======" +
                          servicesDocs[index].documentID.toString());
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.all(1),
                            child: Card(
                              elevation: 3,
                              child: AspectRatio(
                                aspectRatio: 5 / 2.5,
                                child: InkWell(
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      Container(
                                        child: CachedNetworkImage(
                                          imageUrl: servicesDocs[index]
                                              ['imageURL'],
                                          progressIndicatorBuilder: (context,
                                                  url, downloadProgress) =>
                                              CircularProgressIndicator(
                                                  value: downloadProgress
                                                      .progress),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 10,
                                        left: 5,
                                        child: Text(
                                          servicesDocs[index]['type'],
                                          style: GoogleFonts.pangolin(
                                            color: Colors.white,
                                            fontSize: 25,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) {
                                        return CategoryScreen(
                                            servicesDocs[index]
                                                .documentID
                                                .toString());
                                      },
                                    ));
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
              ),
            ],
          );
        },
      ),
    );
  }
}
