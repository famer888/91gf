import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/app_global.dart';
import 'package:jygf/domain/api_validator.dart';
import 'package:jygf/domain/model/album_model.dart';
import 'package:jygf/domain/model/cartoon/cartoon_model.dart';
import 'package:jygf/domain/model/chat/chat_list_model.dart';
import 'package:jygf/domain/model/comic_model.dart';
import 'package:jygf/domain/model/game/game_model.dart';
import 'package:jygf/domain/model/novel_model.dart';
import 'package:jygf/domain/model/vlog_model.dart';
import 'package:jygf/domain/model/voice_model.dart';
import 'package:jygf/domain/remote_domain/domains/album.dart';
import 'package:jygf/domain/remote_domain/domains/asmr.dart';
import 'package:jygf/domain/remote_domain/domains/cartoon.dart';
import 'package:jygf/domain/remote_domain/domains/chat.dart';
import 'package:jygf/domain/remote_domain/domains/comic.dart';
import 'package:jygf/domain/remote_domain/domains/game.dart';
import 'package:jygf/domain/remote_domain/domains/live.dart';
import 'package:jygf/domain/remote_domain/domains/black_domain.dart';
import 'package:jygf/domain/remote_domain/domains/novel.dart';
import 'package:jygf/domain/remote_domain/domains/seed.dart';
import 'package:jygf/domain/remote_domain/domains/user.dart';
import 'package:jygf/domain/remote_domain/domains/vlog.dart';
import 'package:jygf/ui_layer/notifiers/home_config_notifier.dart';
import 'package:jygf/ui_layer/router/routes.dart';
import 'package:jygf/ui_layer/screens/acg/comic/card/comic_item_card.dart';
import 'package:jygf/ui_layer/screens/acg/novel/card/novel_item_card.dart';
import 'package:jygf/ui_layer/screens/asmr/card/voice_gird_card.dart';
import 'package:jygf/ui_layer/screens/common_widgets/cartoon/card/video_card.dart';
import 'package:jygf/ui_layer/screens/common_widgets/chat/list_card.dart';
import 'package:jygf/ui_layer/screens/black/model/black_model.dart';
import 'package:jygf/ui_layer/screens/black/widgets/black_item_widget.dart';
import 'package:jygf/ui_layer/screens/common_widgets/game/card/game_card.dart';
import 'package:jygf/ui_layer/screens/file_search/widget/check_file_item.dart';
import 'package:jygf/ui_layer/screens/vlog/card/vlog_card.dart';
import 'package:jygf/ui_layer/screens/yellow_picture/card/yellow_picture_item_card.dart';
import 'package:jygf/ui_layer/utils/common_utils.dart';
import 'package:provider/provider.dart';
import 'package:jygf/domain/model/collection_model.dart';
import 'package:jygf/domain/model/live_model.dart';
import 'package:jygf/domain/model/post_model.dart';
import 'package:jygf/domain/result.dart';
import 'package:jygf/ui_layer/const.dart';
import 'package:jygf/ui_layer/screens/common_widgets/keep_alive_wrapper.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_app_bar.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_list_view.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_tab_bar.dart';
import 'package:jygf/ui_layer/screens/common_widgets/post/card/card.dart';
import 'package:jygf/ui_layer/screens/common_widgets/screen_background.dart';
import 'package:jygf/ui_layer/screens/live_video/live_card/live_video_card.dart';
import 'package:jygf/ui_layer/screens/mine/common_widgets/video_tile.dart';
import 'package:jygf/ui_layer/screens/theme.dart';

class MineCollectionScreen extends StatefulWidget {
  const MineCollectionScreen({super.key});

  @override
  State<MineCollectionScreen> createState() => _MineCollectionScreenState();
}

