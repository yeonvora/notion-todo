abstract class NotionBlock {
  Map<String, dynamic> toJson();
}

class TodoBlock implements NotionBlock {
  final bool checked;

  final String text;

  const TodoBlock({
    required this.checked,
    required this.text,
  });

  @override
  Map<String, dynamic> toJson() => {
        "object": "block",
        "type": "to_do",
        "to_do": {
          "checked": checked,
          "rich_text": [
            {
              "type": "text",
              "text": {"content": text}
            }
          ],
        },
      };
}

class DividerBlock implements NotionBlock {
  const DividerBlock();

  @override
  Map<String, dynamic> toJson() {
    return {
      "object": "block",
      "type": "divider",
      "divider": {},
    };
  }
}
