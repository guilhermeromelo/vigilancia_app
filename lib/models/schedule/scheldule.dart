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
  Map workPlacesWithGuards;
  String creatorUser;

  Schedule(
      {Key key,
      this.creationDateTime,
      this.workPlacesWithGuards,
      this.creatorUser,
      this.id});

  @override
  String toString() {
    return 'Schedule{id: $id, creationdateTime: $creationDateTime, workPlacesWithGuards: $workPlacesWithGuards, creatorUser: $creatorUser}';
  }
}

Schedule docToSchedule(var doc) {
  Schedule schedule = new Schedule();
  schedule.id = doc['id'];
  schedule.creatorUser = doc['creatorUser'];
  schedule.workPlacesWithGuards = doc['workPlacesWithGuards'];

  if (doc['creationDateTime'] != null) {
    Timestamp timestamp = doc['creationDateTime'];
    schedule.creationDateTime = timestamp.toDate();
  } else {
    schedule.creationDateTime = null;
  }

  return schedule;
}
