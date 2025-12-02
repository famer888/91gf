import 'package:flutter/material.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jygf/ui_layer/screens/image_paths.dart';


class DanSanHDialog extends StatelessWidget {
  const DanSanHDialog({
    super.key,
    this.title,
    this.content,
    this.closeCall,
    this.backgroundColor = const Color.fromRGBO(21, 28, 40, 1),
  });

  final String? title;
  final Widget? content;
  final Color? backgroundColor;
  final Function? closeCall;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 300,
            padding: EdgeInsets.only(
                left: 15,
                right: 15,
                top: title == null ? 0 : 25,
                bottom: 33.5),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: const BorderRadius.all(
                Radius.circular(5),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        title ?? '',
                        style: const TextStyle(
                            color: Color.fromRGBO(255, 255, 255, 1),
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            overflow: TextOverflow.ellipsis,
                            decoration: TextDecoration.none),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => closeCall?.call(),
                      child: const MyImage.asset(
                        MyImagePaths.appCircleClose,
                        width: 30,
                      ),
                    ),
                  ],
                ),
                Container(
                    margin: title == null
                        ? EdgeInsets.zero
                        : const EdgeInsets.only(top: 26),
                    child: content),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
