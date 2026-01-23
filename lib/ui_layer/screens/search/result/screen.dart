import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/app_global.dart';
import 'package:jygf/domain/api_validator.dart';
import 'package:jygf/domain/domain.dart';
import 'package:jygf/domain/model/album_model.dart';
import 'package:jygf/domain/model/cartoon/cartoon_model.dart';
import 'package:jygf/domain/model/chat/chat_list_model.dart';
import 'package:jygf/domain/model/comic_model.dart';
import 'package:jygf/domain/model/feed/feed_model.dart';
import 'package:jygf/domain/model/game/game_model.dart';
import 'package:jygf/domain/model/live_model.dart';
import 'package:jygf/domain/model/novel_model.dart';
import 'package:jygf/domain/model/post_model.dart';
import 'package:jygf/domain/model/vlog_model.dart';
import 'package:jygf/domain/model/voice_model.dart';
import 'package:jygf/domain/remote_domain/domains/album.dart';
import 'package:jygf/domain/remote_domain/domains/asmr.dart';
import 'package:jygf/domain/remote_domain/domains/black_domain.dart';
import 'package:jygf/domain/remote_domain/domains/cartoon.dart';
import 'package:jygf/domain/remote_domain/domains/comic.dart';
import 'package:jygf/domain/remote_domain/domains/game.dart';
import 'package:jygf/domain/remote_domain/domains/live.dart';
import 'package:jygf/domain/remote_domain/domains/novel.dart';
import 'package:jygf/report/ui_layer/report_search_click.dart';
import 'package:jygf/ui_layer/const.dart';
import 'package:jygf/ui_layer/notifiers/home_config_notifier.dart';
import 'package:jygf/ui_layer/router/routes.dart';
import 'package:jygf/ui_layer/screens/acg/comic/card/comic_item_card.dart';
import 'package:jygf/ui_layer/screens/acg/novel/card/novel_item_card.dart';
import 'package:jygf/ui_layer/screens/asmr/card/voice_gird_card.dart';
import 'package:jygf/ui_layer/screens/black/model/black_model.dart';
import 'package:jygf/ui_layer/screens/black/widgets/black_item_widget.dart';
import 'package:jygf/ui_layer/screens/common_widgets/cartoon/card/video_card.dart';
import 'package:jygf/ui_layer/screens/common_widgets/chat/list_card.dart';
import 'package:jygf/ui_layer/screens/common_widgets/feed/card/video_card.dart';
import 'package:jygf/ui_layer/screens/common_widgets/feed/feed_card.dart';
import 'package:jygf/ui_layer/screens/common_widgets/game/card/game_card.dart';
import 'package:jygf/ui_layer/screens/common_widgets/keep_alive_wrapper.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_app_bar.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_list_view.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_tab_bar.dart';
import 'package:jygf/ui_layer/screens/common_widgets/post/card/card.dart';
import 'package:jygf/ui_layer/screens/common_widgets/screen_background.dart';
import 'package:jygf/ui_layer/screens/file_search/widget/check_file_item.dart';
import 'package:jygf/ui_layer/screens/live_video/live_card/live_video_card.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/ui_layer/screens/vlog/card/vlog_card.dart';
import 'package:jygf/ui_layer/screens/yellow_picture/card/yellow_picture_item_card.dart';
import 'package:jygf/ui_layer/utils/common_utils.dart';
import 'package:provider/provider.dart';

import '../../../../domain/remote_domain/domains/chat.dart';

class SearchResultScreen extends StatefulWidget {
  const SearchResultScreen({super.key, required this.title});

  final String title;

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  late final homeConfigNotifier = context.read<HomeConfigNotifier>();

