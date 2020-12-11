import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmket/screens/products/product_category_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductsList extends StatefulWidget {
  @override
  _ProductsListState createState() => _ProductsListState();
}

class _ProductsListState extends State<ProductsList> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Container(
            child: Text("Product Categories",
                style: GoogleFonts.playfairDisplaySc(
                    fontSize: 32, letterSpacing: 1)),
          ),
          SizedBox(
            height: 3,
          ),
          StreamBuilder(
            stream: Firestore.instance.collection('products_list').snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              final productsDocs = snapshot.data.documents;
              List<Widget> l = productsDocs.map((doc) {
                return Container(
                  margin: EdgeInsets.all(2),
                  child: Card(
                    elevation: 3,
                    child: AspectRatio(
                      aspectRatio: 5 / 1.5,
                      child: InkWell(
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Container(
                                child: CachedNetworkImage(
                              imageUrl: doc['imageURL'],
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) =>
                                      CircularProgressIndicator(
                                          value: downloadProgress.progress),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                              fit: BoxFit.cover,
                            ) //Image.network(doc['imageURL'],fit: BoxFit.cover,),
                                ),
                            Positioned(
                              bottom: 10,
                              left: 5,
                              child: Text(
                                doc['type'],
                                style: GoogleFonts.pangolin(
                                  color: Colors.white,
                                  fontSize: 25,
                                ),
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) {
                              return ProductCategoryScreen(
                                  doc.documentID.toString());
                            },
                          ));
                        },
                      ),
                    ),
                  ),
                );
              }).toList();
              return Column(
                children: l,
              );
              // Container(
              //   height: MediaQuery.of(context).size.height*0.4,
              //   child: ListView.builder(
              //    physics: ClampingScrollPhysics(),
              //    shrinkWrap: true,
              //       itemCount: productsDocs.length,
              //       itemBuilder: (context, index) {
              //       return Container(

              //         margin: EdgeInsets.all(2),
              //         child: Card(
              //           elevation: 3,
              //       child: AspectRatio(
              //         aspectRatio: 5/2.05,
              //         child: InkWell(

              //         child: Stack(
              //           fit: StackFit.expand,
              //           children: [
              // Container(
              //   child: Image.network(productsDocs[index]['imageURL'],fit: BoxFit.cover,),
              // ),
              // Positioned(
              //   bottom: 10,
              //   left: 5,
              //   child: Text(productsDocs[index]['type'],style:GoogleFonts.pangolin(color: Colors.white,fontSize:25, ),),
              // ),
              //           ],
              //         ),

              //         onTap: (){

              //           Navigator.of(context).push(
              // MaterialPageRoute(
              //   builder: (context) {
              //     return ProductCategoryScreen(productsDocs[index].documentID.toString());
              //   },
              //           ));
              //         },
              //           ),
              //       ),
              //         ),
              //       );
              //       },

              //       ),
              // );
            },
          ),
        ],
      ),
    );
  }
}
