import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vigilancia_app/models/guard/guard.dart';

Future<String> whoIsNextGuard() async {
  var snapshot = (await FirebaseFirestore.instance
      .collection("guards")
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
  Guard Model
  int id;
  String name;
  String cpf;
  int type;
 */

void addGuard(Guard newGuard, BuildContext context) async {
  String id = await whoIsNextGuard();
  await FirebaseFirestore.instance.collection("guards").doc(id).set({
    "id": int.parse(id),
    "name": newGuard.name,
    "cpf": newGuard.cpf,
    "type": newGuard.type,
    "visible": true
  });
}

void updateGuard(Guard updateGuard, BuildContext context) async {
  await FirebaseFirestore.instance
      .collection("guards")
      .doc(updateGuard.id.toString())
      .update({
    "name": updateGuard.name,
    "cpf": updateGuard.cpf,
    "type": updateGuard.type,
  });
}

Future<List<Guard>> listGuards() async {
  List<Guard> guardList = List();
  await FirebaseFirestore.instance
      .collection("guards")
      .get()
      .then((QuerySnapshot querySnapshot) {
    querySnapshot.docs.forEach((element) {
      guardList.add(docToGuard(element));
    });
  });
  return guardList;
}

void deleteGuard(Guard deleteGuard, BuildContext context) async {
  await FirebaseFirestore.instance
      .collection("guards")
      .doc(deleteGuard.id.toString())
      .delete();
}

void updateGuardVisibility(int id, bool visible) async {
  await FirebaseFirestore.instance
      .collection("guards")
      .doc(id.toString())
      .update({"visible": visible});
}
