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
        body: Stack(
          children: [
            const MyImage.asset(
              MyImagePaths.appMeOriginalN,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
            Positioned(
              left: 70.w,
              right: 70.w,
              bottom: 220.w,
              child: Column(
                children: [
                  Text(
                    '请通过以下方式添加官方审核账号',
                    style: MyTheme.black15,
                    maxLines: 2,
                  ),
                  SizedBox(height: 20.w),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          CommonUtils.launchUrl(config.potatoGroup);
                        },
                        child: Column(
                          children: [
                            MyImage.asset(MyImagePaths.appWdLxpotao,
                                width: 39.w, height: 39.w),
                            SizedBox(height: 10.w),
                            Text('gfqtd'.tr(context: context),
                                style: MyTheme.black15)
                          ],
                        ),
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          CommonUtils.launchUrl(config.tgGroup);
                        },
                        child: Column(
                          children: [
                            MyImage.asset(MyImagePaths.appWdLxtgN,
                                width: 39.w, height: 39.w),
                            SizedBox(height: 10.w),
                            Text('gfqfj'.tr(context: context),
                                style: MyTheme.black15)
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
