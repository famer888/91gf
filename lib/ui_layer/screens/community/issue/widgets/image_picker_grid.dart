import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:provider/provider.dart';
import 'package:universal_html/html.dart' as html;

import '../../../../notifiers/home_config_notifier.dart';
import '../../../../utils/common_utils.dart';
import '../../../../utils/my_toast.dart';
import '../../../common_widgets/my_image.dart';
import '../../../image_paths.dart';
import 'package:jygf/report/ui_layer/report_gesture_detector.dart';
import '../../../webview/fake_native_widget.dart' if (dart.library.html) '../../../webview/real_web_widget.dart' as ui;


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
  final GlobalKey _key = GlobalKey();
  static int _instanceCounter = 0;
  late final String _viewTypeId = 'image_picker_${_instanceCounter++}';
  html.FileUploadInputElement? uploadInput;

  List<Map> get upList => widget.upList;

  int get picLimit => widget.picLimit;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      ui.platformViewRegistry.registerViewFactory(
        _viewTypeId,
        (int viewId, {Object? params}) {
          // 创建一个 FileUploadInputElement
          final uploadInput = html.FileUploadInputElement();

          // 设置文件上传控件的属性
          uploadInput.multiple = true;
          uploadInput.accept = 'image/*';
          uploadInput.style.width = '100%';
          uploadInput.style.height = '100%';
          uploadInput.style.opacity = '0'; // 隐藏控件

          // 文件上传后触发的事件处理
          uploadInput.onChange.listen((event) async {
            if (uploadInput.files != null && uploadInput.files!.isNotEmpty) {
              final files = uploadInput.files!;
              final maxFiles = picLimit - upList.length;
              
              if (files.length > maxFiles) {
                MyToast.showText(text: '最多可传${maxFiles}个文件');
              }
              
              final filesToProcess = files.length > maxFiles
                  ? files.sublist(0, maxFiles)
                  : files;

              MyToast.showLoading(text: 'scz'.tr());

              for (var file in filesToProcess) {
                try {
                  final reader = html.FileReader();
                  reader.readAsArrayBuffer(file);
                  
                  await reader.onLoadEnd.first;
                  
                  final bytes = Uint8List.fromList(reader.result as List<int>);
                  
                  // 创建 XFile 对象用于上传
                  final xFile = XFile.fromData(
                    bytes,
                    name: file.name,
                    mimeType: file.type,
                  );

                  final result = await homeConfigNotifier.uploadImage(xFile);
                  if (result != null && result['code'] == 1) {
                    final url = "${result['msg']}";
                    final image = await decodeImageFromList(bytes);

                    upList.add({
                      'media_url': url,
                      'url': homeConfigNotifier.config.imgBase + url,
                      'thumb_width': image.width,
                      'thumb_height': image.height,
                    });
                  } else {
                    MyToast.showText(text: result?['msg'] ?? 'failed');
                  }
                } catch (e) {
                  MyToast.showText(text: '上传失败: $e');
                }
              }

              if (mounted) {
                setState(() {});
              }
              MyToast.closeAllLoading();
              
              // 重置 input，允许再次选择相同文件
              uploadInput.value = '';
            }
          });

          // 保存引用以便后续使用
          this.uploadInput = uploadInput;

          // 返回 FileUploadInputElement 作为对象
          return uploadInput;
        },
      );
    }
  }

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
                    onTap: () {
                      //不移除响应会触发选择弹窗
                      if (kIsWeb && uploadInput != null) {
                        uploadInput!.style.pointerEvents = 'none';
                      }
                      setState(() {
                        upList.remove(uploadData);
                      });
                      if (kIsWeb && uploadInput != null) {
                        Future.delayed(const Duration(milliseconds: 500), () {
                          if (mounted && uploadInput != null) {
                            uploadInput!.style.pointerEvents = 'auto';
                          }
                        });
                      }
                    },
                    child: MyImage.asset(MyImagePaths.appIssueCancelIcon, width: 18.w, height: 18.w),
                  ),
                )
              ],
            ),
          if (upList.length != picLimit)
            Stack(
              key: _key,
              children: [
                ReportGestureDetector(
                  onTap: kIsWeb ? null : imagePickerAssets,
                  behavior: HitTestBehavior.translucent,
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
                if (kIsWeb)
                  Positioned.fill(
                    child: HtmlElementView(
                      viewType: _viewTypeId,
                    ),
                  ),
              ],
            ),
        ]);
  }
}
