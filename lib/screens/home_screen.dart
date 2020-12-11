import 'package:carousel_pro/carousel_pro.dart';
import 'package:farmket/screens/orders/cart_screen.dart';
import 'package:farmket/widgets/home/carasouel.dart';
import 'package:farmket/widgets/home/drawer.dart';
import 'package:farmket/widgets/home/products_list.dart';
import 'package:farmket/widgets/home/services_list.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text(
          "Farmket",
          style:Theme.of(context).textTheme.title,
        
        ),
        backgroundColor: Colors.white,        
      
      actions: <Widget>[
        IconButton(icon: Icon(Icons.shopping_cart),onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => CartScreen(),));
        },),
        ],
      ),
      
      body: ListView(
        physics: ClampingScrollPhysics(),
        
        children: <Widget>[
          Carasouel(),
          ProductsList(),
          ServicesList(),
        ],
      ),
      
    );
  }
}