import 'package:flutter/material.dart' hide Action;
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:noti/domain/action_entity.dart';
import 'package:noti/domain/action_repository.dart';
import 'package:noti/domain/action_service.dart';
import 'package:noti/notion/notion_api.dart';
import 'package:noti/notion/notion_block.dart';
import 'package:noti/styles/brand.dart';
import 'package:noti/styles/colors.dart';
import 'package:noti/utils/get_today.dart';
import 'package:noti/widgets/action_form.dart';
import 'package:noti/widgets/action_list.dart';
import 'package:noti/widgets/app_bar.dart';
import 'package:noti/widgets/common/icon.dart';

GetIt sl = GetIt.instance;

Future<void> setup() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(sharedPreferences);
  sl.registerLazySingleton<ActionRepositoryPort>(() => ActionRepository(sl()));
  sl.registerLazySingleton<ActionUsecase>(() => ActionService(sl()));
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setup();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'noti',
      home: Main(),
    );
  }
}

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  final _actionNameController = TextEditingController();

  // 할 일 목록
  late List<Action> _actions = [];

  @override
  void initState() {
    super.initState();
    _loadActions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CommonColors.background,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(children: [
          CustomScrollView(slivers: [
            TodoAppBar(titles: title, background: coverImage, actions: [
              IconButton(
                icon: const Icon(
                  FlutterRemix.refresh_line,
                  color: Colors.white,
                ),
                onPressed: synchronizeNotionPage,
              )
            ]),
            SliverPadding(
              padding: const EdgeInsets.only(top: 16, bottom: 120),
              sliver: SliverToBoxAdapter(
                child: ActionList(
                  actions: _actions,
                  onCompleted: _updateAction,
                  onRemoved: _removeAction,
                ),
              ),
            )
          ]),

          // 하단 인풋
          Align(
            alignment: Alignment.bottomCenter,
            child: ActionForm(
              controller: _actionNameController,
              onAddTask: () => _addAction(Action(
                type: ActionType.task,
                name: _actionNameController.text,
              )),
              onAddRoutine: () => _addAction(Action(
                type: ActionType.routine,
                name: _actionNameController.text,
              )),
            ),
          ),
        ]),
      ),
    );
  }

  /// 할 일 불러오기
  void _loadActions() {
    final usecase = sl.get<ActionUsecase>();

    setState(() => _actions = usecase.getActions());
  }

  /// 할 일 추가
  void _addAction(Action action) {
    final usecase = sl.get<ActionUsecase>();

    setState(() {
      usecase.addAction(action);
      _actions = usecase.getActions();
    });
  }

  /// 할 일 제거
  void _removeAction(Action action) {
    final usecase = sl.get<ActionUsecase>();

    setState(() {
      usecase.removeAction(action);
      _actions = usecase.getActions();
    });
  }

  /// 할 일 상태 변경
  void _updateAction(Action action) {
    final usecase = sl.get<ActionUsecase>();

    setState(() {
      usecase.updateAction(action);
      _actions = usecase.getActions();
    });
  }

  /// 노션 동기화
  Future<void> synchronizeNotionPage() async {
    final notion = NotionAPI();
    final usecase = sl.get<ActionUsecase>();

    final today = getToday('yyyy-MM-dd');
    final pages = await notion.getPages(today);

    // 페이지를 이미 생성한 경우 제거.
    // why. 노션은 아직 블록 단위 업데이트를 지원 안함
    // 따라서 Action을 추가한 경우 전체 페이지를 업데이트함
    if (pages.isNotEmpty) {
      await notion.removePage(pages[0]['id'] as String);
    }

    // 블록 형식에 맞게 구체화
    List<dynamic> actionBlocks(String type, List<Action> actions) => actions
        .where((_) => _.type == type)
        .map((_) => checkboxBlock(_.name, _.done))
        .toList();

    // [1] 노션 페이지 생성
    await notion.createPage(
      today,
      [
        ...actionBlocks(ActionType.routine, _actions),
        dividerBlock(),
        ...actionBlocks(ActionType.task, _actions),
      ],
    );

    // [2] 할 일 초기화
    setState(() {
      usecase.initializeActions();
      _actions = usecase.getActions();
    });
  }
}
