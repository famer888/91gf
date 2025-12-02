import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jygf/domain/remote_domain/domains/ainovel.dart';
import 'package:jygf/ui_layer/router/routes.dart';
import 'package:jygf/ui_layer/screens/common_widgets/keep_alive_wrapper.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_list_view.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_tab_bar.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/ui_layer/utils/common_utils.dart';
import 'package:provider/provider.dart';

class MineNovelRecordScreen extends StatefulWidget {
  const MineNovelRecordScreen({super.key, this.status});

  final int? status; // 0-待处理 1-处理中 2-已成功 3-已失败

  @override
  State<MineNovelRecordScreen> createState() => _MineNovelRecordScreenState();
}

class _MineNovelRecordScreenState extends State<MineNovelRecordScreen> {
  @override
  Widget build(BuildContext context) {
    return TabBarWithView.line(
      labelStyle: MyTheme.white16medium,
      unselectedLabelStyle: MyTheme.white25508_16_M,
      tabBarHeight: 40.w,
      isScrollable: false,
      titles: [
        'pdz'.tr(context: context),
        'clz'.tr(context: context),
        'sccg'.tr(context: context),
        'scsb'.tr(context: context),
      ],
      views: const [
        KeepAliveWrapper(
          child: _ContentNovelRecordScreen(status: 0),
        ),
        KeepAliveWrapper(
          child: _ContentNovelRecordScreen(status: 1),
        ),
        KeepAliveWrapper(
          child: _ContentNovelRecordScreen(status: 2),
        ),
        KeepAliveWrapper(
          child: _ContentNovelRecordScreen(status: 3),
        ),
      ],
    );
  }
}

class _ContentNovelRecordScreen extends StatefulWidget {
  const _ContentNovelRecordScreen({this.status});

  final int? status; // 0-待处理 1-处理中 2-已成功 3-已失败

  @override
  State<_ContentNovelRecordScreen> createState() =>
      _ContentNovelRecordScreenState();
}

class _ContentNovelRecordScreenState extends State<_ContentNovelRecordScreen> {
  late final _aiDomain = context.read<AINovelDomain>();

  Future<List<dynamic>?> _getData({
    required int page,
    required int pageSize,
  }) async {
    final result = await _aiDomain.aiNovelRecord(
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
      itemBuilder: (_, item, __) => _AINovelRecordCard(
        data: item is Map ? item : (item as dynamic) as Map,
        delSucess: () {
          context.pop();
          setState(() {});
        },
      ),
      onFetchingMore: (currentPage, pageSize) => _getData(
        page: currentPage,
        pageSize: pageSize,
      ),
    );
  }
}

class _AINovelRecordCard extends StatefulWidget {
  const _AINovelRecordCard({required this.data, required this.delSucess});

  final Map data;
  final VoidCallback delSucess;

  @override
  State<_AINovelRecordCard> createState() => _AINovelRecordCardState();
}

class _AINovelRecordCardState extends State<_AINovelRecordCard> {
  int get _status => (widget.data['status'] ?? 0) is int
      ? widget.data['status'] as int
      : int.tryParse('${widget.data['status'] ?? 0}') ?? 0;

  String get _id => '${widget.data['id'] ?? ''}';

  String get _createdAt =>
      (widget.data['created_at'] ?? widget.data['createdAt'] ?? '')
          ?.toString() ??
      '';

  String get _titleOrDesc =>
      (widget.data['title'] ??
              widget.data['description'] ??
              widget.data['desc'] ??
              '')
          ?.toString() ??
      '';

  String get _contentPreview =>
      (widget.data['content'] ?? widget.data['preview'] ?? '')?.toString() ??
      '';

  @override
  Widget build(BuildContext context) {
    final canView = _status == 2 || _status == 3;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              if (!canView) {
                return;
              }
              AiNovelDetailRoute(_id, _createdAt).push(context);
            },
            child: Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.w),
                color: const Color(0xff1b1c2b),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Padding(
                      padding: EdgeInsets.all(10.w),
                      child: Text(
                        _titleOrDesc,
                        style: MyTheme.white16medium,
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  if (!canView)
                    Positioned.fill(
                      child: CommonUtils.blurCover(borderRadius: 5.w),
                    ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 6.w),
        Text(
          '提交时间： $_createdAt',
          style: MyTheme.white06_10,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
