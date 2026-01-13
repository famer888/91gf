import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jygf/domain/model/chat_select_nav_model.dart';
import 'package:jygf/domain/remote_domain/domains/chat.dart';
import 'package:jygf/domain/type_def.dart';
import 'package:jygf/ui_layer/notifiers/home_config_notifier.dart';
import 'package:jygf/ui_layer/screens/common_widgets/dialog/my_dialog.dart';
import 'package:jygf/ui_layer/screens/common_widgets/dialog/widgets/regular_dialog.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_app_bar.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_button.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jygf/ui_layer/screens/common_widgets/screen_background.dart';
import 'package:jygf/ui_layer/screens/image_paths.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/ui_layer/utils/common_utils.dart';
import 'package:jygf/ui_layer/utils/my_toast.dart';
import 'package:provider/provider.dart';
import 'package:jygf/report/ui_layer/report_gesture_detector.dart';


class ChatIssueScreen extends StatefulWidget {
  const ChatIssueScreen({super.key});

  @override
  State<ChatIssueScreen> createState() => _ChatIssueScreenState();
}

class _ChatIssueScreenState extends State<ChatIssueScreen> {
  late final _domain = context.read<ChatDomain>();
  late final _homeConfigNotifier = context.read<HomeConfigNotifier>();
  late final _homeConfig = context.read<HomeConfigNotifier>();

  late final List<ChatSelectNavModel> cates = _homeConfig.config.chatSelectNav;

  bool isHud = true;
  bool netError = false;
  final ImagePicker picker = ImagePicker();

  int picLimit = 6;
  List<Map> upList = [];
  List<ChatSelectNavModel> _seletedCates = [];

  String girlName = '';
  String girlAge = '';
  String girlHeight = '';
  String girlWeight = '';
  String girlCup = '';
  String girlPrice = '';
  String girlTime = '';
  String girlOption = '';
  String girlIntro = '';
  String girlContact = '';

