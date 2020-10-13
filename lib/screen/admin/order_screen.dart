import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:store_app/constans.dart';
import 'package:store_app/models/order.dart';
import 'package:store_app/services/store.dart';

import 'order_detailes.dart';

class OrderScreen extends StatelessWidget {
  static String id = 'OrderScreen';
  final Store _store = Store();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _store.LoadOrders(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: Text('There is no orders'));
          } else {
            List<Order> Orders = [];
            for (var doc in snapshot.data.documents) {
              Orders.add(Order(
                documentId: doc.documentID,
                totallPrice: doc.data[KTotallPrice],
                address: doc.data[KAddress],
              ));
            }
            return ListView.builder(
              itemBuilder: (context, index) =>
              Padding(
                padding: const EdgeInsets.all(15),
                child: GestureDetector(
                  onTap: (){
                    Navigator.pushNamed(context, OrderDetailes.id,arguments: Orders[index].documentId);
                  },
                  child: Container(
                    color: KseconderyColor,
                    height: MediaQuery.of(context).size.height*.2,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Total Price = \$ ${Orders[index].totallPrice}',style: TextStyle(
                            fontSize: 16,fontWeight: FontWeight.bold
                          ),),
                          SizedBox(height: 10,),
                          Text('Address is ${Orders[index].address}',style: TextStyle(
                              fontSize: 16,fontWeight: FontWeight.bold),),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              itemCount: Orders.length,
            );
          }
        },
      ),
    );
  }
}
