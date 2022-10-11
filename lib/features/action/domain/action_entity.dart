/// Entity
class Action {
  final String type;

  final String name;

  bool done;

  Action({
    final String? type,
    final String? name,
    final bool? done,
  })  : type = type ?? ActionType.task,
        name = name ?? '할 일',
        done = done ?? false;

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
