import 'package:flutter/material.dart' hide Action;
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:noti/widgets/_common/divider.dart';
import 'package:noti/widgets/action/action_list_item.dart';

import 'package:noti/features/action/domain/action_entity.dart';

class ActionList extends StatelessWidget {
  final List<Action> actions;

  final void Function(Action)? onCompleted;

  final void Function(Action)? onRemoved;

  const ActionList({
    required this.actions,
    this.onCompleted,
    this.onRemoved,
  });

  handleAction(Action action, dynamic callback) {
    if (callback != null) {
      callback(action);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SlidableAutoCloseBehavior(
      // [Slidable] 열려있을 경우 자동으로 닫음
      closeWhenTapped: true,
      closeWhenOpened: true,
      child: GroupedListView(
        // constants
        shrinkWrap: true,
        padding: EdgeInsets.zero,

        // builder
        elements: actions,
        groupBy: (Action action) => action.type,
        groupSeparatorBuilder: (String type) => Padding(
          padding: const EdgeInsets.only(left: 12),
          child: TodoDivider(label: type),
        ),
        itemBuilder: (BuildContext context, Action action) {
          return Slidable(
            key: Key(action.name),
            endActionPane: ActionPane(
              extentRatio: 0.2,
              motion: const BehindMotion(),
              children: [
                SlidableAction(
                  icon: Icons.delete,
                  backgroundColor: Colors.red,
                  onPressed: (BuildContext context) => handleAction(action, onRemoved),
                ),
              ],
            ),
            child: ActionListItem(
              done: action.done,
              title: action.name,
              onLongPressed: () => handleAction(action, onCompleted),
            ),
          );
        },
      ),
    );
  }
}
