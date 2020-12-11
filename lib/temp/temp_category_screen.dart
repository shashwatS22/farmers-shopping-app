import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmket/models/product.dart';
import 'package:farmket/models/service.dart';
import 'package:farmket/temp/add_product_screen.dart';
import 'package:farmket/temp/edit_service_screen.dart';
import 'package:flutter/material.dart';

class CategoryScreenTemp extends StatefulWidget {
  final String id;
  CategoryScreenTemp(this.id);
  @override
  _CategoryScreenTempState createState() => _CategoryScreenTempState();
}

class _CategoryScreenTempState extends State<CategoryScreenTemp> {
 @override

  Widget build(BuildContext context) {
    final categoryId=widget.id;
    void addProduct(){
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddProductScreen(categoryId),));
    }
    
    print("id==============="+widget.id);
    return Scaffold(
      appBar: AppBar(
        title: Text("Select a product "),
        actions: <Widget>[FlatButton(child: Text("Add product"),onPressed: addProduct,)],
      ),
      body: StreamBuilder(
        stream: Firestore.instance.collection("products_list").document(widget.id).collection("products").snapshots(),
        builder: (context,snapshot){
          final docs=snapshot.data.documents;
          if(snapshot.connectionState==ConnectionState.waiting){
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if(!snapshot.hasData){
            return Center(child: Text("Add Data"),);
          }
          return GridView.builder(
            padding: EdgeInsets.all(10),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,childAspectRatio: 1,crossAxisSpacing: 5,mainAxisSpacing: 5),
            itemCount: docs.length,
            itemBuilder: (ctx,index){
              Product currentProduct=Product.fromDocument(docs[index]);
              return Card(
                elevation: 20,
                  child: GestureDetector(
                    
                                      
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        
                        Text(currentProduct.name),
                      ],
                    )
                    ),
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) {
                        print("ontap");
                        return EditServiceScreen(currentProduct,categoryId);
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