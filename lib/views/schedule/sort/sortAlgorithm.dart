import 'dart:math';

import 'package:vigilancia_app/models/guard/guard.dart';
import 'package:vigilancia_app/views/schedule/singletonSchedule.dart';

void sortGuards() {
  List<Guard> singletonDoormans = new List();
  singletonDoormans.clear();
  singletonDoormans.addAll(SingletonSchedule().selectedDoormans);
  List<Guard> singletonGuards = new List();
  singletonGuards.clear();
  singletonGuards.addAll(SingletonSchedule().selectedGuards);

  SingletonSchedule().selectedWorkplacesWithGuards = SingletonSchedule().selectedWorkplaces;
  SingletonSchedule().selectedWorkplacesWithGuards.forEach((element) {
    Map<dynamic, dynamic> map = element;
    int doormanQt = map['doormanQt'];
    int guardQt = map['guardQt'];

    Map<dynamic, dynamic> sortedDoormans = new Map();
    Map<dynamic, dynamic> sortedGuards = new Map();


    //SORT AND WRITE DOORMANS -----------------------------------------------------------------------------------------------------------------
    for (int i = 0; i < doormanQt; i++) {
      print("\nDOORMANS--------------------------");

      //SORT THE INDEX OF DOORMANS LIST
      print('tamanho' + singletonDoormans.length.toString());

      int sortIndex;
      if (singletonDoormans.length - 1 == 0) {
        sortIndex = 0;
      } else {
        sortIndex =
            randomNumber(singletonDoormans.length);
      }

      print('Numero Sorteado: ' + sortIndex.toString());
      print('LISTA PORTEIROS ANTES REMOVER: ' +
          singletonDoormans.toString());

      //GET THE SORTED DOORMAN AND REMOVE HIM FROM THE DOORMANS LIST
      Guard selectedDoorman =
          singletonDoormans.elementAt(sortIndex);
      singletonDoormans
          .removeWhere((element) => element.id == selectedDoorman.id);

      print('ELEMENTO RETIRADO: ' + selectedDoorman.toString());
      print('LISTA PORTEIROS DEPOIS REMOVER: ' +
          singletonDoormans.toString());

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
      print('tamanho' + singletonGuards.length.toString());

      int sortIndex;
      if (singletonGuards.length - 1 == 0) {
        sortIndex = 0;
      } else {
        sortIndex = randomNumber(singletonGuards.length);
      }

      print('Numero Sorteado: ' + sortIndex.toString());
      print('LISTA VIGILANTES ANTES REMOVER: ' +
          singletonGuards.toString());

      //GET THE SORTED DOORMAN AND REMOVE HIM FROM THE DOORMANS LIST
      Guard selectedGuard =
          singletonGuards.elementAt(sortIndex);
      singletonGuards
          .removeWhere((element) => element.id == selectedGuard.id);

      print('ELEMENTO RETIRADO: ' + selectedGuard.toString());
      print('LISTA VIGILANTES DEPOIS REMOVER: ' +
          singletonGuards.toString());

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


  print("RESULTADO... " + SingletonSchedule().selectedWorkplacesWithGuards.toString());

}

int randomNumber(int max) {
  Random randomNumber = new Random();
  return randomNumber.nextInt(max);
}
