import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../notifiers/home_config_notifier.dart';
import '../../../utils/common_utils.dart';
import '../../common_widgets/my_app_bar.dart';
import '../../common_widgets/my_image.dart';
import '../../common_widgets/screen_background.dart';
import '../../image_paths.dart';
import '../../theme.dart';
import 'package:jygf/report/ui_layer/report_gesture_detector.dart';


class OriginalEnterScreen extends StatefulWidget {
  const OriginalEnterScreen({super.key});

  @override
  State<OriginalEnterScreen> createState() => _OriginalEnterScreenState();
}

class _OriginalEnterScreenState extends State<OriginalEnterScreen> {
  @override
  Widget build(BuildContext context) {
    final config = context.read<HomeConfigNotifier>().config;
    return ScreenBackground(
      child: Scaffold(
        appBar: MyAppBar(title: 'ycrz'.tr(context: context)),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const MyImage.asset(
                MyImagePaths.appMeOriginalN,
                fit: BoxFit.fitWidth,
              ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
              height: 306.w,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(75, 22, 91, 0.39),
                borderRadius: BorderRadius.circular(20.w),
                border: const Border(
                  top: BorderSide(
                    color: MyTheme.white02Color,
                    width: 1.5,
                  ),
                  left: BorderSide(
                    color: MyTheme.white02Color,
                    width: 1.5,
                  ),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: 15.w),
                  Text('tjgfglry'.tr(context: context),style: MyTheme.white15,),
                  SizedBox(height: 20.w),
                  Text('qtgyxfsjgfshzh'.tr(context: context),style: MyTheme.white06_12,),
                  SizedBox(height: 30.w),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 55.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ReportGestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            CommonUtils.launchUrl(config.potatoGroup);
                          },
                          child: Column(
                            children: [
                              MyImage.asset(
                                MyImagePaths.appWdLxpotao,
                                width: 40.w,
                                height: 40.w,
                              ),
                              SizedBox(height: 10.w),
                              Text('gfqtd'.tr(context: context),style: MyTheme.white11)
                            ],
                          ),
                        ),
                        ReportGestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            CommonUtils.launchUrl(config.tgGroup);
                          },
                          child: Column(
                            children: [
                              MyImage.asset(
                                MyImagePaths.appWdLxtgN,
                                width: 40.w,
                                height: 40.w,
                              ),
                              SizedBox(height: 10.w),
                              Text('gfqfj'.tr(context: context),style: MyTheme.white11)
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 30.w),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 10.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('rzsm'.tr(context: context),style: MyTheme.white15,),
                          SizedBox(height: 10.w),
                          Text('rzsm1'.tr(context: context),style: MyTheme.white07_14,),
                          Text('rzsm2'.tr(context: context),style: MyTheme.white07_14,),
                          Text('rzsm3'.tr(context: context),style: MyTheme.white07_14,),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 20.w),
            ],
          ),
        )
      ),
    );
  }
}
