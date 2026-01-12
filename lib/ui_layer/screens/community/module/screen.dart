import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jygf/ui_layer/screens/common_widgets/gradient_border_box.dart';
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
  const CommunityModuleScreen({super.key, required this.id, this.topicType = 1});

  final int id;

  // final String type;
  final int topicType;

  @override
  State<CommunityModuleScreen> createState() => _CommunityModuleScreenState();
}

class _CommunityModuleScreenState extends State<CommunityModuleScreen> {
  late final _communityDomain = context.read<CommunityDomain>();
  late final _originalDomain = context.read<OriginalDomain>();

  Future<List<TopicModel>?> _getData({required int page, required int limit}) async {
    try {
      final result = await (widget.topicType == 3
          ? _originalDomain.originalTopics(page: page, limit: limit)
          : _communityDomain.communityTopics(page: page, limit: limit, type: widget.topicType));

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
        title: (widget.topicType == 3 ? 'xzcpht' : 'xzht').tr(context: context),
        showDiver: true,
      ),
      body: MyListView.list(
        itemBuilder: (context, item, index) {
          if (widget.topicType == 1 && item.isAi == 1) {
            return const SizedBox.shrink();
          }
          return CommunityModuleItem(data: item, showBorder: widget.id == item.id);
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
  const CommunityModuleItem({super.key, required this.data, required this.showBorder});

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
        margin: EdgeInsets.only(bottom: 10.w),
        height: 70.w,
        decoration: BoxDecoration(
          color: const Color.fromRGBO(41, 28, 50, 0.8),
          borderRadius: BorderRadius.all(Radius.circular(6.w)),
        ),
        child: GradientBorder(
          radius: 6.w,
          borderWidth: 0.8.w,
          gradient: showBorder
              ? MyTheme.dhButtonGradient
              : const LinearGradient(
                  colors: [Color.fromRGBO(255, 133, 164, 0), Color.fromRGBO(176, 66, 255, 0)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
          child: Row(
            children: [
              SizedBox(width: 10.w),
              MyAvatar(thumb: imgUrl, size: 46.w),
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
                          style: MyTheme.white07_12,
                        ),
                        Text(
                          "${CommonUtils.renderFixedNumber(data.viewNum)}${'llan'.tr(context: context)}",
                          style: MyTheme.white07_12,
                        ),
                        Text(
                          "${CommonUtils.renderFixedNumber(data.followNum)}${'gz'.tr(context: context)}",
                          style: MyTheme.white07_12,
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(width: 10.w),
            ],
          ),
        ),
      ),
    );
  }
}
