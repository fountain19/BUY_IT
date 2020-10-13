

import 'package:flutter/material.dart';

import '../constans.dart';

class CustomTextField extends StatelessWidget {
  final String hint;
  final IconData icon;
  final Function onClick;
  String _errorMessage(String str){
    switch(hint){
      case 'Enter Your Name':return 'Name is empty!';
      case 'Enter Your Email':return 'Email is empty!';
      case 'Enter Your Password':return 'Password is empty!';
    }
  }

  CustomTextField({@required this.hint,@required this.icon, this.onClick}) ;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        obscureText: hint=='Enter Your Password'?true:false,
        validator: (value){
          if(value.isEmpty) {
            return _errorMessage(hint);
          }

        },
        onSaved: onClick,
        cursorColor: Colors.deepOrange,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(
            icon,
            color: Colors.lightGreen,
          ),
          filled: true,
          fillColor: KseconderyColor,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: BorderSide(
              color: Colors.white,
            ),
          ),
          focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: BorderSide(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

}
