import 'package:flutter/material.dart' hide Action;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:noti/features/action/domain/action_entity.dart';
import 'package:noti/constants/colors.dart';
import 'package:noti/features/action/presentation/action_controller.dart';
import 'package:noti/widgets/action/action_form.dart';
import 'package:noti/widgets/action/action_list.dart';
import 'package:noti/widgets/action/action_header.dart';
import 'package:noti/widgets/_common/icon.dart';

class ActionScreen extends HookConsumerWidget {
  const ActionScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actionNameController = useTextEditingController();
    final actions = ref.watch(actionControllerProvider);

    return Scaffold(
      backgroundColor: CommonColors.background,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(children: [
          CustomScrollView(slivers: [
            ActionHeader(
              title: null,
              background: null,
              actions: [
                IconButton(
                  icon: const Icon(
                    FlutterRemix.settings_3_fill,
                    color: Colors.white,
                  ),
                  // Navigate To Settings Page
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

  // Widget get _buildSyncButton {
  //   return IconButton(
  //     icon: const Icon(
  //       FlutterRemix.refresh_line,
  //       color: Colors.white,
  //     ),
  //     onPressed: () => synchronizeAction(),
  //   );
  // }
}