  @override
  Widget build(BuildContext context) {
    final openLive = homeConfigNotifier.config.openLive == 1 ? true : false;

    final titles = <String>[
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
    ];

    final views = <Widget>[
      KeepAliveWrapper(
        child: _VideoView(word: widget.title),
      ),
      KeepAliveWrapper(
        child: _VlogVideoView(word: widget.title),
      ),
      KeepAliveWrapper(
        child: _TieztView(word: widget.title),
      ),
      KeepAliveWrapper(
        child: _BlackView(word: widget.title),
      ),
      KeepAliveWrapper(
        child: _YellowPictureView(word: widget.title),
      ),
      KeepAliveWrapper(
        child: _CartoonView(word: widget.title),
      ),
      KeepAliveWrapper(
        child: _ComicView(word: widget.title),
      ),
      KeepAliveWrapper(
        child: _NovelView(word: widget.title),
      ),
      KeepAliveWrapper(
        child: _GameView(word: widget.title),
      ),
      if (openLive)
        KeepAliveWrapper(
          child: _LiveVideoView(word: widget.title),
        ),
      KeepAliveWrapper(
        child: _ASMRView(word: widget.title),
      ),
      KeepAliveWrapper(
        child: _DateView(word: widget.title),
      ),
      KeepAliveWrapper(
        child: _ChatView(word: widget.title),
      ),
      KeepAliveWrapper(
        child: _TorrentView(word: widget.title),
      ),
      KeepAliveWrapper(
        child: _ChaDangView(word: widget.title),
      ),
    ];

    return ScreenBackground(
      child: Scaffold(
        appBar: MyAppBar(title: 'ssjg'.tr(context: context)),
        body: TabBarWithView.line(
          indicatorType: IndicatorType.curve,
          tabBarPadding: EdgeInsets.symmetric(
            vertical: 6.w,
            horizontal: MyTheme.pagePadding,
          ),
          // tabBarHeight: 40.w,
          isScrollable: true,
          titles: titles,
          views: views,
        ),
      ),
    );
  }
}

class _VideoView extends StatefulWidget {
  const _VideoView({required this.word});

  final String word;

  @override
  State<_VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<_VideoView> {
  late final mvDomain = context.read<MvDomain>();

  Future<List<FeedVideoModel>> _getData({
    required int page,
    required int pageSize,
  }) async {
    final result = await mvDomain.videoSearch(page: page, limit: pageSize, word: widget.word);

    return result.data!;
  }

  @override
  Widget build(BuildContext context) {
    return MyListView.grid(
      padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding, vertical: 8.w),
      childAspectRatio: FeedCard.aspectRatio,
      crossAxisSpacing: 8.w,
      itemBuilder: (_, item, index) => VideoCard(data: item).withSearchReport({
        "event": "keyword_click",
        "keyword": widget.word,
        "click_item_id": item.id,
        "click_item_type_key": "video",
        "click_item_type_name": "视频",
        "click_ position": index,
      }),
      onFetchingMore: (currentPage, pageSize) => _getData(
        page: currentPage,
        pageSize: pageSize,
      ),
    );
  }
}

class _TieztView extends StatefulWidget {
  const _TieztView({required this.word});

  final String word;

  @override
  State<_TieztView> createState() => _TieztViewState();
}

class _TieztViewState extends State<_TieztView> {
  late final communityDomain = context.read<CommunityDomain>();

  Future<List<PostModel>> _getData({
    required int page,
    required int pageSize,
  }) async {
    final result = await communityDomain.searchCommunity(
      page: page,
      limit: pageSize,
      word: widget.word,
      type: '1',
    );

    return result.data!;
  }

  @override
  Widget build(BuildContext context) {
    return MyListView.list(
      contentPadding: 15.w,
      itemBuilder: (context, item, index) => PostCard.community(data: item).withSearchReport({
        "event": "keyword_click",
        "keyword": widget.word,
        "click_item_id": item.id,
        "click_item_type_key": "tiezi",
        "click_item_type_name": "贴子",
        "click_ position": index,
      }),
      onFetchingMore: (currentPage, pageSize) => _getData(
        page: currentPage,
        pageSize: pageSize,
      ),
    );
  }
}

