import 'package:flutter/material.dart' hide Action;
import 'package:flutter_remix/flutter_remix.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todolist/api/notion_controller.dart';
import 'package:todolist/domain/entity.dart';
import 'package:todolist/domain/repository.dart';
import 'package:todolist/domain/usecase.dart';
import 'package:todolist/styles/colors.dart';
import 'package:todolist/utils/notion_block.dart';
import 'package:todolist/widgets/action_form.dart';
import 'package:todolist/widgets/action_list.dart';
import 'package:todolist/widgets/app_bar.dart';

void main() {
  runApp(const App());
}

// 할 일 목록
List<Action> _actions = [];

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Todolist',
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
  final actionName = TextEditingController();

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
            const TodoAppBar(titles: "뛰어난 메이커 추구하기"),
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
              controller: actionName,
              onAddTask: () => _addAction(Action(
                type: ActionType.task,
                name: actionName.text,
              )),
              onAddRoutine: () => _addAction(Action(
                type: ActionType.routine,
                name: actionName.text,
              )),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: IconButton(
              icon: const Icon(
                FlutterRemix.flutter_fill,
                color: Colors.red,
              ),
              onPressed: createNotionPage,
            ),
          ),
        ]),
      ),
    );
  }

  void createNotionPage() async {
    final controller = NotionController();
    final _pref = await SharedPreferences.getInstance();

    // 블록으로 변환
    List<dynamic> actionBlock(String type) => _actions
        .where((_) => _.type == type)
        .map((_) => checkboxBlock(_.name, _.done))
        .toList();

    // 노션 페이지 생성
    await controller.createPage([
      ...actionBlock(ActionType.routine),
      dividerBlock(),
      ...actionBlock(ActionType.task),
    ]);

    // 끝낸 일 제거
    setState(() {
      final usecase = ActionUseCase(_actions, ActionRepository(_pref));
      _actions = usecase.initializeActions();
    });
  }

  // 할 일 불러오기
  void _loadActions() async {
    final _pref = await SharedPreferences.getInstance();

    setState(() {
      final usecase = ActionUseCase(_actions, ActionRepository(_pref));
      _actions = usecase.loadActions();
    });
  }

  // 할 일 추가
  void _addAction(Action action) async {
    final _pref = await SharedPreferences.getInstance();

    setState(() {
      final usecase = ActionUseCase(_actions, ActionRepository(_pref));
      usecase.addAction(action);
    });
  }

  // 할 일 제거
  void _removeAction(Action action) async {
    final _pref = await SharedPreferences.getInstance();

    setState(() {
      final usecase = ActionUseCase(_actions, ActionRepository(_pref));
      usecase.removeAction(action);
    });
  }

  // 할 일 상태 변경
  void _updateAction(Action action) async {
    final _pref = await SharedPreferences.getInstance();

    setState(() {
      final usecase = ActionUseCase(_actions, ActionRepository(_pref));
      usecase.updateAction(action);
    });
  }
}
