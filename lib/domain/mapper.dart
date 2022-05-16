import 'dart:convert';

import 'package:todolist/domain/entity.dart';

class ActionMapper {
  static Action actionFromJson(String str) {
    final data = json.decode(str);
    return Action.fromMap(data);
  }

  static List<Action> actionListFromJson(String str) {
    final dataList = json.decode(str);
    return dataList.map<Action>((data) => Action.fromMap(data)).toList();
  }

  static String actionToJson(Action data) {
    return json.encode(data.toMap());
  }

  static String actionListToJson(List<Action> dataList) {
    return json.encode(dataList.map<Map>((data) => data.toMap()).toList());
  }
}
