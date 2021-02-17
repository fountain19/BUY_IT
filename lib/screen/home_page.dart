import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_app/constans.dart';
import 'package:store_app/function.dart';
import 'package:store_app/models/product.dart';


import 'package:store_app/provider/favorite_item.dart';
import 'package:store_app/screen/test.dart';
import 'package:store_app/screen/user/cart_screen.dart';
import 'package:store_app/screen/user/favorite.dart';
import 'package:store_app/screen/user/login_screen.dart';
import 'package:store_app/screen/user/productInfo.dart';
import 'package:store_app/screen/user/setting.dart';
import 'package:store_app/services/auth.dart';
import 'package:store_app/services/store.dart';

class HomePage extends StatefulWidget {
  static String id = 'HomePage';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final _auth = Auth();
  FirebaseUser _loggedUser;
  int _tabBarIndex = 0;
  int _bottomBarIndex = 0;
  final _store = Store();
  List<Product> _products;

  @override
  Widget build(BuildContext context) {

   // int counter= Provider.of<CartCounter>(context).counter;
    String _email = ModalRoute
        .of(context)
        .settings
        .arguments;
    String user = ModalRoute
        .of(context)
        .settings
        .arguments;


    return Stack(
      children: <Widget>[
        DefaultTabController(
          length: 4,
          child: Scaffold(
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              unselectedItemColor: KUnActiveColor,
              currentIndex: _bottomBarIndex,
              fixedColor: Color(0xFF2c425e),
              onTap: (value) async {
                if (value == 2) {
                  SharedPreferences pref =
                  await SharedPreferences.getInstance();
                  pref.clear();
                  await _auth.signOut();
                  Navigator.popAndPushNamed(context, LoginScreen.id);
                } else if (value == 0) {
                  Navigator.pushNamed(
                      context, Setting.id, arguments: checkEmail(_email, user));
                 }
                  else if (value == 1) {
                  Navigator.pushNamed(context, CartScreen.id);
                }

                setState(() {
                  _bottomBarIndex = value;
                });
              },
              items: [
                BottomNavigationBarItem(
                    title: Text('Setting'), icon: Icon(Icons.settings,size: 25,)),
                BottomNavigationBarItem(
                    title: Text('Cart screen'),
                    icon:
                    Icon(Icons.shopping_cart)),
                BottomNavigationBarItem(
                    title: Text('Sign Out'), icon: Icon(Icons.close)),
              ],
            ),
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              bottom: TabBar(
                indicatorColor: KmainColor,
                onTap: (value) {
                  setState(() {
                    _tabBarIndex = value;
                  });
                },
                tabs: <Widget>[
                  Text(
                    'Jackets',
                    style: TextStyle(
                      color: _tabBarIndex == 0 ? Colors.black : KUnActiveColor,
                      fontSize: _tabBarIndex == 0 ? 16 : null,
                    ),
                  ),
                  Text(
                    'Trouser',
                    style: TextStyle(
                      color: _tabBarIndex == 1 ? Colors.black : KUnActiveColor,
                      fontSize: _tabBarIndex == 1 ? 16 : null,
                    ),
                  ),
                  Text(
                    'T-shirts',
                    style: TextStyle(
                      color: _tabBarIndex == 2 ? Colors.black : KUnActiveColor,
                      fontSize: _tabBarIndex == 2 ? 16 : null,
                    ),
                  ),
                  Text(
                    'Shoes',
                    style: TextStyle(
                      color: _tabBarIndex == 3 ? Colors.black : KUnActiveColor,
                      fontSize: _tabBarIndex == 3 ? 16 : null,
                    ),
                  ),
                ],
              ),
            ),
            body: TabBarView(
              children: <Widget>[
                jacketView(),
                TrouserView(),
                TshirtView(),
                ShoesView(),
              ],
            ),
          ),
        ),
        Material(
          color: Color(0xFF2c425e),
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
            child: Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height * .1,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                        Text(
                        'Discover'.toUpperCase(),
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
              //           Stack(
              //
              //           alignment: Alignment.topLeft,
              //           children: <Widget>[
              //
              //             IconButton(
              //               onPressed: () { Navigator.pushNamed(context, CartScreen.id); },
              //               icon: Icon(Icons.shopping_cart,size: 35,color: Colors.black,)),
              //
              //               CircleAvatar(
              //                 backgroundColor: Colors.pink,
              //                   radius: 10,
              //                   child:Text('0',style: TextStyle(
              //                     color: Colors.white
              //                   ),) ,)
              //           ],
              //
              // ),
             ],
            ),
          ),
        ),
        ),],
    );
  }

  @override
  void initState() {
    getCurrenUser();
    getDiviceToken();
    configureCallback();
    subscripeToAdmin();
  }

  getCurrenUser() async {
    _loggedUser = await _auth.getUser();
  }

  Widget jacketView() {
    return StreamBuilder<QuerySnapshot>(
      stream: _store.LoadProducts(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Product> products = [];
          for (var doc in snapshot.data.documents) {
            var data = doc.data;
            products.add(Product(
                pId: doc.documentID,
                pPrice: data[KProductPrice],
                pName: data[KProductName],
                pDescription: data[KProductDescription],
                // pLocation: data[KProductLocation],
                pImage: data[KProductImage],
                pCategory: data[KProductCategory]));
          }
          _products = [...products];
          products.clear();
          products = getProductByCategory(KJackets, _products);
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: .8,
            ),
            itemBuilder: (context, index) =>
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, ProductInfo.id,
                          arguments: products[index]);
                    },
                    child: Stack(
                      children: <Widget>[

                        Positioned.fill(
                          child:
                          Image(
                              fit: BoxFit.fill,
                              // image: AssetImage(products[index].pLocation),
                              image: NetworkImage('${products[index]
                                  .pImage[0]}')),

                        ),
                        Positioned(
                          right: 0,
                          child: FlatButton(
                              onPressed: () {
                                addToFavorite(context, products[index]);
                              },
                              child: Icon(Icons.favorite, color: Colors.red,
                                size: 35,)),
                        ),
                        Positioned(
                          bottom: 0,
                          child: Opacity(
                            opacity: .6,
                            child: Container(
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width,
                              height: 60,
                              color: Colors.white,

                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      products[index].pName,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text('\$ ${products[index].pPrice}')
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
            itemCount: products.length,
          );
        } else {
          return Center(child: Text('Loading...'));
        }
      },
    );
  }

  Widget TrouserView() {
    return StreamBuilder<QuerySnapshot>(
      stream: _store.LoadProducts(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Product> products = [];
          for (var doc in snapshot.data.documents) {
            var data = doc.data;
            products.add(Product(
              pId: doc.documentID,
              pName: data[KProductName],
              pPrice: data[KProductPrice],
              pDescription: data[KProductDescription],
              pCategory: data[KProductCategory],
              // pLocation: data[KProductLocation],
              pImage: data[KProductImage],
            ));
          }
          _products = [...products];
          products.clear();
          products = getProductByCategoryTrousers(KTrousers, _products);

          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, childAspectRatio: 0.7),
            itemBuilder: (context, index) =>
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, ProductInfo.id,
                          arguments: products[index]);
                    },
                    child: Stack(
                      children: <Widget>[
                        Positioned.fill(
                            child: Image(
                                fit: BoxFit.fill,
                                image: NetworkImage('${products[index]
                                    .pImage[0]}')
                              // image: AssetImage(products[index].pLocation[index])
                            )),
                        Positioned(
                          right: 0,
                          child: FlatButton(
                              onPressed: () {
                                addToFavorite(context, products[index]);
                              },
                              child: Icon(Icons.favorite, color: Colors.red,
                                size: 35,)),
                        ),
                        Positioned(
                            bottom: 0,
                            child: Opacity(
                                opacity: 0.6,
                                child: Container(

                                  height: 60,
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width,
                                  color: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          products[index].pName,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                        Text('\$ ${products[index].pPrice}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16))
                                      ],
                                    ),
                                  ),
                                ))),
                      ],
                    ),
                  ),
                ),
            itemCount: products.length,
          );
        } else {
          return Center(
              child: Text(
                'Loading....',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'fonts/Pacifico-Regular.ttf'),
              ));
        }
      },
    );
  }

  Widget TshirtView() {
    return StreamBuilder<QuerySnapshot>(
      stream: _store.LoadProducts(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Product> products = [];
          for (var doc in snapshot.data.documents) {
            var data = doc.data;
            products.add(Product(
                pId: doc.documentID,
                pName: data[KProductName],
                pPrice: data[KProductPrice],
                pDescription: data[KProductDescription],
                pCategory: data[KProductCategory],
                // pLocation: data[KProductLocation],
                pImage: data[KProductImage]));
          }
          _products = [...products];
          products.clear();
          products = getProductByCategoryTshirt(KTshirts, _products);

          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, childAspectRatio: 0.7),
            itemBuilder: (context, index) =>
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, ProductInfo.id,
                          arguments: products[index]);
                    },
                    child: Stack(
                      children: <Widget>[
                        Positioned.fill(
                            child: Image(
                                fit: BoxFit.fill,
                                image: NetworkImage('${products[index]
                                    .pImage[0]}')
                              // image: AssetImage(products[index].pLocation[index])
                            )),
                        Positioned(
                          right: 0,
                          child: FlatButton(
                              onPressed: () {
                                addToFavorite(context, products[index]);
                              },
                              child: Icon(Icons.favorite, color: Colors.red,
                                size: 35,)),
                        ),
                        Positioned(
                            bottom: 0,
                            child: Opacity(
                                opacity: 0.6,
                                child: Container(
                                  height: 60,
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width,
                                  color: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          products[index].pName,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                        Text('\$ ${products[index].pPrice}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16))
                                      ],
                                    ),
                                  ),
                                ))),
                      ],
                    ),
                  ),
                ),
            itemCount: products.length,
          );
        } else {
          return Center(
              child: Text(
                'Loading....',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'fonts/Pacifico-Regular.ttf'),
              ));
        }
      },
    );
  }

  Widget ShoesView() {
    return StreamBuilder<QuerySnapshot>(
      stream: _store.LoadProducts(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Product> products = [];
          for (var doc in snapshot.data.documents) {
            var data = doc.data;
            products.add(Product(
                pId: doc.documentID,
                pName: data[KProductName],
                pPrice: data[KProductPrice],
                pDescription: data[KProductDescription],
                pCategory: data[KProductCategory],
                // pLocation: data[KProductLocation],
                pImage: data[KProductImage]));
          }
          _products = [...products];
          products.clear();
          products = getProductByCategoryShoes(KShoes, _products);

          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, childAspectRatio: 0.7),
            itemBuilder: (context, index) =>
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, ProductInfo.id,
                          arguments: products[index]);
                    },
                    child: Stack(
                      children: <Widget>[
                        Positioned.fill(
                            child: Image(
                                fit: BoxFit.fill,
                                image: NetworkImage('${products[index]
                                    .pImage[0]}')
                              //   image: AssetImage(products[index].pLocation[index])
                            )),
                        Positioned(
                          right: 0,
                          child: FlatButton(
                              onPressed: () {
                                addToFavorite(context, products[index]);
                              },
                              child: Icon(Icons.favorite, color: Colors.red,
                                size: 35,)),
                        ),
                        Positioned(
                            bottom: 0,
                            child: Opacity(
                                opacity: 0.6,
                                child: Container(
                                  height: 60,
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width,
                                  color: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          products[index].pName,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                        Text('\$ ${products[index].pPrice}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16))
                                      ],
                                    ),
                                  ),
                                ))),
                      ],
                    ),
                  ),
                ),
            itemCount: products.length,
          );
        } else {
          return Center(
              child: Text(
                'Loading....',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'fonts/Pacifico-Regular.ttf'),
              ));
        }
      },
    );
  }

  void configureCallback() {
    _firebaseMessaging.configure(
      onMessage: (message) async {
        print('onMessage : $message');
      },
      onResume: (message) async {
        print('onResume : $message');
      },
      onLaunch: (message) async {
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => Testing()));
      },
    );
  }

  void getDiviceToken() {
    FirebaseAuth.instance.currentUser().then((user) async {
      String deviceToken = await _firebaseMessaging.getToken();
      Firestore.instance
          .collection('deviceToken')
          .document(user.uid)
          .setData({'deviceToken': deviceToken});
      print('deviceToken:$deviceToken');
    });
  }

  void subscripeToAdmin() {
    _firebaseMessaging.subscribeToTopic('Admin');
  }

  checkEmail(String email, String user) {
    if (email == null) {
      return user;
    } else
      return email;
  }

  void addToFavorite(context, product) {
    FavoriteItem favoriteItem = Provider.of<FavoriteItem>(
        context, listen: false);

    bool exist = false;
    var productsInCart = favoriteItem.products;

    for (var productInCart in productsInCart) {
      if (productInCart.pName == product.pName) {
        exist = true;
      }
    }
    if (exist) {
      Scaffold.of(context).showSnackBar(
          SnackBar(content: Text('you\'ve added this item before'),));
    } else {
      favoriteItem.addProduct(product);
      Scaffold.of(context).showSnackBar(
          SnackBar(content: Text('Add to favorite'),));
    }
  }
}