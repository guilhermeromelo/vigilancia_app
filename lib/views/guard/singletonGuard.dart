import 'package:flutter/material.dart';
import 'package:vigilancia_app/models/guard/guard.dart';

class SingletonGuard {
  Guard guard;
  bool isUpdate;
  int currentIndexForGuardListPage;

  static SingletonGuard _instance;

  factory SingletonGuard({Guard guard, bool isUpdate, int currentIndexForGuardListPage}) {
    if (_instance == null) {
      _instance = SingletonGuard._internalConstructor(guard, isUpdate, currentIndexForGuardListPage);
    }
    _instance ?? SingletonGuard._internalConstructor(guard, isUpdate, currentIndexForGuardListPage);
    return _instance;
  }
  SingletonGuard._internalConstructor(this.guard, this.isUpdate, this.currentIndexForGuardListPage);
}
