import 'dart:math';

import 'package:vigilancia_app/models/guard/guard.dart';
import 'package:vigilancia_app/views/schedule/singletonSchedule.dart';

void sortGuards() {
  SingletonSchedule().selectedWorkplaces.forEach((element) {
    Map<dynamic, dynamic> map = element;
    int doormanQt = map['doormanQt'];
    int guardQt = map['guardQt'];
    Map<dynamic, dynamic> sortedDoormans = new Map();
    Map<dynamic, dynamic> sortedGuards = new Map();

    //SORT AND WRITE DOORMANS -----------------------------------------------------------------------------------------------------------------
    for (int i = 0; i < doormanQt; i++) {
      print("\nDOORMANS--------------------------");

      //SORT THE INDEX OF DOORMANS LIST
      print('tamanho' + SingletonSchedule().selectedDoormans.length.toString());

      int sortIndex;
      if (SingletonSchedule().selectedDoormans.length - 1 == 0) {
        sortIndex = 0;
      } else {
        sortIndex =
            randomNumber(SingletonSchedule().selectedDoormans.length - 1);
      }

      print('Numero Sorteado: ' + sortIndex.toString());
      print('LISTA PORTEIROS ANTES REMOVER: ' +
          SingletonSchedule().selectedDoormans.toString());

      //GET THE SORTED DOORMAN AND REMOVE HIM FROM THE DOORMANS LIST
      Guard selectedDoorman =
          SingletonSchedule().selectedDoormans.elementAt(sortIndex);
      SingletonSchedule()
          .selectedDoormans
          .removeWhere((element) => element.id == selectedDoorman.id);

      print('ELEMENTO RETIRADO: ' + selectedDoorman.toString());
      print('LISTA PORTEIROS DEPOIS REMOVER: ' +
          SingletonSchedule().selectedDoormans.toString());

      //WRITE THE SORTED DOORMAN INTO SCHEDULE SINGLETON
      sortedDoormans.addAll({
        i: {
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
      print('tamanho' + SingletonSchedule().selectedGuards.length.toString());

      int sortIndex;
      if (SingletonSchedule().selectedGuards.length - 1 == 0) {
        sortIndex = 0;
      } else {
        sortIndex = randomNumber(SingletonSchedule().selectedGuards.length - 1);
      }

      print('Numero Sorteado: ' + sortIndex.toString());
      print('LISTA VIGILANTES ANTES REMOVER: ' +
          SingletonSchedule().selectedGuards.toString());

      //GET THE SORTED DOORMAN AND REMOVE HIM FROM THE DOORMANS LIST
      Guard selectedGuard =
          SingletonSchedule().selectedGuards.elementAt(sortIndex);
      SingletonSchedule()
          .selectedGuards
          .removeWhere((element) => element.id == selectedGuard.id);

      print('ELEMENTO RETIRADO: ' + selectedGuard.toString());
      print('LISTA VIGILANTES DEPOIS REMOVER: ' +
          SingletonSchedule().selectedGuards.toString());

      //WRITE THE SORTED DOORMAN INTO SCHEDULE SINGLETON
      sortedGuards.addAll({
        i: {
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
}

int randomNumber(int max) {
  Random randomNumber = new Random();
  return randomNumber.nextInt(max);
}
