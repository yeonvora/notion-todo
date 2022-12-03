import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:notion_todo/features/action/domain/action_entity.dart';
import 'package:notion_todo/features/action/domain/action_service.dart';

typedef ActionState = List<Action>;

class ActionController extends StateNotifier<ActionState> {
  final ActionUsecase actionUsecase;

  ActionController(this.actionUsecase) : super([]) {
    loadActions();
  }

  /// 할 일 불러오기
  void loadActions() {
    state = actionUsecase.getActions();
  }

  /// 할 일 추가
  void addAction(Action action) {
    final actions = actionUsecase.getActions();

    // 이미 동일한 액션을 추가한 경우 요청 무시
    final doesActionExists = actions.any((a) => a.name == action.name);
    if (doesActionExists) return;

    actionUsecase.addAction(action);
    actions.add(action);

    state = actions;
  }

  /// 할 일 완료
  void doneAction(Action action) {
    actionUsecase.updateAction(action);
    state = actionUsecase.getActions();
  }

  /// 할 일 제거
  void removeAction(Action action) {
    actionUsecase.removeAction(action);
    state = actionUsecase.getActions();
  }

  /// 할 일 초기화
  Future<void> initializeActions() async {
    actionUsecase.initializeActions();
    state = actionUsecase.getActions();
  }
}

final actionControllerProvider = StateNotifierProvider<ActionController, ActionState>((ref) {
  return ActionController(ref.watch(actionServiceProvider));
});
