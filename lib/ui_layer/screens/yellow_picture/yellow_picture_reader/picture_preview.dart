import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jygf/ui_layer/screens/image_paths.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/ui_layer/utils/common_utils.dart';
import 'package:jygf/ui_layer/utils/my_toast.dart';
import 'package:jygf/report/ui_layer/report_gesture_detector.dart';


class PicturePreview extends StatefulWidget {
  const PicturePreview(
      {super.key, required this.index, required this.pictures});

  final int index;
  final List<Map> pictures;

  @override
  State<PicturePreview> createState() => _PicturePreviewState();
}

class _PicturePreviewState extends State<PicturePreview> {
  late PageController _controller;
  PhotoViewScaleState scaleState = PhotoViewScaleState.initial;
  bool hasPop = false;
  List<Map> _pictures = [];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    setupData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void setupData() {
    _selectedIndex = widget.index;
    _pictures = widget.pictures;

    if (widget.pictures.isEmpty) return;
    _controller = PageController(initialPage: _selectedIndex);

    setState(() {});
  }

  void localStorageImage(String url) async {
    try {
      CommonUtils.localStorageImage(url);
    } catch (e) {
      MyToast.showText(text: tr('tpbcsb'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: widget.pictures.isEmpty
          ? Container()
          : Stack(
              children: [
                Stack(
                  children: [
                    ReportGestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onHorizontalDragUpdate: (e) {},
                      onTap: () {
                        if (scaleState == PhotoViewScaleState.initial) {
                          context.pop();
                        }
                      },
                      onVerticalDragUpdate: (e) {
                        if (scaleState == PhotoViewScaleState.initial) {
                          if (e.delta.dy > 5 && hasPop == false) {
                            hasPop = true;
                            context.pop();
                          }
                        }
                      },
                      child: PhotoViewGallery.builder(
                        scrollPhysics: const BouncingScrollPhysics(),
                        pageController: _controller,
                        itemCount: _pictures.length,
                        onPageChanged: (index) {
                          _selectedIndex = index;
                          setState(() {});
                        },
                        scaleStateChangedCallback: (value) {
                          scaleState = value;
                        },
                        builder: (context, index) {
                          var e = _pictures[index];
                          Widget tp =
                              MyImage.network(e['thumb'], fit: BoxFit.contain);
                          return PhotoViewGalleryPageOptions.customChild(
                            initialScale: 1.0,
                            minScale: 1.0,
                            maxScale: 10.0,
                            child: tp,
                          );
                        },
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 0,
                      child: IgnorePointer(
                        child: Container(
                          height: 80.w,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromRGBO(0, 0, 0, 0.6),
                                Color.fromRGBO(0, 0, 0, 0.0)
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned.fill(
                        child: Column(
                      children: [
                        Container(height: MyTheme.statusHeight),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: MyTheme.pagePadding),
                          height: MyTheme.navbarHegiht,
                          child: Stack(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ReportGestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    child: SizedBox(
                                      height: double.infinity,
                                      child: MyImage.asset(
                                        MyImagePaths.appClose,
                                        width: 15.w,
                                        height: 15.w,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    onTap: () {
                                      context.pop();
                                    },
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "${_selectedIndex + 1} / ${_pictures.length}",
                                        style: MyTheme.white16,
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 10.w),
                                        width: 58.w,
                                        height: 20.w,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.white,
                                                width: 1.w),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(2.w))),
                                        alignment: Alignment.center,
                                        child: ReportGestureDetector(
                                                behavior:
                                                    HitTestBehavior.translucent,
                                                onTap: () {
                                                  var e = _pictures[_selectedIndex];
                                                  localStorageImage(e['thumb']);
                                                },
                                                child: Text(
                                                  'bctp'.tr(context: context),
                                                  style: MyTheme.white11,
                                                ),
                                              ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ))
                  ],
                ),
              ],
            ),
    );
  }
}
