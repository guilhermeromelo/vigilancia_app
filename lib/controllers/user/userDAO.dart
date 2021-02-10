import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vigilancia_app/models/user/user.dart';

Future<String> whoIsNextUser() async {
  var snapshot = (await FirebaseFirestore.instance
      .collection("users")
      .orderBy("id", descending: true)
      .limit(1)
      .get());
  String nextID;
  if (snapshot.docs.isEmpty) {
    nextID = "1";
  } else {
    snapshot.docs.forEach((element) {
      nextID = ((element['id']) + 1).toString();
    });
  }
  return nextID;
}

/*
  User Model
  int id;
  String name;
  String cpf;
  String senha;
  int type;
 */

void addUser(User newUser, BuildContext context) async {
  String id = await whoIsNextUser();
  await FirebaseFirestore.instance.collection("users").doc(id).set({
    "id": int.parse(id),
    "name": newUser.name,
    "cpf": newUser.cpf,
    "type": newUser.type,
    "senha": newUser.senha,
    "visible": true
  });
}

void updateUser(User updateUser, BuildContext context) async {
  await FirebaseFirestore.instance
      .collection("users")
      .doc(updateUser.id.toString())
      .update({
    "name": updateUser.name,
    "cpf": updateUser.cpf,
    "type": updateUser.type,
    "senha": updateUser.senha
  });
}

Future<List<User>> listUser() async {
  List<User> userList = List();
  await FirebaseFirestore.instance
      .collection("users")
      .get()
      .then((QuerySnapshot querySnapshot) {
    querySnapshot.docs.forEach((element) {
      userList.add(docToUser(element));
    });
  });
  return userList;
}

void deleteUser(User deleteUser, BuildContext context) async {
  await FirebaseFirestore.instance
      .collection("users")
      .doc(deleteUser.id.toString())
      .delete();
}

void updateUserVisibility(int id, bool visible) async {
  await FirebaseFirestore.instance
      .collection("users")
      .doc(id.toString())
      .update({"visible": visible});
}