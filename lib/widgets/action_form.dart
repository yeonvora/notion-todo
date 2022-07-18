import 'package:flutter/material.dart';
import 'package:todolist/styles/colors.dart';
import 'package:todolist/styles/sizes.dart';
import 'package:todolist/widgets/common/icon.dart';

class ActionForm extends StatefulWidget {
  final TextEditingController controller;

  final VoidCallback onAddTask;

  final VoidCallback onAddRoutine;

  const ActionForm({
    required this.controller,
    required this.onAddTask,
    required this.onAddRoutine,
  });

  @override
  State<ActionForm> createState() => _ActionFormState();
}

class _ActionFormState extends State<ActionForm> {
  late FocusNode focusNode;

  void _handleEvent(callback) {
    // Focus 상태가 아닐 경우
    if (!focusNode.hasFocus) {
      focusNode.requestFocus();
      return;
    }

    // Input text가 없을 경우
    if (widget.controller.text == '') {
      return;
    }

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
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 24,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          stops: [0, 0.8],
          colors: [Colors.black, Colors.transparent],
        ),
      ),
      child: Row(
        children: [
          Flexible(child: buildInput(widget.controller)),
          buildAddButton(
            widget.controller,
            widget.onAddTask,
            widget.onAddRoutine,
          ),
        ],
      ),
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

  Widget buildAddButton(
    TextEditingController controller,
    VoidCallback addTask,
    VoidCallback addRoutine,
  ) {
    return Container(
      margin: const EdgeInsets.only(left: 16),
      width: 48,
      height: 48,
      child: FittedBox(
        child: GestureDetector(
          onLongPress: () => _handleEvent(addRoutine),
          child: FloatingActionButton(
            elevation: 0,
            backgroundColor: CommonColors.brand,
            child: const TodoIcon(
              FlutterRemix.add_line,
              size: IconSizes.large,
              color: Colors.white,
            ),
            onPressed: () => _handleEvent(addTask),
          ),
        ),
      ),
    );
  }
}
