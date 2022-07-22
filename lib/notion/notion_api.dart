import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:todolist/notion/notion_config.dart';

// Notion API Reference
// https://developers.notion.com/reference
class NotionAPI {
  static final header = {
    'Authorization': 'Bearer $NOTION_TOKEN',
    'Content-Type': 'application/json',
    'Notion-Version': '2022-06-28',
  };

  Future<void> createPage(String title, List<dynamic> children) async {
    final uri = Uri.https('api.notion.com', '/v1/pages');

    await http
        .post(
          uri,
          headers: header,
          body: jsonEncode({
            "parent": {"database_id": NOTION_DATABASE_ID},
            "properties": {
              "Date": {
                "title": [
                  {
                    "text": {"content": title}
                  }
                ]
              }
            },
            "children": children
          }),
        )
        .then((value) => print('fdas ${value.body}'));
  }

  Future<void> removePage(String pageId) async {
    final uri = Uri.https('api.notion.com', '/v1/pages/$pageId');

    await http.patch(
      uri,
      headers: header,
      body: jsonEncode({"archived": true}),
    );
  }
}
