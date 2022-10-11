import 'package:flutter/material.dart';
import 'package:noti/constants/colors.dart';
import 'package:noti/constants/sizes.dart';

class TodoTextField extends StatelessWidget {
  final TextEditingController controller;

  final String? labelText;

  String? Function(String?)? validator;

  TodoTextField({
    required this.controller,
    this.labelText,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      cursorColor: Colors.white,
      style: const TextStyle(height: 1.5, fontSize: FontSizes.subHeader),
      decoration: InputDecoration(
        focusColor: CommonColors.brand,
        labelStyle: const TextStyle(
          color: FontColors.secondary,
          fontWeight: FontWeight.w500,
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 1.5),
        ),
        labelText: labelText,
      ),
      validator: validator,
    );
  }
}
