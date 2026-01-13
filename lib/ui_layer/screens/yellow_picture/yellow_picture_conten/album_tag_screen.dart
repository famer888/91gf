import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:jygf/domain/api_validator.dart';
import 'package:jygf/domain/model/album_model.dart';
import 'package:jygf/domain/model/bit_nav_model.dart';
import 'package:jygf/domain/remote_domain/domains/album.dart';
import 'package:jygf/ui_layer/const.dart';
import 'package:jygf/ui_layer/notifiers/home_config_notifier.dart';
import 'package:jygf/ui_layer/router/routes.dart';
import 'package:jygf/ui_layer/screens/yellow_picture/card/yellow_picture_item_card.dart';
import 'package:jygf/ui_layer/screens/common_widgets/keep_alive_wrapper.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_app_bar.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_list_view.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_tab_bar.dart';
import 'package:jygf/ui_layer/screens/common_widgets/screen_background.dart';
import 'package:jygf/ui_layer/screens/image_paths.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/report/ui_layer/report_gesture_detector.dart';


class AlbumTagScreen extends StatefulWidget {
  const AlbumTagScreen({super.key, required this.tag});

  final String tag;

  @override
  State<AlbumTagScreen> createState() => _AlbumTagScreenState();
}

class _AlbumTagScreenState extends State<AlbumTagScreen> {
  late final _homeConfig = context.read<HomeConfigNotifier>();
  late final List<BitNavModel> titles = _homeConfig.config.albumTagSort ?? [];

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
      child: Scaffold(
        appBar: MyAppBar(
          title: '#${widget.tag}',
          rightWidget: ReportGestureDetector(
            onTap: () => const SearchRoute().push(context),
            child: MyImage.asset(MyImagePaths.appSearchIcon,
                width: 25.w, height: 25.w),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
              child: const Divider(
                  thickness: 0.5, height: 0.5, color: MyTheme.white02Color),
            ),
            Expanded(child: cofigContentView())
          ],
        ),
      ),
    );
  }

  Widget cofigContentView() {
    return TabBarWithView.fillColor(
      tabBarHeight: 32.w,
      tabBarPadding: EdgeInsets.symmetric(vertical: 5.w),
      titles: [for (final title in titles) title.title ?? ''],
      views: [
        for (final BitNavModel sort in titles)
          KeepAliveWrapper(
              child: AlbumTagContentView(
                  tag: widget.tag, sort: sort, key: Key(sort.title ?? '')))
      ],
    );
  }
}

class AlbumTagContentView extends StatefulWidget {
  const AlbumTagContentView({super.key, required this.tag, required this.sort});

  final BitNavModel sort;
  final String tag;

  @override
  State<AlbumTagContentView> createState() => AlbumTagContentViewState();
}

class AlbumTagContentViewState extends State<AlbumTagContentView> {
  late final _domain = context.read<AlbumDomain>();
  List<AlbumItemsModel> array = [];

  int _page = 1;
  int _limit = 15;

  Future<List<AlbumItemsModel>?> _getData(
      {required int page, required int pageSize, required String type}) async {
    _page = page;
    _limit = pageSize;

    final result = await _domain.albumTagList(
      tag: widget.tag,
      sort: type,
      page: page,
      limit: pageSize,
    );
    if (result.isValid) {
      List<AlbumItemsModel> tp = List.from(result.data ?? []);
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
      crossAxisCount: 3,
      childAspectRatio: UILayerConst.pictureRatio,
      padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
      itemBuilder: (context, item, index) => YellowPictureItemCard(data: item),
      onFetchingMore: (currentPage, pageSize) => _getData(
          page: currentPage, pageSize: pageSize, type: widget.sort.sort ?? ''),
    );
  }
}
