import 'package:flutter/material.dart';

class User {
  String name;
  String cpf;
  String senha;
  int type; //0 - adm,  1 - Líder

  User({Key key, this.name, this.cpf, this.senha, this.type});

  @override
  String toString() {
    return 'User{name: $name, cpf: $cpf, senha: $senha, type: $type}';
  }
}
