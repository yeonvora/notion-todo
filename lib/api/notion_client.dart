import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:noti/api/notion_config.dart';

/// [Notion API Reference](https://developers.notion.com/reference)

class NotionClient {
  final String token;

  final String databaseId;

  NotionClient({
    required this.token,
    required this.databaseId,
  });

  static const host = 'api.notion.com';

  static final header = {
    'Authorization': 'Bearer $NOTION_TOKEN',
    'Content-Type': 'application/json',
    'Notion-Version': '2022-06-28',
  };

  Future<List> getPages(String pageName) async {
    final uri = Uri.https(host, '/v1/databases/$databaseId/query');

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

  Future<void> createPage(String title, List<dynamic> children) async {
    final uri = Uri.https(host, '/v1/pages');

    await http.post(
      uri,
      headers: header,
      body: json.encode({
        "parent": {"database_id": databaseId},
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
    final uri = Uri.https(host, '/v1/pages/$pageId');

    await http.patch(
      uri,
      headers: header,
      body: json.encode({"archived": true}),
    );
  }
}
