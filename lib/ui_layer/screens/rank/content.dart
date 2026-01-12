import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/domain/model/feed/feed_model.dart';
import 'package:jygf/domain/model/navigator_model.dart';
import 'package:jygf/domain/remote_domain/domains/rank.dart';
import 'package:jygf/ui_layer/notifiers/home_config_notifier.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_list_view.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_tab_bar.dart';
import 'package:jygf/ui_layer/screens/rank/rank_card.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/ui_layer/utils/my_toast.dart';
import 'package:provider/provider.dart';

class RankContentScreen extends StatefulWidget {
  const RankContentScreen({super.key, required this.data});

  final RankNavigatorModel data;

  @override
  State<RankContentScreen> createState() => _RankContentScreenState();
}

class _RankContentScreenState extends State<RankContentScreen> {
  late final _homeConfig = context.read<HomeConfigNotifier>();
  late final List<RankNavigatorModel> _titles = _homeConfig.config.rankCycleNav ?? [];
  late final _domain = context.read<RankDomain>();

  Future<List<FeedModel>?> _getData({
    required String cycle,
    required String type,
  }) async {

    final result = await _domain.rankMVList(
      cycle: cycle,
      type: type,
    );

    if (result.status == 1) {
      if (result.data case final data?) {
        return data;
      }
    } else {
      MyToast.showText(text: result.msg ?? '');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TabBarWithView.line(
        tabBarPadding: EdgeInsets.symmetric(
          vertical: 0.w,
          horizontal: MyTheme.pagePadding,
        ),
        labelStyle: MyTheme.jellyCyan_15,
        unselectedLabelStyle: TextStyle(
          color: const Color.fromRGBO(255, 255, 255, 1),
          fontSize: 15.sp,
          overflow: TextOverflow.visible,
          decoration: TextDecoration.none,
        ),
        // tabBarHeight: 40.w,
        isScrollable: true,
        titles: _titles.map((model) => model.title ?? '').toList(),
        views: _titles.map((model) {
          return MyListView.list(
            padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding, vertical: 8.w),
            isNeedMore: false,
            itemBuilder: (context, item, index) => RankCard(index: index + 1, data: item as FeedVideoModel),
            onFetchingMore: (currentPage, pageSize) => _getData(
              cycle: model.value ?? '',
              type: widget.data.value ?? '',
            ),
          );
        }).toList(),
    );
  }
}
