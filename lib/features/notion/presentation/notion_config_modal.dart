import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:noti/constants/colors.dart';
import 'package:noti/constants/sizes.dart';
import 'package:noti/features/notion/presentation/notion_controller.dart';
import 'package:noti/utils/show_flash_snack_bar.dart';
import 'package:noti/widgets/_common/modal_sheet.dart';
import 'package:noti/widgets/_common/text_field.dart';

class NotionConfigModal extends HookConsumerWidget {
  const NotionConfigModal();

  String? validateToken(String? value) {
    if (value == null || value.isEmpty) {
      return "값을 입력하세요.";
    }

    final tokenPrefix = RegExp(r'secret');
    if (tokenPrefix.matchAsPrefix(value) == null) {
      return '토큰은 "secret"으로 시작합니다.';
    }

    if (value.length < 50) {
      return "토큰을 정확히 입력하세요.";
    }

    return null;
  }

  String? validateDatabaseId(String? text) {
    if (text == null || text.isEmpty) {
      return "값을 입력하세요.";
    }
    if (text.length < 32) {
      return "DB 아이디를 정확히 입력하세요.";
    }

    return null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _formKey = GlobalKey<FormState>();
    final tokenController = useTextEditingController();
    final databaseIdController = useTextEditingController();

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: ModalSheet(
        title: 'Notion API',
        child: Form(
          key: _formKey,
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
            // validator가 없거나, 검증에 실패하면 요청 무시
            final isValid = _formKey.currentState?.validate();
            if (isValid == null && isValid == false) return;

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
          },
          child: const Text('설정하기'),
        ),
      ),
    );
  }
}
