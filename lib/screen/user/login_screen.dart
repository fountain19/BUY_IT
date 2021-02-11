import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_app/constans.dart';
import 'package:store_app/provider/admin_mode.dart';
import 'package:store_app/provider/modalhud.dart';
import 'package:store_app/screen/admin/admin_home.dart';

import 'package:store_app/screen/home_page.dart';

import 'package:store_app/screen/user/signup_screen.dart';

import 'package:store_app/services/auth.dart';
import 'package:store_app/widgets/custom_logo.dart';
import 'package:store_app/widgets/custom_textfield.dart';

// ignore: must_be_immutable
class LoginScreen extends StatefulWidget {

  static String id = 'LoginScreen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  String _email, password;

  final _auth = Auth();

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
final FirebaseAuth auth=FirebaseAuth.instance;
  bool isAdmin = false;

  final adminPassword = 'yasser19';
  final GoogleSignIn _googleSignIn=GoogleSignIn();

bool keepMeLoggedIn=false;

  FirebaseUser firebaseUser;


  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: KmainColor,
        elevation: 0.0,
      ),
      backgroundColor: KmainColor,
      body: ModalProgressHUD(
        inAsyncCall:

        Provider.of<ModalHud>(context).isLoading,
        child: Form(
          key: _globalKey,
          child: ListView(
            children: <Widget>[
              CustomLogo(image: 'assets/icons/icon2.jpg', title: 'Buy It'),
              SizedBox(
                height: 10,
              ),
              CustomTextField(
                onClick: (value) {
                  _email = value;
                },
                icon: Icons.email,
                hint: 'Enter Your Email',

              ),
             Padding(
               padding: const EdgeInsets.only(left: 30.0),
               child: Row(children: <Widget>[
                 Theme(

                   data: ThemeData(
                       unselectedWidgetColor: Colors.white),
                   child: Checkbox(
                     checkColor: KseconderyColor,
                     activeColor: KmainColor,
                     value: keepMeLoggedIn,
                     onChanged: (bool value) {
                       setState(() {
                         keepMeLoggedIn=value;
                       });

                     },),
                 ),
                 Text('Remember Me',style: TextStyle(color: Colors.white),),
               ],),
             ),
              CustomTextField(
                onClick: (value) {
                  password = value;
                },
                icon: Icons.lock,
                hint: 'Enter Your Password',

              ),
              SizedBox(height: height * 0.03),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 100.0),
                child: Builder(
                  builder: (context) => FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    color: Colors.deepOrange,
                    onPressed: () {
                      if(keepMeLoggedIn==true)
                        {
                          keepUserLoggedIn();
                        }
                      _valiDate(context);

                    },
                    child: Text(
                      'Login',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              SizedBox(height: height * 0.03),
              // Padding(
              //   padding: const EdgeInsets.only(left: 30,right: 30),
              //   child:
              //   ButtonTheme(
              //     buttonColor: Colors.green,
              //     child: RaisedButton(
              //       child: Text('Sign In with Google',style: TextStyle(
              //         color: Colors.white
              //       ),),
              //       onPressed: ()async{
              //
              //      await signInWithGoogle();
              //       },
              //     ),
              //
              //   ),
              //
              // ),
              // SizedBox(height: height * 0.03),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Don\'t have an account ?',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, SignupScreen.id);
                    },
                    child: Text(
                      'Signup',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                      child: GestureDetector(
                    onTap: () {
                      Provider.of<AdminMode>(context, listen: false)
                          .changeisAdmin(true);
                    },
                    child: Text(
                      'I\'m an admin',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Provider.of<AdminMode>(context).isAdmin
                              ? KmainColor
                              : Colors.white),
                    ),
                  )),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Provider.of<AdminMode>(context, listen: false)
                            .changeisAdmin(false);
                      },
                      child: Text('I\'m an user',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Provider.of<AdminMode>(context).isAdmin
                                  ? Colors.white
                                  : KmainColor)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

      ),

    );
  }

  void _valiDate(BuildContext context) async {
    final modelHud = Provider.of<ModalHud>(context, listen: false);
    modelHud.changeisLoading(true);
    if (_globalKey.currentState.validate()) {
      _globalKey.currentState.save();
      if (Provider.of<AdminMode>(context, listen: false).isAdmin) {
        if (password == adminPassword) {
          try {
            await _auth.signIn(_email.trim(), password.trim());
            readData(firebaseUser);
            Navigator.pushNamed(context, AdminHome.id);
          } catch (e) {
            modelHud.changeisLoading(false);
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text(e.message),
            ));
          }
        } else {
          modelHud.changeisLoading(false);
          Scaffold.of(context).showSnackBar(SnackBar(backgroundColor: Colors.green,
            content: Text('Something is Wrong !'),
          ));
        }
      } else {
        try {
          modelHud.changeisLoading(false);
          await _auth.signIn(_email.trim(), password.trim()) .then((authUser) {
            firebaseUser = authUser.user;
          });
          // Navigator.pushNamed(context, HomePage.id);
          Navigator.pushNamed(context, HomePage.id,arguments: _email);
        } catch (e) {
          Scaffold.of(context).showSnackBar(SnackBar(backgroundColor: Colors.green,
            content: Text(e.message),
          ));
        }
      }
    }
    modelHud.changeisLoading(false);
  }

  void keepUserLoggedIn() async{
    SharedPreferences preferences=await SharedPreferences.getInstance();
    preferences.setBool(KKeepMeLoggedIn, keepMeLoggedIn);
  }

