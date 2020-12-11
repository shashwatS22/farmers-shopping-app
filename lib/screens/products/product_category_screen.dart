import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmket/models/product.dart';
import 'package:farmket/widgets/category/product_category_card.dart';
import 'package:flutter/material.dart';

class ProductCategoryScreen extends StatefulWidget {
  final String id;
  ProductCategoryScreen(this.id);
  @override
  _ProductCategoryScreenState createState() => _ProductCategoryScreenState();
}

class _ProductCategoryScreenState extends State<ProductCategoryScreen> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select a product "),
      ),
      body: StreamBuilder(
        stream: Firestore.instance
            .collection("products_list")
            .document(widget.id)
            .collection("products")
            .snapshots(),
        builder: (context, snapshot) {
          final docs = snapshot.data.documents;
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return GridView.builder(
              padding: EdgeInsets.all(3),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1,
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 2),
              itemCount: docs.length,
              itemBuilder: (ctx, index) {
                Product currentProduct = Product.fromDocument(docs[index]);
                return ProductCategoryCard(currentProduct);
              });
        },
      ),
    );
  }
}
