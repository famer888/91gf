import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jygf/domain/async_value.dart';
import 'package:jygf/domain/model/live_model.dart';
import 'package:jygf/domain/model/live_video_detail_model.dart';
import 'package:jygf/domain/remote_domain/domains/live.dart';
import 'package:jygf/ui_layer/screens/common_widgets/keep_alive_wrapper.dart';
import 'package:jygf/ui_layer/screens/common_widgets/screen_background.dart';
import 'package:jygf/ui_layer/screens/common_widgets/status/loading.dart';
import 'package:jygf/ui_layer/screens/common_widgets/status/network_error.dart';
import 'package:jygf/ui_layer/screens/common_widgets/video_player/live_mv_palyer.dart';
import 'package:jygf/ui_layer/screens/live_video/live_detail/comment_view.dart';
import 'package:jygf/ui_layer/screens/live_video/live_detail/introduction_view.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/ui_layer/utils/my_toast.dart';
import 'package:provider/provider.dart';



class LiveVideoDetailScreen extends StatefulWidget {
  const LiveVideoDetailScreen({super.key, required this.id});

  final String id;

  @override
  State<LiveVideoDetailScreen> createState() => _LiveVideoDetailScreenState();
}

class _LiveVideoDetailScreenState extends State<LiveVideoDetailScreen> {
  late final liveDomain = context.read<LiveDomain>();

  AsyncValue<LiveVideoDetailData> _asyncValue = const AsyncInit();

  @override
  void initState() {
    _initData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future _initData() async {
    if (_asyncValue.isLoading) return;
    setState(() {
      _asyncValue = const AsyncLoading();
    });

    final res = await liveDomain.getLiveDetail(id: int.parse(widget.id));
    if (res.data case final data?) {
      _asyncValue = AsyncData(data);
    } else {
      if (res.msg case final msg? when msg.isNotEmpty) {
        MyToast.showText(text: msg);
      }
      _asyncValue = const AsyncError();
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          extendBodyBehindAppBar: true,
          // appBar: const MyAppBar(),
          floatingActionButton: GestureDetector(
            onTap: () {
              context.pop();
            },
            child: Container(
              margin: EdgeInsets.only(bottom: 40.w),
              height: 40.w,
              width: 40.w,
              decoration: BoxDecoration(
                gradient: MyTheme.gradient_90_114,
                borderRadius: BorderRadius.all(
                  Radius.circular(20.w),
                ),
              ),
              child: Center(
                child: Text(
                  'fahui'.tr(context: context),
                  style: MyTheme.white255_13_M,
                ),
              ),
            ),
          ),
          body: _asyncValue.maybeWhen(
            orElse: () => const LoadingView(),
            error: (_, __) => NetworkErrorView(onTap: _initData),
            data: (data) => Column(
              children: [
                _VideoView(data: data.live),
                Expanded(child: _Body(id: widget.id, data: data)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _VideoView extends StatelessWidget {
  const _VideoView({required this.data});

  final LiveModel data;
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 10,
      child: LiveMvPlayer(
        info: data,
      ),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body({
    required this.id,
    required this.data,
  });

  final String id;
  final LiveVideoDetailData data;

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> with TickerProviderStateMixin {
  late final titles = [
    'jj'.tr(context: context),
    'pl'.tr(context: context),
  ];
  late final tabController = TabController(length: titles.length, vsync: this);

  Widget _buildTabBar() {
    return TabBar(
      controller: tabController,
      labelStyle: MyTheme.white16medium,
      unselectedLabelStyle: MyTheme.gray16,
      indicator: const BoxDecoration(),
      isScrollable: true,
      tabAlignment: TabAlignment.start,
      dividerColor: Colors.transparent,
      dividerHeight: 0,
      labelPadding: EdgeInsets.only(left: MyTheme.pagePadding),
      overlayColor: WidgetStateProperty.resolveWith<Color>(
        (_) => Colors.transparent,
      ),
      tabs: [
        Tab(child: Text(titles[0])),
        Tab(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${titles[1]}(${widget.data.live.commentCt})'),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTabBar(),
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: [
              KeepAliveWrapper(
                child: LiveVideoDetailIntroductionView(
                  id: widget.id,
                  data: widget.data,
                ),
              ),
              KeepAliveWrapper(
                child: LiveVideoCommentView(
                  id: widget.id,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
