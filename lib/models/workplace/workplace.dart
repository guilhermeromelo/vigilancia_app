import 'package:flutter/material.dart';

class Workplace{
  int id;
  String name;
  int doormanQt;
  int guardQt;
  int type; //0 - Diurno, 1 - Noturno, 2 - Diurno e Noturno

  Workplace({Key key, this.name, this.doormanQt, this.guardQt,
    this.type, this.id});

  @override
  String toString() {
    return 'WorkPlace{id: $id, name: $name, doormanQt: $doormanQt, guardQt: $guardQt, type: $type}';
  }
}

Workplace docToWorkplace(var doc) {
  Workplace workplace = new Workplace();
  workplace.id = doc['id'];
  workplace.name = doc['name'];
  workplace.type = doc['type'];
  workplace.guardQt = doc['guardQt'];
  workplace.doormanQt = doc['doormanQt'];
  return workplace;
}