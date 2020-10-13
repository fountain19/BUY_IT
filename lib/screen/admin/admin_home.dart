import 'package:flutter/material.dart';
import 'package:store_app/constans.dart';
import 'package:store_app/screen/admin/add_product.dart';
import 'package:store_app/screen/admin/mange_product.dart';
import 'package:store_app/screen/admin/order_screen.dart';



class AdminHome extends StatelessWidget {
  static String id='AdminHome';

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: KmainColor,
      body: Column(

        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(width:double.infinity),
          RaisedButton(
            onPressed: () {
              Navigator.pushNamed(context,AddProduct.id);
            },
          child: Text('Add Product'),),
          RaisedButton(
            onPressed: () {
              Navigator.pushNamed(context, MangeProduct.id);
            },
          child: Text('Edit Product'),),
          RaisedButton(
            onPressed: () {
              Navigator.pushNamed(context, OrderScreen.id);
            },
          child: Text('View Orders'),),
        ],
      ),
    );
  }
}
