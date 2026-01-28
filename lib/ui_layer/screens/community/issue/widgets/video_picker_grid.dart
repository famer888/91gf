import 'dart:io';
import 'dart:typed_data';

import 'package:bot_toast/bot_toast.dart';
import 'package:cross_file/cross_file.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:provider/provider.dart';
import 'package:universal_html/html.dart' as html;
import 'package:video_player/video_player.dart';

import '../../../../notifiers/home_config_notifier.dart';
import '../../../../utils/common_utils.dart';
import '../../../../utils/my_toast.dart';
import '../../../common_widgets/my_image.dart';
import '../../../image_paths.dart';
import 'package:jygf/report/ui_layer/report_gesture_detector.dart';
import '../../../webview/fake_native_widget.dart' if (dart.library.html) '../../../webview/real_web_widget.dart' as ui;


class VideoPickerGrid extends StatefulWidget {
  const VideoPickerGrid({super.key, required this.video, required this.upList});

  final List<Map> upList;
  final Map video;

  @override
  State<VideoPickerGrid> createState() => _VideoPickerGridState();
}

class _VideoPickerGridState extends State<VideoPickerGrid> {
  late final _screenUtils = ScreenUtil();
  late final homeConfigNotifier = context.read<HomeConfigNotifier>();
  Uint8List? coverData;
  final GlobalKey _key = GlobalKey();
  static int _instanceCounter = 0;
  late final String _viewTypeId = 'video_picker_${_instanceCounter++}';
  html.FileUploadInputElement? uploadInput;

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
          uploadInput.multiple = false; // 视频通常只选择一个
          uploadInput.accept = 'video/*';
          uploadInput.style.width = '100%';
          uploadInput.style.height = '100%';
          uploadInput.style.opacity = '0'; // 隐藏控件

          // 文件上传后触发的事件处理
          uploadInput.onChange.listen((event) async {
            if (uploadInput.files != null && uploadInput.files!.isNotEmpty) {
              final file = uploadInput.files!.first;
              
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

                final ext = xFile.name.split('.').last.toLowerCase();
                
                // 验证视频格式
                if (ext == 'mp4' || xFile.mimeType == 'video/quicktime' || xFile.mimeType == 'video/mp4') {
                  await uploadVideo(xFile);
                } else {
                  MyToast.showText(text: 'qxzmpf'.tr());
                }
              } catch (e) {
                MyToast.showText(text: '上传失败: $e');
              }
              
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

  Future<void> _videoPickerAssets() async {
    MyToast.showLoading();
    if (await CommonUtils.pickVideo() case final xFile?) {
      MyToast.closeAllLoading();
      final ext = xFile.name.split('.').last.toLowerCase();

      if (kIsWeb || !Platform.isAndroid) {
        if (ext == 'mp4' || xFile.mimeType == 'video/quicktime') {
          await uploadVideo(xFile);
          return;
        }
      } else {
        try {
          final controller = VideoPlayerController.file(File(xFile.path));
          await controller.initialize();
          final codecName = controller.codecName;
          controller.dispose();
          if (codecName == 'h264') {
            await uploadVideo(xFile);
            return;
          }
        } catch (_) {}
      }

      MyToast.showText(text: 'qxzmpf'.tr());
    }
  }

  Future<void> uploadVideo(XFile file) async {
    BotToast.showCustomLoading(
      toastBuilder: (cancel) => XFileProgressToast(
        file: file,
        response: (data) async {
          BotToast.closeAllLoading();
          if (data?['video']?['code'] == 1) {
            final cover = data?['cover'];

            final url = "${data?['video']?['message']}";

            widget.video.clear();
            widget.video.addAll({
              'cover': '${cover?['msg']}',
              'media_url': url,
              'type': 1,
              'video_type': 'r2',
              'thumb_width': cover?['thumb_width'] ?? 0,
              'thumb_height': cover?['thumb_height'] ?? 0,
            });
          } else {
            MyToast.showText(text: data?['cover']?['code'] != 1 ? data?['cover']?['msg'] ?? data?['video']?['message'] : 'r2scsb'.tr());

            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                widget.upList.removeWhere((el) => el['type'] == 1);
                widget.video.clear();
                coverData = null;
              });
            });
          }
        },
        onCoverDataLoad: (Uint8List value) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              coverData = value;
            });
          });
        },
      ),
    );
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
        coverData != null
            ? Stack(
                fit: StackFit.expand,
                children: [
                  Image.memory(coverData!, fit: BoxFit.cover),
                  Center(child: MyImage.asset(MyImagePaths.appVPlayN, width: 30.w, height: 30.w)),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: ReportGestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        if (kIsWeb && uploadInput != null) {
                          uploadInput!.style.pointerEvents = 'none';
                        }
                        setState(() {
                          widget.upList.removeWhere((el) => el['type'] == 1);
                          widget.video.clear();
                          coverData = null;
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
              )
            : Stack(
                key: _key,
                children: [
                  ReportGestureDetector(
                    onTap: kIsWeb ? null : _videoPickerAssets,
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
                            'scsp'.tr(),
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
      ],
    );
  }
}
