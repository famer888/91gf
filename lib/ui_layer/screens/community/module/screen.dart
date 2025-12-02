import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../domain/domain.dart';
import '../../../../domain/remote_domain/domains/original.dart';
import '../../common_widgets/my_avatar.dart';
import '../../common_widgets/screen_background.dart';

import '../../../../domain/model/topic_model.dart';
import '../../../utils/common_utils.dart';
import '../../../utils/my_toast.dart';
import '../../common_widgets/my_app_bar.dart';
import '../../common_widgets/my_list_view.dart';
import '../../theme.dart';

class CommunityModuleScreen extends StatefulWidget {
  const CommunityModuleScreen(
      {super.key, required this.id, required this.type});

  final int id;
  final String type;

  @override
  State<CommunityModuleScreen> createState() => _CommunityModuleScreenState();
}

class _CommunityModuleScreenState extends State<CommunityModuleScreen> {
  late final _communityDomain = context.read<CommunityDomain>();
  late final _originalDomain = context.read<OriginalDomain>();

  Future<List<TopicModel>?> _getData(
      {required int page, required int limit}) async {
    try {
      final result = await (widget.type == '2'
          ? _originalDomain.originalTopics(page: page, limit: limit)
          : _communityDomain.communityTopics(page: page, limit: limit));

      if (result.status == 1) {
        return result.data;
      } else {
        MyToast.showText(text: result.msg ?? '');
      }
    } catch (_) {}
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
        child: Scaffold(
      appBar: MyAppBar(
        title: (widget.type == 'fish' ? 'xzcpht' : 'xzht').tr(context: context),
        showDiver: true,
      ),
      body: MyListView.list(
        itemBuilder: (context, item, index) {
          if (widget.type == '1' && item.isAi == 1) {
            return const SizedBox.shrink();
          }
          return CommunityModuleItem(
              data: item, showBorder: widget.id == item.id);
        },
        onFetchingMore: (currentPage, pageSize) async => await _getData(
          page: currentPage,
          limit: pageSize,
        ),
      ),
    ));
  }
}

class CommunityModuleItem extends StatelessWidget {
  const CommunityModuleItem(
      {super.key, required this.data, required this.showBorder});
  final TopicModel data;
  final bool showBorder;
  String get imgUrl => CommonUtils.getThumb(data.toJson());
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        context.pop(data);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        margin: EdgeInsets.only(bottom: 10.w),
        height: 70.w,
        decoration: BoxDecoration(
          color: const Color.fromRGBO(255, 255, 255, 0.1),
          borderRadius: BorderRadius.all(Radius.circular(5.w)),
          border: showBorder
              ? Border.all(color: MyTheme.blueColor81_151_241)
              : null,
        ),
        child: Row(
          children: [
            MyAvatar(
              thumb: imgUrl,
              size: 46.w,
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('#${data.name}', style: MyTheme.white15bold),
                  SizedBox(height: 5.w),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${CommonUtils.renderFixedNumber(data.postNum)}${'tiez'.tr(context: context)}",
                        style: MyTheme.white12,
                      ),
                      Text(
                        "${CommonUtils.renderFixedNumber(data.viewNum)}${'llan'.tr(context: context)}",
                        style: MyTheme.white12,
                      ),
                      Text(
                        "${CommonUtils.renderFixedNumber(data.followNum)}${'gz'.tr(context: context)}",
                        style: MyTheme.white12,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
