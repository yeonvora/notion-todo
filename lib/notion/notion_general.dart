import 'package:noti/notion/notion_block.dart';

class NotionProperty {
  final String title;

  final String text;

  const NotionProperty(this.title, this.text);

  Map<String, dynamic> toJson() => {
        title: {
          "title": [
            {
              "text": {"content": text}
            }
          ]
        }
      };
}

class NotionObject {
  final String object;

  final String id;

  final bool archived;

  final String url;

  const NotionObject({
    required this.object,
    required this.id,
    required this.archived,
    required this.url,
  });
}

class NotionChildren {
  final List<NotionBlock> _blocks = [];

  NotionChildren add(NotionBlock block) {
    _blocks.add(block);
    return this;
  }

  NotionChildren addAll(List<NotionBlock> blocks) {
    _blocks.addAll(blocks);
    return this;
  }

  List<Map<String, dynamic>> toJson() => _blocks.map((block) => block.toJson()).toList();
}
