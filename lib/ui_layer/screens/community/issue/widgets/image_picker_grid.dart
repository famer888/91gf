import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:provider/provider.dart';

import '../../../../notifiers/home_config_notifier.dart';
import '../../../../utils/common_utils.dart';
import '../../../../utils/my_toast.dart';
import '../../../common_widgets/my_image.dart';
import '../../../image_paths.dart';

class ImagePickerGrid extends StatefulWidget {
  const ImagePickerGrid({
    super.key,
    required this.upList,
    required this.picLimit,
  });

  final List<Map> upList;
  final int picLimit;

  @override
  State<ImagePickerGrid> createState() => _ImagePickerGridState();
}

class _ImagePickerGridState extends State<ImagePickerGrid> {
  late final _screenUtils = ScreenUtil();
  late final homeConfigNotifier = context.read<HomeConfigNotifier>();

  List<Map> get upList => widget.upList;

  int get picLimit => widget.picLimit;

  Future<void> imagePickerAssets() async {
    if (await CommonUtils.pickImage() case final xFile?) {
      MyToast.showLoading(text: 'scz'.tr());
      final result = await homeConfigNotifier.uploadImage(xFile);
      if (result != null && result['code'] == 1) {
        final url = "${result['msg']}";

        final image = await decodeImageFromList(await xFile.readAsBytes());

        upList.add({
          'media_url': url,
          'url': homeConfigNotifier.config.imgBase + url,
          'thumb_width': image.width,
          'thumb_height': image.height,
        });
        if (mounted) {
          setState(() {});
        }
      } else {
        MyToast.showText(text: result?['msg'] ?? 'failed');
      }
      MyToast.closeAllLoading();
    }
  }

  double get _itemWidth => (_screenUtils.screenWidth - 10.w * 2 - MyTheme.pagePadding * 2) / 3;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 3,
        mainAxisSpacing: 10.w,
        crossAxisSpacing: 10.w,
        children: [
          for (final uploadData in upList)
            Stack(
              children: [
                MyImage.network(
                  uploadData['url'],
                  fit: BoxFit.contain,
                  width: double.infinity,
                  height: double.infinity,
                  borderRadius: 5.w,
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () => setState(() => upList.remove(uploadData)),
                    child: MyImage.asset(MyImagePaths.appIssueCancelIcon, width: 18.w, height: 18.w),
                  ),
                )
              ],
            ),
          if (upList.length != picLimit)
            Stack(
              children: [
                GestureDetector(
                  onTap: imagePickerAssets,
                  child: Container(
                    width: _itemWidth,
                    height: _itemWidth,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(41, 28, 50, 0.8),
                      borderRadius: BorderRadius.all(Radius.circular(5.w)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        MyImage.asset(MyImagePaths.appIssueAddIcon, width: 20.w, height: 20.w),
                        SizedBox(height: 10.w),
                        Text(
                          'sctp'.tr(),
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: const Color.fromRGBO(255, 255, 255, 0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // const MyImage.asset(MyImagePaths.appIssueAdd),
                ),
              ],
            ),
        ]);
  }
}
