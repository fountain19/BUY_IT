import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:store_app/provider/modalhud.dart';


class ConnectWithUs extends StatefulWidget {
  static String id='ConnectWithUs';
  @override
  _ConnectWithUsState createState() => _ConnectWithUsState();
}

class _ConnectWithUsState extends State<ConnectWithUs> {
  TextEditingController userEmail=TextEditingController();
  TextEditingController userMessage=TextEditingController();
  final scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.grey[900]
        ),
        elevation: 0.0,
        backgroundColor: Colors.blueGrey,
        title: Text('Connect with us',style: TextStyle(
          color: Colors.black
        ),),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                SizedBox(height: 50,),
                      Center(child: Text('We always like hearing from you',
                        style:TextStyle(fontSize: 20,fontWeight: FontWeight.bold) ,)),
                SizedBox(height: 50,),
                TextField(
                  controller: userEmail,
                   cursorColor: Colors.black,
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ) ,
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueGrey),
                    ) ,
                    hintText: 'Enter you email',
                    icon: Icon(Icons.email,color: Colors.black,),


                      ),
                    ),



                SizedBox(height: 20,),
                Container(
                  margin: EdgeInsets.all(12),

                  child: TextField(
                    controller: userMessage,
                     cursorColor: Colors.black,
                    maxLines: 5,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      border: OutlineInputBorder(),
                      labelText: 'Enter your message',labelStyle: TextStyle(
                        color: Colors.black
                    ),

                  ),
                ),),
                SizedBox(height: 20,),
                    Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 100,),
                    child: Builder(
                    builder: (context) => FlatButton(
                      child: Text('Send a message',style: TextStyle(
                        color: Colors.white
                      ),),
                      color: Colors.pink,
                      onPressed: (){
                        final modelHud = Provider.of<ModalHud>(context, listen: false);
                        modelHud.changeisLoading(true);

                        if(userEmail.text==''){
                          showSnackBar('Email can\t be empty', scaffoldKey);
                          modelHud.changeisLoading(false);
                          return;
                        }
                        if(userMessage.text==''){
                          showSnackBar('The message can\'t be empty', scaffoldKey);
                          modelHud.changeisLoading(false);
                          return;
                        }

                       Firestore.instance.collection('User Message').document().setData({
                         'email':userEmail.text,
                         'message':userMessage.text,
                           });
                        modelHud.changeisLoading(false);
                       showSnackBar('Product added successfully', scaffoldKey);

                      },
                    shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    ),
                    ),
                    ),
                    ),
                 ],

            ),
          ],
        ),
      ),
    );
  }
  showSnackBar(String message, final scaffoldKey) {
    scaffoldKey.currentState.showSnackBar(SnackBar(
      backgroundColor: Colors.red,
      content: Text(message),
    ));
  }
}
