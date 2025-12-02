import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../domain/model/feed/feed_model.dart';
import '../../../domain/remote_domain/domains/mv.dart';
import '../common_widgets/feed/feed_card.dart';
import '../common_widgets/keep_alive_wrapper.dart';
import '../common_widgets/my_app_bar.dart';
import '../common_widgets/my_list_view.dart';
import '../common_widgets/my_tab_bar.dart';
import '../common_widgets/screen_background.dart';
import '../theme.dart';

class MoreVideoScreen extends StatefulWidget {
  const MoreVideoScreen({super.key, required this.name, required this.id});

  final String name;
  final String id;

  @override
  State<MoreVideoScreen> createState() => _MoreVideoScreenState();
}

class _MoreVideoScreenState extends State<MoreVideoScreen> {
  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
        child: Scaffold(
      appBar: MyAppBar(
        title: widget.name,
      ),
      body: TabBarWithView.fillColor(
        tabBarPadding: EdgeInsets.symmetric(
          vertical: 6.w,
          horizontal: MyTheme.pagePadding,
        ),
        tabBarHeight: 32.w,
        isScrollable: true,
        titles: [
          'zxpx'.tr(context: context),
          'rdpx'.tr(context: context),
        ],
        views: [
          KeepAliveWrapper(
            child: _VideoView(
              sort: 'new',
              id: widget.id,
            ),
          ),
          KeepAliveWrapper(
            child: _VideoView(
              sort: 'hot',
              id: widget.id,
            ),
          ),
        ],
      ),
    ));
  }
}

class _VideoView extends StatefulWidget {
  const _VideoView({required this.sort, required this.id});
  final String sort;
  final String id;
  @override
  State<_VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<_VideoView> {
  late final mvDomain = context.read<MvDomain>();

  Future<List<FeedModel>> _getData({
    required int page,
    required int pageSize,
  }) async {
    final result = await mvDomain.getListConstructWithParam(
      page: page,
      limit: pageSize,
      sort: widget.sort,
      id: widget.id,
    );

    return result.data!;
  }

  @override
  Widget build(BuildContext context) {
    return MyListView.grid(
      padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding, vertical: 5.w),
      childAspectRatio: FeedCard.aspectRatio,
      crossAxisSpacing: 8.w,
      itemBuilder: (_, item, __) => FeedCard(feed: item),
      onFetchingMore: (currentPage, pageSize) => _getData(
        page: currentPage,
        pageSize: pageSize,
      ),
    );
  }
}
