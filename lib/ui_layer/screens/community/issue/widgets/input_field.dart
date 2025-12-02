import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../theme.dart';

class InputField extends StatelessWidget {
  const InputField({
    super.key,
    required this.controller,
    required this.height,
    required this.hintText,
    this.inputFormatter,
    this.onChanged,
    this.showBoarder = true,
  });

  final TextEditingController controller;
  final double height;
  final String hintText;
  final List<TextInputFormatter>? inputFormatter;
  final ValueChanged<String>? onChanged;
  final bool showBoarder;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: showBoarder
          ? BoxDecoration(
              border:
                  Border.all(color: Colors.white.withOpacity(0.3), width: 1.w),
              borderRadius: BorderRadius.all(Radius.circular(5.w)),
            )
          : null,
      child: TextField(
        inputFormatters: inputFormatter,
        style: MyTheme.white15,
        maxLines: null,
        cursorColor: const Color.fromRGBO(255, 255, 255, 1),
        textInputAction: TextInputAction.done,
        controller: controller,
        onChanged: onChanged,
        decoration: _InputDecoration(hintText: hintText),
      ),
    );
  }
}

class _InputDecoration extends InputDecoration {
  _InputDecoration({super.hintText})
      : super(
          hintStyle: TextStyle(
            color: const Color(0xffa1a2a9),
            fontSize: 15.sp,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 8.w),
          hoverColor: Colors.white,
          isDense: false,
        );
}
