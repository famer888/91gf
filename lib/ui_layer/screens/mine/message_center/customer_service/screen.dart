import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/ui_layer/router/routes.dart';
import 'package:provider/provider.dart';

import '../../../../../domain/api_validator.dart';
import '../../../../../domain/async_value.dart';
import '../../../../../domain/model/feedback_data_model.dart';
import '../../../../../domain/remote_domain/domains/message.dart';
import '../../../../notifiers/home_config_notifier.dart';
import '../../../../utils/common_utils.dart';
import '../../../../utils/my_toast.dart';
import '../../../common_widgets/my_app_bar.dart';
import '../../../common_widgets/my_image.dart';
import '../../../common_widgets/screen_background.dart';
import '../../../common_widgets/status/empty_data.dart';
import '../../../common_widgets/status/loading.dart';
import '../../../common_widgets/status/network_error.dart';
import '../../../image_paths.dart';
import '../../../theme.dart';
import 'package:jygf/report/ui_layer/report_gesture_detector.dart';


class MineCustomerServiceScreen extends StatefulWidget {
  const MineCustomerServiceScreen({super.key});

  @override
  State<MineCustomerServiceScreen> createState() =>
      _MineCustomerServiceScreenState();
}

class _MineCustomerServiceScreenState extends State<MineCustomerServiceScreen> {
  late final _messageDomain = context.read<MessageDomain>();
  late final _homeConfigNotifier = context.read<HomeConfigNotifier>();

  AsyncValue _asyncValue = const AsyncInit();

  final data = <FeedBackData>[];

  final focusNode = FocusNode();

  final textEditingController = TextEditingController();

  @override
  void initState() {
    _initData();
    super.initState();
  }

  Future<void> _initData() async {
    final result = await _messageDomain.getFeedbackList(page: 1);
    if (result.data case final resultData?) {
      data.addAll(resultData);
      _asyncValue = const AsyncData(null);
    } else {
      if (result.msg case final msg?) {
        MyToast.showText(text: msg);
      }
      _asyncValue = const AsyncError();
    }

    setState(() {});
  }

  Future _imagePickerAssets() async {
    if (await CommonUtils.pickImage() case final xFile?) {
      MyToast.showLoading(text: 'scz'.tr());
      final uploadImageRes = await _homeConfigNotifier.uploadImage(xFile);
      MyToast.closeAllLoading();

      if (uploadImageRes != null && uploadImageRes['code'] == 1) {
        final url = "${uploadImageRes['msg']}";
        final sendFeedingRes = await _messageDomain.sendFeeding(
            content: url, type: 2, helpType: 0);
        if (sendFeedingRes.isValid) {
          final message = FeedBackData.fromJson({
            'messageType': 2,
            'status': 1,
            'createdAt': CommonUtils.getCurrentTimer(),
            'message': '${_homeConfigNotifier.config.imgBase}$url',
          });

          data.insert(0, message);
          setState(() {});
        } else {
          MyToast.showText(text: 'tpsbcs'.tr());
        }
      } else {
        MyToast.showText(text: uploadImageRes?['msg'] ?? 'failed');
      }
    }
  }

