import 'package:flutter/material.dart';
import 'package:todolist/styles/colors.dart';
import 'package:todolist/widgets/add_button.dart';

class ActionForm extends StatefulWidget {
  final TextEditingController controller;

  final VoidCallback addTask;

  final VoidCallback addRoutine;

  const ActionForm({
    required this.controller,
    required this.addTask,
    required this.addRoutine,
  });

  @override
  State<ActionForm> createState() => _ActionFormState();
}

class _ActionFormState extends State<ActionForm> {
  late FocusNode focusNode;

  void _handleEvent(callback) {
    callback();
    widget.controller.clear();
    focusNode.unfocus();
  }

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(child: buildInput(widget.controller)),
        focusNode.hasFocus
            ? buildButton(widget.addTask, widget.addRoutine)
            : const SizedBox(),
      ],
    );
  }

  Widget buildInput(TextEditingController controller) {
    return TextField(
      focusNode: focusNode,
      controller: controller,
      style: const TextStyle(
        fontSize: 14,
        color: Colors.white70,
        fontWeight: FontWeight.bold,
      ),
      decoration: InputDecoration(
        // hint text
        hintText: '할 일 추가',
        hintStyle: const TextStyle(color: Colors.white24),
        // styles
        isDense: true,
        filled: true,
        fillColor: CommonColors.textfield,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget buildButton(
    VoidCallback addTask,
    VoidCallback addRoutine,
  ) {
    return Container(
      margin: const EdgeInsets.only(left: 16),
      width: 48,
      height: 48,
      child: FittedBox(
        child: AddButton(
          onPressed: () => _handleEvent(addTask),
          onLongPressed: () => _handleEvent(addRoutine),
        ),
      ),
    );
  }
}