class _ZhozView extends StatefulWidget {
  const _ZhozView({required this.word});

  final String word;

  @override
  State<_ZhozView> createState() => _ZhozViewState();
}

class _ZhozViewState extends State<_ZhozView> {
  late final seedDomain = context.read<SeedDomain>();

  Future<List<PostModel>> _getData({
    required int page,
    required int pageSize,
  }) async {
    final result = await seedDomain.searchBit(
      page: page,
      limit: pageSize,
      word: widget.word,
    );

    return result.data!;
  }

  @override
  Widget build(BuildContext context) {
    return MyListView.list(
      contentPadding: 15.w,
      itemBuilder: (context, item, index) => PostCard.bit(data: item).withSearchReport({
        "event": "keyword_click",
        "keyword": widget.word,
        "click_item_id": item.id,
        "click_item_type_key": "zhoz",
        "click_item_type_name": "种子",
        "click_ position": index,
      }),
      onFetchingMore: (currentPage, pageSize) => _getData(
        page: currentPage,
        pageSize: pageSize,
      ),
    );
  }
}

class _LiveVideoView extends StatefulWidget {
  const _LiveVideoView({required this.word});

  final String word;

  @override
  State<_LiveVideoView> createState() => _LiveVideoViewState();
}

class _LiveVideoViewState extends State<_LiveVideoView> {
  late final _domain = context.read<LiveDomain>();

  Future<List<LiveModel>?> _getData({
    required int page,
    required int pageSize,
  }) async {
    final result = await _domain.getLiveSearch(page: page, limit: pageSize, word: widget.word);
    return result.data;
  }

  @override
  Widget build(BuildContext context) {
    return MyListView.grid(
      padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding, vertical: 8.w),
      childAspectRatio: UILayerConst.videoRatio,
      crossAxisSpacing: 8.w,
      itemBuilder: (_, item, index) => LiveVideoCard(data: item).withSearchReport({
        "event": "keyword_click",
        "keyword": widget.word,
        "click_item_id": item.id,
        "click_item_type_key": "live",
        "click_item_type_name": "直播",
        "click_ position": index,
      }),
      onFetchingMore: (currentPage, pageSize) => _getData(
        page: currentPage,
        pageSize: pageSize,
      ),
    );
  }
}

class _ASMRView extends StatefulWidget {
  const _ASMRView({required this.word});

  final String word;

  @override
  State<_ASMRView> createState() => _ASMRViewState();
}

class _ASMRViewState extends State<_ASMRView> {
  late final domain = context.read<ASMRDomain>();

  Future<List<VoiceModel>?> _getData({
    required int page,
    required int pageSize,
  }) async {
    final result = await domain.voiceSearch(
      word: widget.word,
      page: page,
      limit: pageSize,
    );
    return result.data!;
  }

  @override
  Widget build(BuildContext context) {
    return MyListView.grid(
      contentPadding: 15.w,
      itemBuilder: (context, item, index) => VoiceGirdCard(data: item).withSearchReport({
        "event": "keyword_click",
        "keyword": widget.word,
        "click_item_id": item.id,
        "click_item_type_key": "asmr",
        "click_item_type_name": "ASMR",
        "click_ position": index,
      }),
      onFetchingMore: (currentPage, pageSize) => _getData(
        page: currentPage,
        pageSize: pageSize,
      ),
    );
  }
}

class _TorrentView extends StatefulWidget {
  const _TorrentView({required this.word});

  final String word;

  @override
  State<_TorrentView> createState() => _TorrentViewState();
}

class _TorrentViewState extends State<_TorrentView> {
  late final domain = context.read<SeedDomain>();

  Future<List<PostModel>> _getData({
    required int page,
    required int pageSize,
  }) async {
    final result = await domain.searchBit(
      page: page,
      limit: pageSize,
      word: widget.word,
    );

    return result.data!;
  }

