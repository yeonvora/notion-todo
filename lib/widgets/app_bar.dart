import 'package:flutter/material.dart';
import 'package:todolist/styles/sizes.dart';
import 'package:todolist/styles/colors.dart';
import 'package:todolist/utils/get_today.dart';
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
      toolbarHeight: 0,
      expandedHeight: 240,
      backgroundColor: CommonColors.brand,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
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
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    'https://t1.daumcdn.net/cfile/tistory/9942CA415FCA28B40A',
                  ),
                  fit: BoxFit.cover,
                  alignment: Alignment(0, -0.5),
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
