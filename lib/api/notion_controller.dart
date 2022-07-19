import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:todolist/config/config.dart';

class NotionController {
  static final header = {
    'Authorization': 'Bearer $NOTION_TOKEN',
    'Content-Type': 'application/json',
    'Notion-Version': '2022-06-28',
  };

  Future createPage({
    required String title,
    required List<dynamic> children,
  }) async {
    final uri = Uri.https('api.notion.com', '/v1/pages');

    await http.post(
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
    );
  }
}
