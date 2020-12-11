import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmket/screens/services/service_category_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ServicesList extends StatefulWidget {
  @override
  _ServicesListState createState() => _ServicesListState();
}

class _ServicesListState extends State<ServicesList> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Container(
            child: Text("Service Categories",
                style: GoogleFonts.playfairDisplaySc(
                    fontSize: 32, letterSpacing: 1)),
          ),
          SizedBox(
            height: 3,
          ),
          StreamBuilder(
            stream: Firestore.instance.collection('services_list').snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              final servicesDocs = snapshot.data.documents;
              List<Widget> l = servicesDocs.map((doc) {
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
                              ),
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
                              return CategoryScreen(doc.documentID.toString());
                            },
                          ));
                        },
                      ),
                    ),
                  ),
                );
              }).toList();
              print(l);
              return Column(
                children: l,
              );
              // Container(
              //   height: MediaQuery.of(context).size.height*0.4,
              //   child: ListView.builder(
              //      physics: ClampingScrollPhysics(),
              //    shrinkWrap: true,
              //       itemCount: servicesDocs.length,
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
              //   child: Image.network(servicesDocs[index]['imageURL'],fit: BoxFit.cover,),
              // ),
              // Positioned(
              //   bottom: 10,
              //   left: 5,
              //   child: Text(servicesDocs[index]['type'],style:GoogleFonts.pangolin(color: Colors.white,fontSize:25, ),),
              // ),
              //           ],
              //         ),

              //         onTap: (){

              //           Navigator.of(context).push(
              // MaterialPageRoute(
              //   builder: (context) {
              //     return CategoryScreen(servicesDocs[index].documentID.toString());
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
