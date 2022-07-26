import 'package:flutter/material.dart';
import 'package:notion_todo/constants/colors.dart';
import 'package:notion_todo/components/icon.dart';
import 'package:notion_todo/components/text.dart';

class ActionListItem extends StatelessWidget {
  final bool done;

  final String title;

  final VoidCallback? onPressed;

  final VoidCallback? onLongPressed;

  const ActionListItem({
    required this.done,
    required this.title,
    this.onPressed,
    this.onLongPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      minLeadingWidth: 0,
      horizontalTitleGap: 8,
      contentPadding: const EdgeInsets.only(left: 12),
      leading: TodoIcon(
        done ? FlutterRemix.checkbox_fill : FlutterRemix.checkbox_blank_line,
        color: FontColors.hint,
      ),
      title: TodoText(
        title,
        color: done ? FontColors.hint : FontColors.primary,
      ),
      onTap: onPressed,
      onLongPress: onLongPressed,
    );
  }
}
