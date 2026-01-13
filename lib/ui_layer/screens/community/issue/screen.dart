import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../domain/domain.dart';
import '../../../../domain/model/video_detail_model.dart';
import '../../../../domain/type_def.dart';

import '../../../notifiers/home_config_notifier.dart';
import '../../common_widgets/screen_background.dart';
import '../../../utils/common_utils.dart';

import '../../../../domain/model/topic_model.dart';
import '../../../notifiers/user_notifier.dart';
import '../../../utils/my_toast.dart';
import '../../common_widgets/dialog/widgets/regular_dialog.dart';
import '../../common_widgets/my_app_bar.dart';
import '../../common_widgets/video_player/shortv_mv_player.dart';
import '../../theme.dart';
import 'widgets/image_picker_grid.dart';
import 'widgets/input_field.dart';
import 'widgets/post_button.dart';
import 'widgets/topic_field.dart';
import 'widgets/upload_hint_text.dart';
import 'widgets/video_picker_grid.dart';
import 'package:jygf/report/ui_layer/report_gesture_detector.dart';


enum CommunityIssueType {
  /// 图片
  image,

  /// 视频
  video,

  /// 图文
  imageAndText,
}

enum CommunityIssueTopicType {
  /// 社区
  community,

  /// 约会
  date,

  /// 原创
  original;

  int get type => switch (this) {
        CommunityIssueTopicType.community => 1,
        CommunityIssueTopicType.date => 2,
        CommunityIssueTopicType.original => 3,
      };
}

class CommunityIssueScreen extends StatefulWidget {
  const CommunityIssueScreen({
    super.key,
    required this.type,
    this.topicType = CommunityIssueTopicType.community,
  });

  final CommunityIssueType type;
  final CommunityIssueTopicType topicType;

  @override
  State<CommunityIssueScreen> createState() => _CommunityIssueScreenState();
}

class _CommunityIssueScreenState extends State<CommunityIssueScreen> {
  CommunityIssueType get type => widget.type;

  final ValueNotifier<bool> _publishAvAvailableNotifier = ValueNotifier(false);
  late final config = context.read<HomeConfigNotifier>().config;
  late final userNotifier = context.read<UserNotifier>();
  late final domain = context.read<CommunityDomain>();

  final video = {};

  /// 上传图片数量
  final List<Map> upList = [];

  /// 图片最大上传数
  final picLimit = 9;

  /// 是否公开
  final isOpenNotifier = ValueNotifier(true);

  /// 是否直播
  bool isLive = true;

  final topicNotifier = ValueNotifier<TopicModel?>(null);

  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final coinController = TextEditingController();
  final contactController = TextEditingController();

  Widget _buildMtxqView() => ValueListenableBuilder(
        valueListenable: topicNotifier,
        builder: (_, topic, __) {
          if (topic?.type == 2) {
            return Padding(
              padding: EdgeInsets.only(bottom: 20.w),
              child: Text(
                'mtxq'.tr(namedArgs: {'name': topic?.name ?? '', 'amount': '${config.payAi}'}),
                style: MyTheme.red14,
                maxLines: 3,
              ),
            );
          }
          return const SizedBox.shrink();
        },
      );

