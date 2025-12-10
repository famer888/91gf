import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/domain/model/chat/chat_list_model.dart';
import 'package:jygf/ui_layer/router/routes.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jygf/ui_layer/screens/image_paths.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/ui_layer/utils/common_utils.dart';

class ChatListCard extends StatelessWidget {
  const ChatListCard({
    super.key,
    required this.data,
    double imageRatio = 169 / 224,
  });
  final ChatListChatModel data;

  final double imageRatio = 165 / 224;

  @override
  Widget build(BuildContext context) {

    return LayoutBuilder(builder: (context, constrains) {
      double w = constrains.maxWidth;
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          ChatDetailRoute(data.id ?? 0).push(context);
        },
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Stack(children: [
            List.from(data.medias ?? []).isEmpty
                ? Container(
                    decoration: const BoxDecoration(
                      color: MyTheme.blackColor38,
                    ),
                    width: w,
                    height: w / imageRatio,
                    child: Center(
                      child: MyImage.asset(
                        MyImagePaths.app2024ComFenxiangOn,
                        width: 25.w,
                        height: 25.w,
                      ),
                    ),
                  )
                : Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.w),
                    ),
                    width: w,
                    height: w / imageRatio,
                    child: MyImage.network(
                      data.medias!.first.mediaUrl!,
                    ),
                  ),
            Positioned(
              left: 0,
              top: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(255, 94, 255, 1),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(4.w),
                    bottomRight: Radius.circular(4.w),
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 3.5.w, vertical: 2.w),
                child: Text(
                  CommonUtils.renderFixedNumber(data.payCt ?? 0) +
                      'rlg'.tr(),
                  style: MyTheme.white10,
                ),
              ),
            ),
          ]),
          SizedBox(height: 4.w),
          RichText(
            maxLines: 2,
            text: TextSpan(children: [
              TextSpan(
                text: data.name ?? '',
                style: MyTheme.white14Medium,
              )
            ]),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              '${data.age}${'sold'.tr()}/${data.cup}${'bzcup'.tr()}/${data.height}${'c'.tr()}',
              style: MyTheme.gray102_12,
              maxLines: 1,
            ),
          ),
        ]),
      );
    });
  }
}
