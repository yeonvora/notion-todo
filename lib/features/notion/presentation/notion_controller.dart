import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:noti/features/notion/domain/notion_service.dart';
import 'package:noti/utils/get_today.dart';
import 'package:noti/api/notion_api.dart';
import 'package:noti/api/notion_block.dart';
import 'package:noti/features/action/domain/action_entity.dart';
import 'package:noti/features/notion/domain/notion_entity.dart';

typedef NotionState = void;

class NotionController extends StateNotifier<NotionState> {
  final NotionKeyUsecase notionUsecase;

  NotionController(this.notionUsecase) : super(null);

  /// 노션 환경 설정
  void configNotion(String token, String databaseId) {
    if (token.isEmpty || databaseId.isEmpty) {
      throw Exception('모두 입력해주세요.');
    }

    notionUsecase.configNotionKey(NotionKey(token: token, databaseId: databaseId));
  }

  void s() {
    final a = notionUsecase.getNotionKey();
    print(a);
  }

  /// 노션에 페이지 생성
  ///
  /// 페이지를 이미 생성한 경우 제거.
  /// why. 노션은 아직 블록 단위 업데이트를 지원 안함
  /// 따라서 Action을 추가한 경우 전체 페이지를 업데이트함
  Future<void> createNotionPage(List<Action> actions) async {
    final notion = NotionAPI(
      token: '',
      databaseId: '',
    );

    final today = getToday('yyyy-MM-dd');
    final pages = await notion.getPages(today);
    if (pages.isNotEmpty) {
      await notion.removePage(pages[0]['id'] as String);
    }

    // 블록 형식에 맞게 구체화
    List<dynamic> actionBlocks(String type, List<Action> actions) =>
        actions.where((_) => _.type == type).map((_) => checkboxBlock(_.name, _.done)).toList();

    // [1] 노션 페이지 생성
    await notion.createPage(
      today,
      [
        ...actionBlocks(ActionType.routine, actions),
        dividerBlock(),
        ...actionBlocks(ActionType.task, actions),
      ],
    );
  }
}

final notionControllerProvider = StateNotifierProvider<NotionController, NotionState>((ref) {
  return NotionController(ref.watch(notionServiceProvider));
});
