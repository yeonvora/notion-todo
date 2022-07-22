import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:todolist/notion/notion_config.dart';

/// [Notion API Reference](https://developers.notion.com/reference)
class NotionAPI {
  static const domain = 'api.notion.com';

  static final header = {
    'Authorization': 'Bearer $NOTION_TOKEN',
    'Content-Type': 'application/json',
    'Notion-Version': '2022-06-28',
  };

  Future<void> createPage(String title, List<dynamic> children) async {
    final uri = Uri.https(domain, '/v1/pages');

    await http.post(
      uri,
      headers: header,
      body: json.encode({
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

  Future<void> removePage(String pageId) async {
    final uri = Uri.https(domain, '/v1/pages/$pageId');

    await http.patch(
      uri,
      headers: header,
      body: json.encode({"archived": true}),
    );
  }

  Future<List> getPages(String pageName) async {
    final uri = Uri.https(domain, '/v1/databases/$NOTION_DATABASE_ID/query');

    final response = await http.post(
      uri,
      headers: header,
      body: json.encode({
        "filter": {
          "or": [
            {
              "property": "Date",
              "title": {"equals": pageName}
            }
          ]
        }
      }),
    );

    // response: { object: 'database', results: [], ...}
    return json.decode(response.body)['results'];
  }
}
