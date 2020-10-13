import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const KmainColor =Color(0xffad3292);
const KseconderyColor =Color(0xffc5d1d7);
const KProductName='productName';
const KProductPrice='productPrice';
const KProductDescription='productDescription';
const KProductCategory='productCategory';
const KProductLocation='productLocation';
const  KProductImage='ProductImage';
const KProductsCollection='products';
const KUnActiveColor= Color(0xffc1bdb8);
const KTshirts='tshirts';
const KShoes='shoes';
const KTrousers='trousers';
const KJackets='jacket';
const Korders='orders';
const KorderDetails='orderDetails';
const KAddress='Address';
const KproductQuantity='Quantity';
const KTotallPrice='TotallPrice';
const KKeepMeLoggedIn='KeepMeLoggedIn';
const KAuthCollection='User info';
const KUid='Uid';
const KName='Name';
const KEmail='Email';
const KuserCartList='userCartList';
const KUrl='Url image';





// const String acctFullName = 'acctFullName';
// const String userEmail = 'userEmail';
// const String photoUrl = 'photoUrl';
// const String loggedIn = 'loggedIn';

const List<String> localCategory = [
  'Select a Category',
  'jacket',
  'trousers',
  'tshirts',
  'shoes',
];

class Buy {
  static FirebaseAuth auth;
  static FirebaseUser user;
  static Firestore firestore;
  static SharedPreferences sharedPreferences;

}

