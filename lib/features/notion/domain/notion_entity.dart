/// Entity
class NotionKey {
  final String token;

  final String databaseId;

  const NotionKey({
    final String? token,
    final String? databaseId,
  })  : token = token ?? '',
        databaseId = databaseId ?? '';
}
