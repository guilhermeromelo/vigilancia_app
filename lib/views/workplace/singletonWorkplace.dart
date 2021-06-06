import 'package:flutter/material.dart';
import 'package:vigilancia_app/models/workplace/workplace.dart';

class SingletonWorkplace {
  Workplace workplace;
  bool isUpdate;
  int currentIndexForWorkplaceListPage;

  static SingletonWorkplace _instance;

  factory SingletonWorkplace({Workplace workplace, bool isUpdate, int currentIndexForWorkplaceListPage}) {
    if (_instance == null) {
      _instance = SingletonWorkplace._internalConstructor(workplace, isUpdate, currentIndexForWorkplaceListPage);
    }
    _instance ?? SingletonWorkplace._internalConstructor(workplace, isUpdate, currentIndexForWorkplaceListPage);
    return _instance;
  }
  SingletonWorkplace._internalConstructor(this.workplace, this.isUpdate, this.currentIndexForWorkplaceListPage);
}
