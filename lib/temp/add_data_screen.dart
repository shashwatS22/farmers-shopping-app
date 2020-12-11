import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmket/screens/services/service_category_screen.dart';
import 'package:farmket/temp/add_image_type.dart';
import 'package:farmket/temp/temp_category_screen.dart';
import 'package:flutter/material.dart';

class AddDataScreen extends StatefulWidget {
  @override
  _AddDataScreenState createState() => _AddDataScreenState();
}

class _AddDataScreenState extends State<AddDataScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: StreamBuilder(
        stream: Firestore.instance.collection('services_list').snapshots(),
        
        builder: (context,productssnapshot){
          if(productssnapshot.connectionState==ConnectionState.waiting){
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          
  
          final productDocs=productssnapshot.data.documents;     
          
          return ListView.builder(
            itemCount: productssnapshot.data.documents.length,
            itemBuilder: (ctx,index){
              print("document id======="+productDocs[index].documentID.toString());
              return Card(
                elevation: 10,

                  child: ListTile(
                  
                  title: Text(productDocs[index]["type"]),
                  onTap: (){
                    
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return AddImageType(productDocs[index].documentID.toString());
                        },
                    ));
                  },
                ),
              );

            }
            );
        },
      ),
      
    );
  }
}