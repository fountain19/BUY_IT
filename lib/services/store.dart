

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:store_app/constans.dart';
import 'package:store_app/models/product.dart';
 class Store {
   List<File> imageList;
   List<String> imagesUrl = List();

   final Firestore _firestore = Firestore.instance;

   addProduct(Product product) {
     FirebaseAuth.instance.currentUser().then((user) {
       _firestore.collection(KProductsCollection).document(user.uid).setData({
         KProductName: product.pName,
         KProductPrice: product.pPrice,
//      KProductLocation:product.pLocation,
         KProductCategory: product.pCategory,
         KProductDescription: product.pDescription
       });
     });
   }

   Stream<QuerySnapshot> LoadProducts() {
     return _firestore.collection(KProductsCollection).snapshots();
   }

   Stream<QuerySnapshot> LoadOrders() {
     return _firestore.collection(Korders).snapshots();
   }

   Stream<QuerySnapshot> LoadOrderDetailes(documentId) {
     return _firestore.collection(Korders).document(documentId).collection(
         KorderDetails).snapshots();
   }

   deleteProduct(documentId,image)async{
     _firestore.collection(KProductsCollection).document(documentId).delete();
      StorageReference storageReference=await FirebaseStorage.instance.getReferenceFromUrl(image);
     await storageReference.delete();

   }

   editProduct(data, documentId) {
     _firestore.collection(KProductsCollection).document(documentId).updateData(
         data);
   }

   storeOrders(data, List<Product> products) {
     FirebaseAuth.instance.currentUser().then((user) {
       var documentRef = _firestore.collection(Korders).document(user.uid);
       documentRef.setData(data);
       for (var product in products) {
         documentRef.collection(KorderDetails).document().setData(
             {
               KProductName: product.pName,
               KProductPrice: product.pPrice,
               KproductQuantity: product.pQuantity,
               KProductLocation: product.pLocation,
               KProductCategory: product.pCategory,
             }
         );
       }
     });
   }

   Future<List<String>> uploadProductImages(
       {List<File> imageList, String docID}) async {

     try {
       for (int s = 0; s < imageList.length; s++) {

         StorageReference storageReference = FirebaseStorage.instance.ref().child(KProductsCollection)
             .child(docID)
             .child(docID + '$s.jpg');
         StorageUploadTask uploadTask = storageReference.putFile(
             (imageList[s]));
         StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
         String downloadUrl = await taskSnapshot.ref.getDownloadURL();

         imagesUrl.add(downloadUrl.toString());
       }
     } on PlatformException catch (e) {
       print(e.details);
     }
     return imagesUrl;
   }

   Future<String> addNewProduct({Map newProduct}) async {
     String documentID;
     await _firestore.collection(KProductsCollection).add(newProduct).then((
         documentRef) => documentID = documentRef.documentID);
     return documentID;
   }

   Future<bool> updateProductImages({String docID, List<String> data}) async {
     bool msg;
     await _firestore.collection(KProductsCollection)
         .document(docID)
         .updateData(
         {KProductImage: data})
         .whenComplete(() => msg = true);
     return msg;
   }


   }

