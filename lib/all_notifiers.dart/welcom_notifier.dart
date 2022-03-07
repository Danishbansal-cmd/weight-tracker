import 'package:flutter/material.dart';

class WelcomeNotifier extends ChangeNotifier{
  String text='';

  void onChangeEmail(String value){
    text = value;
    notifyListeners();
  }
}