  showClass(BuildContext ctx) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: ctx,
      builder: (context) {
        List<ChatSelectNavModel> seletedCates = List.from(_seletedCates);

        return StatefulBuilder(builder: (context, sss) {
          return Container(
            constraints: BoxConstraints(minHeight: 100.w, maxHeight: 300.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(16.w)
              ),
              color: MyTheme.bgColor,
            ),
            padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
            child: Column(children: [
              SizedBox(
                height: 45.w,
                child: Row(children: [
                  const Spacer(),
                  ReportGestureDetector(
                    onTap: () {
                      Navigator.of(ctx).pop();
                    },
                    child: Icon(
                      Icons.close,
                      size: 25.w,
                      color: MyTheme.white08Color,
                    ),
                  )
                ]),
              ),
              SizedBox(height: 15.w),
              Wrap(
                runSpacing: 10.w,
                spacing: 10.w,
                children: cates.map((e) => ReportGestureDetector(
                  onTap: () {
                    if (seletedCates.contains(e)) {
                      seletedCates.remove(e);
                    }
                    else {
                      seletedCates.add(e);
                    }
                    sss(() {});
                  },
                  child: Builder(builder: (context) {
                    bool isSelected = false;
                    for (var element in seletedCates) {
                      if (element == e) {
                        isSelected = true;
                        break;
                      }
                    }
                    return Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.w, vertical: 5.w),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? MyTheme.white08Color
                            : const Color.fromRGBO(0, 0, 0, 0.08),
                        borderRadius: BorderRadius.circular(5.w),
                      ),
                      child: Text(
                        '${e.name}',
                        style: isSelected 
                            ? MyTheme.white14
                            : MyTheme.gray153_14,
                      ),
                    );
                  }),
                )).toList(),
              ),
              const Spacer(),
              MyButton.gradient(
                minimumSize: Size.fromHeight(44.w),
                onPressed: () async {
                  _seletedCates = seletedCates;
                  _seletedCates.sort((a, b) => (a.id ?? 0).compareTo(b.id ?? 0));
                  if (mounted) setState(() {});
                  Navigator.of(ctx).pop();
                },
                borderRadius: 8,
                text: 'qr'.tr(context: context),
              ),
              SizedBox(height: 25.w),
            ]),
          );
        });
      },
    );
  }

  Future<void> imagePickerAssets() async {
    if (await CommonUtils.pickImage() case final xFile?) {
      MyToast.showLoading(text: 'scz'.tr());
      final result = await _homeConfigNotifier.uploadImage(xFile);
      if (result != null && result['code'] == 1) {
        final url = "${result['msg']}";

        final image = await decodeImageFromList(await xFile.readAsBytes());

        upList.add({
          'media_url': url,
          'url': _homeConfigNotifier.config.imgBase + url,
          'thumb_width': image.width,
          'thumb_height': image.height,
        });
        if (mounted) {
          setState(() {});
        }
      }
      else {
        MyToast.showText(text: result?['msg'] ?? 'failed');
      }
      MyToast.closeAllLoading();
    }
  }

  void uploadData() async {
    if (_seletedCates.isEmpty ||
        girlName.isEmpty ||
        girlAge.isEmpty ||
        girlHeight.isEmpty ||
        girlWeight.isEmpty ||
        girlCup.isEmpty ||
        girlPrice.isEmpty ||
        girlTime.isEmpty ||
        girlOption.isEmpty ||
        girlIntro.isEmpty ||
        girlContact.isEmpty) {
      MyToast.showText(text: 'qs'.tr());
      return;
    }

    if (upList.isEmpty) {
      MyToast.showText(text: 'qsctp'.tr());
      return;
    }

    List media = [];
    for (var element in upList) {
      media.add({
        'cover': element['media_url'],
        'uri': element['media_url'],
        'width': element['thumb_width'],
        'height': element['thumb_height'],
        'type': 'img',
      });
    }

    MyToast.showLoading();

    String cateString = _seletedCates.map((e) => e.id).join(',');

    final result = await _domain.chatCreate(allInfo: {
      'name': girlName,
      'cate_id': cateString,
      'price': girlPrice,
      'age': girlAge,
      'height': girlHeight,
      'weight': girlWeight,
      'cup': girlCup,
      'option': girlOption,
      'time': girlTime,
      'contact': girlContact,
      'intro': girlIntro,
      'medias': json.encode(media),
    });

    if (result.status == 1) {
      MyDialog.showDialog(
        context: context,
        child: RegularDialog(
          buttonText: 'qr'.tr(),
          cancelText: 'qx'.tr(),
          title: 'ts'.tr(),
          content: Text(
            result.msg ?? '',
            style: MyTheme.gray153_13,
            maxLines: 10,
          ),
          confirmOnTap: () {
            context.pop();
          },
          cancelOnTap: () {
            context.pop();
          },
        ),
      );
    }
    else {
      MyDialog.showDialog(
        context: context,
        child: RegularDialog(
          buttonText: 'qr'.tr(),
          cancelText: 'qx'.tr(),
          title: 'ts'.tr(),
          content: Text(
            result.msg ?? '',
            style: MyTheme.gray153_13,
            maxLines: 10,
          ),
          confirmOnTap: () {
            context.pop();
            FocusScope.of(context).unfocus();
          },
          cancelOnTap: () {
            context.pop();
            FocusScope.of(context).unfocus();
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      child: Scaffold(
        appBar: MyAppBar(title: 'fbll'.tr(context: context)),
        body: ReportGestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: MyTheme.pagePadding,
              vertical: 10.w
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 15.w),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 80.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            '*',
                            style: TextStyle(
                              color: MyTheme.primaryColor,
                              fontSize: 15.sp,
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.none,
                              height: 2,
                            ),
                          ),
                          SizedBox(width: 5.w),
                          Text(
                            '${'fbnc'.tr()}',
                            style: MyTheme.white16medium,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 5.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.w),
                          color: MyTheme.white02Color,
                        ),
                        child: TextField(
                          onChanged: (value) {
                            girlName = value;
                          },
                          style: MyTheme.white12,
                          cursorColor: MyTheme.white08Color,
                          textInputAction: TextInputAction.done,
                          decoration: CommonUtils.customInputStyle(
                            horizontal: 5.w,
                            hit: 'qsrnh'.tr() + 'nc'.tr(),
                            style: MyTheme.white04_12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15.w),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 80.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            '*',
                            style: TextStyle(
                              color: MyTheme.primaryColor,
                              fontSize: 15.sp,
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.none,
                              height: 2,
                            ),
                          ),
                          SizedBox(width: 5.w),
                          Text(
                            '${'tdzl'.tr()}',
                            style: MyTheme.white16medium,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(child: SizedBox()),
                  ],
                ),
                SizedBox(height: 10.w),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 80.w,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '${'liex'.tr()}',
                          style: MyTheme.white255_15,
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: ReportGestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          showClass(context);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.w),
                            color: MyTheme.white02Color,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Builder(builder: (context) {
                                String text = 'qxzyx'.tr();

                                if (_seletedCates.isNotEmpty) {
                                  text = _seletedCates.map((e) => e.name).join(',');
                                }
                                return Text(
                                  text,
                                  style: _seletedCates.isEmpty
                                      ? MyTheme.white04_12
                                      : MyTheme.white12,
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15.w),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 80.w,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '${'nl'.tr()}',
                          style: MyTheme.white255_15,
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 5.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.w),
                          color: MyTheme.white02Color,
                        ),
                        child: TextField(
                          onChanged: (value) {
                            girlAge = value;
                          },
                          style: MyTheme.white12,
                          cursorColor: MyTheme.white08Color,
                          inputFormatters: [
                            FilteringTextInputFormatter(RegExp('[0-9]'),
                                allow: true),
                            LengthLimitingTextInputFormatter(4),
                          ],
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          decoration: CommonUtils.customInputStyle(
                            horizontal: 5.w,
                            hit: 'qsrnh'.tr() + 'nl'.tr(),
                            style: MyTheme.white04_12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15.w),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 80.w,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '${'sg'.tr()}',
                          style: MyTheme.white255_15,
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 5.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.w),
                          color: MyTheme.white02Color,
                        ),
                        child: TextField(
                          onChanged: (value) {
                            girlHeight = value;
                          },
                          style: MyTheme.white12,
                          cursorColor: MyTheme.white08Color,
                          inputFormatters: [
                            FilteringTextInputFormatter(RegExp('[0-9]'),
                                allow: true),
                            LengthLimitingTextInputFormatter(4),
                          ],
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          decoration: CommonUtils.customInputStyle(
                            horizontal: 5.w,
                            hit: '${'qsrnh'.tr()}${'sg'.tr()} cm',
                            style: MyTheme.white04_12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15.w),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 80.w,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '${'tz'.tr()}',
                          style: MyTheme.white255_15,
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 5.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.w),
                          color: MyTheme.white02Color,
                        ),
                        child: TextField(
                          onChanged: (value) {
                            girlWeight = value;
                          },
                          style: MyTheme.white12,
                          cursorColor: MyTheme.white08Color,
                          inputFormatters: [
                            FilteringTextInputFormatter(RegExp('[0-9]'),
                                allow: true),
                            LengthLimitingTextInputFormatter(4),
                          ],
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          decoration: CommonUtils.customInputStyle(
                            horizontal: 5.w,
                            hit: '${'qsrnh'.tr()}${'tz'.tr()} kg',
                            style: MyTheme.white04_12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15.w),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 80.w,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '${'bzcup'.tr()}',
                          style: MyTheme.white255_15,
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 5.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.w),
                          color: MyTheme.white02Color,
                        ),
                        child: TextField(
                          onChanged: (value) {
                            girlCup = value;
                          },
                          style: MyTheme.white12,
                          cursorColor: MyTheme.white08Color,
                          textInputAction: TextInputAction.done,
                          decoration: CommonUtils.customInputStyle(
                            horizontal: 5.w,
                            hit: 'qsrnh'.tr() + 'bzcup'.tr(),
                            style: MyTheme.white04_12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15.w),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 80.w,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '${'fybz'.tr()}',
                          style: MyTheme.white255_15,
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 5.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.w),
                          color: MyTheme.white02Color,
                        ),
                        child: TextField(
                          onChanged: (value) {
                            girlPrice = value;
                          },
                          style: MyTheme.white12,
                          cursorColor: MyTheme.white08Color,
                          textInputAction: TextInputAction.done,
                          decoration: CommonUtils.customInputStyle(
                            horizontal: 5.w,
                            hit: 'qsrfybz'.tr(),
                            style: MyTheme.white04_12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15.w),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 80.w,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '${'fwsj'.tr()}',
                          style: MyTheme.white255_15,
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 5.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.w),
                          color: MyTheme.white02Color,
                        ),
                        child: TextField(
                          onChanged: (value) {
                            girlTime = value;
                          },
                          style: MyTheme.white12,
                          cursorColor: MyTheme.white08Color,
                          textInputAction: TextInputAction.done,
                          decoration: CommonUtils.customInputStyle(
                            horizontal: 5.w,
                            hit: 'qsrfwsj'.tr(),
                            style: MyTheme.white04_12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15.w),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 80.w,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '${'fwxm'.tr()}',
                          style: MyTheme.white255_15,
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: SizedBox(
                        height: 150.w,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.w),
                            color: MyTheme.white02Color,
                          ),
                          child: TextField(
                            keyboardType: TextInputType.multiline,
                            maxLines: 10,
                            autofocus: false,
                            onChanged: (value) {
                              girlOption = value;
                            },
                            style: MyTheme.white12,
                            cursorColor: MyTheme.white08Color,
                            textInputAction: TextInputAction.done,
                            decoration: CommonUtils.customInputStyle(
                              horizontal: 5.w,
                              hit: 'qsrfwxm'.tr(),
                              vertical: 8,
                              style: MyTheme.white04_12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15.w),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 80.w,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '${'fwjs'.tr()}',
                          style: MyTheme.white255_15,
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: SizedBox(
                        height: 150.w,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.w),
                            color: MyTheme.white02Color,
                          ),
                          child: TextField(
                            keyboardType: TextInputType.multiline,
                            maxLines: 10,
                            autofocus: false,
                            onChanged: (value) {
                              girlIntro = value;
                            },
                            style: MyTheme.white12,
                            cursorColor: MyTheme.white08Color,
                            textInputAction: TextInputAction.done,
                            decoration: CommonUtils.customInputStyle(
                              horizontal: 5.w,
                              hit: 'qsrfwjs'.tr(),
                              vertical: 8,
                              style: MyTheme.white04_12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15.w),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 80.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            '*',
                            style: TextStyle(
                              color: MyTheme.white08Color,
                              fontSize: 15.sp,
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.none,
                              height: 2,
                            ),
                          ),
                          SizedBox(width: 5.w),
                          Text(
                            '${'lxfs'.tr()}',
                            style: MyTheme.white255_15,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 5.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.w),
                          color: MyTheme.white02Color,
                        ),
                        child: TextField(
                          onChanged: (value) {
                            girlContact = value;
                          },
                          style: MyTheme.white12,
                          cursorColor: MyTheme.white08Color,
                          textInputAction: TextInputAction.done,
                          decoration: CommonUtils.customInputStyle(
                            horizontal: 5.w,
                            hit: 'qsrlxfs'.tr(),
                            style: MyTheme.white04_12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15.w),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 80.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            '*',
                            style: TextStyle(
                              color: MyTheme.white08Color,
                              fontSize: 15.sp,
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.none,
                              height: 2,
                            ),
                          ),
                          SizedBox(width: 5.w),
                          Text(
                            '${'sctp'.tr()}',
                            style: MyTheme.white255_15,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 7.5.w),
                          GridView.count(
                            padding: EdgeInsets.zero,
                            crossAxisCount: 3,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            mainAxisSpacing: 10.w,
                            crossAxisSpacing: 10.w,
                            children: upList.map((e) {
                              Widget w = Stack(children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 9.w, right: 9.w),
                                  child: Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    clipBehavior: Clip.hardEdge,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.w),
                                    ),
                                    child: MyImage.network(
                                      e['url'] ?? '',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: ReportGestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onTap: () {
                                      upList.remove(e);
                                      if (mounted) setState(() {});
                                    },
                                    child: MyImage.asset(
                                      MyImagePaths.appIssueCancelIcon,
                                      width: 18.w,
                                      height: 18.w,
                                    ),
                                  ),
                                )
                              ]);
                              return w;
                            }).toList()
                              ..add(
                                upList.length == picLimit
                                    ? const SizedBox()
                                    : ReportGestureDetector(
                                        onTap: imagePickerAssets,
                                        child: const MyImage.asset(MyImagePaths.appIssueAdd),
                                      ),
                              ),
                          ),
                          SizedBox(height: 10.w),
                          Text(
                            'zuscazpbcgbm'
                                .tr()
                                .replaceAll('a', '$picLimit')
                                .replaceAll('b', '2'),
                            style: MyTheme.white04_14,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40.w),
                MyButton.gradient(
                  minimumSize: Size.fromHeight(40.w),
                  onPressed: () async {
                    uploadData();
                  },
                  borderRadius: 20.w,
                  text: 'ljfb'.tr(context: context),
                ),
                SizedBox(height: 100.w)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
