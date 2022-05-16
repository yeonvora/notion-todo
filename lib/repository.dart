import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todolist/domain/entity.dart';

// 내장 저장소
class ActionRepository {
  final _key = 'actions';

  final SharedPreferences sharedPreferences;

  ActionRepository(this.sharedPreferences);

  List<Action> find() {
    final actions = sharedPreferences.getString(_key) ?? '[]' as dynamic;
    final data = actions.map((a) => Action.fromMap(a)).toList();

    return json.decode(data);
  }

  void save(List<Action> actions) {
    final data = actions.map((a) => a.toMap()).toList();

    sharedPreferences.setString(_key, json.encode(data));

    print('Saved it!');
  }

  void remove() {
    sharedPreferences.remove(_key);

    print('Removed it!');
  }
}
