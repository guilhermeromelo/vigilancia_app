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
  DateTime creationdateTime;
  Map workPlacesWithGuards;
  String creatorUser;

  Schedule(
      {Key key,
      this.creationdateTime,
      this.workPlacesWithGuards,
      this.creatorUser});

  @override
  String toString() {
    return 'Schedule{creationdateTime: $creationdateTime, workPlacesWithGuards: $workPlacesWithGuards, creatorUser: $creatorUser}';
  }
}