  @override
  Widget build(BuildContext context) {
    return MyListView.list(
      contentPadding: 15.w,
      itemBuilder: (context, item, index) => PostCard.bit(data: item).withSearchReport({
        "event": "keyword_click",
        "keyword": widget.word,
        "click_item_id": item.id,
        "click_item_type_key": "torrent",
        "click_item_type_name": "种子",
        "click_ position": index,
      }),
      onFetchingMore: (currentPage, pageSize) => _getData(
        page: currentPage,
        pageSize: pageSize,
      ),
    );
  }
}

class _VlogVideoView extends StatefulWidget {
  const _VlogVideoView({required this.word});

  final String word;

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

    final result = await _domain.vlogSearchList(word: widget.word, page: page, limit: pageSize);
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
                'api': 'vlog/search',
                'params': {
                  'limit': _limit,
                  'word': widget.word,
                }
              };
              const VlogSecondRoute().push(context);
            } else {
              //广告类型
              CommonUtils.openRoute(context, item.toJson());
            }
          }).withSearchReport({
        "event": "keyword_click",
        "keyword": widget.word,
        "click_item_id": item.id,
        "click_item_type_key": "vlog",
        "click_item_type_name": "短视频",
        "click_ position": index,
      }),
      onFetchingMore: (currentPage, pageSize) => _getData(
        page: currentPage,
        pageSize: pageSize,
      ),
    );
  }
}

class _CartoonView extends StatefulWidget {
  const _CartoonView({required this.word});

  final String word;

  @override
  State<_CartoonView> createState() => _CartoonViewState();
}

class _CartoonViewState extends State<_CartoonView> {
  late final _domain = context.read<CartoonDomain>();

  Future<List<CartoonModel>?> _getData({
    required int page,
    required int pageSize,
  }) async {
    final result = await _domain.cartoonSearchList(word: widget.word, page: page, limit: pageSize);
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
      padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding, vertical: 8.w),
      childAspectRatio: CartoonVideoCard.aspectRatio,
      crossAxisSpacing: 8.w,
      itemBuilder: (context, item, index) => CartoonVideoCard(data: item).withSearchReport({
        "event": "keyword_click",
        "keyword": widget.word,
        "click_item_id": item.id,
        "click_item_type_key": "cartoon",
        "click_item_type_name": "动漫",
        "click_ position": index,
      }),
      onFetchingMore: (currentPage, pageSize) => _getData(
        page: currentPage,
        pageSize: pageSize,
      ),
    );
  }
}

class _GameView extends StatefulWidget {
  const _GameView({required this.word});

  final String word;

  @override
  State<_GameView> createState() => _GameViewState();
}

class _GameViewState extends State<_GameView> {
  late final _domain = context.read<GameDomain>();

  Future<List<GameModel>?> _getData({
    required int page,
    required int pageSize,
  }) async {
    final result = await _domain.gameSearchList(word: widget.word, page: page, limit: pageSize);
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
      padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding, vertical: 8.w),
      childAspectRatio: GameCard.aspectRatio,
      crossAxisSpacing: 8.w,
      itemBuilder: (context, item, index) => GameCard(data: item).withSearchReport({
        "event": "keyword_click",
        "keyword": widget.word,
        "click_item_id": item.id,
        "click_item_type_key": "game",
        "click_item_type_name": "黄游",
        "click_ position": index,
      }),
      onFetchingMore: (currentPage, pageSize) => _getData(
        page: currentPage,
        pageSize: pageSize,
      ),
    );
  }
}

//约炮
class _DateView extends StatefulWidget {
  const _DateView({required this.word});

  final String word;

  @override
  State<_DateView> createState() => _DateViewState();
}

class _DateViewState extends State<_DateView> {
  late final communityDomain = context.read<CommunityDomain>();

