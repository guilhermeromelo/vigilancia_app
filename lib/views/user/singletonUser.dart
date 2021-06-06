import 'package:flutter/material.dart';
import 'package:vigilancia_app/models/guard/guard.dart';
import 'package:vigilancia_app/models/user/user.dart';

class SingletonUser {
  User user;
  bool isUpdate;
  int currentIndexForUserListPage;

  static SingletonUser _instance;

  factory SingletonUser({User user, bool isUpdate, int currentIndexForUserListPage}) {
    if (_instance == null) {
      _instance = SingletonUser._internalConstructor(user, isUpdate, currentIndexForUserListPage);
    }
    _instance ?? SingletonUser._internalConstructor(user, isUpdate, currentIndexForUserListPage);
    return _instance;
  }
  SingletonUser._internalConstructor(this.user, this.isUpdate, this.currentIndexForUserListPage);
}
