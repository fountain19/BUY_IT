import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:store_app/constans.dart';
import 'package:store_app/models/order.dart';
import 'package:store_app/models/product.dart';
import 'package:store_app/services/store.dart';
class OrderDetailes extends StatelessWidget {
  static String id='OrderDetailes';
  Store store=Store();
  @override
  Widget build(BuildContext context) {
     String documenId=ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body:StreamBuilder<QuerySnapshot>(
      stream: store.LoadOrderDetailes(documenId),
      // ignore: missing_return
      builder: (context,snapshot){
        if(snapshot.hasData)
          {
            List<Product> products=[];
            for(var doc in snapshot.data.documents)
              {
                products.add(Product(
                  pName: doc.data[KProductName],
                  pQuantity: doc.data[KproductQuantity],
                  pCategory: doc.data[KProductCategory]
                ));
                return Column(
                  children: <Widget>[
                    Expanded(
                      child: ListView.builder(
                        itemBuilder:(context,index)=> Padding(
                          padding: const EdgeInsets.all(20),
                          child: Container(
                            color: KseconderyColor,
                            height: MediaQuery.of(context).size.height*.2,
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text('Product Name : ${products[index].pName}}',style: TextStyle(
                                      fontSize: 16,fontWeight: FontWeight.bold
                                  ),),
                                  SizedBox(height: 10,),
                                  Text('Quantity : ${products[index].pQuantity}',style: TextStyle(
                                      fontSize: 16,fontWeight: FontWeight.bold),),
                                  SizedBox(height: 10,),
                                  Text('Product Category : ${products[index].pCategory}',style: TextStyle(
                                      fontSize: 16,fontWeight: FontWeight.bold),),
                                ],
                              ),
                            ),
                          ),
                        ),
                        itemCount:products.length ,
                      ),
                    ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                        Expanded(
                          child: ButtonTheme(
                            buttonColor: KmainColor,
                            child: RaisedButton(
                              onPressed: (){},
                              child: Text('Confirm order',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                            ),
                          ),
                        ),
                        SizedBox(width: 10,),
                        Expanded(
                          child: ButtonTheme(
                            buttonColor: KmainColor,
                            child: RaisedButton(
                              onPressed: (){},
                              child: Text('Delete order',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                            ),
                          ),
                        ),
                    ],),
                      ),
                  ],
                );
              }
          }
        else{
          return Text('Loading Order details');
        }
      },
      ),
    );
  }
}
