import 'package:flutter/material.dart';
import 'package:todolist/styles/sizes.dart';
import 'package:todolist/styles/colors.dart';
import 'package:todolist/utils/get_today.dart';
import 'package:todolist/widgets/common/text.dart';

class TodoAppBar extends StatelessWidget {
  final String titles;

  final String background;

  final List<Widget>? actions;

  const TodoAppBar({
    required this.titles,
    required this.background,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      actions: actions,
      elevation: 0,
      expandedHeight: 240,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        // collapseMode: CollapseMode.pin,
        background: Stack(
          children: [
            Container(
              foregroundDecoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: FractionalOffset.bottomCenter,
                    end: FractionalOffset.topCenter,
                    colors: [
                      CommonColors.background,
                      Colors.transparent,
                    ],
                    stops: [
                      0.1,
                      0.8,
                    ]),
              ),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(background),
                  fit: BoxFit.cover,
                  alignment: const Alignment(0, -0.5),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 12, bottom: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TodoText(
                      getToday('yyyy년 M월 d일'),
                      size: FontSizes.subHeader,
                      color: FontColors.secondary,
                      strong: true,
                    ),
                    const SizedBox(height: 4),
                    TodoText(
                      titles,
                      size: FontSizes.headline,
                      color: FontColors.primary,
                      strong: true,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
