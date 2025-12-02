import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jygf/domain/async_value.dart';
import 'package:jygf/domain/model/ai/ai_magic_model.dart';
import 'package:jygf/domain/model/member_model.dart';
import 'package:jygf/domain/model/video_detail_model.dart';
import 'package:jygf/domain/remote_domain/domains/aimagic.dart';
import 'package:jygf/ui_layer/notifiers/home_config_notifier.dart';
import 'package:jygf/ui_layer/notifiers/user_notifier.dart';
import 'package:jygf/ui_layer/screens/common_widgets/dialog/widgets/regular_dialog.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_app_bar.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jygf/ui_layer/screens/common_widgets/screen_background.dart';
import 'package:jygf/ui_layer/screens/common_widgets/status/loading.dart';
import 'package:jygf/ui_layer/screens/common_widgets/status/network_error.dart';
import 'package:jygf/ui_layer/screens/common_widgets/video_player/shortv_mv_player.dart';
import 'package:jygf/ui_layer/screens/image_paths.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/ui_layer/utils/common_utils.dart';
import 'package:jygf/ui_layer/utils/my_toast.dart';
import 'package:provider/provider.dart';

class AIMagicDetail extends StatefulWidget {
  const AIMagicDetail({super.key, required this.data});
  final AIMagicModel data;

  @override
  State<AIMagicDetail> createState() => _AIMagicDetailState();
}

class _AIMagicDetailState extends State<AIMagicDetail> {
  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
        child: Scaffold(
      appBar: MyAppBar(
        title: widget.data.title,
      ),
      body: _Body(data: widget.data),
    ));
  }
}

class _Body extends StatefulWidget {
  const _Body({required this.data});
  final AIMagicModel data;

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> with WidgetsBindingObserver {
  late final _appDomain = context.read<AIMagicDomain>();
  late final homeConfig = context.read<HomeConfigNotifier>();
  late final userNotifier = context.read<UserNotifier>();
  late Member member = userNotifier.member;
  late int aiMagicCost = homeConfig.config.payAiMagic;
  int get freeNumber => userNotifier.member.aiMagicValue;
  int get coins => userNotifier.member.money;
  AsyncValue<dynamic> _asyncValue = const AsyncInit();

  // upList
  List<Map> upList = [];

  @override
  void initState() {
    _init();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeMetrics() {
    // Handle metrics change if needed
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _init() async {
    if (_asyncValue.isLoading) return;

    setState(() {
      _asyncValue = const AsyncLoading();
    });

    final videoJson = {
      'id': widget.data.id,
      'title': widget.data.title,
      'second_title': widget.data.title,
      'thumb_cover': widget.data.cover,
      'source_240': widget.data.video,
    };

    VideoData data = VideoData.fromJson(videoJson);

    _asyncValue = AsyncData(data);

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> onSubmit() async {
    MyToast.showLoading(text: '正在提交...');
    final String thumb = upList[0]['media_url'].toString();
    final String thumbW = upList[0]['thumb_width'].toString();
    final String thumbH = upList[0]['thumb_height'].toString();
    final result = await _appDomain.aiMagicGenerate(
        materialId: widget.data.id.toString(),
        thumb: thumb,
        thumbW: thumbW,
        thumbH: thumbH);

    MyToast.closeAllLoading();
    if (result.status == 1) {
      CommonUtils.showDialog(
        context: context,
        builder: (context) => RegularDialog(
          buttonText: 'gb'.tr(),
          title: 'wxts'.tr(),
          content: Text('提交成功，稍后前往\n【AI记录】中查看',
              style: MyTheme.white255_15, textAlign: TextAlign.center),
          confirmOnTap: () async {
            clearUploadList();
            context.pop();
          },
        ),
      );
      final magicValue = freeNumber - 1;
      if (magicValue >= 0) {
        userNotifier.setMagicValue(num: magicValue);
      } else {
        userNotifier.setMoney(money: coins - aiMagicCost);
      }
    } else {
      MyToast.showText(text: result.msg ?? '生成失败');
    }
  }

  void clearUploadList() {
    upList.clear();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return _asyncValue.maybeWhen(
      data: (data) {
        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                        padding: EdgeInsets.all(10.w),
                        width: double.infinity,
                        child: widget.data.video.isEmpty
                            ? widget.data.cover.isEmpty
                                ? const SizedBox()
                                : MyImage.network(widget.data.cover)
                            : AspectRatio(
                                aspectRatio: 1,
                                child:
                                    ShortvMvPlayer(info: data, noBack: true))),
                    Center(
                      child: Text(
                        "选择一张照片",
                        style: MyTheme.white15,
                      ),
                    ),
                    Center(
                      child: Text(
                        "照片大小不超过1M",
                        style: MyTheme.white06_15,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25.w),
                      child: AIImagePickerGrid(upList: upList, picLimit: 1),
                    ),
                    SizedBox(height: 20.h),
                    Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 25.w),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            UploadMagicTip(
                              thumb: MyImagePaths.appAiMagicPic1,
                              title: "近身照",
                              icon: MyImagePaths.appAiMagicRight,
                            ),
                            UploadMagicTip(
                              thumb: MyImagePaths.appAiMagicPic2,
                              title: "上身有遮挡",
                              icon: MyImagePaths.appAiMagicError,
                            ),
                            UploadMagicTip(
                              thumb: MyImagePaths.appAiMagicPic3,
                              title: "不是正面",
                              icon: MyImagePaths.appAiMagicError,
                            ),
                            UploadMagicTip(
                              thumb: MyImagePaths.appAiMagicPic4,
                              title: "过于模糊",
                              icon: MyImagePaths.appAiMagicError,
                            ),
                          ],
                        )),
                  ],
                ),
              ),
            ),
            SubmitButton(
              onTap: () async {
                if (upList.isEmpty) {
                  CommonUtils.showDialog(
                    context: context,
                    builder: (context) => RegularDialog(
                      buttonText: 'qd'.tr(),
                      title: 'wxts'.tr(),
                      content: Text('qsctp'.tr(context: context),
                          style: MyTheme.white255_15,
                          textAlign: TextAlign.center),
                    ),
                  );
                  return;
                }
                if (freeNumber <= 0) {
                  CommonUtils.showDialog(
                    context: context,
                    builder: (context) => RegularDialog(
                      buttonText: 'qd'.tr(),
                      cancelText: 'qx'.tr(),
                      title: 'ts'.tr(),
                      content: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(children: [
                            TextSpan(
                              text: '使用$aiMagicCost金币进行生成？',
                              style: MyTheme.white255_15,
                            ),
                          ])),
                      confirmOnTap: () {
                        onSubmit();
                        context.pop();
                      },
                    ),
                  );
                } else {
                  onSubmit();
                }
              },
            )
          ],
        );
      },
      error: (error, __) => NetworkErrorView(
        text: error is String? ? error : null,
        onTap: _init,
      ),
      orElse: () => const LoadingView(),
    );
  }
}