class _MineCollectionScreenState extends State<MineCollectionScreen> {
  late final homeConfigNotifier = context.read<HomeConfigNotifier>();
  @override
  Widget build(BuildContext context) {
    final openLive = homeConfigNotifier.config.openLive == 1 ? true : false;

    return ScreenBackground(
      child: Scaffold(
        appBar: MyAppBar(
          title: 'wdsc'.tr(context: context),
        ),
        body: TabBarWithView.line(
          indicatorType: IndicatorType.curve,
          // labelStyle: MyTheme.jellyCyan_15,
          unselectedLabelStyle: TextStyle(
            color: const Color.fromRGBO(255, 255, 255, 0.8),
            fontSize: 15.sp,
            overflow: TextOverflow.visible,
            decoration: TextDecoration.none,
          ),
          // tabBarHeight: 40.w,
          isScrollable: true,
          titles: [
            'csp'.tr(context: context),
            'dsp'.tr(context: context),
            'tiezt'.tr(context: context),
            'heil'.tr(context: context),
            'meit'.tr(context: context),
            'dman'.tr(),
            'mh'.tr(context: context),
            'xs'.tr(context: context),
            'hyou'.tr(),
            if (openLive) 'zhib'.tr(context: context),
            'ASMR',
            'yuep'.tr(context: context),
            'luol'.tr(context: context),
            'zhoz'.tr(context: context),
            'chad'.tr(context: context),
          ],
          views: [
            const KeepAliveWrapper(
              child: _VideoView(),
            ),
            const KeepAliveWrapper(
              child: _VlogVideoView(),
            ),
            const KeepAliveWrapper(
              child: _TieztView(type: _TieztType.community),
            ),
            const KeepAliveWrapper(
              child: _BlackView(),
            ),
            const KeepAliveWrapper(
              child: _YellowPictureView(),
            ),
            const KeepAliveWrapper(
              child: _CartoonView(),
            ),
            const KeepAliveWrapper(
              child: _ComicView(),
            ),
            const KeepAliveWrapper(
              child: _NovelView(),
            ),
            const KeepAliveWrapper(
              child: _GameView(),
            ),
            if (openLive)
              const KeepAliveWrapper(
                child: _LiveView(),
              ),
            const KeepAliveWrapper(
              child: _ASMRView(),
            ),
            const KeepAliveWrapper(
              child: _DateView(),
            ),
            const KeepAliveWrapper(
              child: _ChatView(),
            ),
            const KeepAliveWrapper(
              child: _ZhozView(),
            ),
            const KeepAliveWrapper(
              child: _ChaDangView(),
            ),
          ],
        ),
      ),
    );
  }
}

class _VideoView extends StatefulWidget {
  const _VideoView();

  @override
  State<_VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<_VideoView> {
  late final userDomain = context.read<UserDomain>();
  String lastIx = '';

  Future<List<MineVideoCardData>> _getData({
    required int page,
    required int pageSize,
  }) async {
    final result = await userDomain.getUserFavor(
      page: page,
      limit: pageSize,
      type: 1,
      lastIx: page == 1 ? '' : lastIx,
    ) as Result<MineVideoListModel>;
    lastIx = result.data?.lastIx ?? '';

    return result.data!.list!;
  }

  @override
  Widget build(BuildContext context) {
    return MyListView.grid(
      childAspectRatio: 1,
      itemBuilder: (_, item, __) => MineVideoTile(data: item),
      onFetchingMore: (currentPage, pageSize) => _getData(
        page: currentPage,
        pageSize: pageSize,
      ),
    );
  }
}

enum _TieztType {
  community,
  bit;
  // date;

  int get id => switch (this) {
        _TieztType.community => 14,
        _TieztType.bit => 19,
        // _TieztType.date => 10,
      };
}

class _TieztView extends StatefulWidget {
  const _TieztView({required this.type});

  final _TieztType type;

  @override
  State<_TieztView> createState() => _TieztViewState();
}

class _TieztViewState extends State<_TieztView> {
  late final userDomain = context.read<UserDomain>();
  String lastIx = '';

  Future<List<PostModel>> _getData({
    required int page,
    required int pageSize,
  }) async {
    final result = await userDomain.getUserFavor(
      page: page,
      limit: pageSize,
      type: widget.type.id,
      lastIx: page == 1 ? '' : lastIx,
    ) as Result<MineTieztListModel>;
    lastIx = result.data?.lastIx ?? '';

    return result.data!.list!;
  }