  Future<List<PostModel>> _getData({
    required int page,
    required int pageSize,
  }) async {
    final result = await communityDomain.searchCommunity(
      page: page,
      limit: pageSize,
      word: widget.word,
      type: '1',
    );

    return result.data!;
  }

  @override
  Widget build(BuildContext context) {
    return MyListView.list(
      contentPadding: 15.w,
      itemBuilder: (context, item, index) => PostCard.community(data: item).withSearchReport({
        "event": "keyword_click",
        "keyword": widget.word,
        "click_item_id": item.id,
        "click_item_type_key": "date",
        "click_item_type_name": "约炮",
        "click_ position": index,
      }),
      onFetchingMore: (currentPage, pageSize) => _getData(
        page: currentPage,
        pageSize: pageSize,
      ),
    );
  }
}

//查档
class _ChaDangView extends StatefulWidget {
  const _ChaDangView({required this.word});

  final String word;

  @override
  State<_ChaDangView> createState() => _ChaDangViewState();
}

class _ChaDangViewState extends State<_ChaDangView> {
  late final communityDomain = context.read<CommunityDomain>();

  Future<List<PostModel>> _getData({
    required int page,
    required int pageSize,
  }) async {
    final result = await communityDomain.searchCommunity(
      page: page,
      limit: pageSize,
      word: widget.word,
      type: '3',
    );

    return result.data!;
  }

  @override
  Widget build(BuildContext context) {
    return MyListView.list(
      contentPadding: 15.w,
      itemBuilder: (context, item, index) => CheckFileItem(item: item, itemWidth: (ScreenUtil().screenWidth - MyTheme.pagePadding * 2)).withSearchReport({
        "event": "keyword_click",
        "keyword": widget.word,
        "click_item_id": item.id,
        "click_item_type_key": "check_file",
        "click_item_type_name": "查档",
        "click_ position": index,
      }),
      onFetchingMore: (currentPage, pageSize) => _getData(
        page: currentPage,
        pageSize: pageSize,
      ),
    );
  }
}

//美图
class _YellowPictureView extends StatefulWidget {
  const _YellowPictureView({required this.word});

  final String word;

  @override
  State<_YellowPictureView> createState() => _YellowPictureViewState();
}

class _YellowPictureViewState extends State<_YellowPictureView> {
  late final albumDomain = context.read<AlbumDomain>();

  Future<List<AlbumItemsModel>> _getData({
    required int page,
    required int pageSize,
  }) async {
    final result = await albumDomain.albumSearchList(
      page: page,
      limit: pageSize,
      word: widget.word,
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
      itemBuilder: (context, item, index) => YellowPictureItemCard(data: item).withSearchReport({
        "event": "keyword_click",
        "keyword": widget.word,
        "click_item_id": item.id,
        "click_item_type_key": "yellow_picture",
        "click_item_type_name": "美图",
        "click_ position": index,
      }),
      onFetchingMore: (currentPage, pageSize) => _getData(
        page: currentPage,
        pageSize: pageSize,
      ),
    );
  }
}

//漫画
class _ComicView extends StatefulWidget {
  const _ComicView({required this.word});

  final String word;

  @override
  State<_ComicView> createState() => _ComicViewState();
}

class _ComicViewState extends State<_ComicView> {
  late final comicDomain = context.read<ComicDomain>();

  Future<List<ComicItemsModel>> _getData({
    required int page,
    required int pageSize,
  }) async {
    final result = await comicDomain.comicSearchList(
      page: page,
      limit: pageSize,
      word: widget.word,
    );

    return result.data!;
  }

  @override
  Widget build(BuildContext context) {
    return MyListView.grid(
      childAspectRatio: UILayerConst.comicRatio,
      crossAxisCount: 3,
      padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
      itemBuilder: (context, item, index) => ComicItemCard(data: item).withSearchReport({
        "event": "keyword_click",
        "keyword": widget.word,
        "click_item_id": item.id,
        "click_item_type_key": "comic",
        "click_item_type_name": "漫画",
        "click_ position": index,
      }),
      onFetchingMore: (currentPage, pageSize) => _getData(
        page: currentPage,
        pageSize: pageSize,
      ),
    );
  }
}

