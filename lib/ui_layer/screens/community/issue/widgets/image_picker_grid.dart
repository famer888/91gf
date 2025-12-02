import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
                    child: MyImage.asset(
                      MyImagePaths.appIssueCancelIcon,
                      width: 18.w,
                      height: 18.w,
                    ),
                  ),
                )
              ],
            ),
          if (upList.length != picLimit)
            Stack(
              children: [
                GestureDetector(
                  onTap: imagePickerAssets,
                  child: const MyImage.asset(MyImagePaths.appIssueAdd),
                ),
              ],
            )
        ]);
  }
}
