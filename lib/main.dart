
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_app/constans.dart';
import 'package:store_app/provider/admin_mode.dart';
import 'package:store_app/provider/cartItem.dart';

import 'package:store_app/provider/favorite_item.dart';
import 'package:store_app/provider/modalhud.dart';
import 'package:store_app/screen/admin/add_product.dart';
import 'package:store_app/screen/admin/admin_home.dart';
import 'package:store_app/screen/admin/edit_product.dart';
import 'package:store_app/screen/admin/mange_product.dart';
import 'package:store_app/screen/admin/order_detailes.dart';
import 'package:store_app/screen/admin/order_screen.dart';
import 'package:store_app/screen/home_page.dart';
import 'package:store_app/screen/user/about_us.dart';
import 'package:store_app/screen/user/cart_screen.dart';
import 'package:store_app/screen/user/connect_with_us.dart';
import 'package:store_app/screen/user/existing_card.dart';
import 'package:store_app/screen/user/favorite.dart';
import 'package:store_app/screen/user/going_to_map.dart';
import 'package:store_app/screen/user/payment_page.dart';
import 'package:store_app/screen/user/productInfo.dart';
import 'package:store_app/screen/user/realtime_location.dart';
import 'package:store_app/screen/user/setting.dart';
import 'package:store_app/screen/user/signup_screen.dart';
import 'package:store_app/screen/user/user_location.dart';
import 'screen/user/login_screen.dart';

void main()async {

  runApp(StoreApp());
  WidgetsFlutterBinding.ensureInitialized();
  Buy.auth= FirebaseAuth.instance;
  Buy.firestore=Firestore.instance;
  Buy.sharedPreferences=await SharedPreferences.getInstance();
}
class StoreApp extends StatelessWidget {


  bool isUserLoggedIn=false;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context,snapshot) {
        if(!snapshot.hasData){
          return MaterialApp(home: Scaffold(
            body: Center(child: Text('Loading....'),),

          ));
        }else{
          isUserLoggedIn=snapshot.data.getBool(KKeepMeLoggedIn)??false  ;
          return MultiProvider(
            providers: [

              ChangeNotifierProvider<FavoriteItem>(
                  create: (context)=> FavoriteItem()),

              ChangeNotifierProvider<ModalHud>(
                  create: (context)=> ModalHud()),
              ChangeNotifierProvider<AdminMode>(
                create: (context)=> AdminMode(),),
              ChangeNotifierProvider<CartItem>(
                  create: (context)=> CartItem()),
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              initialRoute:

               isUserLoggedIn? HomePage.id:LoginScreen.id,

              routes:{
                Favorite.id:(context)=>Favorite(),
                AboutUs.id:(context)=>AboutUs(),
                ConnectWithUs.id:(context)=>ConnectWithUs(),
                Setting.id:(context)=>Setting(),
                RealTime.id:(context)=>RealTime(),
                UserAdress.id:(context)=>UserAdress(),
                GoingToMap.id:(context)=>GoingToMap(),
                LoginScreen.id: (context) => LoginScreen(),
                SignupScreen.id: (context) => SignupScreen(),
                HomePage.id: (context) =>HomePage(),
                AdminHome.id: (context) =>AdminHome(),
                AddProduct.id: (context) =>AddProduct(),
                MangeProduct.id:(context)=> MangeProduct(),
                EditProduct.id:(context)=>EditProduct(),
                ProductInfo.id:(context)=>ProductInfo(),
                CartScreen.id:(context)=>CartScreen(),
                OrderScreen.id:(context)=>OrderScreen(),
                OrderDetailes.id:(context)=>OrderDetailes(),
                PaymentPage.id:(context)=>PaymentPage(),
                ExistingCard.id:(context)=>ExistingCard(),
              } ,
            ),
          );
        }
      },
    );
  }
}
