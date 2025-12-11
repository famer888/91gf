import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/ui_layer/screens/image_paths.dart';
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
          // leading: SizedBox(height: 40.0, width: 40.0, child: MyImage.network(member.thumb ?? '', borderRadius: 20)),
          title: ValueListenableBuilder(
            valueListenable: hintNotifier,
            builder: (_, hint, __) {
              return Container(
                padding: EdgeInsets.only(left: 8.w, right: 8.w, top: 2.w, bottom: 2.w),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0.w), color: const Color.fromRGBO(200, 120, 255, 0.08)),
                child: TextField(
                  controller: controller,
                  focusNode: focusNode,
                  style: MyTheme.white255_15.s14,
                  cursorColor: const Color.fromRGBO(255, 255, 255, 1),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: MyTheme.gray109_15.s14,
                    isDense: true,
                    contentPadding: const EdgeInsets.all(5),
                    border: const OutlineInputBorder(gapPadding: 0, borderSide: BorderSide(width: 0, style: BorderStyle.none)),
                  ),
                  minLines: 1,
                  maxLines: 2,
                ),
              );
            },
          ),
          trailing: GestureDetector(
            onTap: onSubmitted,
            child: MyImage.asset(MyImagePaths.appCommentSend, width: 32.w, height: 32.w),
          ),
        ),
      ),
    );
  }
}
