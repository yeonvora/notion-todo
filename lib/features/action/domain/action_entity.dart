/// Entity
class Action {
  final String type;

  String name;

  bool done;

  Action({
    required this.type,
    required this.name,
    this.done = false,
  });

  void changeStatus() {
    done = !done;
  }
}

/// Enums
class ActionType {
  // 단기적 할 일
  static const String task = 'Task';

  // 정기적 할 일
  static const String routine = 'Routine';
}
