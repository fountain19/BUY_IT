import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import 'package:store_app/constans.dart';
import 'package:store_app/models/product.dart';
import 'package:store_app/provider/cartItem.dart';

import 'package:store_app/screen/user/payment_page.dart';
import 'package:store_app/screen/user/productInfo.dart';

import 'package:store_app/services/store.dart';
import 'package:store_app/widgets/costum_menu.dart';

class CartScreen extends StatefulWidget {
  static String id = 'CartScreen';

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  TextEditingController textGeolocator=TextEditingController();
  // Future<SharedPreferences> sharedPreferences=SharedPreferences.getInstance();
  @override
  Widget build(BuildContext context) {

    List<Product> products = Provider.of<CartItem>(context).products;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double appBarHeight = AppBar().preferredSize.height;
    final double statusBarHeight = MediaQuery.of(context).padding.top;




    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: Color(0xFF2c425e),
        centerTitle: true,
        title: Text(
          'My Cart',
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
                             children: <Widget>[
                               CircleAvatar(
                                 radius: screenHeight * 0.15 / 2,
                                 backgroundImage:
                                 NetworkImage(products[index].pImage[0]),
                                 // AssetImage(products[index].pLocation[index])
                               ),
                               Expanded(
                                 child: Row(
                                   mainAxisAlignment:
                                   MainAxisAlignment.spaceBetween,
                                   children: <Widget>[
                                     Padding(
                                       padding: const EdgeInsets.only(left: 10),
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
                                     Padding(
                                       padding: const EdgeInsets.only(right: 10),
                                       child: Text(
                                         products[index].pQuantity.toString(),
                                         style: TextStyle(
                                             fontSize: 16,
                                             fontWeight: FontWeight.bold),
                                       ),
                                     ),
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
           Builder(
             builder: (context) => ButtonTheme(
               minWidth: screenWidth,
               height: screenHeight * 0.08,
               child: RaisedButton(
                 onPressed: () {
                   if(products.isNotEmpty){showCustomDialog(products, context);}
                   else{
                     Scaffold.of(context).showSnackBar(SnackBar(content: Text('Cart Is Empty'),));
                   }

                 },
                 child: Text(
                   'order'.toUpperCase(),
                   style: TextStyle(fontWeight: FontWeight.bold),
                 ),
                 color: Colors.blueGrey,
                 shape: RoundedRectangleBorder(
                     borderRadius: BorderRadius.only(
                         topLeft: Radius.circular(10),
                         topRight: Radius.circular(10))),
               ),
             ),
           ),
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
              Provider.of<CartItem>(context, listen: false)
                  .deleteProduct(product);
              Navigator.pushNamed(context, ProductInfo.id, arguments: product);
            },
          ),
          MyPopupMenuItem(
            onClick: () async {
              Navigator.pop(context);
              Provider.of<CartItem>(context, listen: false)
                  .deleteProduct(product);
            },
            child: Text('Delete'),
          ),
        ]);
  }

  void showCustomDialog(List<Product> products, context) async {
    var price = getTotallPrice(products);


    AlertDialog alertDialog = AlertDialog(
      actions: <Widget>[

        MaterialButton(
          child: Text('Pay'),
          onPressed: () {
            try {
              Store _store = Store();
              _store.storeOrders(
                  {KTotallPrice: price, KAddress: textGeolocator.text.trim()}, products);
              Navigator.pushNamed(context, PaymentPage.id, arguments: price);
//              Scaffold.of(context).showSnackBar(SnackBar(content: Text('Order Successfully'),));
//              Navigator.pop(context);
            } catch (ex) {
              print(ex.message);
            }
          },
        ),
      ],
      content:
     Column(
       children: <Widget>[

         ListTile(
           leading: Icon(Icons.pin_drop,color: Colors.green,),
           title: TextField(
               controller:textGeolocator ,
               decoration: InputDecoration(
                   hintText: 'Enter your address',border: InputBorder.none
               )),),
         SizedBox(height: 10.0,),
         RaisedButton.icon(
             color: KmainColor,
             onPressed: getUserLocation,
             icon: Icon(Icons.my_location,color: Colors.red,),
             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
             label: Text('Use Current Location')),

       ],
     ),
       title: Text('Totall Price = \$ ${price.toString()}'),
      // title: Text(price.toString()),
    );
    await showDialog(
        context: context,
        builder: (context) {
          return alertDialog;
        });
  }

  getTotallPrice(List<Product> products) {
   double price = 0.0;
    for (var product in products) {
      // price += product.pQuantity * int.parse(product.pPrice);
       price+=product.pQuantity*num.parse(product.pPrice).floor();
    }
    return price.floor();
  }

  void getUserLocation() async{
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy:LocationAccuracy.high);
    List<Placemark> placemarks = await Geolocator().placemarkFromCoordinates(position.latitude,position.longitude);
    Placemark placemark=placemarks[0];

    String fullAddress=
            '${placemark.subLocality}'+','+
            '${placemark.thoroughfare}'+','+'No:'+'${placemark.subThoroughfare}';
    print('fullAddress is '"$fullAddress");

    textGeolocator.text=fullAddress;
  }

}
