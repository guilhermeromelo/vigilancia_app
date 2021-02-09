import 'package:flutter/material.dart';

class Guard{
  String name;
  String cpf;
  int type; // 0 - Vigilante,  1 - Porteiro

  Guard({Key key, this.name, this.cpf, this.type});

  @override
  String toString() {
    return 'Guard{name: $name, cpf: $cpf, type: $type}';
  }

}