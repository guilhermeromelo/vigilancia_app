import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vigilancia_app/controllers/schedule/scheduleDAO.dart';
import 'package:vigilancia_app/models/guard/guard.dart';
import 'package:vigilancia_app/models/schedule/scheldule.dart';
import 'package:vigilancia_app/views/schedule/singletonSchedule.dart';

void sortGuards(
    {Key key, String creator, DateTime date, BuildContext context, int type}) {
  List<Guard> _singletonDoormans = new List();
  _singletonDoormans.clear();
  _singletonDoormans.addAll(SingletonSchedule().selectedDoormans);
  List<Guard> _singletonGuards = new List();
  _singletonGuards.clear();
  _singletonGuards.addAll(SingletonSchedule().selectedGuards);

  List<Map<String, dynamic>> _selectedWorkplacesWithGuards =
      SingletonSchedule().selectedWorkplaces;

  _selectedWorkplacesWithGuards.forEach((element) {
    Map<String, dynamic> _map = element;
    int doormanQt = _map['doormanQt'];
    int guardQt = _map['guardQt'];

    Map<String, dynamic> _sortedDoormans = new Map();
    Map<String, dynamic> _sortedGuards = new Map();

    //SORT AND WRITE DOORMANS -----------------------------------------------------------------------------------------------------------------
    for (int i = 0; i < doormanQt; i++) {
      //print("\nDOORMANS--------------------------");

      //SORT THE INDEX OF DOORMANS LIST
      //print('tamanho' + _singletonDoormans.length.toString());

      int sortIndex;
      if (_singletonDoormans.length - 1 == 0) {
        sortIndex = 0;
      } else {
        sortIndex = randomNumber(_singletonDoormans.length);
      }

      //print('Numero Sorteado: ' + sortIndex.toString());
      //print('LISTA PORTEIROS ANTES REMOVER: ' + _singletonDoormans.toString());

      //GET THE SORTED DOORMAN AND REMOVE HIM FROM THE DOORMANS LIST
      Guard selectedDoorman = _singletonDoormans.elementAt(sortIndex);
      _singletonDoormans
          .removeWhere((element) => element.id == selectedDoorman.id);

      //print('ELEMENTO RETIRADO: ' + selectedDoorman.toString());
      //print('LISTA PORTEIROS DEPOIS REMOVER: ' + _singletonDoormans.toString());

      //WRITE THE SORTED DOORMAN INTO SCHEDULE SINGLETON
      _sortedDoormans.addAll({
        i.toString(): {
          'id': selectedDoorman.id,
          'name': selectedDoorman.name,
          'cpf': selectedDoorman.cpf,
          'type': selectedDoorman.type
        }
      });

      //print("\nDOORMANS--------------------------");
    }

    //SORT AND WRITE GUARDS ------------------------------------------------------------------------------------------------------------------------
    for (int i = 0; i < guardQt; i++) {
      //print("\nGUARDS--------------------------");

      //SORT THE INDEX OF DOORMANS LIST
      //print('tamanho' + _singletonGuards.length.toString());

      int sortIndex;
      if (_singletonGuards.length - 1 == 0) {
        sortIndex = 0;
      } else {
        sortIndex = randomNumber(_singletonGuards.length);
      }

      //print('Numero Sorteado: ' + sortIndex.toString());
      //print('LISTA VIGILANTES ANTES REMOVER: ' + _singletonGuards.toString());

      //GET THE SORTED DOORMAN AND REMOVE HIM FROM THE DOORMANS LIST
      Guard _selectedGuard = _singletonGuards.elementAt(sortIndex);
      _singletonGuards.removeWhere((element) => element.id == _selectedGuard.id);

      //print('ELEMENTO RETIRADO: ' + _selectedGuard.toString());
      //print('LISTA VIGILANTES DEPOIS REMOVER: ' + _singletonGuards.toString());

      //WRITE THE SORTED DOORMAN INTO SCHEDULE SINGLETON
      _sortedGuards.addAll({
        i.toString(): {
          'id': _selectedGuard.id,
          'name': _selectedGuard.name,
          'cpf': _selectedGuard.cpf,
          'type': _selectedGuard.type
        }
      });

      //print("\nGUARDS--------------------------");
    }
    element.addAll({'guards': _sortedGuards});
    element.addAll({'doormans': _sortedDoormans});
  });

  Map<String, dynamic> scheduleData = {};
  int _i = 0;
  _selectedWorkplacesWithGuards.forEach((element) {
    Map<String, dynamic> workplace = {};
    workplace['id'] = element['id'];
    workplace['name'] = element['name'];
    workplace['type'] = element['type'];
    workplace['guardQt'] = element['guardQt'];
    workplace['doormanQt'] = element['doormanQt'];
    workplace['guards'] = element['guards'];
    workplace['doormans'] = element['doormans'];
    scheduleData[_i.toString()] = workplace;
    _i++;
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
