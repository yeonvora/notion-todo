import 'dart:convert';
import 'package:http/http.dart' as http;

dynamic checkboxBlock(String name, bool? checked) {
  return {
    "object": "block",
    "type": "to_do",
    "to_do": {
      "checked": checked,
      "rich_text": [
        {
          "type": "text",
          "text": {
            "content": name,
          }
        }
      ],
    }
  };
}

class NotionController {
  static const NOTION_TOKEN =
      'secret_MFqkmKim7tBj2GIt8i51TKJp9jQYSua26OCi8tscq9v';

  static const NOTION_DATABASE_ID = 'b781cb7b15a6401e898ade5b38ef2504';

  Future request(dynamic data) async {
    var uri = Uri.https('api.notion.com', '/v1/pages');
    var header = {
      'Authorization': 'Bearer $NOTION_TOKEN',
      'Content-Type': 'application/json',
      'Notion-Version': '2022-02-22',
    };

    await http.post(uri, headers: header, body: jsonEncode(data));
  }

  Future createPage(String title, List<dynamic> children) async {
    var data = {
      'parent': {'database_id': NOTION_DATABASE_ID},
      'properties': {
        "Date": {
          "title": [
            {
              "text": {"content": title}
            }
          ]
        },
      },
      'children': children,
    };

    await request(data);
  }
}
