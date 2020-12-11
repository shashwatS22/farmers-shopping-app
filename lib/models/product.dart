import 'package:cloud_firestore/cloud_firestore.dart';


class Product{
  String name;
  String imageURL;
  String price;
  String unit;
  String minimumOrder;
  String type;
  String id;
  String category;
  String description;
  String quantity;
  
  
  Product({
    this.name,
    this.category,
    this.description,
    this.id,
    this.imageURL,
    this.minimumOrder,
    this.price,
    this.type,
    this.unit,
    this.quantity,
    
  });

  factory Product.fromDocument(DocumentSnapshot doc){
    return Product(
      name: doc['name'],
      id: doc.documentID,
      category: doc['category'],
      description: doc['description'],
      imageURL: doc['imageURL'],
      minimumOrder: doc['minimumOrder'],
      price: doc['price'],
      type: doc['type'],
      unit: doc['unit'],      
      quantity: doc['quantity'],
    );
  }
}