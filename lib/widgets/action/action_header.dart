import 'dart:io';

import 'package:flutter/material.dart';
import 'package:noti/constants/text.dart';
import 'package:noti/constants/widget.dart';
import 'package:noti/constants/sizes.dart';
import 'package:noti/constants/colors.dart';
import 'package:noti/utils/get_today.dart';
import 'package:noti/widgets/_common/text.dart';

class ActionHeader extends StatelessWidget {
  final String? title;

  final String? background;

  final List<Widget>? actions;

  const ActionHeader({
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
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: background != null
                      ? FileImage(File(background!))
                      : const AssetImage(kDefaultBackgroundImage) as ImageProvider,
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
                      // 제목이 없으면 기본 제목으로 표시
                      title != '' && title != null ? title : kDefaultTitle,
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
