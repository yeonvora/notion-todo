import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:noti/constants/text.dart';
import 'package:noti/constants/colors.dart';
import 'package:noti/constants/sizes.dart';
import 'package:noti/constants/widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:noti/widgets/common/icon.dart';
import 'package:noti/widgets/common/modal_sheet.dart';
import 'package:noti/widgets/common/text.dart';
import 'package:noti/widgets/common/text_field.dart';

class SettingScreen extends HookWidget {
  Future<File?> pickBackgroundImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);

    if (picked == null) return null;

    return File(picked.path);
  }

  void handleConfigNotionBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: CommonColors.background,
      clipBehavior: Clip.hardEdge,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      isScrollControlled: true,
      builder: (_) => Padding(
        // Keybord padding
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: const ConfigNotionModal(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final file = useState<File?>(null);
    final titleController = useTextEditingController();

    useEffect(() {
      titleController.text = 'ㅎㅇ';
      return null;
    }, []);

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(title: const Text("설정"), elevation: 0),
        body: Column(children: [
          // 사진 수정
          _buildBackgroundImage(
            picked: file.value,
            onPressed: pickBackgroundImage,
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // 목표 입력 필드
              TitleTextField(
                controller: titleController,
                hintText: kDefaultTitle,
              ),
              const SizedBox(height: 24),

              // Notion API 설정 버튼
              TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero, // remove horizontal padding
                  foregroundColor: Colors.transparent, // ripple color
                ),
                onPressed: () => handleConfigNotionBottomSheet(context),
                child: const TodoText(
                  'Notion API 설정',
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              ),
            ]),
          ),
        ]),
      ),
    );
  }

  Widget _buildBackgroundImage({
    required File? picked,
    void Function()? onPressed,
  }) {
    return Container(
      width: double.infinity,
      height: kAppBarHeight,
      decoration: BoxDecoration(
        image: DecorationImage(
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.6),
            BlendMode.dstATop,
          ),
          fit: BoxFit.cover,
          image: picked == null
              ? const AssetImage(kDefaultBackgroundImage)
              : FileImage(picked) as ImageProvider,
        ),
      ),
      child: GestureDetector(
        onTap: onPressed,
        child: Center(
          child: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const TodoIcon(
              FlutterRemix.camera_fill,
              size: IconSizes.large,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}

class ConfigNotionModal extends HookWidget {
  const ConfigNotionModal();

  @override
  Widget build(BuildContext context) {
    final tokenController = useTextEditingController();
    final databaseIdController = useTextEditingController();

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: ModalSheet(
        title: 'Notion API',
        child: Column(children: [
          TodoTextField(
            controller: tokenController,
            labelText: 'Notion Token',
          ),
          const SizedBox(height: 16),
          TodoTextField(
            controller: databaseIdController,
            labelText: 'Database ID',
          ),
        ]),
        submit: ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            backgroundColor: CommonColors.brand,
            minimumSize: const Size.fromHeight(56),
            textStyle: const TextStyle(
              fontSize: FontSizes.subHeader,
              fontWeight: FontWeight.w500,
            ),
          ),
          onPressed: () => print('submit'),
          child: const Text('설정하기'),
        ),
      ),
    );
  }
}

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
