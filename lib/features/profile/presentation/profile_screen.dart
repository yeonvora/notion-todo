import 'dart:io';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:noti/constants/text.dart';
import 'package:noti/constants/colors.dart';
import 'package:noti/constants/sizes.dart';
import 'package:noti/constants/widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:noti/features/action/presentation/action_controller.dart';
import 'package:noti/utils/show_flash_snack_bar.dart';
import 'package:noti/widgets/_common/icon.dart';
import 'package:noti/widgets/_common/modal_sheet.dart';
import 'package:noti/widgets/_common/text.dart';
import 'package:noti/widgets/_common/text_field.dart';
import 'package:noti/widgets/profile/title_text_field.dart';

class ProfileScreen extends HookConsumerWidget {
  const ProfileScreen();

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
  Widget build(BuildContext context, WidgetRef ref) {
    final file = useState<File?>(null);
    final titleController = useTextEditingController();

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
        resizeToAvoidBottomInset: true,
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
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
            onPressed: () async {
              try {
                await ref.read(actionControllerProvider.notifier).synchronizeAction();
                showFlashSnackBar(context, snack: FlashBar(content: const Text('노션에 추가했어요')));
              } catch (error, track) {
                showFlashSnackBar(context, snack: FlashBar(content: const Text('문제가 생겼어요')));
                print(track);
              }
            },
            child: const Text('노션 동기화'),
          ),
        ),
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
