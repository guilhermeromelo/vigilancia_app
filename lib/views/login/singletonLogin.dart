import 'package:flutter/material.dart';
import 'package:vigilancia_app/models/user/user.dart';

class SingletonLogin {
  User loggedUser;

  static SingletonLogin _instance;

  factory SingletonLogin({User loggedUser}) {
    if (_instance == null) {
      _instance = SingletonLogin._internalConstructor(loggedUser);
    }
    _instance ?? SingletonLogin._internalConstructor(loggedUser);
    return _instance;
  }
  SingletonLogin._internalConstructor(this.loggedUser);
}
