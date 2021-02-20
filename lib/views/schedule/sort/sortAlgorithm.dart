import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vigilancia_app/controllers/schedule/scheduleDAO.dart';
import 'package:vigilancia_app/models/guard/guard.dart';
import 'package:vigilancia_app/models/schedule/scheldule.dart';
import 'package:vigilancia_app/views/schedule/singletonSchedule.dart';

void sortGuards(
    {Key key, String creator, DateTime date, BuildContext context, int type}) {
  List<Guard> singletonDoormans = new List();
  singletonDoormans.clear();
  singletonDoormans.addAll(SingletonSchedule().selectedDoormans);
  List<Guard> singletonGuards = new List();
  singletonGuards.clear();
  singletonGuards.addAll(SingletonSchedule().selectedGuards);

  List<Map<String, dynamic>> selectedWorkplacesWithGuards =
      SingletonSchedule().selectedWorkplaces;

  selectedWorkplacesWithGuards.forEach((element) {
    Map<String, dynamic> map = element;
    int doormanQt = map['doormanQt'];
    int guardQt = map['guardQt'];

    Map<String, dynamic> sortedDoormans = new Map();
    Map<String, dynamic> sortedGuards = new Map();

    //SORT AND WRITE DOORMANS -----------------------------------------------------------------------------------------------------------------
    for (int i = 0; i < doormanQt; i++) {
      print("\nDOORMANS--------------------------");

      //SORT THE INDEX OF DOORMANS LIST
      print('tamanho' + singletonDoormans.length.toString());

      int sortIndex;
      if (singletonDoormans.length - 1 == 0) {
        sortIndex = 0;
      } else {
        sortIndex = randomNumber(singletonDoormans.length);
      }

      print('Numero Sorteado: ' + sortIndex.toString());
      print('LISTA PORTEIROS ANTES REMOVER: ' + singletonDoormans.toString());

      //GET THE SORTED DOORMAN AND REMOVE HIM FROM THE DOORMANS LIST
      Guard selectedDoorman = singletonDoormans.elementAt(sortIndex);
      singletonDoormans
          .removeWhere((element) => element.id == selectedDoorman.id);

      print('ELEMENTO RETIRADO: ' + selectedDoorman.toString());
      print('LISTA PORTEIROS DEPOIS REMOVER: ' + singletonDoormans.toString());

      //WRITE THE SORTED DOORMAN INTO SCHEDULE SINGLETON
      sortedDoormans.addAll({
        i.toString(): {
          'id': selectedDoorman.id,
          'name': selectedDoorman.name,
          'cpf': selectedDoorman.cpf,
          'type': selectedDoorman.type
        }
      });

      print("\nDOORMANS--------------------------");
    }

    //SORT AND WRITE GUARDS ------------------------------------------------------------------------------------------------------------------------
    for (int i = 0; i < guardQt; i++) {
      print("\nGUARDS--------------------------");

      //SORT THE INDEX OF DOORMANS LIST
      print('tamanho' + singletonGuards.length.toString());

      int sortIndex;
      if (singletonGuards.length - 1 == 0) {
        sortIndex = 0;
      } else {
        sortIndex = randomNumber(singletonGuards.length);
      }

      print('Numero Sorteado: ' + sortIndex.toString());
      print('LISTA VIGILANTES ANTES REMOVER: ' + singletonGuards.toString());

      //GET THE SORTED DOORMAN AND REMOVE HIM FROM THE DOORMANS LIST
      Guard selectedGuard = singletonGuards.elementAt(sortIndex);
      singletonGuards.removeWhere((element) => element.id == selectedGuard.id);

      print('ELEMENTO RETIRADO: ' + selectedGuard.toString());
      print('LISTA VIGILANTES DEPOIS REMOVER: ' + singletonGuards.toString());

      //WRITE THE SORTED DOORMAN INTO SCHEDULE SINGLETON
      sortedGuards.addAll({
        i.toString(): {
          'id': selectedGuard.id,
          'name': selectedGuard.name,
          'cpf': selectedGuard.cpf,
          'type': selectedGuard.type
        }
      });

      print("\nGUARDS--------------------------");
    }
    element.addAll({'guards': sortedGuards});
    element.addAll({'doormans': sortedDoormans});
  });

  Map<String, dynamic> scheduleData = {};
  int i = 0;
  selectedWorkplacesWithGuards.forEach((element) {
    Map<String, dynamic> workplace = {};
    workplace['id'] = element['id'];
    workplace['name'] = element['name'];
    workplace['type'] = element['type'];
    workplace['guardQt'] = element['guardQt'];
    workplace['doormanQt'] = element['doormanQt'];
    workplace['guards'] = element['guards'];
    workplace['doormans'] = element['doormans'];
    scheduleData[i.toString()] = workplace;
    i++;
  });

  Schedule newSchedule = Schedule(
      id: 0,
      scheduleDateTime: date,
      creatorUser: creator,
      workPlacesWithGuards: scheduleData,
      note: "123",
      creationDateTime: DateTime.now(),
  type: type);

  saveDataInFirebase(context: context, schedule: newSchedule);
}

void saveDataInFirebase({Key key, Schedule schedule, BuildContext context}) async {
  SingletonSchedule().schedule = schedule;
  String id = await addSchedule(schedule, context);
  SingletonSchedule().schedule.id = int.parse(id);
  print("RESULTADO... " +
      SingletonSchedule().schedule.workPlacesWithGuards.toString());
}

int randomNumber(int max) {
  Random randomNumber = new Random();
  return randomNumber.nextInt(max);
}