//   Future<void> signInWithGoogle() async{
//     final modelHud = Provider.of<ModalHud>(context, listen: false);
//     modelHud.changeisLoading(true);
//     GoogleSignInAccount googleSignInAccount=await _googleSignIn.signIn();
//     GoogleSignInAuthentication googleSignInAuthentication=await googleSignInAccount.authentication;
//    AuthCredential authCredential= GoogleAuthProvider.getCredential(idToken: googleSignInAuthentication.idToken, accessToken: googleSignInAuthentication.accessToken);
//     AuthResult authResult=await auth.signInWithCredential(authCredential);
//     FirebaseUser user=authResult.user;
//     modelHud.changeisLoading(false);
//
//     Firestore.instance.collection(KAuthCollection).document(user.uid).setData({
//       KUid: user.uid,
//       KName: user.displayName,
//       KEmail: user.email,
//       KUrl: user.photoUrl,
//       KuserCartList: ["garbageValue"],
//     });
//     await Buy.sharedPreferences.setString(KUid, user.uid);
//     await Buy.sharedPreferences.setString(KEmail, user.email);
//     await Buy.sharedPreferences.setString(KUrl, user.photoUrl);
//     await Buy.sharedPreferences.setString(
//       KName,
//       user.displayName,
//     );
//     await Buy.sharedPreferences.setStringList(KuserCartList, ["garbageValue"]);
//
//
//     Navigator.pushNamed(context,HomePage.id,arguments:
//      // '${authResult.user}'
// '${user.email}'
//     );
//   }

  Future readData(FirebaseUser fUser) async {

    Firestore.instance
        .collection(KAuthCollection)
        .document(fUser.uid)
        .get()
        .then((dataSnapshot) async {
      await Buy.sharedPreferences
          .setString('uid', dataSnapshot.data[KUid]);
      await Buy.sharedPreferences
          .setString('name', dataSnapshot.data[KName]);
      await Buy.sharedPreferences
          .setString('email', dataSnapshot.data[KEmail]);
      await Buy.sharedPreferences
          .setString('url', dataSnapshot.data[KUrl]);
      List<String> cartList = dataSnapshot.data[KuserCartList].cast<String>();
      await Buy.sharedPreferences
          .setStringList(KuserCartList, cartList);
    });
  }
}

