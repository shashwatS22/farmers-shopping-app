import 'package:cloud_firestore/cloud_firestore.dart';

class CartItem {
  String name;
  String customerId;
  String productId;
  int quantity;
  String unit;
  String price;
  int amount;
  String imageURL;
  String type;
  String cartItemId;
  String serviceProviderId;

  CartItem(
      {this.cartItemId,
      this.amount,
      this.customerId,
      this.imageURL,
      this.name,
      this.price,
      this.productId,
      this.quantity,
      this.type,
      this.unit,
      this.serviceProviderId});

  factory CartItem.fromDocument(DocumentSnapshot doc) {
    return CartItem(
      amount: doc['amount'],
      customerId: doc['customerId'],
      imageURL: doc['imageURL'],
      name: doc['name'],
      price: doc['price'],
      productId: doc['productId'],
      quantity: doc['quantity'],
      type: doc['type'],
      unit: doc['unit'],
      cartItemId: doc.documentID,
      serviceProviderId: doc['serviceProviderId'],
    );
  }
}
