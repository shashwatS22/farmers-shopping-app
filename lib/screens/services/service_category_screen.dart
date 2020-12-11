import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmket/models/service.dart';
import 'package:farmket/screens/services/select_service_provider_screen.dart';
import 'package:farmket/widgets/category/category_card.dart';
import 'package:flutter/material.dart';

class CategoryScreen extends StatefulWidget {
  final String id;
  CategoryScreen(this.id);
  @override
  _CategoryScreenState createState() => _CategoryScreenState();

}

class _CategoryScreenState extends State<CategoryScreen> {
  //final documentref=Firestore.instance.collection("services_list").document(widget.documentid).collection("services")
  
  @override
  Widget build(BuildContext context) {
    print("id==============="+widget.id);
    return Scaffold(
      appBar: AppBar(
        title: Text("Select a service "),
      ),
      body: StreamBuilder(
        stream: Firestore.instance.collection("services_list").document(widget.id).collection("services").snapshots(),
        builder: (context,snapshot){
          final docs=snapshot.data.documents;
          if(snapshot.connectionState==ConnectionState.waiting){
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return GridView.builder(
            padding: EdgeInsets.all(3),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,childAspectRatio: 1,crossAxisSpacing: 2,mainAxisSpacing: 2),
            itemCount: docs.length,
            itemBuilder: (ctx,index){
              Service currentService=Service.fromDocument(docs[index]);
              return CategoryCard(currentService);
            }
            );
        },
      ),
      
      
    );
  }
}