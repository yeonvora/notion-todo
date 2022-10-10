import 'package:flutter/material.dart';
import 'package:noti/constants/text.dart';
import 'package:noti/constants/widget.dart';
import 'package:noti/constants/sizes.dart';
import 'package:noti/constants/colors.dart';
import 'package:noti/utils/get_today.dart';
import 'package:noti/widgets/common/text.dart';

class TodoAppBar extends StatelessWidget {
  final String? title;

  final String? background;

  final List<Widget>? actions;

  const TodoAppBar({
    this.title,
    this.background,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      actions: actions,
      elevation: 0,
      expandedHeight: kAppBarHeight,
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
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(kDefaultBackgroundImage),
                  fit: BoxFit.cover,
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
                      title ?? kDefaultTitle,
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
