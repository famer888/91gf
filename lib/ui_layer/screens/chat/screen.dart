import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/domain/model/banner_model.dart';
import 'package:jygf/domain/model/chat/chat_list_model.dart';
import 'package:jygf/domain/model/chat_nav_model.dart';
import 'package:jygf/domain/model/girl/girl_option_model.dart';
import 'package:jygf/domain/model/tip_model.dart';
import 'package:jygf/domain/remote_domain/domains/chat.dart';
import 'package:jygf/ui_layer/notifiers/home_config_notifier.dart';
import 'package:jygf/ui_layer/router/routes.dart';
import 'package:jygf/ui_layer/screens/common_widgets/chat/card.dart';
import 'package:jygf/ui_layer/screens/common_widgets/general_banner.dart';
import 'package:jygf/ui_layer/screens/common_widgets/gradient_border.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_app_bar.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_list_view.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_tab_bar.dart';
import 'package:jygf/ui_layer/screens/community/issue/widgets/post_button.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final _homeConfig = context.read<HomeConfigNotifier>();

  final ValueNotifier<List<BannerModel>> _bannersNotifier = ValueNotifier([]);

  late final List<ChatNavModel> _titles = _homeConfig.config.chatNav;
  List<GirlOptionModel> options = [];

  void headerFunc(List<BannerModel> bannerList, List<TipModel> tipList) {
    _bannersNotifier.value = bannerList;
  }

  @override
  void dispose() {
    _bannersNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: 'luol'.tr(),
        rightWidget: GestureDetector(
          onTap: () {
            const ChatIssueRoute().push(context);
          },
          child: GradientBorder(
            gradient: MyTheme.gradient_90_114,
            borderRadius: BorderRadius.circular(4.w),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 1.w),
              child: Text('fb'.tr(), style: MyTheme.white10),
            ),
          ),
        ),
      ),
      body: Stack(children: [
        NestedScrollView(
          headerSliverBuilder: (_, __) => [
            SliverToBoxAdapter(
              child: _Header(
                bannersNotifier: _bannersNotifier,
              ),
            ),
          ],
          body: TabBarWithView.line(
            indicatorType: IndicatorType.curve,
            tabBarHeight: 35.w,
            tabBarPadding: EdgeInsets.fromLTRB(MyTheme.pagePadding, 5.w,
                MyTheme.pagePadding, 0),
            // labelPadding: EdgeInsets.only(right: 19.w),
            labelStyle: MyTheme.white08_15,
            unselectedLabelStyle: MyTheme.gray153_15,
            titles: [for (final title in _titles) title.name ?? ''],
            views: [
              for (final ChatNavModel nav in _titles)
                ChatChildScreen(
                  nav: nav,
                  headerFunc: _titles.indexOf(nav) == 0 ? headerFunc : null,
                )
            ],
          ),
        ),
      ]),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.bannersNotifier,
  });
  final ValueNotifier<List<BannerModel>> bannersNotifier;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: bannersNotifier,
      builder: (context, banners, child) {
        if (banners.isEmpty) return const SizedBox.shrink();
        return Padding(
          padding: EdgeInsets.fromLTRB(MyTheme.pagePadding, 10.w,
              MyTheme.pagePadding, 5.w),
          child: GeneralBannerAppsListWidget(data: banners),
        );
      },
    );
  }
}

class ChatChildScreen extends StatefulWidget {
  const ChatChildScreen({
    super.key,
    required this.nav,
    this.headerFunc,
  });
  final ChatNavModel nav;
  final Function(List<BannerModel> bannerList, List<TipModel> tipList)? headerFunc;

  @override
  State<ChatChildScreen> createState() => _ChatChildScreenState();
}

class _ChatChildScreenState extends State<ChatChildScreen> {
  late final _domain = context.read<ChatDomain>();

  Future<List<ChatListModel>?> _getData({
    required int page,
    required int pageSize,
  }) async {
    final result = widget.nav.type == 2
        ? await _domain.chatSortIndex(
            sort: widget.nav.sort!,
            page: page,
            limit: pageSize,
          )
        : await _domain.chatIndex(
            id: widget.nav.id ?? 0,
            page: page,
            limit: pageSize,
          );

    if (widget.headerFunc != null) {
      List<BannerModel> banner = [];

      List<TipModel> tips = [];

      if (result.data?.banner case final data? when data.isNotEmpty) {
        banner = data;
      }
      if (result.data?.tips case final data? when data.isNotEmpty) {
        tips = data;
      }

      widget.headerFunc?.call(banner, tips);
    }

    if (result.data?.chats case final chats) {
      return chats;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MyListView.grid(
      padding: EdgeInsets.symmetric(vertical: 5.w, horizontal: MyTheme.pagePadding),
      childAspectRatio: 169 / (224 + 48),
      mainAxisSpacing: 10,
      crossAxisSpacing: 7,
      itemBuilder: (context, item, index) => ChatCard(
        data: item,
      ),
      onFetchingMore: (currentPage, pageSize) => _getData(
        page: currentPage,
        pageSize: pageSize,
      ),
    );
  }
}
