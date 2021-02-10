import 'package:flutter/material.dart';

class Guard {
  int id;
  String name;
  String cpf;
  int type; // 0 - Vigilante,  1 - Porteiro

  Guard({Key key, this.name, this.cpf, this.type, this.id});

  @override
  String toString() {
    return 'Guard{id: $id, name: $name, cpf: $cpf, type: $type}';
  }
}

Guard docToGuard(var doc) {
  Guard guard = new Guard();
  guard.id = doc['id'];
  guard.name = doc['name'];
  guard.cpf = doc['cpf'];
  guard.type = doc['type'];
  return guard;
}
