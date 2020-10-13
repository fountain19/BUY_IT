import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:store_app/constans.dart';
import 'package:store_app/models/product.dart';

import 'package:store_app/provider/favorite_item.dart';

import 'package:store_app/screen/user/productInfo.dart';


import 'package:store_app/widgets/costum_menu.dart';

class Favorite extends StatefulWidget {
  static String id = 'Favorite';

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<Favorite> {

  @override
  Widget build(BuildContext context) {
    List<Product> products = Provider.of<FavoriteItem>(context).products;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double appBarHeight = AppBar().preferredSize.height;
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: KmainColor,
        centerTitle: true,
        title: Text(
          'My favorite',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0.0,
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            )),
      ),
      body:
      ListView(children: <Widget>[
        Column(
          children: <Widget>[
            LayoutBuilder(builder: (context, constrains) {
              if (products.isNotEmpty) {
                return Container(
                  height: screenHeight -
                      (screenHeight * .08) -
                      statusBarHeight -
                      appBarHeight,
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(10),
                        child: GestureDetector(
                          onTapUp: (details) {
                            showCustomMenu(details, context, products[index]);
                          },
                          child: Container(
                            height: screenHeight * 0.15,
                            color: KseconderyColor,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                CircleAvatar(
                                  radius: screenHeight * 0.15 / 2,
                                  backgroundImage:
                                  NetworkImage(products[index].pImage[0]),
                                  // AssetImage(products[index].pLocation[index])
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        products[index].pName,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        '\$ ${products[index].pPrice}',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: products.length,
                  ),
                );
              } else {
                return Container(
                    height: screenHeight -
                        (screenHeight * .08) -
                        statusBarHeight -
                        appBarHeight,
                    child: Center(child: Text('Cart Is Empty')));
              }
            }),

          ],
        ),
      ],),
    );
  }

  void showCustomMenu(details, context, product) {
    double dx = details.globalPosition.dx;
    double dy = details.globalPosition.dy;
    double dx1 = MediaQuery.of(context).size.width - dx;
    double dy1 = MediaQuery.of(context).size.width - dy;
    showMenu(
        context: context,
        position: RelativeRect.fromLTRB(dx, dy, dx1, dy1),
        items: [
          MyPopupMenuItem(
            child: Text('Edit'),
            onClick: () async {
              Navigator.pop(context);
              Provider.of<FavoriteItem>(context, listen: false)
                  .deleteProduct(product);
              Navigator.pushNamed(context, ProductInfo.id, arguments: product);
            },
          ),
          MyPopupMenuItem(
            onClick: () async {
              Navigator.pop(context);
              Provider.of<FavoriteItem>(context, listen: false)
                  .deleteProduct(product);
            },
            child: Text('Delete'),
          ),
        ]);
  }







}
