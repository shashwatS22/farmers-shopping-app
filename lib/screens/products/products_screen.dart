import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmket/screens/orders/cart_screen.dart';
import 'package:farmket/screens/products/product_category_screen.dart';
import 'package:farmket/screens/services/service_category_screen.dart';
import 'package:farmket/widgets/home/drawer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductsScreen extends StatefulWidget {
  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: Text(
          "Products",
          style: Theme.of(context).textTheme.title,
        ),
        backgroundColor: Colors.white,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => CartScreen(),
              ));
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: Firestore.instance.collection('products_list').snapshots(),
        builder: (context, productsnapshot) {
          if (productsnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final productsDocs = productsnapshot.data.documents;

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
                    itemCount: productsnapshot.data.documents.length,
                    itemBuilder: (ctx, index) {
                      print("document id=======" +
                          productsDocs[index].documentID.toString());
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
                                          imageUrl: productsDocs[index]
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
                                          productsDocs[index]['type'],
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
                                        return ProductCategoryScreen(
                                            productsDocs[index]
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
