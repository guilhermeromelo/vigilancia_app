
class SingletonSchedule {
  bool isDaytime;

  static SingletonSchedule _instance;

  factory SingletonSchedule({bool isDaytime}) {
    if (_instance == null) {
      _instance = SingletonSchedule._internalConstructor(isDaytime);
    }
    _instance ?? SingletonSchedule._internalConstructor(isDaytime);
    return _instance;
  }
  SingletonSchedule._internalConstructor(this.isDaytime);
}
