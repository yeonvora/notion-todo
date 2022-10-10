import 'package:flutter/material.dart';
import 'package:noti/constants/colors.dart';
import 'package:noti/constants/sizes.dart';

class TitleTextField extends StatelessWidget {
  final TextEditingController? controller;

  final String? hintText;

  final bool? autofocus;

  final void Function(String)? onChange;

  const TitleTextField({
    this.controller,
    this.hintText,
    this.autofocus,
    this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChange,
      autofocus: autofocus ?? false,
      textAlign: TextAlign.center,
      cursorColor: Colors.white,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        hintText: hintText,
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(width: 1, color: CommonColors.divider),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(width: 1.2, color: Colors.white),
        ),
      ),
      style: const TextStyle(
        fontSize: FontSizes.title,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
