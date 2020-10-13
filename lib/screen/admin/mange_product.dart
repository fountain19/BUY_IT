import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:store_app/models/product.dart';
import 'package:store_app/services/store.dart';
import 'package:store_app/widgets/costum_menu.dart';

import '../../constans.dart';
import 'edit_product.dart';


class MangeProduct extends StatefulWidget {
  static String id='MangeProduct';

  @override
  _MangeProductState createState() => _MangeProductState();
}

class _MangeProductState extends State<MangeProduct> {
  final _store=Store();
  Firestore firestore = Firestore.instance;

  @override
  Widget build(BuildContext context,) {

    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
          stream : _store.LoadProducts(),

        builder:(context,snapshot,) {
          if(snapshot.hasData){

            List<Product> products=[];
            for (var doc in snapshot.data.documents) {

              var data = doc.data;
              products.add(Product(
                pId:doc.documentID,
                  pName: data[KProductName],
                  pPrice: data[KProductPrice],
                  pDescription: data[KProductDescription],
                  pCategory: data[KProductCategory],
                  // pLocation: data[KProductImage]
                pImage: data[KProductImage]
              ));
            }
            return  GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,
              childAspectRatio: 0.8),

              itemCount: products.length,
              itemBuilder: (context, index) =>
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10.0),
                   child: GestureDetector(
                     onTapUp: (details){
                       double dx=details.globalPosition.dx;
                       double dy=details.globalPosition.dy;
                       double dx1=MediaQuery.of(context).size.width-dx;
                       double dy1=MediaQuery.of(context).size.width-dy;
                       showMenu(context: context,
                           position: RelativeRect.fromLTRB(dx,dy,dx1, dy1),
                           items:[
                             MyPopupMenuItem(
                               child: Text('Edit'),
                               onClick:()async{
                                 Navigator.pushNamed(context, EditProduct.id,arguments: products[index]);
                               },
                             ),
                            MyPopupMenuItem(
                              onClick: ()async{
                                _store.deleteProduct(products[index].pId,products[index].pImage[0]);

                                Navigator.pop(context);
                              },
                              child: Text('Delete'),),
                           ]);
                     },
                     child: Stack(
                  children: <Widget>[
                      Positioned.fill(
                        child: Image(
                          fit: BoxFit.fill,
                          // image: AssetImage(products[index].pLocation[index]),
                            image: NetworkImage(products[index].pImage[0])
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        child: Opacity(
                          opacity: 0.6,
                          child: Container(
                            height: 60.0,
                            color: Colors.grey,
                            width: MediaQuery.of(context).size.width,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(products[index].pName,style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),),
                                  Text('\$ ${products[index].pPrice}'),

                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                   ),

              ) ,

            );
          }
       else{
         return Center(child: Text('Loading......'));
          }
        }
      ),
    );
  }
}
