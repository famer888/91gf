import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../domain/model/notice_message.dart';
import '../../../../../domain/remote_domain/domains/message.dart';
import '../../../../router/routes.dart';
import '../../../../utils/my_toast.dart';
import '../../../common_widgets/my_app_bar.dart';
import '../../../common_widgets/my_list_view.dart';
import '../../../common_widgets/screen_background.dart';
import '../../../theme.dart';
import 'package:jygf/report/ui_layer/report_gesture_detector.dart';


class SystemMessageScreen extends StatefulWidget {
  const SystemMessageScreen({super.key});

  @override
  State<SystemMessageScreen> createState() => _SystemMessageScreenState();
}

class _SystemMessageScreenState extends State<SystemMessageScreen> {
  late final _messageDomain = context.read<MessageDomain>();

  Future<List<NoticeMessage>> _getData({
    required int currentPage,
    required int limit,
  }) async {
    final res = await _messageDomain.getSystemNoticeList(
      page: currentPage,
      limit: limit,
    );

    if (res.msg case final msg? when msg.isNotEmpty) {
      MyToast.showText(text: msg);
    }

    return res.data!;
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      child: Scaffold(
        appBar: MyAppBar(title: 'tzxx'.tr(context: context)),
        body: MyListView.list(
          padding: EdgeInsets.zero,
          itemBuilder: (context, item, index) {
            return NoticeItem(message: item);
          },
          onFetchingMore: (currentPage, pageSize) =>
              _getData(currentPage: currentPage, limit: pageSize),
        ),
      ),
    );
  }
}

class NoticeItem extends StatelessWidget {
  const NoticeItem({
    super.key,
    required this.message,
  });

  final NoticeMessage message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 12.5.w, right: 12.5.w, top: 20.w),
      child: ReportGestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          if (message.type == 1) {
            CommunityPostDetailRoute('${message.relatedId}').push(context);
          }
        },
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(15.w),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(255, 255, 255, 0.03),
            borderRadius: BorderRadius.circular(10.w),
          ),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              message.title ?? '',
              style: MyTheme.white255_18_M,
              maxLines: 100,
            ),
            SizedBox(height: 10.w),
            Text(
              message.content ?? '',
              style: MyTheme.gray199_13,
              maxLines: 100,
            ),
            SizedBox(height: 10.w),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(message.createdAt, style: MyTheme.hexa3a2a2_11),
                message.type == 1
                    ? Text(
                        'ckxq'.tr(context: context),
                        style: MyTheme.blue80_11,
                      )
                    : const SizedBox.shrink(),
              ],
            )
          ]),
        ),
      ),
    );
  }
}
