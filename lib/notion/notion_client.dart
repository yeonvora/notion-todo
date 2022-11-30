import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:notion_todo/notion/notion_response.dart';
import 'package:notion_todo/notion/notion_general.dart';

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
  Future<NotionHttpResponse> getPage(NotionProperty property) async {
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

    return NotionHttpResponse.from(response);
  }

  /// 페이지 생성
  Future<NotionHttpResponse> createPage(NotionProperty property, NotionChildren children) async {
    final response = await http.post(
      Uri.https(host, '/$v/pages'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Notion-Version': version,
      },
      body: json.encode({
        "parent": {'database_id': databaseId},
        "properties": property.toJson(),
        "children": children.toJson(),
      }),
    );

    return NotionHttpResponse.from(response);
  }

  /// 페이지 제거
  Future<NotionHttpResponse> removePage(String pageId) async {
    final response = await http.patch(
      Uri.https(host, '/$v/pages/$pageId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Notion-Version': version,
      },
      body: json.encode({"archived": true}),
    );

    return NotionHttpResponse.from(response);
  }
}
