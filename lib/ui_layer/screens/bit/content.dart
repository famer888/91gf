import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../domain/domain.dart';
import '../../../domain/model/banner_model.dart';
import '../../../domain/model/bit_nav_model.dart';
import '../../../domain/model/navigator_model.dart';
import '../../../domain/model/post_model.dart';
import '../../utils/my_toast.dart';
import '../common_widgets/my_tab_bar.dart';
import '../../notifiers/home_config_notifier.dart';
import '../common_widgets/general_banner.dart';
import '../common_widgets/my_list_view.dart';
import '../common_widgets/post/card/card.dart';
import '../theme.dart';

class BitContentView extends StatefulWidget {
  const BitContentView({super.key, required this.nav});

  final BitNavModel nav;

  @override
  State<BitContentView> createState() => _BitContentViewState();
}

class _BitContentViewState extends State<BitContentView> {
  late final _domain = context.read<SeedDomain>();
  late final _homeConfig = context.read<HomeConfigNotifier>();
  final ValueNotifier<List<BannerModel>> _bannersNotifier = ValueNotifier([]);
  late final List<NavigatorModel> _titles = _homeConfig.config.seedSortNav ?? [];

  bool isInit = false;

  Future<List<PostModel>?> _getData({required int page, required int pageSize, required String sort}) async {
    final result = await _domain.bitSortList(
      id: widget.nav.id,
      sort: sort,
      page: page,
      limit: pageSize,
    );
    if (!isInit) {
      setState(() {
        isInit = true;
      });
    }

    if (result.status == 1) {
      if (result.data?.banners case final data? when data.isNotEmpty && _bannersNotifier.value.isEmpty) {
        _bannersNotifier.value = data;
      }
      return result.data?.posts;
    } else {
      MyToast.showText(text: result.msg ?? '');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (_, __) => [
        SliverToBoxAdapter(
          child: _Header(
            bannersNotifier: _bannersNotifier,
          ),
        ),
      ],
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
        child: TabBarWithView.fillColor(
          tabBarPadding: EdgeInsets.symmetric(vertical: 6.w),
          tabBarHeight: 32.w,
          isScrollable: true,
          titles: isInit ? [for (final title in _titles) title.title] : [],
          views: [
            for (final NavigatorModel nav in _titles)
              MyListView.list(
                contentPadding: 15.w,
                padding: EdgeInsets.symmetric(vertical: MyTheme.pagePadding),
                itemBuilder: (context, item, index) => PostCard.bit(data: item),
                onFetchingMore: (currentPage, pageSize) => _getData(page: currentPage, pageSize: pageSize, sort: nav.type),
              )
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.bannersNotifier});

  final ValueNotifier<List<BannerModel>> bannersNotifier;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 6.w),
        ValueListenableBuilder(
          valueListenable: bannersNotifier,
          builder: (context, banners, child) {
            if (banners.isEmpty) return const SizedBox.shrink();
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
              child: GeneralBannerAppsListWidget(data: banners),
            );
          },
        ),
        SizedBox(height: 4.w),
      ],
    );
  }
}
