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
  List<Action> load();
  // DB의 기존 데이터를 덮어씀
  Future<void> save(List<Action> actions);
}

// Implementation
class ActionRepository implements ActionRepositoryPort {
  final String name = 'acitons';

  final SharedPreferences pref;

  ActionRepository(this.pref);

  @override
  List<Action> load() {
    final str = pref.getString(name) ?? '[]';
    return ActionMapper.toDomainList(str);
  }

  @override
  Future<void> save(List<Action> actions) async {
    final data = ActionMapper.toJsonList(actions);
    await pref.setString(name, data);
  }
}
