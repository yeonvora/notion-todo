import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:noti/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:noti/features/profile/domain/profile_entity.dart';
import 'package:noti/features/profile/data/profile_mapper.dart';

// 🟡 Riverpod Dependency
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ProfileRepository(prefs);
});

// Interface
abstract class ProfileRepositoryPort {
  Profile load();
  Future<void> save(Profile profile);
}

// Implementation
class ProfileRepository implements ProfileRepositoryPort {
  final String name = 'profile';

  final SharedPreferences pref;

  ProfileRepository(this.pref);

  @override
  Profile load() {
    final str = pref.getString(name) ?? '{}';
    return ProfileMapper.toDomain(str);
  }

  @override
  Future<void> save(Profile profile) async {
    final data = ProfileMapper.toJson(profile);
    await pref.setString(name, data);
  }
}
