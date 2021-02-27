import 'package:flutter/material.dart';

class Guard {
  int id;
  String name;
  String matricula;
  int type; // 0 - Vigilante,  1 - Porteiro
  String team; // A B C D

  Guard({Key key, this.name, this.matricula, this.type, this.id, this.team});

  @override
  String toString() {
    return 'Guard{id: $id, name: $name, matricula: $matricula, type: $type, team: $team}';
  }
}

Guard docToGuard(var doc) {
  Guard guard = new Guard();
  guard.id = doc['id'];
  guard.name = doc['name'];
  guard.matricula = doc['matricula'];
  guard.type = doc['type'];
  guard.team = doc['team'];
  return guard;
}
