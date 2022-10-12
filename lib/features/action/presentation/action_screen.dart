import 'package:flash/flash.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:noti/constants/colors.dart';
import 'package:noti/features/profile/presentation/notion_controller.dart';
import 'package:noti/features/profile/presentation/profile_controller.dart';
import 'package:noti/utils/exception_message.dart';
import 'package:noti/utils/show_flash_snack_bar.dart';
import 'package:noti/widgets/action/action_form.dart';
import 'package:noti/widgets/action/action_list.dart';
import 'package:noti/widgets/action/action_header.dart';
import 'package:noti/widgets/_common/icon.dart';

import 'package:noti/features/action/domain/action_entity.dart';
import 'package:noti/features/action/presentation/action_controller.dart';

class ActionScreen extends HookConsumerWidget {
  const ActionScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actionNameController = useTextEditingController();
    final actions = ref.watch(actionControllerProvider);
    final profile = ref.watch(profileControllerProvider);

    return Scaffold(
      backgroundColor: CommonColors.background,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(children: [
          CustomScrollView(slivers: [
            ActionHeader(
              title: profile.title,
              background: profile.image,
              actions: [
                _buildSyncButton(() async {
                  try {
                    // [1] Notion API가 응답할 때까지 기다림
                    await Future.wait([
                      ref.read(notionControllerProvider.notifier).createNotionPage(actions),
                    ]);

                    // [2-1] 요청에 성공하면 할 일 초기화 및 성공 메세지 표시
                    ref.read(actionControllerProvider.notifier).initializeActions();
                    showFlashSnackBar(
                      context,
                      snack: FlashBar(content: const Text('노션에 추가되었습니다.')),
                    );
                  } catch (error) {
                    // [2-2] 요청에 실패하면 오류 메세지 표시
                    final match = RegExp(r'(\d+)').firstMatch(error.toString());
                    final status = int.parse(match![0].toString());
                    showFlashSnackBar(
                      context,
                      snack: FlashBar(content: Text(ExceptionMessage.from(status))),
                    );
                  }
                }),
                _buildSettingsButton(() => Navigator.pushNamed(context, '/profile')),
              ],
            ),
            SliverPadding(
              padding: const EdgeInsets.only(top: 16, bottom: 120),
              sliver: SliverToBoxAdapter(
                child: ActionList(
                  actions: actions,
                  onCompleted: (action) =>
                      ref.read(actionControllerProvider.notifier).doneAction(action),
                  onRemoved: (action) =>
                      ref.read(actionControllerProvider.notifier).removeAction(action),
                ),
              ),
            )
          ]),

          // 하단 인풋
          Align(
            alignment: Alignment.bottomCenter,
            child: ActionForm(
              controller: actionNameController,
              onAddTask: () => ref.read(actionControllerProvider.notifier).addAction(Action(
                    type: ActionType.task,
                    name: actionNameController.text,
                  )),
              onAddRoutine: () => ref.read(actionControllerProvider.notifier).addAction(Action(
                    type: ActionType.routine,
                    name: actionNameController.text,
                  )),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _buildSettingsButton(VoidCallback onPressed) {
    return IconButton(
      icon: const Icon(
        FlutterRemix.settings_3_fill,
        color: Colors.white,
      ),
      // Navigate To Settings Page
      onPressed: onPressed,
    );
  }

  Widget _buildSyncButton(VoidCallback onPressed) {
    return IconButton(
      icon: const Icon(
        FlutterRemix.refresh_line,
        color: Colors.white,
      ),
      onPressed: onPressed,
    );
  }
}
