import 'package:flash/flash.dart';
import 'package:flutter/material.dart';

void showFlashSnackBar(BuildContext context, {required FlashBar snack}) {
  showFlash(
    context: context,
    duration: const Duration(seconds: 3),
    builder: (_, controller) {
      return Flash(
        controller: controller,
        position: FlashPosition.top,
        behavior: FlashBehavior.floating,
        margin: const EdgeInsets.all(16),
        borderRadius: BorderRadius.circular(8),
        boxShadows: kElevationToShadow[8],
        child: DefaultTextStyle(
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
          child: snack,
        ),
      );
    },
  );
}
