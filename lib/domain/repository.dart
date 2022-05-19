import 'package:shared_preferences/shared_preferences.dart';
import 'package:todolist/domain/entity.dart';
import 'package:todolist/domain/mapper.dart';

abstract class ActionRepositoryPort {
  // DB의 모든 데이터를 불러옴
  List<Action> load();

  // DB의 기존 데이터를 덮어씀
  void save(List<Action> actions);
}

class ActionRepository implements ActionRepositoryPort {
  final String name = 'acitons';

  final SharedPreferences pref;

  ActionRepository(this.pref);

  @override
  List<Action> load() {
    final str = pref.getString(name) ?? '[]';
    final actions = ActionMapper.actionListFromJson(str);

    return actions;
  }

  @override
  void save(List<Action> actions) {
    final data = ActionMapper.actionListToJson(actions);
    pref.setString(name, data);
  }
}
