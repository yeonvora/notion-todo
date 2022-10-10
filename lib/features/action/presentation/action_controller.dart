import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:noti/features/action/domain/action_entity.dart';
import 'package:noti/features/action/domain/action_service.dart';
import 'package:noti/utils/synchronize_notion_page.dart';

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
    actionUsecase.addAction(action);
    state = actionUsecase.getActions();
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

  /// 노션 동기화
  Future<void> synchronizeAction() async {
    if (state.isEmpty) return;

    // 완료될 때까지 기다림
    await Future.wait([createNotionPage(state)]);

    actionUsecase.initializeActions();
    state = actionUsecase.getActions();
  }
}

final actionControllerProvider = StateNotifierProvider<ActionController, ActionState>((ref) {
  return ActionController(ref.watch(actionServiceProvider));
});
