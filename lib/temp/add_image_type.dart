import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddImageType extends StatefulWidget {
  final String id;
  AddImageType(this.id);
  @override
  _AddImageTypeState createState() => _AddImageTypeState();
}

class _AddImageTypeState extends State<AddImageType> {
  File image;
  String imageURL;
   void pickImage()async{
      
                final picker = ImagePicker();
                final pickedImage = await picker.getImage(source: ImageSource.gallery,imageQuality: 100 );
                final pickedImageFile = File(pickedImage.path);
                
                  image=pickedImageFile;
                
                  
    }
  void submit()async{
    final ref= FirebaseStorage.instance.ref().child('category_images').child(widget.id+'.jpg');    
          StorageUploadTask uploadTask=ref.putFile(image);
          var dowurl = await (await uploadTask.onComplete).ref.getDownloadURL();
          final url = dowurl.toString();
          imageURL=url;
    Firestore.instance.collection('services_list').document(widget.id).updateData({
      'imageURL':imageURL,
    }).whenComplete(() => Navigator.of(context).pop());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RaisedButton(
              child: Text("Add Image"),
              onPressed: pickImage,          
              ),
              RaisedButton(
              child: Text("Submit"),
              onPressed: submit,          
              ),
              
          ]
        ),
        

      ),
      
    );
  }
}