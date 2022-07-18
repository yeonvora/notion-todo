import 'package:flutter/material.dart';
import 'package:todolist/styles/sizes.dart';
import 'package:todolist/styles/colors.dart';
import 'package:todolist/widgets/common/text.dart';

class TodoAppBar extends StatelessWidget {
  final String titles;

  final Widget? avatar;

  const TodoAppBar({
    required this.titles,
    this.avatar,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      elevation: 0,
      expandedHeight: 256,
      backgroundColor: CommonColors.brand,
      flexibleSpace: _buildFlexibleSpace(context),
    );
  }

  Widget _buildFlexibleSpace(BuildContext context) {
    // Divice status bar height
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return FlexibleSpaceBar(
      centerTitle: true,
      title: TodoText(
        titles,
        size: FontSizes.title,
        color: FontColors.primary,
        strong: true,
      ),
      collapseMode: CollapseMode.parallax,
      background: Container(
        padding: EdgeInsets.only(top: statusBarHeight),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [avatar ?? const SizedBox()],
        ),
      ),
    );
  }
}
