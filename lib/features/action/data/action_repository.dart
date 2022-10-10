import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:noti/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:noti/features/action/domain/action_entity.dart';
import 'package:noti/features/action/data/action_mapper.dart';

// 🟡 Riverpod Dependency
final actionRepositoryProvider = Provider<ActionRepository>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ActionRepository(prefs);
});

// Interface
abstract class ActionRepositoryPort {
  // DB의 모든 데이터를 불러옴
  List<Action> load();

  // DB의 기존 데이터를 덮어씀
  void save(List<Action> actions);
}

// Implementation
class ActionRepository implements ActionRepositoryPort {
  final String name = 'acitons';

  final SharedPreferences pref;

  ActionRepository(this.pref);

  @override
  List<Action> load() {
    final str = pref.getString(name) ?? '[]';
    final actions = ActionMapper.toDomainList(str);

    return actions;
  }

  @override
  void save(List<Action> actions) {
    final data = ActionMapper.toJsonList(actions);
    pref.setString(name, data);
  }
}
