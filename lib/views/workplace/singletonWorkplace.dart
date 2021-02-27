import 'package:flutter/material.dart';
import 'package:vigilancia_app/models/workplace/workplace.dart';

class SingletonWorkplace {
  Workplace workplace;
  bool isUpdate;

  static SingletonWorkplace _instance;

  factory SingletonWorkplace({Workplace workplace}) {
    if (_instance == null) {
      _instance = SingletonWorkplace._internalConstructor(workplace);
    }
    _instance ?? SingletonWorkplace._internalConstructor(workplace);
    return _instance;
  }
  SingletonWorkplace._internalConstructor(this.workplace);
}
