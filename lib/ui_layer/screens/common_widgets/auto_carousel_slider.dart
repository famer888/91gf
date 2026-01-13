import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../domain/model/banner_model.dart';
import '../../utils/common_utils.dart';
import '../theme.dart';
import 'my_image.dart';
import 'package:jygf/report/ui_layer/report_gesture_detector.dart';


class BannerCarousel extends StatelessWidget {
  final List<BannerModel> banners;
  final int columeNumber;

  const BannerCarousel({super.key, required this.banners, required this.columeNumber});

  @override
  Widget build(BuildContext context) {
    final itemWidth = (MediaQuery.sizeOf(context).width - (columeNumber + 1) * 7.w - MyTheme.pagePadding * 2) / columeNumber;

    return CarouselSlider(
      options: CarouselOptions(
        height: itemWidth + 28.w,
        viewportFraction: 1 / columeNumber, // 每屏显示 columeNumber 个
        enlargeCenterPage: false,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        pauseAutoPlayOnTouch: true,
        enableInfiniteScroll: true,
      ),
      items: banners.map((banner) {
        return Builder(
          builder: (BuildContext context) {
            return ReportGestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
                CommonUtils.openRoute(context, banner.toJson());
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox.square(
                      dimension: itemWidth,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.w),
                        child: MyImage.network(
                          CommonUtils.getThumb(banner.toJson()),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: 8.w),
                    Text(
                      banner.name ?? banner.title ?? "",
                      style: TextStyle(
                        color: Colors.white,
                        overflow: TextOverflow.ellipsis,
                        decoration: TextDecoration.none,
                        height: 1,
                        fontWeight: FontWeight.w600,
                        fontSize: 11.sp,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }

}
