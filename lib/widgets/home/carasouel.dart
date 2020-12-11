import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';

class Carasouel extends StatefulWidget {
  @override
  _CarasouelState createState() => _CarasouelState();
}

class _CarasouelState extends State<Carasouel> {
  @override
  Widget build(BuildContext context) {
    return Card(
            
             child: Container(
               padding: EdgeInsets.all(2),
              height: MediaQuery.of(context).size.height*0.25, 
              width: MediaQuery.of(context).size.width*0.99,          
              child: Carousel(
                borderRadius: true,
        boxFit: BoxFit.cover,
        images: [
              AssetImage('lib/assets/images/pic1.jpg'),
              AssetImage('lib/assets/images/pic2.jpg'),
              AssetImage('lib/assets/images/pic3.jpg'),
              AssetImage('lib/assets/images/pic4.jpg'),
        ],
        autoplay: true,
        indicatorBgPadding: 1.0,
        dotSize: 4.0,

      ),
            
          ),
                       );
      
      
    
  }
}