// 할 일 불러오기
import 'package:todolist/domain/entity.dart';
import 'package:todolist/domain/repository.dart';

// Usecase
class ActionUseCase {
  List<Action> actions;

  final ActionRepositoryPort repository;

  ActionUseCase(this.actions, this.repository);

  // 할 일 불러오기
  List<Action> loadActions() {
    return repository.load();
  }

  // 할 일 초기화
  List<Action> initializeActions() {
    final data = actions
        // [Routine]은 그대로
        .map((action) {
          if (action.type == ActionType.routine) {
            action.done = false;
          }

          return action;
        })
        // 완료된 [Task]은 필터링
        .where((action) => action.done == false)
        .toList();

    repository.save(data);

    return data;
  }

  // 할 일 추가
  void addAction(Action action) {
    actions.add(action);
    repository.save(actions);
  }

  // 할 일 제거
  void removeAction(Action action) {
    actions.remove(action);
    repository.save(actions);
  }

  // 할 일 상태 변경
  void updateAction(Action action) {
    action.changeStatus();
    repository.save(actions);
  }
}
