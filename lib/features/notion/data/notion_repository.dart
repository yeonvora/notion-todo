import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:noti/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:noti/features/notion/domain/notion_entity.dart';
import 'package:noti/features/notion/data/notion_mapper.dart';

// 🟡 Riverpod Dependency
final notionRepositoryProvider = Provider<NotionRepository>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return NotionRepository(prefs);
});

// Interface
abstract class NotionRepositoryPort {
  NotionKey load();
  Future<void> save(NotionKey notion);
}

// Implementation
class NotionRepository implements NotionRepositoryPort {
  final String name = 'notion_key';

  final SharedPreferences pref;

  NotionRepository(this.pref);

  @override
  NotionKey load() {
    final str = pref.getString(name) ?? '{}';
    print(str);
    return NotionMapper.toDomain(str);
  }

  @override
  Future<void> save(NotionKey notion) async {
    final data = NotionMapper.toJson(notion);
    await pref.setString(name, data);
  }
}
