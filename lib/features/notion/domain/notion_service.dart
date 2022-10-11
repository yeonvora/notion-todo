import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:noti/features/notion/domain/notion_entity.dart';
import 'package:noti/features/notion/data/notion_repository.dart';

// 🟡 Riverpod Dependency
final notionServiceProvider = Provider<NotionKeyUsecase>((ref) {
  final repository = ref.watch(notionRepositoryProvider);
  return NotionKeyService(repository);
});

/// Interface
abstract class NotionKeyUsecase {
  // 노션 설정 가져오기
  NotionKey getNotionKey();

  // 노션 환경 설정
  void configNotionKey(NotionKey key);
}

// Implementation
class NotionKeyService implements NotionKeyUsecase {
  final NotionRepositoryPort _repository;

  NotionKeyService(this._repository);

  @override
  NotionKey getNotionKey() {
    return _repository.load();
  }

  @override
  void configNotionKey(NotionKey key) {
    _repository.save(key);
  }
}
