import 'package:flutter/material.dart';

class Guard {
  int id;
  String name;
  String cpf;
  int type; // 0 - Vigilante,  1 - Porteiro
  String team; // A B C D

  Guard({Key key, this.name, this.cpf, this.type, this.id, this.team});

  @override
  String toString() {
    return 'Guard{id: $id, name: $name, cpf: $cpf, type: $type, team: $team}';
  }
}

Guard docToGuard(var doc) {
  Guard guard = new Guard();
  guard.id = doc['id'];
  guard.name = doc['name'];
  guard.cpf = doc['cpf'];
  guard.type = doc['type'];
  guard.team = doc['team'];
  return guard;
}
