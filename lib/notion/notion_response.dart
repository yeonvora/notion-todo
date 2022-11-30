import 'dart:convert';
import 'package:http/http.dart' show Response;
import 'package:notion_todo/notion/notion_general.dart';

class NotionHttpResponse {
  final String object;

  final int status;

  final NotionPage? page;

  // notion error code
  final String? code;

  // noiton error message
  final String? message;

  const NotionHttpResponse({
    required this.object,
    required this.status,
    this.page,
    this.code,
    this.message,
  });

  factory NotionHttpResponse.from(Response response) {
    final body = json.decode(response.body);
    NotionPage? page;

    /// 만약 요청에 성공하면 페이지 속성을 설정함
    ///
    /// response { object: "database", results: [{ object: "page", id: "45ee8d13" }], ...}
    final List? results = body['results'];
    if (results != null && results.isNotEmpty) {
      page = NotionPage(
        id: results[0]['id'],
        url: results[0]['url'],
        object: results[0]['object'],
        archived: results[0]['archived'],
      );
    }

    return NotionHttpResponse(
      object: body['object'] ?? 'error',
      status: body['status'] ?? response.statusCode,
      code: body['code'],
      message: body['message'],
      page: page,
    );
  }
}
