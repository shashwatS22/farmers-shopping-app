import 'package:cached_network_image/cached_network_image.dart';
import 'package:farmket/models/service.dart';
import 'package:farmket/screens/services/select_service_provider_screen.dart';
import 'package:farmket/screens/services/service_detail_screen.dart';

import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final Service service;
  CategoryCard(this.service);
  void onTap(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) {
        print("ontap");
        return ServiceDetailScreen(service);
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 5.0, bottom: 5.0, left: 5.0, right: 5.0),
      child: InkWell(
        onTap: () {
          onTap(context);
        },
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 3.0,
                    blurRadius: 5.0)
              ],
              color: Colors.white),
          child: Column(
            children: <Widget>[
              Expanded(
                child: Card(
                  elevation: 0,
                  child: CachedNetworkImage(
                    imageUrl: service.imageURL,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) =>
                            CircularProgressIndicator(
                                value: downloadProgress.progress),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(height: 2.0),
              Text("\u20B9 ${service.price} /${service.unit}",
                  style: TextStyle(color: Colors.lightGreen, fontSize: 17.0)),
              SizedBox(height: 7.0),
              Text(service.name,
                  style: TextStyle(color: Color(0xFF575E67), fontSize: 18.0)),
              Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Container(color: Color(0xFFEBEBEB), height: 1.0)),
              Padding(
                  padding: EdgeInsets.only(left: 5.0, right: 5.0, bottom: 10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(Icons.shopping_basket,
                            color: Colors.green, size: 20.0),
                        Text('Select Service Provider',
                            style: TextStyle(
                                fontFamily: 'Varela',
                                color: Colors.green,
                                fontSize: 14.0))
                      ]))
            ],
          ),
        ),
      ),
    );
  }
}
