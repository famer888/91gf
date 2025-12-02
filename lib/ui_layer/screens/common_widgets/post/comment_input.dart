import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../notifiers/user_notifier.dart';
import '../../theme.dart';
import '../my_image.dart';

class CommentInput extends StatelessWidget {
  const CommentInput({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.hintNotifier,
    required this.onSubmitted,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueNotifier<String> hintNotifier;
  final VoidCallback onSubmitted;

  @override
  Widget build(BuildContext context) {
    final member = context.read<UserNotifier>().member;
    return ColoredBox(
      color: const Color.fromRGBO(255, 255, 255, 0.03),
      child: SafeArea(
        top: false,
        child: ListTile(
          leading: SizedBox(
            height: 40.0,
            width: 40.0,
            child: MyImage.network(
              member.thumb ?? '',
              borderRadius: 20,
            ),
          ),
          title: ValueListenableBuilder(
            valueListenable: hintNotifier,
            builder: (_, hint, __) {
              return TextField(
                controller: controller,
                focusNode: focusNode,
                style: MyTheme.white255_15,
                cursorColor: const Color.fromRGBO(255, 255, 255, 1),
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: MyTheme.gray109_15,
                  isDense: true,
                  contentPadding: const EdgeInsets.all(5),
                  border: const OutlineInputBorder(
                    gapPadding: 0,
                    borderSide: BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                ),
                minLines: 1,
                maxLines: 2,
              );
            },
          ),
          trailing: GestureDetector(
            onTap: onSubmitted,
            child: const Icon(
              Icons.send_sharp,
              size: 30,
              color: MyTheme.jellyCyanColor103224185,
            ),
          ),
        ),
      ),
    );
  }
}