//小说
class _NovelView extends StatefulWidget {
  const _NovelView({required this.word});

  final String word;

  @override
  State<_NovelView> createState() => _NovelViewState();
}

class _NovelViewState extends State<_NovelView> {
  late final novelDomain = context.read<NovelDomain>();

  Future<List<NovelItemsModel>> _getData({
    required int page,
    required int pageSize,
  }) async {
    final result = await novelDomain.novelSearchList(
      page: page,
      limit: pageSize,
      word: widget.word,
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
      itemBuilder: (context, item, index) => NovelItemCard(data: item).withSearchReport({
        "event": "keyword_click",
        "keyword": widget.word,
        "click_item_id": item.id,
        "click_item_type_key": "novel",
        "click_item_type_name": "小说",
        "click_ position": index,
      }),
      onFetchingMore: (currentPage, pageSize) => _getData(
        page: currentPage,
        pageSize: pageSize,
      ),
    );
  }
}

//裸聊
class _ChatView extends StatefulWidget {
  const _ChatView({required this.word});

  final String word;

  @override
  State<_ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<_ChatView> {
  late final chatDomain = context.read<ChatDomain>();

  Future<List<ChatListChatModel>> _getData({
    required int page,
    required int pageSize,
  }) async {
    final result = await chatDomain.chatSearchList(
      page: page,
      limit: pageSize,
      word: widget.word,
    );

    return result.data!;
  }

  @override
  Widget build(BuildContext context) {
    return MyListView.grid(
      padding: EdgeInsets.symmetric(vertical: 5.w, horizontal: MyTheme.pagePadding),
      childAspectRatio: 169 / (224 + 48),
      mainAxisSpacing: 10,
      crossAxisSpacing: 7,
      itemBuilder: (context, item, index) => ChatListCard(data: item).withSearchReport({
        "event": "keyword_click",
        "keyword": widget.word,
        "click_item_id": item.id,
        "click_item_type_key": "chat",
        "click_item_type_name": "裸聊",
        "click_ position": index,
      }),
      onFetchingMore: (currentPage, pageSize) => _getData(
        page: currentPage,
        pageSize: pageSize,
      ),
    );
  }
}

class _BlackView extends StatefulWidget {
  const _BlackView({required this.word});

  final String word;

  @override
  State<_BlackView> createState() => _BlackViewState();
}

class _BlackViewState extends State<_BlackView> {
  late final _screenUtils = ScreenUtil();
  late final _blackDomain = context.read<BlackDomain>();

  Future<List<BlackListItemModel>?> _searchData({int page = 1, int limit = 15}) async {
    final result = await _blackDomain.getBlackSearch(word: widget.word, page: page, limit: limit);
    if (result.status == 1) {
      if (result.data?.list case final data? when data.isNotEmpty) {
        return data;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
      child: MyListView.list(
        contentPadding: 15.w,
        padding: EdgeInsets.only(top: 5.w, bottom: MyTheme.pagePadding),
        itemBuilder: (context, item, index) => BlackItemWidget(item: item, itemWidth: (_screenUtils.screenWidth - MyTheme.pagePadding * 2)).withSearchReport({
        "event": "keyword_click",
        "keyword": widget.word,
        "click_item_id": item.id,
        "click_item_type_key": "black",
        "click_item_type_name": "黑料",
        "click_ position": index,
      }),
        onFetchingMore: (currentPage, pageSize) => _searchData(page: currentPage, limit: pageSize),
      ),
    );
  }
}

extension EventClick on Widget {
  Widget withSearchReport(Map data) {
    return ReportSearchClick(
      child: this,
      data: data
    );
  }
}