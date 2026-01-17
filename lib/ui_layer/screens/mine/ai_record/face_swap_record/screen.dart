import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jygf/domain/model/ai_model.dart';
import 'package:jygf/domain/remote_domain/domains/ai.dart';
import 'package:jygf/ui_layer/screens/common_widgets/keep_alive_wrapper.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_list_view.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_tab_bar.dart';
import 'package:jygf/ui_layer/screens/mine/ai_record/card/ai_record_card.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:provider/provider.dart';


class MineFaceSwapRecordScreen extends StatefulWidget {
  const MineFaceSwapRecordScreen({super.key, this.status});

  final int? status;// 0-待处理 1-处理中 2-已成功 3-已失败

  @override
  State<MineFaceSwapRecordScreen> createState() => _MineFaceSwapRecordScreenState();
}

class _MineFaceSwapRecordScreenState extends State<MineFaceSwapRecordScreen> {

  late final aiDomain = context.read<AIDomain>();

  Future<List<AIModel>?> _getData({
    required int page,
    required int pageSize,
  }) async {
    final result = await aiDomain.aIMyFace(
      status: widget.status ?? 0,
      page: page,
      limit: pageSize,
    );
    return result.data;
  }

  @override
  Widget build(BuildContext context) {
    return TabBarWithView.line(
      indicatorType: IndicatorType.curve,
      unselectedLabelStyle: MyTheme.white25508_16_M,
      // tabBarHeight: 40.w,
      // isScrollable: false,
      titles: [
        'pdz'.tr(context: context),
        'clz'.tr(context: context),
        'sccg'.tr(context: context),
        'scsb'.tr(context: context),
      ],
      views: const [
        KeepAliveWrapper(
          child: _ContentFaceSwapRecordScreen(status: 0),
        ),
        KeepAliveWrapper(
          child: _ContentFaceSwapRecordScreen(status: 1),
        ),
        KeepAliveWrapper(
          child: _ContentFaceSwapRecordScreen(status: 2),
        ),
        KeepAliveWrapper(
          child: _ContentFaceSwapRecordScreen(status: 3),
        ),
      ],
    );
  }
}

class _ContentFaceSwapRecordScreen extends StatefulWidget {
  const _ContentFaceSwapRecordScreen({this.status});

  final int? status;// 0-待处理 1-处理中 2-已成功 3-已失败

  @override
  State<_ContentFaceSwapRecordScreen> createState() => _ContentFaceSwapRecordScreenState();
}

class _ContentFaceSwapRecordScreenState extends State<_ContentFaceSwapRecordScreen> {

  late final aiDomain = context.read<AIDomain>();

  Future<List<AIModel>?> _getData({
    required int page,
    required int pageSize,
  }) async {
    final result = await aiDomain.aIMyFace(
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
      childAspectRatio: 170 / 250,
      itemBuilder: (_, item, __) => AIRecordCard(data: item, type: AIRecordType.FaceSwap, delSucess: () {
        context.pop();
        setState(() {
        });
      }),
      onFetchingMore: (currentPage, pageSize) => _getData(
        page: currentPage,
        pageSize: pageSize,
      ),
    );
  }
}