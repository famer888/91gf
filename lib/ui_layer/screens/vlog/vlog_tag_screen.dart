import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/ui_layer/screens/common_widgets/screen_background.dart';
import 'package:provider/provider.dart';
import 'package:jygf/app_global.dart';
import 'package:jygf/domain/api_validator.dart';
import 'package:jygf/domain/model/navigator_model.dart';
import 'package:jygf/domain/model/vlog_model.dart';
import 'package:jygf/domain/remote_domain/domains/vlog.dart';
import 'package:jygf/ui_layer/const.dart';
import 'package:jygf/ui_layer/notifiers/home_config_notifier.dart';
import 'package:jygf/ui_layer/router/routes.dart';
import 'package:jygf/ui_layer/screens/common_widgets/keep_alive_wrapper.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_app_bar.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_list_view.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_tab_bar.dart';
import 'package:jygf/ui_layer/screens/vlog/card/vlog_card.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/ui_layer/utils/common_utils.dart';
import 'package:jygf/report/ui_layer/report_gesture_detector.dart';


class VlogTagScreen extends StatefulWidget {
  const VlogTagScreen({super.key, required this.tag});

  final String tag;

  @override
  State<VlogTagScreen> createState() => _VlogTagScreenState();
}

class _VlogTagScreenState extends State<VlogTagScreen> {
  late final _homeConfig = context.read<HomeConfigNotifier>();
  late final List<NavigatorModel> titles =
      _homeConfig.config.vlogTagSortNav ?? [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      child: SafeArea(
        child: Scaffold(
          appBar: MyAppBar(
            title: '#${widget.tag}',
            // rightWidget: ReportGestureDetector(
            //   onTap: () => const SearchRoute().push(context),
            //   child: MyImage.asset(MyImagePaths.appSearchWhite,
            //       width: 25.w, height: 25.w),
            // ),
          ),
          body: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
                child: SizedBox(height: 10.w),
              ),
              Expanded(child: configContentView())
            ],
          ),
        ),
      ),
    );
  }

  Widget configContentView() {
    return TabBarWithView.fillColor(
      tabBarHeight: 32.w,
      tabBarPadding: EdgeInsets.all(5.w),
      titles: [for (final title in titles) title.title],
      views: [
        for (final NavigatorModel sort in titles)
          KeepAliveWrapper(
              child: VlogTagContentView(
                  tag: widget.tag, sort: sort, key: Key(sort.type)))
      ],
    );
  }
}

class VlogTagContentView extends StatefulWidget {
  const VlogTagContentView({super.key, required this.tag, required this.sort});

  final NavigatorModel sort;
  final String tag;

  @override
  State<VlogTagContentView> createState() => VlogTagContentViewState();
}

class VlogTagContentViewState extends State<VlogTagContentView> {
  late final _domain = context.read<VlogDomain>();
  List<VlogModel> array = [];

  int _page = 1;
  int _limit = 15;

  Future<List<VlogModel>?> _getData(
      {required int page, required int pageSize, required String type}) async {
    _page = page;
    _limit = pageSize;

    final result = await _domain.vlogListTag(
      word: widget.tag,
      type: type,
      page: page,
      limit: pageSize,
    );
    if (result.isValid) {
      List<VlogModel> tp = List.from(result.data ?? []);
      if (page == 1) {
        array = tp;
      } else {
        array.addAll(tp);
      }
      return tp;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MyListView.grid(
      contentPadding: 10.w,
      childAspectRatio: UILayerConst.vlogVideoRatio,
      padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
      itemBuilder: (context, item, index) => VlogCard(
          data: item,
          onTapFunc: (type) {
            if (type == 1) {
              //点击短视频视频
              AppGlobal.shortVideosInfo = {
                'list': array,
                'page': _page,
                'index': index,
                'api': 'vlog/list_tag',
                'params': {
                  'word': widget.tag,
                  'type': widget.sort.type,
                  'limit': _limit,
                }
              };
              const VlogSecondRoute().push(context);
            } else {
              //广告类型
              CommonUtils.openRoute(context, item.toJson());
            }
          }),
      onFetchingMore: (currentPage, pageSize) => _getData(
          page: currentPage, pageSize: pageSize, type: widget.sort.type),
    );
  }
}
