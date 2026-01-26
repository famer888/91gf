import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/domain/model/post_model.dart';
import 'package:jygf/report/ui_layer/report_gesture_detector.dart';
import 'package:jygf/ui_layer/router/routes.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jygf/ui_layer/utils/common_utils.dart';


class CheckFileItem extends StatelessWidget {
  final PostModel item;
  final double itemWidth;

  const CheckFileItem({super.key, required this.item, required this.itemWidth});

  @override
  Widget build(BuildContext context) {
    Widget current = (item.medias == null || item.medias!.isEmpty) ? const SizedBox.shrink() : Stack(
      children: [
        MyImage.network(item.medias?.first.cover ?? '', width: itemWidth, height: 120.w, borderRadius: 6.w),
        Positioned(top: 0, left: 0, child: _buildBlackTypeWidget()),
      ],
    );
    current = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      current,
      Padding(
        padding: EdgeInsets.only(top: 5.5.w, bottom: 2.w),
        child: Text(item.title,
            style: TextStyle(
              color: const Color.fromRGBO(255, 255, 255, 1),
              fontWeight: FontWeight.w400,
              fontSize: 14.sp,
              overflow: TextOverflow.ellipsis,
              decoration: TextDecoration.none,
            ),
            maxLines: 2),
      ),
      SizedBox(height: 2.w),
      _buildSubContentWidget(context),
    ]);
    return ReportGestureDetector(
      onTap: () {
        CheckFileDetailRoute('${item.id}').push(context);
      },
      child: current,
    );
  }

  Widget _buildSubContentWidget(BuildContext context) {
    String content = '';
    content += item.user?.nickname ?? '';
    content += ' · ${item.createdAt}';
    // if (item.category.isNotEmpty) {
    //   List list = item.category;
    //   if (list.length > 2) {
    //     list = list.sublist(0, 2);
    //   }
    //   content += ' · ${list.map((i) => i.name).join(' · ')}';
    // }

    return Row(children: [
      Expanded(
        key: key,
        flex: 1,
        child: Text(content,
            style: TextStyle(
              color: const Color.fromRGBO(255, 255, 255, 1),
              fontWeight: FontWeight.w400,
              fontSize: 11.sp,
              overflow: TextOverflow.ellipsis,
              decoration: TextDecoration.none,
            ),
            overflow: TextOverflow.ellipsis),
      ),
      SizedBox(width: 10.w),
      Text('${CommonUtils.formatNumber(item.viewNum)}${'llan'.tr(context: context)}',
          style: TextStyle(
            color: const Color.fromRGBO(255, 255, 255, 1),
            fontWeight: FontWeight.w400,
            fontSize: 11.sp,
            overflow: TextOverflow.ellipsis,
            decoration: TextDecoration.none,
          ),
          overflow: TextOverflow.ellipsis),
    ]);
  }

  Widget _buildSubscripteWidget() {
    // if (item.isHot) {
    //   return Container(margin: EdgeInsets.only(right: 6.w, top: 2.w), child: const HotSubscriptWidget());
    // }
    // if (item.isNew) {
    //   return const NewSubscriptWidget();
    // }
    return const SizedBox();
  }

  Widget _buildBlackTypeWidget() {
    // if (item.type == 1) return const VipSubscriptWidget();
    // if (item.type == 2) return const CoinSubscriptWidget();
    return const SizedBox();
  }
}
