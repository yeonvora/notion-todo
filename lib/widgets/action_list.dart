import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todolist/models.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:todolist/styles/colors.dart';
import 'package:todolist/widgets/common/divider.dart';
import 'package:todolist/widgets/action_list_item.dart';

// Widget
class ActionList extends StatelessWidget {
  final List<IAction> actions;

  final void Function(IAction)? onCompleted;

  final void Function(IAction)? onRemoved;

  const ActionList({
    required this.actions,
    this.onCompleted,
    this.onRemoved,
  });

  handleAction(IAction action, dynamic callback) {
    if (callback != null) {
      callback(action);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GroupedListView(
      // styles
      shrinkWrap: true,
      padding: EdgeInsets.zero,

      // builder
      elements: actions,
      groupBy: (IAction action) => action.type,
      groupSeparatorBuilder: (String type) => Padding(
        padding: const EdgeInsets.only(left: 12),
        child: LoasDivider(label: type),
      ),
      itemBuilder: (BuildContext context, IAction action) {
        return Slidable(
          key: Key(action.name),
          child: ActionListItem(
            done: action.done,
            title: action.name,
            onLongPressed: () => handleAction(action, onCompleted),
          ),
          endActionPane: ActionPane(
            extentRatio: 0.2,
            motion: const BehindMotion(),
            children: [
              SlidableAction(
                icon: Icons.delete,
                backgroundColor: SystemColors.danger,
                onPressed: (BuildContext context) =>
                    handleAction(action, onRemoved),
              ),
            ],
          ),
        );
      },
    );
  }
}
