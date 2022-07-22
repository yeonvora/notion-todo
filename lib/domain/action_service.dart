import 'package:todolist/domain/action_entity.dart';
import 'package:todolist/domain/action_repository.dart';

/// Interface
abstract class ActionUsecase {
  // 할 일 가져오기
  List<Action> getActions();

  // 할 일 추가
  void addAction(Action action);

  // 할 일 제거
  void removeAction(Action action);

  // 할 일 상태 변경
  void updateAction(Action action);

  // 할 일 초기화
  List<Action> initializeActions();
}

// Implementation
class ActionService implements ActionUsecase {
  final ActionRepositoryPort _repository;

  ActionService(this._repository);

  @override
  List<Action> getActions() {
    return _repository.load();
  }

  @override
  void addAction(Action action) {
    final actions = getActions();
    actions.add(action);

    _repository.save(actions);
  }

  @override
  void removeAction(Action action) {
    final actions = getActions();
    actions.removeWhere((a) => a.name == action.name);

    _repository.save(actions);
  }

  @override
  void updateAction(Action action) {
    final actions = getActions();
    for (var a in actions) {
      if (a.name == action.name) a.changeStatus();
    }

    _repository.save(actions);
  }

  @override
  List<Action> initializeActions() {
    final actions = getActions();

    final initialize = actions
        // [Routine]은 상태 초기화
        .map((action) {
          if (action.type == ActionType.routine) action.done = false;
          return action;
        })
        // [Task]는 완료했다면 필터링
        .where((action) => action.done == false)
        .toList();

    _repository.save(initialize);

    return initialize;
  }
}
