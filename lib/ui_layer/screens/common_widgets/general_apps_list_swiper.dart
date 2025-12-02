import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper_null_safety_flutter3/flutter_swiper_null_safety_flutter3.dart';
import 'package:jygf/ui_layer/screens/common_widgets/auto_carousel_slider.dart';
import 'package:jygf/ui_layer/screens/theme.dart';

import '../../../domain/model/banner_model.dart';
import '../../utils/common_utils.dart';
import 'infinite_banner_list.dart';
import 'my_image.dart';

class GeneralAppListSwiper extends StatefulWidget {
  GeneralAppListSwiper({
    super.key,
    required this.data,
    this.radius = 5,
    this.aspectRatio = 7 / 3,
    this.maxWidth = 375,
    this.columnNumber = 5,
    this.useMargin = false,
  });

  List<BannerModel> data;
  final double radius;
  final double aspectRatio;

  final double maxWidth;
  final int columnNumber;
  bool useMargin = false;

  @override
  State<GeneralAppListSwiper> createState() => _GeneralAppListSwiperState();
}

class _GeneralAppListSwiperState extends State<GeneralAppListSwiper> {
  final double _childAspectRatio = 57 / 76;
  final int threshold = 10;

  int _ColumNumber = 5;

  @override
  void initState() {
    super.initState();
    _ColumNumber = widget.columnNumber;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data.length > threshold) {
      // 取前 5 个（不足 5 个则全取）
      final firstPart = widget.data.sublist(0, min(5, widget.data.length));
      // 取第 6 个之后的部分（如果不够 5 个就为空）
      final secondPart = widget.data.length > 5 ? widget.data.sublist(5) : [];
      final itemWidth = (ScreenUtil().screenWidth -
              (_ColumNumber + 1) * 6.w -
              MyTheme.pagePadding * 2) /
          _ColumNumber;

      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(firstPart.length, (index) {
                final item = firstPart[index];
                return GestureDetector(
                  onTap: () {
                    CommonUtils.openRoute(context, item.toJson());
                  },
                  child: SizedBox(
                      width: itemWidth,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: itemWidth,
                            height: itemWidth,
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: MyImage.network(
                                  CommonUtils.getThumb(item.toJson()),
                                  fit: BoxFit.cover,
                                  borderRadius: 8.w),
                            ),
                          ),
                          SizedBox(height: 8.w),
                          Text(
                            item.name ?? item.title ?? "",
                            style: TextStyle(
                                color: Colors.white,
                                overflow: TextOverflow.ellipsis,
                                decoration: TextDecoration.none,
                                height: 1,
                                fontWeight: FontWeight.w600,
                                fontSize: 11.sp),
                          ),
                        ],
                      )),
                );
              }),
            ),
          ),
          if (secondPart.isNotEmpty && secondPart is List<BannerModel>)
            SizedBox(height: 10.w),
          if (secondPart.isNotEmpty && secondPart is List<BannerModel>)
            InfiniteBannerList(banners: secondPart, columNumber: _ColumNumber),
        ],
      );
    } else {
      List<List<BannerModel>> pages = [];
      List<BannerModel> page = [];
      for (var element in widget.data) {
        if (page.length >= _ColumNumber * 2) {
          pages.add(page);
          page = [];
        }
        page.add(element);
      }

      if (page.isNotEmpty) {
        pages.add(page);
      }

      return Container(
        child: widget.data.isEmpty
            ? Container()
            : LayoutBuilder(builder: (context, constrains) {
                double width = constrains.maxWidth;
                double itemWidth =
                    (width - (_ColumNumber - 1) * 10.w) / _ColumNumber;
                double itemHeight = itemWidth / _childAspectRatio;
                // double bannerHeight = widget.data.length >= 10 ? itemHeight + (pages.first.length > _ColumeNumber ? 10.w : 7.w) :
                // (itemHeight * (pages.first.length <= _ColumeNumber ? 1 : 2)) + (pages.first.length > _ColumeNumber ? 15.w : 0);
                double bannerHeight = (itemHeight *
                        (pages.first.length <= _ColumNumber ? 1 : 2)) +
                    (pages.first.length > _ColumNumber ? 15.w : 0);

                return SizedBox(
                  width: width,
                  height: bannerHeight,
                  child: widget.data.isEmpty
                      ? Container()
                      : Swiper(
                          autoplay: pages.length > 1,
                          loop: pages.length > 1,
                          itemBuilder: (BuildContext context, int index) {
                            double w = itemWidth;
                            return SizedBox(
                              width: width,
                              child: GridView.count(
                                  padding: EdgeInsets.only(bottom: 10.w),
                                  crossAxisCount: _ColumNumber,
                                  mainAxisSpacing: 10.w,
                                  crossAxisSpacing: 10.w,
                                  physics: const NeverScrollableScrollPhysics(),
                                  childAspectRatio: _childAspectRatio,
                                  shrinkWrap: true,
                                  children: pages[index].map((e) {
                                    // return Container();

                                    return GestureDetector(
                                        behavior: HitTestBehavior.translucent,
                                        onTap: () {
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                          CommonUtils.openRoute(
                                              context, e.toJson());
                                        },
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: w,
                                              height: w,
                                              child: AspectRatio(
                                                aspectRatio: 1,
                                                child: MyImage.network(
                                                  CommonUtils.getThumb(
                                                      e.toJson()),
                                                  fit: BoxFit.cover,
                                                  borderRadius: 8.w,
                                                ),
                                              ),
                                            ),
                                            // SizedBox(height: 8.w),
                                            Expanded(
                                              child: Container(
                                                alignment: Alignment.center,
                                                // color: Colors.blue,
                                                child: Text(
                                                  e.name ?? e.title ?? "",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      decoration:
                                                          TextDecoration.none,
                                                      height: 1,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 11.sp),
                                                ),
                                              ),
                                            )
                                          ],
                                        ));
                                  }).toList()

                                  // pages[index].map((e) {
                                  //   return Container();
                                  // }).toList(),
                                  ),
                            );
                          },
                          itemCount: pages.length,
                          pagination: pages.length > 1 || true
                              ? SwiperPagination(
                                  margin: EdgeInsets.zero,
                                  builder: SwiperCustomPagination(
                                      builder: (context, config) {
                                    int count = pages.length;
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: List.generate(count, (index) {
                                        return config.activeIndex == index
                                            ? Container(
                                                width: 10.w,
                                                height: 4.w,
                                                margin:
                                                    EdgeInsets.only(right: 4.w),
                                                decoration: BoxDecoration(
                                                  // color: StyleTheme.white255Color,
                                                  gradient:
                                                      MyTheme.gradient_90_114,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(2.w)),
                                                ),
                                              )
                                            : Container(
                                                width: 4.w,
                                                height: 4.w,
                                                margin:
                                                    EdgeInsets.only(right: 4.w),
                                                decoration: BoxDecoration(
                                                  color: MyTheme.white08Color,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(2.w)),
                                                ),
                                              );
                                      }),
                                    );
                                  }))
                              : null,
                        ),
                );
              }),
      );
    }
  }
}
