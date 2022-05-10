import 'package:flutter/material.dart';
import 'package:todolist/styles/colors.dart';
import 'package:todolist/styles/sizes.dart';
import 'package:todolist/widgets/common/text.dart';

class LoasDivider extends StatelessWidget {
  final String label;

  const LoasDivider({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 4),
          child: LoasText(label, size: FontSizes.caption),
        ),
        const Expanded(
          child: Divider(
            height: 40,
            thickness: 0.8,
            color: CommonColors.divider,
          ),
        ),
      ],
    );
  }
}