class UploadMagicTip extends StatelessWidget {
  const UploadMagicTip({
    super.key,
    required this.thumb,
    required this.title,
    required this.icon,
  });

  final String thumb;
  final String title;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          thumb,
          width: 85.w,
          fit: BoxFit.fitHeight,
        ),
        SizedBox(height: 5.w),
        Text(
          title,
          style: MyTheme.white14,
        ),
        SizedBox(height: 5.w),
        Center(
          child: Image.asset(
            icon,
            width: 15.w,
            fit: BoxFit.fitHeight,
          ),
        )
      ],
    );
  }
}

class SubmitButton extends StatefulWidget {
  const SubmitButton({super.key, this.onTap});
  final Function? onTap;

  @override
  State<SubmitButton> createState() => _SubmitButtonState();
}

class _SubmitButtonState extends State<SubmitButton> {
  late final homeConfig = context.read<HomeConfigNotifier>();

  void _handleTap(BuildContext context) {
    final userNotifier = context.read<UserNotifier>();
    final member = userNotifier.member;
    final freeNumber = member.aiMagicValue;
    final coins = member.money;
    final aiMagicCost = homeConfig.config.payAiMagic;

    if (freeNumber > 0) {
      widget.onTap?.call();
    } else if (coins < aiMagicCost) {
      MyToast.showText(text: '余额不足，无法生成');
    } else {
      widget.onTap?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    // 使用 context.watch 来监听 UserNotifier 的变化
    final userNotifier = context.watch<UserNotifier>();
    final member = userNotifier.member;
    final aiMagicCost = homeConfig.config.payAiMagic;
    final freeNumber = member.aiMagicValue;
    final coins = member.money;

    final String buttonText = freeNumber > 0
        ? '免费生成（剩余 $freeNumber 次）'
        : '需消耗 $aiMagicCost 金币【余额 $coins】生成';
    return GestureDetector(
      onTap: () => _handleTap(context),
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.all(15.w),
        padding: EdgeInsets.symmetric(vertical: 12.w),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(35.r),
            gradient: const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xff579bf1),
                Color(0xff3d54f5),
              ],
            )),
        child: Text(buttonText, style: MyTheme.white16medium),
      ),
    );
  }
}

class AIImagePickerGrid extends StatefulWidget {
  const AIImagePickerGrid({
    super.key,
    required this.upList,
    required this.picLimit,
  });
  final List<Map> upList;
  final int picLimit;
  @override
  State<AIImagePickerGrid> createState() => _AIImagePickerGridState();
}

class _AIImagePickerGridState extends State<AIImagePickerGrid> {
  late final homeConfigNotifier = context.read<HomeConfigNotifier>();
  List<Map> get upList => widget.upList;
  int get picLimit => widget.picLimit;
  Future<void> imagePickerAssets() async {
    if (await CommonUtils.pickImage() case final xFile?) {
      final ext = xFile.name.split('.').last.toLowerCase();
      if (!['jpg', 'jpeg', 'png'].contains(ext)) {
        MyToast.showText(text: '只支持 jpg/jpeg/png 格式的图片');
        return;
      }
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
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xff1b1c2b),
                      borderRadius: BorderRadius.circular(5.r),
                    ),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MyImage.asset(
                          MyImagePaths.appAiUploadIcon,
                          width: 50.w,
                          height: 50.w,
                        ),
                        SizedBox(height: 5.w),
                        Text(
                          '点击上传',
                          style: MyTheme.white14,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            )
        ]);
  }
}
