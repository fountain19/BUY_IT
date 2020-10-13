import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_app/provider/modalhud.dart';
import 'package:store_app/screen/home_page.dart';

import 'package:store_app/widgets/custom_textfield.dart';
import 'package:store_app/services/auth.dart';
import '../../constans.dart';


import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  static String id = 'SignupScreen';

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  String _email, _password, _name;
  final Firestore _firestore = Firestore.instance;
  final _auth = Auth();

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  // File _image;
  String userImageUrl = '';
  File _imageFile;
  FirebaseUser firebaseUser;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery
        .of(context)
        .size
        .height;
    return Scaffold(
      backgroundColor: KmainColor,
      body: ModalProgressHUD(
        inAsyncCall: Provider
            .of<ModalHud>(context)
            .isLoading,
        child: Form(
          key: _globalKey,
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: height * 0.1,
              ),
              // CustomLogo(image:'images/icons/icon.png', title: 'Buy It'),
              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: <Widget>[

                    CircleAvatar(
                      radius: 75,
                      backgroundImage:
                      // _image == null ? null : FileImage(_image),
                      _imageFile == null ? null : FileImage(_imageFile),
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.black,
                      child: GestureDetector(
                          onTap: () {
                            // pickImage();
                            _selecteImageAndPickup();
                          },
                          child: Icon(Icons.camera_alt)),
                    ),

                  ],
                ),
              ),
              SizedBox(
                height: height * 0.1,
              ),
              CustomTextField(
                icon: Icons.person,
                hint: 'Enter Your Name',
                onClick: (value) {
                  _name = value;
                },
              ),
              SizedBox(height: height * 0.03),
              CustomTextField(
                icon: Icons.email,
                hint: 'Enter Your Email',
                onClick: (value) {
                  _email = value;
                },
              ),

              SizedBox(height: height * 0.03),
              CustomTextField(
                icon: Icons.lock,
                hint: 'Enter Your Password',
                onClick: (value) {
                  _password = value;
                },
              ),

              SizedBox(height: height * 0.03),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 100.0),
                child: Builder(
                  builder: (context) =>
                      FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        color: Colors.deepOrange,
                        onPressed: () async {
                          final modalHud =
                          Provider.of<ModalHud>(context, listen: false);
                          modalHud.changeisLoading(true);
                          if (_globalKey.currentState.validate()) {
                            _globalKey.currentState.save();
                            try {
                              final authResult = await _auth.signUp(
                                  _email.trim(), _password.trim());
                              print(authResult.user.uid);
                              firebaseUser = authResult.user;
                              saveUSERInfToFirestor(firebaseUser);
                              modalHud.changeisLoading(false);
                              Navigator.pushNamed(context, HomePage.id,
                                  arguments: _email);
                            } on PlatformException catch (e) {
                              modalHud.changeisLoading(false);
                              Scaffold.of(context)
                                  .showSnackBar(
                                  SnackBar(content: Text(e.message)));
                            }
                          }
                          modalHud.changeisLoading(false);
                        },
                        child: Text(
                          'Sign up',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                ),
              ),
              SizedBox(height: height * 0.03),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Do You have an account ?',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, LoginScreen.id);
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
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

  // void pickImage() async {
  //   var image = await ImagePicker.pickImage(source: ImageSource.gallery);
  //
  //   setState(() {
  //     _image = image;
  //   });
  // }


  void _selecteImageAndPickup() async {
    _imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    String imageFileName = DateTime
        .now()
        .millisecondsSinceEpoch
        .toString();
    StorageReference storageReference =
    FirebaseStorage.instance.ref().child(imageFileName);
    StorageUploadTask uploadTask = storageReference.putFile(_imageFile);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    await taskSnapshot.ref.getDownloadURL().then((urlImage) {
     return userImageUrl = urlImage;
    }
    );
  }

  Future saveUSERInfToFirestor(FirebaseUser fUser) async {

    Firestore.instance.collection(KAuthCollection).document(fUser.uid).setData({
      KUid: fUser.uid,
      KName: _name,
      KEmail: fUser.email,
      KUrl: userImageUrl,
      KuserCartList: ["garbageValue"],
    });
    await Buy.sharedPreferences.setString(KUid, fUser.uid);
    await Buy.sharedPreferences.setString(KEmail, fUser.email);
    await Buy.sharedPreferences.setString(KUrl, userImageUrl);
    await Buy.sharedPreferences.setString(
      KName,
      _name,
    );
    await Buy.sharedPreferences.setStringList(KuserCartList, ["garbageValue"]);
  }
}