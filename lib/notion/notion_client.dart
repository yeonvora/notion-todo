import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:noti/notion/notion_general.dart';

/// [Notion API Reference](https://developers.notion.com/reference)

class NotionLocation {
  static const String host = 'api.notion.com';

  static const String apiVersion = 'v1';

  static const String notionVersion = '2022-06-28';
}

class NotionClient {
  final String token;

  final String databaseId;

  final String host = NotionLocation.host;

  final String v = NotionLocation.apiVersion;

  final String version = NotionLocation.notionVersion;

  NotionClient({
    required this.token,
    required this.databaseId,
  });

  /// 페이지 검색
  Future<NotionObject?> getPage(NotionProperty property) async {
    if (databaseId.isEmpty) throw Exception('No databaseId');

    final response = await http.post(
      Uri.https(host, '/$v/databases/$databaseId/query'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Notion-Version': version,
      },
      body: json.encode({
        "filter": {
          "property": property.title,
          "title": {"equals": property.text}
        }
      }),
    );

    // response { object: "database", results: [{ object: "page", id: "45ee8d13" }], ...}
    final results = json.decode(response.body)['results'];

    if (results == null) return null;

    return NotionObject(
      id: results[0]['id'],
      url: results[0]['url'],
      object: results[0]['object'],
      archived: results[0]['archived'],
    );
  }

  /// 페이지 생성
  Future<void> createPage(NotionProperty property, NotionChildren children) async {
    final body = json.encode({
      "parent": {'database_id': databaseId},
      "properties": property.toJson(),
      "children": children.toJson(),
    });

    await http.post(
      Uri.https(host, '/$v/pages'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Notion-Version': version,
      },
      body: body,
    );
  }

  /// 페이지 제거
  Future<void> removePage(String pageId) async {
    await http.patch(
      Uri.https(host, '/$v/pages/$pageId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Notion-Version': version,
      },
      body: json.encode({"archived": true}),
    );
  }
}
