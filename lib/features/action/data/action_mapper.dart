import 'dart:convert';
import 'package:notion_todo/features/action/domain/action_entity.dart';

class ActionMapper {
  static String toJson(Action domain) {
    return json.encode({
      "type": domain.type,
      "name": domain.name,
      "done": domain.done,
    });
  }

  static String toJsonList(List<Action> domainList) {
    return json.encode(domainList.map((domain) => toJson(domain)).toList());
  }

  static Action toDomain(String str) {
    final dynamic data = json.decode(str);
    return Action(
      type: data["type"],
      name: data["name"],
      done: data["done"],
    );
  }

  static List<Action> toDomainList(String str) {
    final List<dynamic> dataList = json.decode(str);
    return dataList.map((data) => toDomain(data)).toList();
  }
}
