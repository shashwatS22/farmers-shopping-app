import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:farmket/screens/orders/cart_screen.dart';
import 'package:farmket/widgets/home/drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'services/services_screen.dart';
import 'products/products_screen.dart';
import './home_screen.dart';
import '../screens/profile/profile_screen.dart';

class PagesScreen extends StatefulWidget {
  @override
  _PagesScreenState createState() => _PagesScreenState();
}

class _PagesScreenState extends State<PagesScreen> {
  int bottomSelectedIndex = 0;
  List<BottomNavyBarItem> buildNavigationBarItems() {
    return [
      BottomNavyBarItem(
          icon: Icon(Icons.home),
          title: Text(
            "Home",
          ),
          activeColor: Colors.green,
          inactiveColor: Colors.black),
      BottomNavyBarItem(
          icon: Icon(Icons.shopping_cart),
          title: Text("Products"),
          activeColor: Colors.green,
          inactiveColor: Colors.black),
      BottomNavyBarItem(
          icon: Icon(Icons.room_service),
          title: Text("Services"),
          activeColor: Colors.green,
          inactiveColor: Colors.black),
      BottomNavyBarItem(
          icon: Icon(Icons.account_circle),
          title: Text("My Profile"),
          activeColor: Colors.green,
          inactiveColor: Colors.black),
    ];
  }

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );
  Widget buildPageView() {
    return PageView(
      controller: pageController,
      onPageChanged: (index) {
        pageChanged(index);
      },
      children: <Widget>[
        HomeScreen(),
        ProductsScreen(),
        ServicesScreen(),
        ProfileScreen(),
      ],
    );
  }

  void pageChanged(int index) {
    setState(() {
      bottomSelectedIndex = index;
    });
  }

  void bottomTapped(int index) {
    setState(() {
      bottomSelectedIndex = index;
      pageController.animateToPage(
        index,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildPageView(),
      bottomNavigationBar: BottomNavyBar(
        backgroundColor: Colors.white,
        selectedIndex: bottomSelectedIndex,
        onItemSelected: (index) {
          bottomTapped(index);
        },
        items: buildNavigationBarItems(),
      ),
    );
  }
}
