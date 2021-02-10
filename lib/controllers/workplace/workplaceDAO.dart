import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vigilancia_app/models/workplace/workplace.dart';

Future<String> whoIsNextWorkplace() async {
  var snapshot = (await FirebaseFirestore.instance
      .collection("workplaces")
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
  Workplace Model
  int id;
  String name;
  int doormanQt;
  int guardQt;
  int type; //0 - Diurno, 1 - Noturno
 */

void addWorkplace(Workplace newWorkplace, BuildContext context) async {
  String id = await whoIsNextWorkplace();
  await FirebaseFirestore.instance.collection("workplaces").doc(id).set({
    "id": int.parse(id),
    "name": newWorkplace.name,
    "type": newWorkplace.type,
    "doormanQt": newWorkplace.doormanQt,
    "guardQt": newWorkplace.guardQt,
    "visible": true
  });
}

void updateWorkplace(Workplace updateWorkplace, BuildContext context) async {
  await FirebaseFirestore.instance
      .collection("workplaces")
      .doc(updateWorkplace.id.toString())
      .update({
    "name": updateWorkplace.name,
    "type": updateWorkplace.type,
    "doormanQt": updateWorkplace.doormanQt,
    "guardQt": updateWorkplace.guardQt
  });
}

Future<List<Workplace>> listWorkplace() async {
  List<Workplace> userList = List();
  await FirebaseFirestore.instance
      .collection("workplaces")
      .get()
      .then((QuerySnapshot querySnapshot) {
    querySnapshot.docs.forEach((element) {
      userList.add(docToWorkplace(element));
    });
  });
  return userList;
}

void deleteWorkplace(Workplace deleteWorkplace, BuildContext context) async {
  await FirebaseFirestore.instance
      .collection("workplaces")
      .doc(deleteWorkplace.id.toString())
      .delete();
}

void updateWorkplaceVisibility(int id, bool visible) async {
  await FirebaseFirestore.instance
      .collection("workplaces")
      .doc(id.toString())
      .update({"visible": visible});
}