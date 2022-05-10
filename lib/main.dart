import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:todolist/models.dart';
import 'package:todolist/styles/colors.dart';
import 'package:todolist/widgets/action_form.dart';
import 'package:todolist/widgets/action_list.dart';
import 'package:todolist/widgets/app_bar.dart';

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
  final double _horizontalSpace = 16;

  final actionValueController = TextEditingController();

  String getToday() => DateFormat('M월 d일').format(DateTime.now());

  // 할 일 목록
  final List<IAction> _actions = List<IAction>.generate(
    10,
    (index) => IAction(
      type: Type.task,
      name: '할 일 무언가 $index',
    ),
  );

  // 할 일 추가
  void add(String type, String name) =>
      setState(() => _actions.add(IAction(type: type, name: name)));

  // 할 일 제거
  void remove(IAction action) => setState(() => _actions.remove(action));

  // 할 일 상태 변경
  void changeStatus(IAction action) {
    setState(() {
      action.changeStatus();
      _actions.sort();
    });
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
                  onCompleted: changeStatus,
                  onRemoved: remove,
                ),
              ),
            )
          ]),
          // 하단 인풋
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: _horizontalSpace,
                vertical: 24,
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  stops: [0.6, 0.8],
                  colors: [Colors.black, Colors.transparent],
                ),
              ),
              child: ActionForm(
                controller: actionValueController,
                addTask: () => add(Type.task, actionValueController.text),
                addRoutine: () => add(Type.routine, actionValueController.text),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
