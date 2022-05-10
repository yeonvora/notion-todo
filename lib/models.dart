class Type {
  static const String task = 'Task';
  static const String routine = 'Routine';
}

class IAction extends Comparable {
  String type;

  String name;

  bool done = false;

  IAction({
    required this.type,
    required this.name,
    bool? done,
  });

  void rename(String name) {
    this.name = name;
  }

  void changeStatus() {
    done = !done;
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
