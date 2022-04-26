import 'package:flutter/material.dart';

class EmailProvider extends ChangeNotifier {

  String email = '';

  void setEmail(String mail) {
    email = mail;
    notifyListeners();
  }

  String getEmail() {
    return email;
  }

}