  @override
  Widget build(BuildContext context) {
    return MyListView.list(
      contentPadding: 15.w,
      itemBuilder: (context, item, index) => switch (widget.type) {
        _TieztType.community => PostCard.community(data: item),
        _TieztType.bit => PostCard.bit(data: item),
      },
      onFetchingMore: (currentPage, pageSize) => _getData(
        page: currentPage,
        pageSize: pageSize,
      ),
    );
  }
}

class _LiveView extends StatefulWidget {
  const _LiveView();

  @override
  State<_LiveView> createState() => _LiveViewState();
}

class _LiveViewState extends State<_LiveView> {
  late final liveDomain = context.read<LiveDomain>();

  Future<List<LiveModel>?> _getData({
    required int page,
    required int pageSize,
  }) async {
    final result = await liveDomain.getLiveListFavorite(
      page: page,
      limit: pageSize,
    );
    return result.data;
  }

  @override
  Widget build(BuildContext context) {
    return MyListView.grid(
      childAspectRatio: UILayerConst.videoRatio,
      contentPadding: 15.w,
      padding: EdgeInsets.symmetric(
          vertical: MyTheme.pagePadding, horizontal: MyTheme.pagePadding),
      itemBuilder: (context, item, index) => LiveVideoCard(data: item),
      onFetchingMore: (currentPage, pageSize) =>
          _getData(page: currentPage, pageSize: pageSize),
    );
  }
}

class _ZhozView extends StatefulWidget {
  const _ZhozView();

  @override
  State<_ZhozView> createState() => _ZhozViewState();
}

class _ZhozViewState extends State<_ZhozView> {
  late final seedDomain = context.read<SeedDomain>();

  Future<List<PostModel>> _getData({
    required int page,
    required int pageSize,
  }) async {
    final result = await seedDomain.favoriteBitList(
      page: page,
      limit: pageSize,
    );

    return result.data!;
  }

  @override
  Widget build(BuildContext context) {
    return MyListView.list(
      contentPadding: 15.w,
      itemBuilder: (context, item, index) => PostCard.bit(data: item),
      onFetchingMore: (currentPage, pageSize) => _getData(
        page: currentPage,
        pageSize: pageSize,
      ),
    );
  }
}

class _ASMRView extends StatefulWidget {
  const _ASMRView();

  @override
  State<_ASMRView> createState() => _ASMRViewState();
}

class _ASMRViewState extends State<_ASMRView> {
  late final domain = context.read<ASMRDomain>();

  Future<List<VoiceModel>?> _getData({
    required int page,
    required int pageSize,
  }) async {
    final result = await domain.voiceFavoriteList(
      page: page,
      limit: pageSize,
    );

    return result.data!;
  }

  @override
  Widget build(BuildContext context) {
    return MyListView.grid(
      contentPadding: 15.w,
      itemBuilder: (context, item, index) => VoiceGirdCard(data: item),
      onFetchingMore: (currentPage, pageSize) => _getData(
        page: currentPage,
        pageSize: pageSize,
      ),
    );
  }
}

class _VlogVideoView extends StatefulWidget {
  const _VlogVideoView();

  @override
  State<_VlogVideoView> createState() => _VlogVideoViewState();
}

class _VlogVideoViewState extends State<_VlogVideoView> {
  late final _domain = context.read<VlogDomain>();
  List<VlogModel> array = [];

  int _page = 1;
  int _limit = 15;

