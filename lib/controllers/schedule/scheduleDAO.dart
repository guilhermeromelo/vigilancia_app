import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vigilancia_app/models/schedule/scheldule.dart';
import 'package:vigilancia_app/views/shared/constants/appColors.dart';

Future<String> whoIsNextSchedule() async {
  var snapshot = (await FirebaseFirestore.instance
      .collection("schedule")
      .orderBy("id", descending: true)
      .limit(1)
      .get());
  String nextID;
  if (snapshot.docs.isEmpty) {
    nextID = '1';
  } else {
    snapshot.docs.forEach((element) {
      nextID = ((element['id']) + 1).toString();
    });
  }
  return nextID;
}

/*
  SCHEDULE MODEL
  int id;
  DateTime creationdateTime;
  Map workPlacesWithGuards;
  String creatorUser;
 */

Future<String> addSchedule(Schedule newSchedule, BuildContext context) async {
  String idNextSchedule = await whoIsNextSchedule();
  await FirebaseFirestore.instance.collection("schedule").doc(idNextSchedule).set({
    "id": int.parse(idNextSchedule),
    "creatorUser": newSchedule.creatorUser,
    "workPlacesWithGuards": newSchedule.workPlacesWithGuards,
    "creationDateTime": DateTime.now(),
    "scheduleDateTime": newSchedule.scheduleDateTime,
    "note": newSchedule.note,
    "type": newSchedule.type,
    "visible": true
  });
  return idNextSchedule;
}

/*
void updateSchedule(Schedule updateSchedule, BuildContext context) async {
  await FirebaseFirestore.instance
      .collection("schedule")
      .doc(updateSchedule.id.toString())
      .update({
    "workPlacesWithGuards": updateSchedule.workPlacesWithGuards,
  });
}*/


void updateNoteSchedule({Key key, int id, String note, BuildContext context}) async {
  await FirebaseFirestore.instance
      .collection("schedule")
      .doc(id.toString())
      .update({
    "note": note,
  }).then((value) {
    Fluttertoast.showToast(
        msg: "Observações Salvas",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        textColor: Colors.white,
        fontSize: 20,
        backgroundColor: AppColors.mainBlue,
        timeInSecForIosWeb: 3);
  });
}

Future<List<Schedule>> listSchedule() async {
  List<Schedule> scheduleList = List();
  await FirebaseFirestore.instance
      .collection("schedule")
      .get()
      .then((QuerySnapshot querySnapshot) {
    querySnapshot.docs.forEach((element) {
      scheduleList.add(docToSchedule(element));
    });
  });
  return scheduleList;
}

void deleteSchedule(Schedule deleteSchedule, BuildContext context) async {
  await FirebaseFirestore.instance
      .collection("schedule")
      .doc(deleteSchedule.id.toString())
      .delete();
}

void updateScheduleVisibility(int id, bool visible) async {
  await FirebaseFirestore.instance
      .collection("schedule")
      .doc(id.toString())
      .update({"visible": visible});
}