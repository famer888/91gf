import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../domain/enum.dart';
import '../../../../../domain/model/media_model.dart';
import '../../../image_paths.dart';
import '../../../theme.dart';
import '../../my_image.dart';

class CardMediaView extends StatelessWidget {
  const CardMediaView({super.key, required this.medias});

  final List<MediaModel>? medias;

  @override
  Widget build(BuildContext context) {
    if (medias == null || medias!.isEmpty) {
      return const SizedBox.shrink();
    }

    final mediaCount = medias!.length;

    return GridView.builder(
      padding: EdgeInsets.only(top: 10.w),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 7.w,
        crossAxisSpacing: 7.w,
        childAspectRatio: 1.0,
      ),
      itemCount: min(mediaCount, 3),
      scrollDirection: Axis.vertical,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final isVideo = medias![index].type == MyMediaType.video;
        final coverUrl = isVideo
            ? medias![index].cover
            : medias![index].mediaUrl.isNotEmpty
                ? medias![index].mediaUrl
                : medias![index].cover;
        final showLastMediaCount = index == 2 && mediaCount > 3;

        return Stack(
          children: [
            Positioned.fill(
              child: MyImage.network(
                coverUrl,
                borderRadius: 5.w,
                fit: BoxFit.cover,
                backgroundColor: MyTheme.imageBgColor,
              ),
            ),
            if (isVideo)
              Center(
                child: MyImage.asset(
                  MyImagePaths.appVPlayN,
                  width: 30.w,
                  height: 30.w,
                ),
              ),
            if (showLastMediaCount)
              Positioned(
                right: 6.w,
                bottom: 6.w,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(0, 0, 0, 0.5),
                    borderRadius: BorderRadius.all(Radius.circular(2.w)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: Text(
                      '+${mediaCount - 3}',
                      style: MyTheme.white255_12,
                    ),
                  ),
                ),
              )
          ],
        );
      },
    );
  }
}
