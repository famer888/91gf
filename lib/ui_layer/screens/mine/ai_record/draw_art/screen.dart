import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jygf/domain/model/ai/ai_draw_record_model.dart';
import 'package:jygf/domain/model/ai_model.dart';
import 'package:jygf/domain/remote_domain/domains/ai.dart';
import 'package:jygf/domain/remote_domain/domains/aidraw.dart';
import 'package:jygf/ui_layer/screens/common_widgets/keep_alive_wrapper.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_list_view.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_tab_bar.dart';
import 'package:jygf/ui_layer/screens/mine/ai_record/card/ai_record_card.dart';
import 'package:jygf/ui_layer/screens/mine/ai_record/card/draw_record_card.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:provider/provider.dart';

class MineDrawArtScreen extends StatefulWidget {
  const MineDrawArtScreen({super.key, this.status});

  final int? status; // 0-待处理 1-处理中 2-已成功 3-已失败

  @override
  State<MineDrawArtScreen> createState() => _MineDrawArtScreenState();
}

class _MineDrawArtScreenState extends State<MineDrawArtScreen> {
  @override
  Widget build(BuildContext context) {
    return TabBarWithView.line(
      indicatorType: IndicatorType.curve,
      unselectedLabelStyle: MyTheme.white25508_16_M,
      // tabBarHeight: 40.w,
      isScrollable: true,
      titles: [
        'pdz'.tr(context: context),
        'clz'.tr(context: context),
        'sccg'.tr(context: context),
        'scsb'.tr(context: context),
      ],
      views: const [
        KeepAliveWrapper(
          child: _ContentStripOffRecordScreen(status: 0),
        ),
        KeepAliveWrapper(
          child: _ContentStripOffRecordScreen(status: 1),
        ),
        KeepAliveWrapper(
          child: _ContentStripOffRecordScreen(status: 2),
        ),
        KeepAliveWrapper(
          child: _ContentStripOffRecordScreen(status: 3),
        ),
      ],
    );
  }
}

class _ContentStripOffRecordScreen extends StatefulWidget {
  const _ContentStripOffRecordScreen({this.status});

  final int? status; // 0-待处理 1-处理中 2-已成功 3-已失败

  @override
  State<_ContentStripOffRecordScreen> createState() =>
      _ContentStripOffRecordScreenState();
}

class _ContentStripOffRecordScreenState
    extends State<_ContentStripOffRecordScreen> {
  late final aiDomain = context.read<AIDrawDomain>();

  Future<List<AIDrawRecordModel>?> _getData({
    required int page,
    required int pageSize,
  }) async {
    final result = await aiDomain.aiDrawRecord(
      status: widget.status ?? 0,
      page: page,
      limit: pageSize,
    );
    return result.data;
  }

  @override
  Widget build(BuildContext context) {
    return MyListView.grid(
      key: UniqueKey(),
      crossAxisCount: 1,
      childAspectRatio: 2.3 / 1,
      itemBuilder: (_, item, __) => AIDrawRecordCard(
          data: item,
          delSucess: () {
            context.pop();
            setState(() {});
          }),
      onFetchingMore: (currentPage, pageSize) => _getData(
        page: currentPage,
        pageSize: pageSize,
      ),
    );
  }
}
