import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:notion_todo/constants/colors.dart';
import 'package:notion_todo/constants/sizes.dart';

class SubmitButton extends HookConsumerWidget {
  final String title;

  final VoidCallback? onPressed;

  const SubmitButton({
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: CommonColors.brand,
        minimumSize: const Size.fromHeight(56),
        textStyle: const TextStyle(
          fontSize: FontSizes.subHeader,
          fontWeight: FontWeight.w500,
        ),
      ),
      onPressed: onPressed,
      child: Text(title),
    );
  }
}