  Future<List<VlogModel>?> _getData({
    required int page,
    required int pageSize,
  }) async {
    _page = page;
    _limit = pageSize;

    final result = await _domain.vlogFavoriteList(page: page, limit: pageSize);
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
      padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
      childAspectRatio: UILayerConst.vlogVideoRatio,
      crossAxisSpacing: 10.w,
      itemBuilder: (_, item, index) => VlogCard(
          data: item,
          onTapFunc: (type) {
            if (type == 1) {
              //点击短视频视频
              AppGlobal.shortVideosInfo = {
                'list': array,
                'page': _page,
                'index': index,
                'api': 'vlog/list_favorite',
                'params': {
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
        page: currentPage,
        pageSize: pageSize,
      ),
    );
  }
}

class _GameView extends StatefulWidget {
  const _GameView();

  @override
  State<_GameView> createState() => _GameViewState();
}

class _GameViewState extends State<_GameView> {
  late final _domain = context.read<GameDomain>();
  Future<List<GameModel>?> _getData({
    required int page,
    required int pageSize,
  }) async {
    final result = await _domain.gameFavoriteList(page: page, limit: pageSize);
    if (result.isValid) {
      List<GameModel> tp = List.from(result.data ?? []);
      return tp;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MyListView.grid(
      padding:
          EdgeInsets.symmetric(horizontal: MyTheme.pagePadding, vertical: 8.w),
      childAspectRatio: GameCard.aspectRatio,
      crossAxisSpacing: 8.w,
      itemBuilder: (context, item, index) => GameCard(data: item),
      onFetchingMore: (currentPage, pageSize) => _getData(
        page: currentPage,
        pageSize: pageSize,
      ),
    );
  }
}

class _YellowPictureView extends StatefulWidget {
  const _YellowPictureView();

  @override
  State<_YellowPictureView> createState() => _YellowPictureViewState();
}

class _YellowPictureViewState extends State<_YellowPictureView> {
  late final albumDomain = context.read<AlbumDomain>();

  Future<List<AlbumItemsModel>> _getData({
    required int page,
    required int pageSize,
  }) async {
    final result = await albumDomain.albumFavoriteList(
      page: page,
      limit: pageSize,
    );

    return result.data!;
  }

  @override
  Widget build(BuildContext context) {
    return MyListView.grid(
      childAspectRatio: UILayerConst.pictureRatio,
      contentPadding: 10.w,
      crossAxisCount: 3,
      padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
      itemBuilder: (context, item, index) => YellowPictureItemCard(data: item),
      onFetchingMore: (currentPage, pageSize) => _getData(
        page: currentPage,
        pageSize: pageSize,
      ),
    );
  }
}

class _CartoonView extends StatefulWidget {
  const _CartoonView();

  @override
  State<_CartoonView> createState() => _CartoonViewState();
}

class _CartoonViewState extends State<_CartoonView> {
  late final _domain = context.read<CartoonDomain>();

  Future<List<CartoonModel>?> _getData({
    required int page,
    required int pageSize,
  }) async {
    final result = await _domain.cartoonFavoriteList(
      page: page,
      limit: pageSize,
    );
    if (result.isValid) {
      List<CartoonModel> tp = List.from(result.data ?? []);
      return tp;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MyListView.grid(
      padding:
          EdgeInsets.symmetric(horizontal: MyTheme.pagePadding, vertical: 8.w),
      childAspectRatio: CartoonVideoCard.aspectRatio,
      crossAxisSpacing: 8.w,
      itemBuilder: (context, item, index) => CartoonVideoCard(data: item),
      onFetchingMore: (currentPage, pageSize) => _getData(
        page: currentPage,
        pageSize: pageSize,
      ),
    );
  }
}

class _ComicView extends StatefulWidget {
  const _ComicView();

  @override
  State<_ComicView> createState() => _ComicViewState();
}

class _ComicViewState extends State<_ComicView> {
  late final comicDomain = context.read<ComicDomain>();

  Future<List<ComicItemsModel>> _getData({
    required int page,
    required int pageSize,
  }) async {
    final result = await comicDomain.comicFavoriteList(
      page: page,
      limit: pageSize,
    );

    return result.data!;
  }

  @override
  Widget build(BuildContext context) {
    return MyListView.grid(
      childAspectRatio: UILayerConst.comicRatio,
      crossAxisCount: 3,
      padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
      itemBuilder: (context, item, index) => ComicItemCard(data: item),
      onFetchingMore: (currentPage, pageSize) => _getData(
        page: currentPage,
        pageSize: pageSize,
      ),
    );
  }
}

class _NovelView extends StatefulWidget {
  const _NovelView();

  @override
  State<_NovelView> createState() => _NovelViewState();
}

class _NovelViewState extends State<_NovelView> {
  late final novelDomain = context.read<NovelDomain>();

  Future<List<NovelItemsModel>> _getData({
    required int page,
    required int pageSize,
  }) async {
    final result = await novelDomain.novelFavoriteList(
      page: page,
      limit: pageSize,
    );

    return result.data!;
  }

  @override
  Widget build(BuildContext context) {
    return MyListView.grid(
      childAspectRatio: UILayerConst.pictureRatio,
      contentPadding: 10.w,
      crossAxisCount: 3,
      padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
      itemBuilder: (context, item, index) => NovelItemCard(data: item),
      onFetchingMore: (currentPage, pageSize) => _getData(
        page: currentPage,
        pageSize: pageSize,
      ),
    );
  }
}

class _ChatView extends StatefulWidget {
  const _ChatView();

  @override
  State<_ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<_ChatView> {
  late final chatDomain = context.read<ChatDomain>();

  Future<List<ChatListChatModel>> _getData({
    required int page,
    required int pageSize,
  }) async {
    final result = await chatDomain.chatFavoriteList(
      page: page,
      limit: pageSize,
    );

    return result.data!
        .whereType<ChatListChatModel>()
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return MyListView.grid(
      padding: EdgeInsets.symmetric(vertical: 5.w, horizontal: MyTheme.pagePadding),
      childAspectRatio: 169 / (224 + 48),
      mainAxisSpacing: 10,
      crossAxisSpacing: 7,
      itemBuilder: (context, item, index) => ChatListCard(data: item),
      onFetchingMore: (currentPage, pageSize) => _getData(
        page: currentPage,
        pageSize: pageSize,
      ),
    );
  }
}

//黑料
class _BlackView extends StatefulWidget {
  const _BlackView();

  @override
  State<_BlackView> createState() => _BlackViewState();
}

class _BlackViewState extends State<_BlackView> {
  late final blackDomain = context.read<BlackDomain>();

  Future<List<BlackListItemModel>?> _getData({
    required int page,
    required int pageSize,
  }) async {
    final result = await blackDomain.getBlackCollectList(
      page: page,
      limit: pageSize,
    );

    return result.data;
  }

  @override
  Widget build(BuildContext context) {
    return MyListView.list(
      contentPadding: 15.w,
      itemBuilder: (context, item, index) => BlackItemWidget(
        item: item,
        itemWidth: (ScreenUtil().screenWidth - MyTheme.pagePadding * 2),
      ),
      onFetchingMore: (currentPage, pageSize) => _getData(
        page: currentPage,
        pageSize: pageSize,
      ),
    );
  }
}

//约炮
class _DateView extends StatefulWidget {
  const _DateView();


  @override
  State<_DateView> createState() => _DateViewState();
}

class _DateViewState extends State<_DateView> {
late final userDomain = context.read<UserDomain>();
  String lastIx = '';

  Future<List<PostModel>> _getData({
    required int page,
    required int pageSize,
  }) async {
    final result = await userDomain.getUserFavor(
      page: page,
      limit: pageSize,
      type: 10,
      lastIx: page == 1 ? '' : lastIx,
    ) as Result<MineTieztListModel>;
    lastIx = result.data?.lastIx ?? '';

    return result.data!.list!;
  }

  @override
  Widget build(BuildContext context) {
    return MyListView.list(
      contentPadding: 15.w,
      itemBuilder: (context, item, index) => PostCard.community(data: item),
      onFetchingMore: (currentPage, pageSize) => _getData(
        page: currentPage,
        pageSize: pageSize,
      ),
    );
  }
}

//查档
class _ChaDangView extends StatefulWidget {
  const _ChaDangView();

  @override
  State<_ChaDangView> createState() => _ChaDangViewState();
}

class _ChaDangViewState extends State<_ChaDangView> {
  late final userDomain = context.read<UserDomain>();
  String lastIx = '';

  Future<List<PostModel>> _getData({
    required int page,
    required int pageSize,
  }) async {
    final result = await userDomain.getUserFavor(
      page: page,
      limit: pageSize,
      type: 25,//后端约定
      lastIx: page == 1 ? '' : lastIx,
    ) as Result<MineTieztListModel>;
    lastIx = result.data?.lastIx ?? '';

    return result.data!.list!;
  }

  @override
  Widget build(BuildContext context) {
    return MyListView.list(
      contentPadding: 15.w,
      itemBuilder: (context, item, index) => CheckFileItem(item: item, itemWidth: (ScreenUtil().screenWidth - MyTheme.pagePadding * 2)),
      onFetchingMore: (currentPage, pageSize) => _getData(
        page: currentPage,
        pageSize: pageSize,
      ),
    );
  }
}


