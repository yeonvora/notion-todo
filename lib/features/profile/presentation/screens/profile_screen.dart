import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:notion_todo/constants/text.dart';
import 'package:notion_todo/constants/colors.dart';
import 'package:notion_todo/components/text.dart';
import 'package:notion_todo/features/profile/presentation/controllers/profile_controller.dart';
import 'package:notion_todo/features/profile/presentation/screens/notion_config_modal.dart';
import 'package:notion_todo/features/profile/presentation/widgets/background_picker.dart';
import 'package:notion_todo/features/profile/presentation/widgets/title_text_field.dart';

class ProfileScreen extends StatefulHookConsumerWidget {
  const ProfileScreen();

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  // 타이핑이 끝나면 callback 호출
  void debounceQuery(String query, void Function(String) callback) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      callback(query);
    });
  }

  void showConfigBottomSheet(BuildContext context, NotionConfigModal modal) {
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
        child: modal,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileControllerProvider);
    final titleController = useTextEditingController();

    useEffect(() {
      titleController.text = profile.title ?? '';
      return null;
    }, []);

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(title: const Text("설정"), elevation: 0),
        body: Column(children: [
          // 배경 사진 선택
          BackgroundPicker(
            image: profile.image,
            onChanged: (image) =>
                ref.read(profileControllerProvider.notifier).changeBackground(image!.path),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // 제목 입력
              TitleTextField(
                controller: titleController,
                hintText: kDefaultTitle,
                onChange: (title) => debounceQuery(title, (query) {
                  ref.read(profileControllerProvider.notifier).editTitle(query);
                }),
              ),
              const SizedBox(height: 24),

              // Notion API 설정
              TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero, // remove horizontal padding
                  foregroundColor: Colors.transparent, // ripple color
                ),
                onPressed: () => showConfigBottomSheet(context, const NotionConfigModal()),
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
}
