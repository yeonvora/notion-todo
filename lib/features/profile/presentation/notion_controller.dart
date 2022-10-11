import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:noti/features/profile/data/profile_repository.dart';
import 'package:noti/notion/notion_general.dart';
import 'package:noti/utils/get_today.dart';
import 'package:noti/notion/notion_client.dart';
import 'package:noti/notion/notion_block.dart';
import 'package:noti/features/action/domain/action_entity.dart';
import 'package:noti/features/profile/domain/profile_entity.dart';
import 'package:noti/features/profile/domain/profile_service.dart';

typedef NotionState = void;

class NotionController extends StateNotifier<NotionState> {
  final NotionKey key;

  final ProfileUsecase profileUsecase;

  NotionController(
    this.key,
    this.profileUsecase,
  ) : super(null);

  /// 노션 환경 설정
  void configNotion(String token, String databaseId) {
    if (token.isEmpty || databaseId.isEmpty) {
      throw Exception('모두 입력해주세요.');
    }

    profileUsecase.configNotionKey(NotionKey(token: token, databaseId: databaseId));
  }

  /// 노션에 페이지 만들기
  Future<void> createNotionPage(List<Action> actions) async {
    final client = NotionClient(token: key.token, databaseId: key.databaseId);
    final today = getToday('yyyy-MM-dd');

    // [1] 페이지를 이미 생성한 경우 제거
    final page = await client.getPage(NotionProperty('Data', today));
    if (page != null) await client.removePage(page.id);

    // [2] 노션 페이지 콘텐츠 구성
    final contents = NotionChildren()
        .addAll(actions.map((_) => TodoBlock(checked: _.done, text: _.name)).toList());

    // [3] 노션 페이지 생성
    await client.createPage(NotionProperty('Date', today), contents);
  }
}

final notionControllerProvider = StateNotifierProvider<NotionController, NotionState>((ref) {
  final profileRepository = ref.watch(profileRepositoryProvider);
  final profileService = ref.watch(profileServiceProvider);

  final profile = profileRepository.load();

  return NotionController(profile.key, profileService);
});
