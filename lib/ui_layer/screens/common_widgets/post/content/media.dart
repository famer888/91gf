import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../domain/enum.dart';
import '../../../../../domain/model/media_model.dart';
import '../../../../router/routes.dart';
import '../../../../utils/common_utils.dart';
import '../../../image_paths.dart';
import '../../../theme.dart';
import '../../my_image.dart';

class PostMediaView extends StatelessWidget {
  const PostMediaView(
      {super.key, required this.medias, required this.unlockCoins});
  final List<MediaModel> medias;
  final int unlockCoins;

  @override
  Widget build(BuildContext context) {
    /// 前往图片/影片浏览页
    void goPictureView(int index) {
      if (medias.isNotEmpty) {
        MediaViewerRoute({'resources': medias, 'index': index}).push(context);
      }
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.only(bottom: 10.w),
      itemCount: medias.length,
      itemBuilder: (context, index) {
        final media = medias[index];
        if (media.type == MyMediaType.video) {
          media.unlockCoins = unlockCoins;
        }
        double width = 1.sw - MyTheme.pagePadding * 2;
        final thumbWidth = media.thumbWidth.toDouble();
        final w = thumbWidth == 0.0 ? width : thumbWidth;
        final thumbHeight = media.thumbHeight.toDouble();
        final h = thumbHeight == 0.0 ? (width / 2) : thumbHeight;
        width = min(w, width);

        return medias[index].type == MyMediaType.image
            ? Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: width,
                  height: width / w * h,
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () => goPictureView(index),
                    child: MyImage.network(
                      CommonUtils.getThumb(medias[index].toJson()),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.w),
                  unlockCoins > 0 && medias[index].mediaUrl.isEmpty
                      ? Text(
                          "$unlockCoins${'jbjsgk'.tr(context: context)}:",
                          style: TextStyle(
                            color: MyTheme.cyanColor00edfd,
                            fontSize: 14.sp,
                          ),
                        )
                      : Text(
                          "${'shp'.tr(context: context)}:",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14.sp,
                          ),
                        ),
                  SizedBox(height: 5.w),
                  SizedBox(
                    width: 1.sw - MyTheme.pagePadding * 2,
                    height: (1.sw - MyTheme.pagePadding * 2) / 16 * 9,
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () => goPictureView(index),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: MyImage.network(
                              media.cover,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const Center(
                            child: MyImage.asset(
                              MyImagePaths.appVPlayN,
                              width: 40,
                              height: 40,
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              );
      },
    );
  }
}
