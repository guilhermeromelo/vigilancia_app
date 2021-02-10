import 'package:flutter/material.dart';

class User {
  int id;
  String name;
  String cpf;
  String senha;
  int type; //0 - adm,  1 - Líder

  User({Key key, this.name, this.cpf, this.senha, this.type, this.id});

  @override
  String toString() {
    return 'User{id: $id, name: $name, cpf: $cpf, senha: $senha, type: $type}';
  }
}

User docToUser(var doc) {
  User user = new User();
  user.id = doc['id'];
  user.name = doc['name'];
  user.cpf = doc['cpf'];
  user.type = doc['type'];
  user.senha = doc['senha'];
  return user;
}
