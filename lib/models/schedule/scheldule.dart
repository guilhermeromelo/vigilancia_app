import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/*
workPlacesWithGuards{
  workplace: "Portaria Principal",
  users: {
            [0] : Porteiro 1,
            [1] : Vigilante 3,
            [2] : Vigilante 1
         }
}
 */

class Schedule {
  int id;
  DateTime creationDateTime;
  DateTime scheduleDateTime;
  Map<String, dynamic> workPlacesWithGuards;
  String creatorUser;
  String note;
  int type; //0 - day, 1 - night

  Schedule(
      {Key key,
      this.creationDateTime,
      this.workPlacesWithGuards,
      this.creatorUser,
      this.scheduleDateTime,
      this.note,
      this.type,
      this.id});

  @override
  String toString() {
    return 'Schedule{id: $id, creationDateTime: $creationDateTime, scheduleDateTime: $scheduleDateTime, workPlacesWithGuards: $workPlacesWithGuards, creatorUser: $creatorUser, note: $note, type: $type}';
  }
}

Schedule docToSchedule(var doc) {
  Schedule schedule = new Schedule();
  schedule.id = doc['id'];
  schedule.creatorUser = doc['creatorUser'];
  schedule.workPlacesWithGuards = doc['workPlacesWithGuards'];
  schedule.note = doc['note'];
  schedule.type = doc['type'];

  if (doc['creationDateTime'] != null) {
    Timestamp timestamp = doc['creationDateTime'];
    schedule.creationDateTime = timestamp.toDate();
  } else {
    schedule.creationDateTime = null;
  }

  if (doc['scheduleDateTime'] != null) {
    Timestamp timestamp = doc['scheduleDateTime'];
    schedule.scheduleDateTime = timestamp.toDate();
  } else {
    schedule.scheduleDateTime = null;
  }

  return schedule;
}
