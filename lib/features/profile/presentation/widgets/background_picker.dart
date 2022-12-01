import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notion_todo/constants/text.dart';
import 'package:notion_todo/constants/sizes.dart';
import 'package:notion_todo/constants/widget.dart';
import 'package:notion_todo/components/icon.dart';

class BackgroundPicker extends HookWidget {
  final String? image;

  final void Function(File?)? onChanged;

  const BackgroundPicker({
    this.image,
    this.onChanged,
  });

  Future<File?> pickBackgroundImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked == null) return null;

    return File(picked.path);
  }

  @override
  Widget build(BuildContext context) {
    final picked = useState<File?>(null);

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
          // 우선순위 : 선택한 이미지 > 설정된 이미지 > 기본 이미지
          image: picked.value != null
              ? FileImage(picked.value!)
              : image != null
                  ? FileImage(File(image!))
                  : const AssetImage(kDefaultBackgroundImage) as ImageProvider,
        ),
      ),
      child: GestureDetector(
        onTap: () async {
          picked.value = await pickBackgroundImage();
          onChanged?.call(picked.value);
        },
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
