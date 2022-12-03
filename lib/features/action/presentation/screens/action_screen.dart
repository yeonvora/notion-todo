import 'package:flash/flash.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:notion_todo/constants/colors.dart';
import 'package:notion_todo/notion/exception_message.dart';
import 'package:notion_todo/utils/show_flash_snack_bar.dart';
import 'package:notion_todo/components/icon.dart';

import 'package:notion_todo/features/action/domain/action_entity.dart';

import 'package:notion_todo/features/action/presentation/controllers/action_controller.dart';
import 'package:notion_todo/features/profile/presentation/controllers/notion_controller.dart';
import 'package:notion_todo/features/profile/presentation/controllers/profile_controller.dart';

import 'package:notion_todo/features/action/presentation/widgets/action_form.dart';
import 'package:notion_todo/features/action/presentation/widgets/action_list.dart';
import 'package:notion_todo/features/action/presentation/widgets/action_header.dart';

class ActionScreen extends HookConsumerWidget {
  const ActionScreen();

  /// 노션 동기화
  Future<void> _synchronizeNotion(
    BuildContext context,
    WidgetRef ref,
    List<Action> actions,
  ) async {
    try {
      // 노션에 페이지 생성 후, 할 일 기록
      await ref.read(notionControllerProvider.notifier).createNotionPage(actions);

      // 할 일 초기화
      await ref.read(actionControllerProvider.notifier).initializeActions();

      if (!context.mounted) return;
      showFlashSnackBar(
        context,
        snack: FlashBar(content: const Text('노션에 추가되었습니다.')),
      );
    } catch (error) {
      // 요청에 실패하면 오류 메세지 표시
      final match = RegExp(r'(\d+)').firstMatch(error.toString());
      final status = int.parse(match![0].toString());
      showFlashSnackBar(
        context,
        snack: FlashBar(content: Text(ExceptionMessage.from(status))),
      );
    }
  }

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
                IconButton(
                  icon: const Icon(FlutterRemix.refresh_line),
                  onPressed: () => _synchronizeNotion(context, ref, actions),
                ),
                IconButton(
                  icon: const Icon(FlutterRemix.settings_3_fill),
                  onPressed: () => Navigator.pushNamed(context, '/profile'),
                ),
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
}
