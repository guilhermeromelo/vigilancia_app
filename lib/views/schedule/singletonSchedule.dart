
import 'package:vigilancia_app/models/guard/guard.dart';
import 'package:vigilancia_app/models/schedule/scheldule.dart';

class SingletonSchedule {
  bool isDaytime;
  List<Guard> selectedGuards;
  List<Guard> selectedDoormans;
  List<Map<String, dynamic>> selectedWorkplaces;
  //List<Map<dynamic, dynamic>> selectedWorkplacesWithGuards;
  Schedule schedule;

  static SingletonSchedule _instance;

  factory SingletonSchedule({bool isDaytime, List<Guard> selectedGuards, List<Map<dynamic, dynamic>> selectedWorkplaces, List<Guard> selectedDoormans, /*List<Map<dynamic, dynamic>> selectedWorkplacesWithGuards*/}) {
    if (_instance == null) {
      _instance = SingletonSchedule._internalConstructor(isDaytime, selectedGuards, selectedWorkplaces, selectedDoormans, /*selectedWorkplacesWithGuards*/);
    }
    _instance ?? SingletonSchedule._internalConstructor(isDaytime, selectedGuards, selectedWorkplaces, selectedDoormans, /*selectedWorkplacesWithGuards*/);
    return _instance;
  }
  SingletonSchedule._internalConstructor(this.isDaytime, this.selectedGuards, this.selectedWorkplaces, this.selectedDoormans, /*this.selectedWorkplacesWithGuards*/);
}
