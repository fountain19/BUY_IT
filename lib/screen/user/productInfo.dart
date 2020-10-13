

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/constans.dart';
import 'package:store_app/models/product.dart';
import 'package:store_app/provider/cartItem.dart';


import 'cart_screen.dart';

class ProductInfo extends StatefulWidget {
  static String id = 'ProductInfo';
  @override
  _ProductInfoState createState() => _ProductInfoState();
}

class _ProductInfoState extends State<ProductInfo> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    Product product = ModalRoute
        .of(context)
        .settings
        .arguments;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              child: Image(
                // image: AssetImage(product.pLocation),
                      image: NetworkImage(product.pImage[0]),
                fit: BoxFit.fill,
              )),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
            child: Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height * .1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.arrow_back_ios)),
                  GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, CartScreen.id);
                      },
                      child: Icon(Icons.shopping_cart))
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Column(
              children: <Widget>[
                Opacity(
                    opacity: .5,
                    child: Container(
                      color: Colors.white,
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      height: MediaQuery
                          .of(context)
                          .size
                          .height * 0.3,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: ListView(
                           children: <Widget>[
                             Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: <Widget>[
                                 Text(product.pName, style: TextStyle(
                                     fontSize: 20.0,
                                     fontWeight: FontWeight.bold
                                 ),),
                                 SizedBox(height: 10,),
                                 Text(product.pDescription, style: TextStyle(
                                     fontSize: 20.0,
                                     fontWeight: FontWeight.bold
                                 ),),
                                 SizedBox(height: 10,),
                                 Text('\$${product.pPrice}', style: TextStyle(
                                     fontSize: 20.0,
                                     fontWeight: FontWeight.bold
                                 ),),
                                 SizedBox(height: 10,),
                                 Row(
                                   mainAxisAlignment: MainAxisAlignment.center,
                                   children: <Widget>[
                                     ClipOval(
                                       child: Material(
                                         color: KmainColor,
                                         child: GestureDetector(
                                           onTap: add,
                                           child: SizedBox(child: Icon(Icons.add),
                                             height: 28, width: 28,),
                                         ),
                                       ),
                                     ),
                                     Text(_quantity.toString(),
                                       style: TextStyle(fontSize: 50),),
                                     ClipOval(
                                       child: Material(
                                         color: KmainColor,
                                         child: GestureDetector(
                                           onTap: subtract,
                                           child: SizedBox(child: Icon(Icons.remove),
                                             height: 28, width: 28,),
                                         ),
                                       ),
                                     ),
                                     SizedBox(height: 10,)
                                   ],),
                               ],
                             ),
                           ],
                        ),
                      ),
                    )),
                ButtonTheme(
                  minWidth: MediaQuery
                      .of(context)
                      .size
                      .width,
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.1,
                  child: Builder(
                    builder: (context) =>
                        RaisedButton(
                          child: Text(
                            'Add to cart'.toUpperCase(),
                            style: TextStyle(fontWeight: FontWeight.bold,
                                fontSize: 25),
                          ),
                          color: KmainColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20)
                              )
                          ),
                          onPressed: () {
                            addToCart(context, product);
                          },
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  add() {
    setState(() {
      _quantity++;
    });
  }

  subtract() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  void addToCart(context, product) {

    CartItem cartitem = Provider.of<CartItem>(context, listen: false);

    product.pQuantity = _quantity;
    bool exist = false;
    var productsInCart = cartitem.products;

    for (var productInCart in productsInCart) {
      if (productInCart.pName == product.pName) {
        exist = true;
      }
    }
    if (exist) {

      Scaffold.of(context).showSnackBar(
          SnackBar(content: Text('you\'ve added this item before'),));
    } else {

      cartitem.addProduct(product);

      Scaffold.of(context).showSnackBar(
          SnackBar(content: Text('Add to cart'),));
    }
  }

}