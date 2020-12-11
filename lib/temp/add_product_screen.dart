import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
class AddProductScreen extends StatefulWidget {
  final String id;
  AddProductScreen(this.id);
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  
  

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
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
  File image;
    void pickImage()async{
      
                final picker = ImagePicker();
                final pickedImage = await picker.getImage(source: ImageSource.gallery,imageQuality: 100  );
                final pickedImageFile = File(pickedImage.path);
                
                  image=pickedImageFile;
                
                  
    }
    void submit()async{
      
      final form=_formKey.currentState;
      if(form.validate()){
        form.save();
        
        

        Firestore.instance.collection('products_list').document(widget.id).collection('products').add({
          'name':name,                   
          'minimumOrder':minimumOrder,
          'price':price,
          'type':type,
          'unit':unit,
          'description':description,
          'category':category,
          'quantity':quantity,
          'id':'',
          'imageURL':'',
          }).then((doc) async{
          final ref= FirebaseStorage.instance.ref().child('products').child(doc.documentID+'.png');    
          StorageUploadTask uploadTask=ref.putFile(image);
          var dowurl = await (await uploadTask.onComplete).ref.getDownloadURL();
          final url = dowurl.toString();
          imageURL=url;
          Firestore.instance.collection('products_list').document(widget.id).collection('products').document(doc.documentID).updateData({
            'id':doc.documentID,
            'imageURL':imageURL, 
          });
          
          }
          ).whenComplete((){             
            return Navigator.of(context).pop();
            });

      }
    }
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Add details"),        
      ),
      body:SingleChildScrollView(
              child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Form(
              key: _formKey,
              autovalidate: true,

              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16,16,16,0),                
                   
                    child: Center(
                      child: Text(
                        "Name",
                        style: TextStyle(fontSize: 25.0),
                      ),
                    ),
                  ),
                  Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            validator: (val) {
                              if (val.trim().isEmpty ) {
                                return "Name cannot be empty";
                              } else {
                                return null;
                              }
                            },
                            onSaved: (val) => name = val,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Enter Name",
                              labelStyle: TextStyle(fontSize: 15.0),
                              
                            ),
                          ),
                        ),
                        Padding(
                    padding: const EdgeInsets.fromLTRB(16,16,16,0),                
                   
                    child: Center(
                      child: Text(
                        "Quantity",
                        style: TextStyle(fontSize: 25.0),
                      ),
                    ),
                  ),
                  Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            validator: (val) {
                              if (val.trim().isEmpty ) {
                                return "Quantity cannot be empty";
                              } else {
                                return null;
                              }
                            },
                            onSaved: (val) => quantity = val,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Enter Quantity",
                              labelStyle: TextStyle(fontSize: 15.0),
                              
                            ),
                          ),
                        ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16,16,16,0),                
                   
                    child: Center(
                      child: Text(
                        "Price",
                        style: TextStyle(fontSize: 25.0),
                      ),
                    ),
                  ),
                  Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: TextFormField(
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            validator: (val) {
                              if (val.trim().isEmpty ) {
                                return "Price cannot be empty";
                              } else {
                                return null;
                              }
                            },
                            onSaved: (val) => price = val,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Enter Price",
                              labelStyle: TextStyle(fontSize: 15.0),
                              
                            ),
                          ),
                        ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16,16,16,0),                
                   
                    child: Center(
                      child: Text(
                        "Unit",
                        style: TextStyle(fontSize: 25.0),
                      ),
                    ),
                  ),
                  Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: TextFormField(
                            keyboardType: TextInputType.multiline,
                            validator: (val) {
                              if (val.trim().isEmpty ) {
                                return "Unit be empty";
                              } else {
                                return null;
                              }
                            },
                            onSaved: (val) => unit = val,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Enter Unit",
                              labelStyle: TextStyle(fontSize: 15.0),
                              
                            ),
                          ),
                        ),
                        Padding(
                    padding: const EdgeInsets.fromLTRB(16,16,16,0),                
                   
                    child: Center(
                      child: Text(
                        "Minimum Order",
                        style: TextStyle(fontSize: 25.0),
                      ),
                    ),
                  ),
                  Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            validator: (val) {
                              if (val.trim().isEmpty ) {
                                return "Minimum Order cannot be empty";
                              } else {
                                return null;
                              }
                            },
                            onSaved: (val) => minimumOrder = val,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Enter Minimum Order",
                              labelStyle: TextStyle(fontSize: 15.0),
                              
                            ),
                          ),
                        ),
                        Padding(
                    padding: const EdgeInsets.fromLTRB(16,16,16,0),                
                   
                    child: Center(
                      child: Text(
                        "Type",
                        style: TextStyle(fontSize: 25.0),
                      ),
                    ),
                  ),
                  Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            validator: (val) {
                              if (val.trim().isEmpty ) {
                                return "Type cannot be empty";
                              } else {
                                return null;
                              }
                            },
                            onSaved: (val) => type = val,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Enter Type",
                              labelStyle: TextStyle(fontSize: 15.0),
                              
                            ),
                          ),
                        ),
                        Padding(
                    padding: const EdgeInsets.fromLTRB(16,16,16,0),                
                   
                    child: Center(
                      child: Text(
                        "Category",
                        style: TextStyle(fontSize: 25.0),
                      ),
                    ),
                  ),
                  Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            validator: (val) {
                              if (val.trim().isEmpty ) {
                                return "Category cannot be empty";
                              } else {
                                return null;
                              }
                            },
                            onSaved: (val) => category = val,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Enter Address",
                              labelStyle: TextStyle(fontSize: 15.0),
                              
                            ),
                          ),
                        ),
                        Padding(
                    padding: const EdgeInsets.fromLTRB(16,16,16,0),                
                   
                    child: Center(
                      child: Text(
                        "Description",
                        style: TextStyle(fontSize: 25.0),
                      ),
                    ),
                  ),
                  Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            validator: (val) {
                              if (val.trim().isEmpty ) {
                                return "Description cannot be empty";
                              } else {
                                return null;
                              }
                            },
                            onSaved: (val) => description = val,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Enter Address",
                              labelStyle: TextStyle(fontSize: 15.0),
                              
                            ),
                          ),
                        ),
                      SizedBox(height: 20,),
                      RaisedButton(
                        child: Text("Submit"),
                        onPressed: submit,
                      ),
                      SizedBox(height: 20),
                      RaisedButton(
                        child: Text("Add image"),
                        onPressed: pickImage,
                      ),
                        
                ],
              ),

            ),
          ],
          
        ),
      ), 
    );
  }
}