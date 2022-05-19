class ActionType {
  // 단기적 할 일
  static const String task = 'Task';

  // 정기적 할 일
  static const String routine = 'Routine';
}

class Action {
  final String type;

  String name;

  bool done;

  Action({
    required this.type,
    required this.name,
    this.done = false,
  });

  // Events

  void changeStatus() {
    done = !done;
  }

  // Generate

  factory Action.fromMap(Map<String, dynamic> json) => Action(
        type: json["type"],
        name: json["name"],
        done: json["done"],
      );

  Map<String, dynamic> toMap() => {
        "type": type,
        "name": name,
        "done": done,
      };
}
