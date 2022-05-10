import 'package:flutter/material.dart';
import 'package:todolist/styles/colors.dart';
import 'package:todolist/styles/sizes.dart';
import 'package:todolist/widgets/common/icon.dart';

class AddButton extends StatelessWidget {
  final void Function()? onPressed;

  final void Function()? onLongPressed;

  const AddButton({
    this.onPressed,
    this.onLongPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPressed,
      child: FloatingActionButton(
        elevation: 0,
        backgroundColor: CommonColors.brand,
        child: const LoasIcon(
          FlutterRemix.add_line,
          size: IconSizes.large,
          color: Colors.white,
        ),
        onPressed: onPressed,
      ),
    );
  }
}
