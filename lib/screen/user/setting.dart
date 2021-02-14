import 'dart:io';
import 'dart:math';


import 'package:flutter/material.dart';

import 'package:store_app/screen/user/about_us.dart';
import 'package:store_app/screen/user/cart_screen.dart';

import 'package:store_app/screen/user/connect_with_us.dart';


import 'package:store_app/screen/user/favorite.dart';
import 'package:store_app/services/auth.dart';
import '../../constans.dart';
import 'login_screen.dart';


class Setting extends StatefulWidget {
  static String id='Setting';
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting>{
  final _auth = Auth();




  @override
  Widget build(BuildContext context) {
   // String _email=ModalRoute.of(context).settings.arguments;
   // String user=ModalRoute.of(context).settings.arguments;
    String email=ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Color(0xFF2c425e),
        title: Text('Setting',),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                    color: Color(0xFF2c425e)
                ),
                // currentAccountPicture: CircleAvatar(
                //   radius: 25,
                //   backgroundColor: Colors.white,
                //   backgroundImage:Buy.sharedPreferences.getString(KUrl)!=null?
                //   NetworkImage(
                //       Buy.sharedPreferences.getString(KUrl),):AssetImage('')
                // ),
                //
                // accountName:Buy.sharedPreferences.getString(KName)!=null? Text(
                //           Buy.sharedPreferences.getString(KName)):Text(''),
                //
                //       accountEmail: Buy.sharedPreferences.getString(KEmail)!=null?Text(
                //           Buy.sharedPreferences.getString(KEmail)):Text(''),
              ),
                 ListTile(
                    onTap: () {
                    Navigator.pushNamed(context, Favorite.id);
                },
                leading: CircleAvatar(
                  backgroundColor: Colors.blueGrey,
                  child: Icon(Icons.favorite),
                ),
                title: Text("Favorite"),
                ),
                Divider(
                color: Colors.black,),
                ListTile(
                onTap: () {
                 Navigator.pushNamed(context, CartScreen.id);
                },
                leading: CircleAvatar(
                backgroundColor: Colors.blueGrey,
                child: Icon(Icons.shopping_cart),
                ),
                title: Text("Cart screen"),
                ),
                Divider(color: Colors.black,
                ),
                ListTile(
                onTap: () {
              Navigator.pushNamed(context, AboutUs.id);
                },
                leading: CircleAvatar(
                backgroundColor: Colors.blueGrey,
                child: Icon(Icons.person),
                ),
                title: Text("About us"),
                ),
                  Divider(color: Colors.black,),
                ListTile(
                onTap: () {
                     Navigator.pushNamed(context, ConnectWithUs.id);
                },
                leading: CircleAvatar(
                backgroundColor: Colors.blueGrey,
                child: Icon(Icons.email),
                ),
                title: Text("Connect with us"),
                ),
                Divider(
                color: Colors.black,
                ),
              ListTile(
                onTap: ()async {
                  await _auth.signOut();
                  Navigator.popAndPushNamed(context, LoginScreen.id);
                },

                trailing: CircleAvatar(
                  backgroundColor: Colors.blueGrey,
                  child: Icon(Icons.exit_to_app),
                ),
                title: Text("Sign Out"),
              ),
            ],
          )
        ],
      ),
    );
  }




}
