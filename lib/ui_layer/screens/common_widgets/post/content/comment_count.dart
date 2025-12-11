import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../theme.dart';

class PostCommentCountView extends StatelessWidget {
  const PostCommentCountView({super.key, required this.commentCount});
  final int commentCount;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('pl'.tr(context: context), style: MyTheme.white255_18_M),
        Text("（$commentCount${'taoi'.tr(context: context)}）", style: MyTheme.white255_13),
      ],
    );
  }
}