  Future _sendMsg() async {
    final text = textEditingController.text.trim();
    textEditingController.clear();
    if (text.isNotEmpty) {
      final result =
          await _messageDomain.sendFeeding(content: text, type: 1, helpType: 0);
      if (result.isValid) {
        final message = FeedBackData.fromJson({
          'messageType': 1,
          'status': 1,
          'createdAt': CommonUtils.getCurrentTimer(),
          'message': text,
        });
        data.insert(0, message);
        setState(() {});
      } else {
        MyToast.showText(text: 'wlbjcs'.tr());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      child: Scaffold(
        appBar: MyAppBar(
          title: 'zxkf'.tr(context: context),
          rightWidget: ReportGestureDetector(
            onTap: () => const MineHelpRoute().push(context),
            child: Text(
              'cjwti'.tr(context: context),
              style: MyTheme.gray15,
            ),
          ),
        ),
        body: Column(
          children: [
            const _Tips(),
            Expanded(
              child: _asyncValue.maybeWhen(
                orElse: () => const LoadingView(),
                error: (_, __) => NetworkErrorView(onTap: _initData),
                data: (_) => data.isEmpty
                    ? const PageEmptyDataView()
                    : ListView.builder(
                        itemCount: data.length,
                        reverse: true,
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        padding: EdgeInsets.symmetric(
                          horizontal: MyTheme.pagePadding,
                          vertical: 30.w,
                        ),
                        itemBuilder: (BuildContext context, int index) =>
                            data[index].status == 1
                                ? _UserBubble(item: data[index])
                                : _ServiceBubble(item: data[index]),
                      ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: MyTheme.pagePadding),
              color: Colors.white.withOpacity(0.1),
              child: SafeArea(
                child: SizedBox(
                  height: 50.w,
                  child: Row(
                    children: [
                      Container(
                        width: 310.w,
                        height: 36.w,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.03),
                          borderRadius: BorderRadius.circular(18.w),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 17.5.w,
                              height: 17.w,
                              child: ReportGestureDetector(
                                onTap: _imagePickerAssets,
                                child: MyImage.asset(
                                  MyImagePaths.appCustomerServiceSelectImg,
                                  width: 17.5.w,
                                  height: 17.w,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5.w),
                                child: TextField(
                                  focusNode: focusNode,
                                  autofocus: true,
                                  controller: textEditingController,
                                  style: MyTheme.white255_14,
                                  cursorColor: MyTheme.cyanColor00edfd,
                                  textInputAction: TextInputAction.done,
                                  decoration: InputDecoration(
                                    hintText: 'srhf'.tr(context: context),
                                    hintStyle: MyTheme.gray180_15_M,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 7.w),
                      ReportGestureDetector(
                        onTap: _sendMsg,
                        child: SizedBox(
                          width: 44.w,
                          height: 44.w,
                          child: const Center(
                            child: Icon(
                              Icons.send_sharp,
                              size: 30,
                              color: MyTheme.jellyCyanColor103224185,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _Tips extends StatelessWidget {
  const _Tips();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30.w,
      width: double.infinity,
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.1)),
      child: Center(
        child: Text(
          'zxkfts'.tr(context: context),
          textAlign: TextAlign.center,
          style: MyTheme.green11,
        ),
      ),
    );
  }
}

class _UserBubble extends StatelessWidget {
  const _UserBubble({required this.item});

  final FeedBackData item;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: item.createdAt != null
              ? Text(
                  item.createdAt!,
                  style: TextStyle(
                      color: const Color(0xffb4b4b4), fontSize: 11.sp),
                )
              : const SizedBox.shrink(),
        ),
        Padding(
          padding: EdgeInsets.only(top: 13.w, bottom: 20.w),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Flexible(
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(21, 28, 40, 1),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 15.5.w,
                    vertical: 14.5.w,
                  ),
                  child: item.messageType == 1
                      ? _RichMessage(msg: item.message, status: item.status)
                      : item.isLocal != null
                          ? kIsWeb
                              ? Image.memory(
                                  base64.decode(item.message.split(',')[1]),
                                  fit: BoxFit.contain,
                                  width: 150.w,
                                  height: 150.w,
                                  gaplessPlayback: true,
                                )
                              : SizedBox(
                                  width: 150.w,
                                  height: 150.w,
                                  child: MyImage.network(item.message,
                                      key: UniqueKey()),
                                )
                          : SizedBox(
                              width: 150.w,
                              height: 150.w,
                              child: MyImage.network(item.message,
                                  key: UniqueKey()),
                            ),
                ),
              ),
              SizedBox(width: 9.5.w),
              MyImage.asset(
                MyImagePaths.appWdServmeN,
                width: 36.w,
                height: 36.w,
              ),
            ],
          ),
        )
      ],
    );
  }
}

class _ServiceBubble extends StatelessWidget {
  const _ServiceBubble({required this.item});

  final FeedBackData item;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: item.createdAt != null
              ? Text(
                  item.createdAt!,
                  style:
                      TextStyle(color: const Color(0xffb4b4b4), fontSize: 11.w),
                )
              : const SizedBox.shrink(),
        ),
        Padding(
          padding: EdgeInsets.only(top: 13.w, bottom: 20.w),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyImage.asset(
                MyImagePaths.appWdServsN,
                width: 36.w,
                height: 36.w,
              ),
              SizedBox(width: 9.5.w),
              Flexible(
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(21, 28, 40, 1),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: EdgeInsets.symmetric(
                      horizontal: 15.5.w, vertical: 14.5.w),
                  child: item.messageType == 1
                      ? _RichMessage(msg: item.message, status: 0)
                      : item.isLocal != null
                          ? kIsWeb
                              ? Image.memory(
                                  base64.decode(item.message.split(',')[1]),
                                  fit: BoxFit.contain,
                                  width: 150.w,
                                  height: 150.w,
                                  gaplessPlayback: true,
                                )
                              : SizedBox(
                                  width: 150.w,
                                  height: 150.w,
                                  child: MyImage.network(item.message,
                                      key: UniqueKey()),
                                )
                          : SizedBox(
                              width: 150.w,
                              height: 150.w,
                              child: MyImage.network(item.message,
                                  key: UniqueKey()),
                            ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}

class _RichMessage extends StatelessWidget {
  const _RichMessage({
    required this.msg,
    required this.status,
  });

  static final regExp = RegExp(
    r'(http|ftp|https):\/\/[\w\-_]+(\.[\w\-_]+)+([\w\-\.,@?^=%&amp;:/~\+#]*[\w\-\@?^=%&amp;/~\+#])?',
    multiLine: true,
  );
  final String msg;
  final int status;

  @override
  Widget build(BuildContext context) {
    final isPath = regExp.hasMatch(msg);
    final pathMsg = msg.replaceAll('http', '[wwsj]http');
    final pathList = pathMsg.split('[wwsj]');
    final textList = [];
    for (var i = 0; i < pathList.length; i++) {
      if (regExp.hasMatch(pathList[i])) {
        final subString = regExp.stringMatch(pathList[i]);
        var newMsg = subString == null
            ? pathList[i]
            : pathList[i].replaceAll(subString, '[wwsj]$subString[wwsj]');
        textList.addAll(newMsg.split('[wwsj]'));
      } else {
        textList.add(pathList[i]);
      }
    }

    return isPath
        ? Text.rich(TextSpan(
            children: textList
                .asMap()
                .keys
                .map((e) => TextSpan(
                      text: textList[e],
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: regExp.hasMatch(textList[e])
                            ? const Color(0xff1967D2)
                            : status == 1
                                ? const Color.fromRGBO(180, 180, 180, 1)
                                : const Color(0xff1967D2),
                        decoration: regExp.hasMatch(textList[e])
                            ? TextDecoration.underline
                            : null,
                        height: 1.7,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          CommonUtils.launchUrl(textList[e]);
                        },
                    ))
                .toList()))
        : Text(
            msg,
            style: TextStyle(
              fontSize: 15.sp,
              color: const Color.fromRGBO(180, 180, 180, 1),
              height: 1.7,
            ),
            softWrap: true,
          );
  }
}
