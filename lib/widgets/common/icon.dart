import 'package:flutter/widgets.dart';
import 'package:todolist/styles/sizes.dart';
import 'package:todolist/styles/colors.dart';

export 'package:flutter_remix/flutter_remix.dart';

class LoasIcon extends StatelessWidget {
  final IconData? icon;

  final double? size;

  final Color? color;

  const LoasIcon(
    this.icon, {
    this.size = IconSizes.medium,
    this.color = FontColors.secondary,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(icon, size: size, color: color);
  }
}
