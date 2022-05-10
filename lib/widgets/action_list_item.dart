import 'package:flutter/material.dart';
import 'package:todolist/styles/colors.dart';

import 'package:todolist/widgets/common/text.dart';

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
      contentPadding: const EdgeInsets.only(left: 12),
      title: LoasText(
        title,
        color: done ? FontColors.hint : FontColors.primary,
      ),
      onTap: onPressed,
      onLongPress: onLongPressed,
    );
  }
}
