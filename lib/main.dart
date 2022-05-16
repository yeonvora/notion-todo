import 'package:flutter/material.dart' hide Action;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todolist/repository.dart';
import 'package:todolist/domain/entity.dart';
import 'package:todolist/domain/mapper.dart';
import 'package:todolist/styles/colors.dart';
import 'package:todolist/widgets/action_form.dart';
import 'package:todolist/widgets/action_list.dart';
import 'package:todolist/widgets/app_bar.dart';

// TODO: 스케줄에 따라 리스트 아이템 제거 및 노션 페이지 생성 구현하기
// void repeatedNotifications() {
//   var notion = NotionController();

//   var cron = Cron();
//   cron.schedule(Schedule.parse('*/1 * * * *'), () async {
//     var actionItems = _actions
//         .map((action) => notion.checkboxBlock(action.name, action.done))
//         .toList();

//     await notion.exceute('대충 제목', actionItems);
//   });
// }

void main() {
  runApp(const App());
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

  String getToday() => DateFormat('yyyy.MM.dd').format(DateTime.now());

  // 할 일 목록
  late List<Action> _actions = [];

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
    SharedPreferences _pref = await SharedPreferences.getInstance();

    setState(() {
      // Load SQLite
      final str = _pref.getString('actions') ?? '[]';
      final data = ActionMapper.actionListFromJson(str);

      // Sync Action
      _actions = data;
    });
  }

  // 할 일 추가
  void _addAction(Action action) async {
    SharedPreferences _pref = await SharedPreferences.getInstance();

    setState(() {
      // Added Action
      _actions.add(action);

      // Saved SQLite
      final data = ActionMapper.actionListToJson(_actions);
      _pref.setString('actions', data);
    });
  }

  // 할 일 제거
  void _removeAction(Action action) async {
    SharedPreferences _pref = await SharedPreferences.getInstance();

    setState(() {
      // Removed Action
      _actions.remove(action);

      // Saved SQLite
      final data = ActionMapper.actionListToJson(_actions);
      _pref.setString('actions', data);
    });
  }

  // 할 일 상태 변경
  void _updateAction(Action action) async {
    final _pref = await SharedPreferences.getInstance();
    final repository = ActionRepository(_pref);

    setState(() {
      action.changeStatus();
      _actions.sort();
      repository.save(_actions);
    });
  }
}
