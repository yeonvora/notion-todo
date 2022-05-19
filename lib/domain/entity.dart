class ActionType {
  // 단기적 할 일
  static const String task = 'Task';

  // 정기적 할 일
  static const String routine = 'Routine';
}

class Action extends Comparable {
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

  // Override

  @override
  String toString() {
    return '{name: $name, salary: $done}';
  }

  @override
  int compareTo(other) {
    // 작업이 아직 안 끝났다면 위로
    // 컨텍스트에서 이름은 오름차순으로
    int primary = done.toString().compareTo(other.done.toString());
    int secondary = name.compareTo(other.name);

    if (primary == 0) {
      return secondary;
    }

    return primary;
  }
}
