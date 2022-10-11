import 'dart:convert';
import 'package:noti/features/notion/domain/notion_entity.dart';

class NotionMapper {
  static String toJson(NotionKey domain) {
    return json.encode({
      "token": domain.token,
      "databaseId": domain.databaseId,
    });
  }

  static NotionKey toDomain(String str) {
    final dynamic data = json.decode(str);
    return NotionKey(
      token: data["token"],
      databaseId: data["database_id"],
    );
  }
}
