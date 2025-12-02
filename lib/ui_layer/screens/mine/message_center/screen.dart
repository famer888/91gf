import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../../../../domain/model/system_notice_model.dart';
import '../../../notifiers/chat_notifier.dart';
import '../../../notifiers/user_notifier.dart';
import '../../../router/routes.dart';
import '../../common_widgets/my_app_bar.dart';
import '../../common_widgets/my_avatar.dart';
import '../../common_widgets/my_image.dart';
import '../../common_widgets/screen_background.dart';
import '../../image_paths.dart';
import '../../theme.dart';

class MessageCenterScreen extends StatefulWidget {
  const MessageCenterScreen({super.key});

  @override
  State<MessageCenterScreen> createState() => _MessageCenterScreenState();
}

class _MessageCenterScreenState extends State<MessageCenterScreen> {
  late final userNotifier = context.read<UserNotifier>();

  @override
  void initState() {
    userNotifier.initSystemNotice();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      child: Scaffold(
        appBar: MyAppBar(title: 'xxzx'.tr(context: context)),
        body: Selector<ChatNotifier, List<ChatList>>(
            shouldRebuild: (_, __) => true,
            selector: (_, notifier) {
              return notifier.chats;
            },
            builder: (_, chats, __) {
              return ListView(
                children: [
                  const _SystemMessageView(),
                  const _NoticeMessageView(),
                  chats.isNotEmpty
                      ? Container(
                          padding: EdgeInsets.only(
                            top: 20.w,
                            bottom: 5.w,
                            left: MyTheme.pagePadding,
                            right: MyTheme.pagePadding,
                          ),
                          child: Text(
                            tr('jsltxx'),
                            style: MyTheme.white15bold,
                          ),
                        )
                      : Container(),
                  Column(
                    children: chats.map((e) {
                      final DateTime targetDate =
                          DateTime.fromMillisecondsSinceEpoch(
                              int.parse(e.list.last.time) * 1000);
                      final String formattedDate =
                          DateFormat('HH:mm').format(targetDate);
                      return Slidable(
                          endActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (_) {
                                  context
                                      .read<ChatNotifier>()
                                      .removeChat(e.touser?.uuid ?? '');
                                },
                                backgroundColor: const Color(0xFFFE4A49),
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                                label: tr('sch'),
                              ),
                            ],
                          ),
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              ChatMessageRoute(
                                      nickName: e.touser?.nickname ?? '',
                                      toUuid: e.touser?.uuid ?? '',
                                      thumb: e.touser?.avatar ?? '')
                                  .push(context);
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.w),
                              child: Container(
                                decoration: const BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.white10, width: 0.5)),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 15.w),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    MyAvatar(
                                        thumb: Uri.decodeComponent(
                                            e.touser?.avatar ?? ''),
                                        size: 50.w),
                                    SizedBox(width: 15.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            Uri.decodeComponent(
                                                e.touser?.nickname ?? ''),
                                            style: MyTheme.white13medium,
                                          ),
                                          SizedBox(height: 9.w),
                                          Text(
                                            e.list.last.content_type == 0
                                                ? e.list.last.content
                                                : "[${tr('tp')}]",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: MyTheme.gray153_13,
                                          )
                                        ],
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          formattedDate,
                                          style: MyTheme.gray153_11,
                                        ),
                                        SizedBox(height: 15.w),
                                        Opacity(
                                          opacity: e.count == 0 ? 0 : 1,
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 1.w, horizontal: 8.w),
                                            decoration: BoxDecoration(
                                                color: const Color(0xFFFE4A49),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        7.5.w)),
                                            child: Text(
                                              e.count.toString(),
                                              style: MyTheme.white10,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ));
                    }).toList(),
                  ),
                ],
              );
            }),
      ),
    );
  }
}

class _SystemMessageView extends StatelessWidget {
  const _SystemMessageView();

  @override
  Widget build(BuildContext context) {
    final systemNotice = context.select<UserNotifier, SystemNotice?>(
        (notifier) => notifier.systemNotice);
    String times = ' ';
    String messages = 'zwxx'.tr();
    int noticeCount = 0;
    final feed = systemNotice?.systemNotice;
    if (feed != null) {
      times = feed.createdAt;
      messages = feed.question;
      noticeCount = systemNotice?.systemNoticeCount ?? 0;
    }
    return _MessageActionItem(
      title: 'tzxx'.tr(),
      message: messages,
      icon: MyImagePaths.appWdTzxxN,
      time: times,
      number: '$noticeCount',
      onTap: () {
        context.read<UserNotifier>().readSystemNotice();
        const SystemMessageRoute().push(context);
      },
    );
  }
}

class _NoticeMessageView extends StatelessWidget {
  const _NoticeMessageView();

  @override
  Widget build(BuildContext context) {
    final systemNotice = context.select<UserNotifier, SystemNotice?>(
        (notifier) => notifier.systemNotice);
    String times = ' ';
    String messages = 'zwxx'.tr();
    int noticeCount = 0;
    final feed = systemNotice?.feed;
    if (feed != null) {
      times = feed.createdAt;
      messages = feed.question;
      noticeCount = systemNotice?.feedCount ?? 0;
    }
    return _MessageActionItem(
      title: 'gfkf'.tr(),
      message: messages.contains('/new/') ? 'tp'.tr() : messages,
      icon: MyImagePaths.appWdServsN,
      time: times,
      number: '$noticeCount',
      onTap: () {
        context.read<UserNotifier>().readCustomerService();
        const MineCustomerServiceRoute().push(context);
      },
    );
  }
}

class _MessageActionItem extends StatelessWidget {
  const _MessageActionItem({
    required this.title,
    required this.icon,
    required this.message,
    required this.time,
    required this.number,
    required this.onTap,
  });

  final String title;
  final String icon;
  final String message;
  final String time;
  final String number;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    var newTimeString = time;
    if (time.isNotEmpty && time != ' ') {
      final dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
      final dateTime = dateFormat.parse(time);
      final dateFormat2 = DateFormat('HH:mm');
      newTimeString = dateFormat2.format(dateTime);
    }

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 15.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MyImage.asset(icon, width: 50.w, height: 50.w),
              SizedBox(width: 15.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: MyTheme.white14Medium,
                    ),
                    SizedBox(height: 4.w),
                    Text(
                      message,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: MyTheme.whiteOpacity612w400,
                    )
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Opacity(
                    opacity: (number == '0') ? 0 : 1,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 1.w,
                        horizontal: 8.w,
                      ),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(236, 174, 55, 1),
                        borderRadius: BorderRadius.circular(9.w),
                      ),
                      child: Text(
                        number,
                        style: TextStyle(
                          color: const Color.fromRGBO(255, 255, 255, 1),
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15.w),
                  SizedBox(
                    width: 40.w,
                    child: Text(
                      newTimeString,
                      textAlign: TextAlign.right,
                      style: MyTheme.hexa3a2a2_11,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