  Widget _buildContent() => switch (type) {
        CommunityIssueType.image => ValueListenableBuilder(
            valueListenable: topicNotifier,
            builder: (_, topic, __) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...topic?.isAi == 2
                      ? [
                          InputField(
                            controller: contactController,
                            height: 42.w,
                            hintText: 'srlxfs'.tr(context: context),
                            showBoarder: false,
                            backgroundDecoration: BoxDecoration(
                              color: const Color.fromRGBO(41, 28, 50, 0.8),
                              borderRadius: BorderRadius.all(Radius.circular(6.w)),
                            ),
                          ),
                          SizedBox(height: 20.w),
                          InputField(
                            controller: coinController,
                            height: 42.w,
                            hintText: 'szjsjg'.tr(context: context),
                            showBoarder: false,
                            backgroundDecoration: BoxDecoration(
                              color: const Color.fromRGBO(41, 28, 50, 0.8),
                              borderRadius: BorderRadius.all(Radius.circular(6.w)),
                            ),
                            inputFormatter: [
                              FilteringTextInputFormatter(
                                RegExp('[0-9]'),
                                allow: true,
                              ),
                              LengthLimitingTextInputFormatter(3),
                            ],
                          ),
                          SizedBox(height: 20.w),
                        ]
                      : [Container()],
                  UploadHintText(
                    title: 'sctp'.tr(context: context),
                    text: 'zdjzbkb'.tr(context: context),
                  ),
                  SizedBox(height: 15.w),
                  ImagePickerGrid(upList: upList, picLimit: picLimit)
                ],
              );
            },
          ),
        CommunityIssueType.imageAndText => ValueListenableBuilder(
            valueListenable: topicNotifier,
            builder: (_, topic, __) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InputField(
                    controller: contentController,
                    height: 150.w,
                    hintText: 'runr'.tr(context: context),
                    showBoarder: false,
                    backgroundDecoration: BoxDecoration(
                      color: const Color.fromRGBO(41, 28, 50, 0.8),
                      borderRadius: BorderRadius.all(Radius.circular(6.w)),
                    ),
                  ),
                  SizedBox(height: 15.w),
                  ...topic?.isAi == 2
                      ? [
                          InputField(
                            controller: contactController,
                            height: 42.w,
                            hintText: 'srlxfs'.tr(context: context),
                            showBoarder: false,
                            backgroundDecoration: BoxDecoration(
                              color: const Color.fromRGBO(41, 28, 50, 0.8),
                              borderRadius: BorderRadius.all(Radius.circular(6.w)),
                            ),
                          ),
                          SizedBox(height: 20.w),
                          InputField(
                            controller: coinController,
                            height: 42.w,
                            hintText: 'szjsjg'.tr(context: context),
                            showBoarder: false,
                            backgroundDecoration: BoxDecoration(
                              color: const Color.fromRGBO(41, 28, 50, 0.8),
                              borderRadius: BorderRadius.all(Radius.circular(6.w)),
                            ),
                            inputFormatter: [
                              FilteringTextInputFormatter(
                                RegExp('[0-9]'),
                                allow: true,
                              ),
                              LengthLimitingTextInputFormatter(3),
                            ],
                          ),
                          SizedBox(height: 20.w),
                        ]
                      : [Container()],
                  UploadHintText(
                    title: 'sctp'.tr(context: context),
                    text: 'zdjzbkb'.tr(context: context),
                  ),
                  SizedBox(height: 16.w),
                  ImagePickerGrid(
                    upList: upList,
                    picLimit: picLimit,
                  )
                ],
              );
            },
          ),
        CommunityIssueType.video => ValueListenableBuilder(
            valueListenable: topicNotifier,
            builder: (_, topic, __) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InputField(
                    controller: contentController,
                    height: 150.w,
                    showBoarder: false,
                    backgroundDecoration: BoxDecoration(
                      color: const Color.fromRGBO(41, 28, 50, 0.8),
                      borderRadius: BorderRadius.all(Radius.circular(6.w)),
                    ),
                    hintText: "[${'xutie'.tr(context: context)}]${'runr'.tr(context: context)}",
                  ),
                  SizedBox(height: 20.w),
                  ...topic?.isAi == 2
                      ? [
                          InputField(
                            controller: contactController,
                            height: 42.w,
                            hintText: 'srlxfs'.tr(context: context),
                            showBoarder: false,
                            backgroundDecoration: BoxDecoration(
                              color: const Color.fromRGBO(41, 28, 50, 0.8),
                              borderRadius: BorderRadius.all(Radius.circular(6.w)),
                            ),
                          ),
                          SizedBox(height: 20.w),
                          InputField(
                            controller: coinController,
                            height: 42.w,
                            hintText: 'szjsjg'.tr(context: context),
                            showBoarder: false,
                            backgroundDecoration: BoxDecoration(
                              color: const Color.fromRGBO(41, 28, 50, 0.8),
                              borderRadius: BorderRadius.all(Radius.circular(6.w)),
                            ),
                            inputFormatter: [
                              FilteringTextInputFormatter(
                                RegExp('[0-9]'),
                                allow: true,
                              ),
                              LengthLimitingTextInputFormatter(3),
                            ],
                          ),
                        ]
                      : [
                          InputField(
                            controller: coinController,
                            height: 42.w,
                            hintText: 'szspjg'.tr(context: context),
                            showBoarder: false,
                            backgroundDecoration: BoxDecoration(
                              color: const Color.fromRGBO(41, 28, 50, 0.8),
                              borderRadius: BorderRadius.all(Radius.circular(6.w)),
                            ),
                            inputFormatter: [
                              FilteringTextInputFormatter(
                                RegExp('[0-9]'),
                                allow: true,
                              ),
                              LengthLimitingTextInputFormatter(3),
                            ],
                          ),
                        ],
                  if (topic?.isLive == 1)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20.w),
                        SizedBox(
                          height: 42.w,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3.w),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 1.w,
                              ),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  "${'sflive'.tr(context: context)}：",
                                  style: TextStyle(
                                    color: const Color(0xffa1a2a9),
                                    fontSize: 15.sp,
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                ReportGestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () {
                                    setState(() {
                                      isLive = true;
                                      video.clear();
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        'zxlive'.tr(context: context),
                                        style: TextStyle(
                                          color: const Color(0xffa1a2a9),
                                          fontSize: 15.sp,
                                        ),
                                      ),
                                      SizedBox(width: 2.w),
                                      Icon(
                                        isLive ? Icons.check_circle : Icons.circle_outlined,
                                        size: 16.w,
                                        color: isLive ? const Color.fromRGBO(94, 79, 236, 1) : const Color(0xffa1a2a9),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 20.w),
                                ReportGestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () {
                                    setState(() {
                                      isLive = false;
                                      video.clear();
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        'lblive'.tr(context: context),
                                        style: TextStyle(
                                          color: const Color(0xffa1a2a9),
                                          fontSize: 15.sp,
                                        ),
                                      ),
                                      SizedBox(width: 2.w),
                                      Icon(
                                        isLive ? Icons.circle_outlined : Icons.check_circle,
                                        size: 16.w,
                                        color: isLive ? const Color(0xffa1a2a9) : const Color.fromRGBO(94, 79, 236, 1),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (isLive)
                          Container(
                            margin: EdgeInsets.only(top: 20.w),
                            height: 42.w,
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3.w),
                                  border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.w)),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: InputField(
                                      hintText: 'srzbdz'.tr(context: context),
                                      controller: TextEditingController(),
                                      showBoarder: false,
                                      backgroundDecoration: BoxDecoration(
                                        color: const Color.fromRGBO(41, 28, 50, 0.8),
                                        borderRadius: BorderRadius.all(Radius.circular(6.w)),
                                      ),
                                      height: 42.w,
                                      onChanged: (value) {
                                        if (value.isEmpty) {
                                          video.clear();
                                        } else {
                                          video.addAll({
                                            'media_url': value.trim(),
                                            'thumb_width': 1600,
                                            'thumb_height': 900,
                                            'type': 1,
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  ReportGestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onTap: () async {
                                      if (video['media_url'] == null) {
                                        return;
                                      }
                                      showDialog<dynamic>(
                                        context: context,
                                        barrierDismissible: true,
                                        builder: (context) {
                                          return StatefulBuilder(builder: (context, setDialogState) {
                                            return Dialog(
                                              backgroundColor: Colors.transparent,
                                              child: Container(
                                                margin: EdgeInsets.symmetric(horizontal: 40.w),
                                                decoration: BoxDecoration(
                                                  color: MyTheme.blackColor49,
                                                  borderRadius: BorderRadius.all(
                                                    Radius.circular(5.w),
                                                  ),
                                                ),
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    SizedBox(
                                                      height: 50.w,
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                        children: [
                                                          ReportGestureDetector(
                                                            onTap: () => Navigator.of(context).pop(),
                                                            child: Icon(
                                                              Icons.close,
                                                              color: Colors.white,
                                                              size: 20.w,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: MyTheme.pagePadding,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: double.infinity,
                                                      height: (1.sw - 80.w) / 7 * 10,
                                                      child: Builder(builder: (_) {
                                                        final videoInfo = VideoData(
                                                          source240: video['media_url'],
                                                          previewUrl: '',
                                                          title: '',
                                                        );

                                                        return ShortvMvPlayer(
                                                          info: videoInfo,
                                                          noBack: true,
                                                          isLive: true,
                                                        );
                                                      }),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            );
                                          });
                                        },
                                      );
                                    },
                                    child: Text('dwcskk'.tr(context: context), style: MyTheme.blue80_14_M),
                                  ),
                                  SizedBox(width: 10.w),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  SizedBox(height: 20.w),
                  UploadHintText(
                    title: 'sctp'.tr(context: context),
                    subTitle: '',
                    text: 'zdjzbkb'.tr(context: context),
                  ),
                  SizedBox(height: 10.w),
                  ImagePickerGrid(
                    upList: upList,
                    picLimit: picLimit,
                  ),
                  SizedBox(height: 20.w),
                  topic?.isLive == 1 && isLive
                      ? const SizedBox.shrink()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            UploadHintText(
                              title: tr('scsp'),
                              text: kIsWeb ? tr('zdybmpwa') : tr('zdybm'),
                            ),
                            SizedBox(height: 10.w),
                            VideoPickerGrid(upList: upList, video: video)
                          ],
                        ),
                ],
              );
            },
          ),
      };

  /// 发布
  Future<void> _send() async {
    final topic = topicNotifier.value;
    List<Map> p = List.from(upList);
    if (topic == null) {
      MyToast.showText(text: 'q'.tr(context: context) + 'xzht'.tr(context: context));
      return;
    }
    if (titleController.text.isEmpty) {
      MyToast.showText(text: 'qsbtxx'.tr(context: context));
      return;
    }
    if (type == CommunityIssueType.image) {
      if (topic.isAi == 2 && contactController.text.isEmpty) {
        MyToast.showText(text: 'qsrlxfs'.tr(context: context));
        return;
      }
      if (upList.isEmpty) {
        MyToast.showText(text: 'qsctp'.tr(context: context));
        return;
      }
    }
    if (type == CommunityIssueType.video) {
      if (topic.isAi == 2 && contactController.text.isEmpty) {
        MyToast.showText(text: 'qsrlxfs'.tr(context: context));
        return;
      }
      if (upList.isEmpty) {
        MyToast.showText(text: 'qsctp'.tr(context: context));
        return;
      }
      if (video.isEmpty && topic.isLive == 1 && isLive) {
        MyToast.showText(text: 'srzbdz'.tr(context: context));
        return;
      }
      if (video.isEmpty) {
        MyToast.showText(text: 'qscsp'.tr(context: context));
        return;
      }
      //视频数据添加到尾部
      final index = upList.indexWhere((el) => el['type'] == 1);
      if (index == -1 && video.isNotEmpty) {
        p.add(video);
      }
    }
    if (type == CommunityIssueType.imageAndText) {
      if (contentController.text.isEmpty) {
        MyToast.showText(text: 'qsnrxx'.tr(context: context));
        return;
      }
      if (topic.isAi == 2 && contactController.text.isEmpty) {
        MyToast.showText(text: 'qsrlxfs'.tr(context: context));
        return;
      }
      if (upList.isEmpty) {
        MyToast.showText(text: 'qsctp'.tr(context: context));
        return;
      }
    }

    MyToast.showLoading();
    try {
      final money = userNotifier.member.money - config.payAi;
      final result = await domain.communityPost(
        topicId: '${topic.id}',
        title: titleController.text,
        content: contentController.text,
        contact: contactController.text,
        type: '${topic.type}',
        coins: coinController.text.isEmpty ? '0' : coinController.text,
        medias: jsonEncode(p),
        isPublic: isOpenNotifier.value ? 1 : 0,
      );
      BotToast.closeAllLoading();
      if (result.status == 1) {
        if (money > 0) {
          userNotifier.setMoney(money: money);
        }

        if (mounted) {
          CommonUtils.showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => RegularDialog(
              title: 'fbcg'.tr(context: context),
              buttonText: 'qd'.tr(context: context),
              confirmOnTap: () {
                context.pop();
                context.pop();
              },
              content: DefaultTextStyle(
                style: MyTheme.gray203_13,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'fbcgdsh'.tr(context: context),
                      style: MyTheme.gray203_13,
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      } else {
        MyToast.showText(text: result.msg ?? '');
      }
    } catch (_) {}
  }

  @override
  void initState() {
    titleController.addListener(() {
      if (topicNotifier.value != null && titleController.text.isNotEmpty) {
        _publishAvAvailableNotifier.value = true;
      } else {
        _publishAvAvailableNotifier.value = false;
      }
    });
    topicNotifier.addListener(() {
      if (topicNotifier.value != null && titleController.text.isNotEmpty) {
        _publishAvAvailableNotifier.value = true;
      } else {
        _publishAvAvailableNotifier.value = false;
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _publishAvAvailableNotifier.dispose();
    isOpenNotifier.dispose();
    topicNotifier.dispose();
    titleController.dispose();
    contentController.dispose();
    coinController.dispose();
    contactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      child: Scaffold(
        appBar: MyAppBar(
          title: 'fbtz'.tr(context: context),
          rightWidget: PostButton(
            onTap: _send,
            publishAvAvailableNotifier: _publishAvAvailableNotifier,
          ),
        ),
        body: ReportGestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding, vertical: 16.w),
              child: Column(
                children: [
                  _buildMtxqView(),
                  TopicField(
                    // type: widget.topicType.type == '3'
                    //     ? '3'
                    //     : widget.type == CommunityIssueType.video
                    //         ? '0'
                    //         : '1',
                    type: widget.topicType.type,
                    topicNotifier: topicNotifier,
                  ),
                  SizedBox(height: 30.w),
                  InputField(
                    controller: titleController,
                    height: 42.w,
                    hintText: 'tbtxx'.tr(context: context),
                    showBoarder: false,
                    backgroundDecoration: BoxDecoration(
                      color: const Color.fromRGBO(41, 28, 50, 0.8),
                      borderRadius: BorderRadius.all(Radius.circular(6.w)),
                    ),
                  ),
                  SizedBox(height: 20.w),
                  _buildContent(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
