import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:notion_todo/constants/colors.dart';
import 'package:notion_todo/constants/sizes.dart';
import 'package:notion_todo/utils/validation.dart';
import 'package:notion_todo/utils/show_flash_snack_bar.dart';
import 'package:notion_todo/components/text_field.dart';
import 'package:notion_todo/components/modal_sheet.dart';

import 'package:notion_todo/features/profile/presentation/controllers/notion_controller.dart';

class NotionConfigModal extends HookConsumerWidget {
  const NotionConfigModal();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormState>();
    final tokenController = useTextEditingController();
    final databaseIdController = useTextEditingController();

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: ModalSheet(
        title: 'Notion API',
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
          onPressed: () {
            // 검증에 성공하면 실행
            if (formKey.currentState!.validate()) {
              // [1] 노션 설정
              ref
                  .read(notionControllerProvider.notifier)
                  .configNotion(tokenController.text, databaseIdController.text);

              // [2] 하단 시트 닫음
              Navigator.pop(context);

              // [3] 메세지 알림
              showFlashSnackBar(
                context,
                snack: FlashBar(content: const Text('설정이 완료되었습니다.')),
              );
            }
          },
          child: const Text('설정하기'),
        ),
        child: Form(
          key: formKey,
          child: Column(children: [
            TodoTextField(
              controller: tokenController,
              labelText: '토큰',
              validator: validateToken,
            ),
            const SizedBox(height: 16),
            TodoTextField(
              controller: databaseIdController,
              labelText: 'DB 아이디',
              validator: validateDatabaseId,
            ),
          ]),
        ),
      ),
    );
  }
}
