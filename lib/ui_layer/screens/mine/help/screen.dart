import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../domain/model/home_data_model.dart';
import '../../../notifiers/home_config_notifier.dart';
import '../../../router/routes.dart';
import '../../common_widgets/my_app_bar.dart';
import '../../common_widgets/my_image.dart';
import '../../common_widgets/screen_background.dart';
import '../../image_paths.dart';
import '../../theme.dart';
import 'package:jygf/report/ui_layer/report_gesture_detector.dart';


class MineHelpScreen extends StatefulWidget {
  const MineHelpScreen({super.key});

  @override
  State<MineHelpScreen> createState() => _MineHelpScreenState();
}

class _MineHelpScreenState extends State<MineHelpScreen> {
  Widget _questionItem(HelpItem help) {
    return Padding(
      padding: EdgeInsets.only(bottom: 32.5.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(help.question, style: MyTheme.gray203_15medium),
          SizedBox(
            height: 15.w,
          ),
          Text(
            help.answer,
            style: TextStyle(
              color: const Color.fromRGBO(153, 153, 153, 1),
              fontSize: 12.sp,
              height: 1.7,
            ),
          ),
          SizedBox(height: 10.w),
          Container(
            height: 0.5,
            color: const Color.fromRGBO(21, 21, 42, 1),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final helpList = context.read<HomeConfigNotifier>().homeData.help ?? [];
    return ScreenBackground(
      child: Scaffold(
        appBar: MyAppBar(title: 'cjwt'.tr(context: context)),
        body: Stack(children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10.w,
              ),
              Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
                  child: Text('cjwtyfk'.tr(context: context),
                      style: MyTheme.white255_22_M)),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: MyTheme.pagePadding,
                    vertical: 10.w,
                  ),
                  child: Column(
                    children: helpList
                        .expand((element) => element.items)
                        .map((e) => _questionItem(e))
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            right: 17.w,
            bottom: 50.w,
            child: ReportGestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                const MineCustomerServiceRoute().push(context);
              },
              child: SizedBox(
                width: 60.w,
                height: 60.w,
                child: const MyImage.asset(
                  MyImagePaths.appWdZzkf,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
