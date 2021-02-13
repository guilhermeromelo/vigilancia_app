
import 'package:vigilancia_app/models/guard/guard.dart';

class SingletonSchedule {
  bool isDaytime;
  List<Guard> selectedGuards;
  List<Guard> selectedDoormans;
  List<Map<dynamic, dynamic>> selectedWorkplaces;

  static SingletonSchedule _instance;

  factory SingletonSchedule({bool isDaytime, List<Guard> selectedGuards, List<Map<dynamic, dynamic>> selectedWorkplaces, List<Guard> selectedDoormans}) {
    if (_instance == null) {
      _instance = SingletonSchedule._internalConstructor(isDaytime, selectedGuards, selectedWorkplaces, selectedDoormans);
    }
    _instance ?? SingletonSchedule._internalConstructor(isDaytime, selectedGuards, selectedWorkplaces, selectedDoormans);
    return _instance;
  }
  SingletonSchedule._internalConstructor(this.isDaytime, this.selectedGuards, this.selectedWorkplaces, this.selectedDoormans);
}
