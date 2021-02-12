
class SingletonSchedule {
  bool isDaytime;
  List<int> selectedGuardsID;
  Map<dynamic, dynamic> workplacesMap;

  static SingletonSchedule _instance;

  factory SingletonSchedule({bool isDaytime, List<int> selectedGuardsID, Map<dynamic, dynamic> workplacesMap}) {
    if (_instance == null) {
      _instance = SingletonSchedule._internalConstructor(isDaytime, selectedGuardsID, workplacesMap);
    }
    _instance ?? SingletonSchedule._internalConstructor(isDaytime, selectedGuardsID, workplacesMap);
    return _instance;
  }
  SingletonSchedule._internalConstructor(this.isDaytime, this.selectedGuardsID, this.workplacesMap);
}
