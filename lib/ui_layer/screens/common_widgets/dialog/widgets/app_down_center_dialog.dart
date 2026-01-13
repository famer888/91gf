import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/domain/model/home_data_model.dart';
import 'package:jygf/ui_layer/notifiers/home_config_notifier.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jygf/ui_layer/screens/image_paths.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/ui_layer/utils/common_utils.dart';
import 'package:provider/provider.dart';
import 'package:jygf/report/ui_layer/report_gesture_detector.dart';


class AppDownCenterDialog extends StatelessWidget {
  const AppDownCenterDialog({
    super.key,
    required this.cancel,
  });
  final VoidCallback cancel;
  @override
  Widget build(BuildContext context) {
    late final homeConfigNotifier = context.read<HomeConfigNotifier>();
    final apps = homeConfigNotifier.homeData.noticeApps;

    return ColoredBox(
      color: Colors.black38,
      child: ReportGestureDetector(
        behavior: HitTestBehavior.opaque,
        // onTap: () => cancel.call(),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 35.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 405.w,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(22, 24, 34, 0.95),
                    borderRadius: BorderRadius.all(Radius.circular(10.w)),
                  ),
                  child: const AppDownCenterCard(),
                ),
                SizedBox(height: 20.w),
                ReportGestureDetector(
                  onTap: () => cancel.call(),
                  child: SizedBox(
                    child: MyImage.asset(
                      MyImagePaths.appCancelWithCircle,
                      fit: BoxFit.cover,
                      width: 33.w,
                      height: 33.w,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AppDownCenterCard extends StatefulWidget {
  const AppDownCenterCard({
    super.key,
  });

  @override
  State<AppDownCenterCard> createState() => _AppDownCenterCardState();
}

class _AppDownCenterCardState extends State<AppDownCenterCard> {
  late final homeConfigNotifier = context.read<HomeConfigNotifier>();
  late final apps = homeConfigNotifier.homeData.noticeApps ?? [];

  List<List<Notice>> groupedApps = [];

  // 创建一个 ScrollController
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // // 将前6个元素放在一组，剩余元素放在另一组
    // if (apps.length <= 6) {
    //   groupedApps.add(apps); // 如果少于或等于 6 个元素，直接将整个列表作为一组
    // } else {
    //   groupedApps.add(apps.sublist(0, 6)); // 添加前 6 个元素
    //   groupedApps.add(apps.sublist(6)); // 添加剩余的元素
    // }
  }

  @override
  void dispose() {
    _scrollController.dispose(); // 释放资源
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ScrollbarTheme(
        data: ScrollbarThemeData(
          thumbColor: WidgetStateProperty.all(MyTheme.white008Color), // 滑动条颜色
          trackColor: WidgetStateProperty.all(MyTheme.white008Color), // 滑动条背景颜色
          thickness: WidgetStateProperty.all(5.w), // 滑动条宽度
          radius: Radius.circular(10.w), // 滑动条圆角
          minThumbLength: 20, // 滑动条最小长度
        ),
        child: Scrollbar(
          controller: _scrollController, // 绑定 ScrollController
          thumbVisibility: true, // 显示滑动条（即使不滚动也显示）
          child: ListView(
            controller: _scrollController, // 将相同的 ScrollController 传递给 ListView
            padding: EdgeInsets.all(MyTheme.pagePadding),
            children: [
              // GridView.builder(
              //     shrinkWrap: true,
              //     addRepaintBoundaries: false,
              //     addAutomaticKeepAlives: false,
              //     physics: const BouncingScrollPhysics(),
              //     itemCount: groupedApps.first.length,
              //     padding: EdgeInsets.zero,
              //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              //       crossAxisCount: 3,
              //       childAspectRatio: 50 / 58,
              //       // mainAxisSpacing: 10.w,
              //       // crossAxisSpacing: 10.w,
              //     ),
              //     itemBuilder: (context, index) {
              //       Notice? model = groupedApps.first[index];
              //       return ReportGestureDetector(
              //         behavior: HitTestBehavior.translucent,
              //         onTap: () {
              //           final json = model.toJson() ?? {};
              //           CommonUtils.openRoute(context, json);
              //         },
              //         child: Column(
              //           children: [
              //             SizedBox(
              //               height: 76.w,
              //               width: 76.w,
              //               child: MyImage.network(
              //                 model.imgUrl ?? '',
              //                 fit: BoxFit.fill,
              //                 borderRadius: 10.w,
              //               ),
              //             ),
              //             SizedBox(height: 5.w),
              //             Text(
              //               model.title ?? '',
              //               style: TextStyle(
              //                   color: Colors.white,
              //                   overflow: TextOverflow.ellipsis,
              //                   decoration: TextDecoration.none,
              //                   fontSize: 13.sp),
              //               maxLines: 1,
              //             ),
              //           ],
              //         ),
              //       );
              //     }),
              // groupedApps.length < 2
              //     ? SizedBox()
              // :
              GridView.builder(
                  shrinkWrap: true,
                  addRepaintBoundaries: false,
                  addAutomaticKeepAlives: false,
                  physics: const BouncingScrollPhysics(),
                  // itemCount: groupedApps.last.length,
                  itemCount: apps.length,
                  padding: EdgeInsets.zero,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: 49 / 62,
                    // mainAxisSpacing: 10.w,
                    // crossAxisSpacing: 10.w,
                  ),
                  itemBuilder: (context, index) {
                    Notice? model = apps[index];
                    return ReportGestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        final json = model.toJson() ?? {};
                        CommonUtils.openRoute(context, json);
                      },
                      child: Column(
                        children: [
                          SizedBox(
                            height: 56.w,
                            width: 56.w,
                            child: MyImage.network(
                              model.imgUrl ?? '',
                              fit: BoxFit.fill,
                              borderRadius: 10.w,
                            ),
                          ),
                          SizedBox(height: 5.w),
                          Text(
                            model.title ?? '',
                            style: TextStyle(
                                color: Colors.white,
                                overflow: TextOverflow.ellipsis,
                                decoration: TextDecoration.none,
                                fontSize: 11.sp),
                            maxLines: 1,
                          ),
                        ],
                      ),
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }
}
