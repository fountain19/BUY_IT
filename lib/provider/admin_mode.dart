

import 'package:flutter/cupertino.dart';

class AdminMode extends ChangeNotifier{
  bool isAdmin= false;
  changeisAdmin(bool value){
    isAdmin=value;
    notifyListeners();
  }
}