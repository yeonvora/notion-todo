import 'package:cron/cron.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todolist/api/notion.dart';
import 'package:todolist/domain/entity.dart';
import 'package:todolist/domain/repository.dart';
import 'package:todolist/domain/usecase.dart';
import 'package:todolist/styles/colors.dart';
import 'package:todolist/widgets/action_form.dart';
import 'package:todolist/widgets/action_list.dart';
import 'package:todolist/widgets/app_bar.dart';

void main() {
  runApp(const App());

  scheduleTask();
}

// 할 일 목록
List<Action> _actions = [];

String getToday() => DateFormat('yyyy-MM-dd').format(DateTime.now());

void scheduleTask() {
  final cron = Cron();
  final notion = NotionController();

  /**
   * 하루 단위로 작업 실행
   */
  cron.schedule(Schedule.parse('* * */1 * *'), () async {
    // 블록으로 변환
    var actionBlock = _actions
        .map((action) => checkboxBlock(action.name, action.done))
        .toList();

    // 노션 페이지 생성
    final today = getToday();
    await notion.createPage(today, actionBlock);

    // 끝낸 일 제거
    final pref = await SharedPreferences.getInstance();
    final usecase = ActionUseCase(_actions, ActionRepository(pref));
    usecase.cleanActions();
  });
}

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
    String today = getToday();

    return Scaffold(
      backgroundColor: CommonColors.background,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(children: [
          CustomScrollView(slivers: [
            LoasAppBar(titles: today),
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
        ]),
      ),
    );
  }

  // 할 일 불러오기
  void _loadActions() async {
    final _pref = await SharedPreferences.getInstance();

    setState(() {
      final usecase = ActionUseCase(_actions, ActionRepository(_pref));
      final actions = usecase.loadActions();

      _actions = actions;
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
