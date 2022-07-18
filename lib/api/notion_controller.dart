import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:todolist/utils/get_today.dart';

const NOTION_TOKEN = 'secret_5AxDZGYZc2c6j6CNeRYtwns1lXQRi7fSgtLxdgcIY4u';
const NOTION_DATABASE_ID = 'a2a5fc5ecc78498da6a3742ff5c6ea1a';

class NotionController {
  Future post(dynamic data) async {
    var uri = Uri.https('api.notion.com', '/v1/pages');
    var header = {
      'Authorization': 'Bearer $NOTION_TOKEN',
      'Content-Type': 'application/json',
      'Notion-Version': '2022-06-28',
    };

    await http.post(
      uri,
      headers: header,
      body: jsonEncode(data),
    );
  }
}

// Create a page
dynamic createPage(List<dynamic> children) {
  return {
    'parent': {'database_id': NOTION_DATABASE_ID},
    'properties': {
      "Date": {"id": getToday()},
    },
    'children': children,
  };
}
