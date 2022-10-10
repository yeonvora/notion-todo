import 'package:flash/flash.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:get_it/get_it.dart';
import 'package:noti/domain/action_entity.dart';
import 'package:noti/domain/action_service.dart';
import 'package:noti/screens/setting_screen.dart';
import 'package:noti/constants/colors.dart';
import 'package:noti/utils/show_flash_snack_bar.dart';
import 'package:noti/utils/synchronize_notion_page.dart';
import 'package:noti/widgets/action_form.dart';
import 'package:noti/widgets/action_list.dart';
import 'package:noti/widgets/app_bar.dart';
import 'package:noti/widgets/common/icon.dart';

GetIt sl = GetIt.instance;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _actionNameController = TextEditingController();

  // Action Service
  late final ActionUsecase usecase;

  // 할 일 목록
  late List<Action> _actions = [];

  @override
  void initState() {
    super.initState();
    usecase = sl.get<ActionUsecase>();
    _loadActions();
  }

  /// 할 일 불러오기
  void _loadActions() {
    setState(() => _actions = usecase.getActions());
  }

  /// 할 일 추가
  void _addAction(Action action) {
    setState(() {
      usecase.addAction(action);
      _actions = usecase.getActions();
    });
  }

  /// 할 일 제거
  void _removeAction(Action action) {
    setState(() {
      usecase.removeAction(action);
      _actions = usecase.getActions();
    });
  }

  /// 할 일 상태 변경
  void _updateAction(Action action) {
    setState(() {
      usecase.updateAction(action);
      _actions = usecase.getActions();
    });
  }

  /// 노션 동기화
  Future<void> synchronizeAction() async {
    try {
      await synchronizeNotionPage(
        actions: _actions,
        callback: () {
          // 동기화 후 할 일 초기화
          setState(() {
            usecase.initializeActions();
            _actions = usecase.getActions();
          });
        },
      );
      showFlashSnackBar(context, snack: FlashBar(content: const Text('노션에 추가했어요')));
    } catch (error, track) {
      showFlashSnackBar(context, snack: FlashBar(content: const Text('문제가 생겼어요')));
      print(track);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CommonColors.background,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(children: [
          CustomScrollView(slivers: [
            TodoAppBar(
              title: null,
              background: null,
              actions: [
                // _buildSyncButton,
                IconButton(
                  icon: const Icon(
                    FlutterRemix.settings_3_fill,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    // Navigate To Settings Page
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (c) => SettingScreen()),
                    );
                  },
                ),
              ],
            ),
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

  Widget get _buildSyncButton {
    return IconButton(
      icon: const Icon(
        FlutterRemix.refresh_line,
        color: Colors.white,
      ),
      onPressed: () => synchronizeAction(),
    );
  }
}
