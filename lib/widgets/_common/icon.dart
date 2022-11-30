import 'package:flutter/widgets.dart';
import 'package:notion_todo/constants/sizes.dart';
import 'package:notion_todo/constants/colors.dart';

export 'package:flutter_remix/flutter_remix.dart';

class TodoIcon extends StatelessWidget {
  final IconData? icon;

  final double? size;

  final Color? color;

  const TodoIcon(
    this.icon, {
    this.size = IconSizes.medium,
    this.color = FontColors.secondary,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(icon, size: size, color: color);
  }
}
