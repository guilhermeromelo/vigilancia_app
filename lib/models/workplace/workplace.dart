import 'package:flutter/material.dart';

class WorkPlace{
  String name;
  int doormanQt;
  int guardQt;
  int type; //0 - Diurno, 1 - Noturno

  WorkPlace({Key key, this.name, this.doormanQt, this.guardQt,
    this.type});

  @override
  String toString() {
    return 'WorkPlace{name: $name, doormanQt: $doormanQt, guardQt: $guardQt, type: $type}';
  }

}