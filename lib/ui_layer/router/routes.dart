import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jygf/domain/model/ai/ai_magic_model.dart';
import 'package:jygf/domain/model/album_model.dart';
import 'package:jygf/domain/model/comic_model.dart';
import 'package:jygf/domain/model/novel_model.dart';
import 'package:jygf/domain/model/soul_group_model.dart';
import 'package:jygf/domain/model/voice_model.dart';
import 'package:jygf/ui_layer/screens/acg/comic/comic_chapters/comic_chapters_content.dart';
import 'package:jygf/ui_layer/screens/acg/comic/comic_detail/screen.dart';
import 'package:jygf/ui_layer/screens/acg/comic/comic_part_content/comic_end_content.dart';
import 'package:jygf/ui_layer/screens/acg/comic/comic_part_content/comic_more_content.dart';
import 'package:jygf/ui_layer/screens/acg/comic/comic_part_content/comic_new_content.dart';
import 'package:jygf/ui_layer/screens/acg/comic/comic_part_content/comic_rank_content.dart';
import 'package:jygf/ui_layer/screens/acg/comic/comic_part_content/comic_sort_content.dart';
import 'package:jygf/ui_layer/screens/acg/comic/comic_part_content/comic_updating_content.dart';
import 'package:jygf/ui_layer/screens/acg/comic/comic_reader/comic_reader_content.dart';
import 'package:jygf/ui_layer/screens/acg/novel/novel%20_reader/novel_reader_content.dart';
import 'package:jygf/ui_layer/screens/acg/novel/novel_chapters/novel_chapters_content.dart';
import 'package:jygf/ui_layer/screens/acg/novel/novel_detail/screen.dart';
import 'package:jygf/ui_layer/screens/acg/novel/novel_part_content/novel_end_content.dart';
import 'package:jygf/ui_layer/screens/acg/novel/novel_part_content/novel_more_content.dart';
import 'package:jygf/ui_layer/screens/acg/novel/novel_part_content/novel_new_content.dart';
import 'package:jygf/ui_layer/screens/acg/novel/novel_part_content/novel_sort_content.dart';
import 'package:jygf/ui_layer/screens/acg/novel/novel_part_content/novel_updating_content.dart';
import 'package:jygf/ui_layer/screens/acg/novel/novel_voice_player/novel_voice_player_content.dart';
import 'package:jygf/ui_layer/screens/acg/screen.dart';
import 'package:jygf/ui_layer/screens/ai_server/screen.dart';
import 'package:jygf/ui_layer/screens/ai_server/widgets/detail/ai_magic_detail.dart';
import 'package:jygf/ui_layer/screens/ai_server/widgets/ai_magic.dart';
import 'package:jygf/ui_layer/screens/ai_server/widgets/ai_art.dart';
import 'package:jygf/ui_layer/screens/ai_server/widgets/ai_novel_page.dart';
import 'package:jygf/ui_layer/screens/ai_server/widgets/ai_novel_detail_page.dart';
import 'package:jygf/ui_layer/screens/ai_server/widgets/ai_voice_page.dart';
import 'package:jygf/ui_layer/screens/ai_server/widgets/ai_kiss_page.dart';
import 'package:jygf/ui_layer/screens/ai_server/widgets/ai_face_swap.dart';
import 'package:jygf/ui_layer/screens/ai_server/widgets/ai_video_face_swap.dart';
import 'package:jygf/ui_layer/screens/ai_server/widgets/ai_off_derobe.dart';
import 'package:jygf/ui_layer/screens/anime/detail/screen.dart';
import 'package:jygf/ui_layer/screens/anime/more/screen.dart';
import 'package:jygf/ui_layer/screens/anime/screen.dart';
import 'package:jygf/ui_layer/screens/asmr/voice_player/local_voice_player.dart';
import 'package:jygf/ui_layer/screens/asmr/voice_player/voice_player_content.dart';
import 'package:jygf/ui_layer/screens/chat/detail/screen.dart';
import 'package:jygf/ui_layer/screens/chat/issue/screen.dart';
import 'package:jygf/ui_layer/screens/chat/screen.dart';
import 'package:jygf/ui_layer/screens/circle/circle_screen.dart';
import 'package:jygf/ui_layer/screens/community/ori_create_group_chat/group_chat/group_chat_detail_content.dart';
import 'package:jygf/ui_layer/screens/community/ori_create_group_chat/group_chat/group_chat_list_content.dart';
import 'package:jygf/ui_layer/screens/community/ori_create_group_chat/group_chat/group_chat_top_msg_content.dart';
import 'package:jygf/ui_layer/screens/community/ori_create_group_chat/group_chat/group_members_content.dart';
import 'package:jygf/ui_layer/screens/community/ori_create_group_chat/screen.dart';
import 'package:jygf/ui_layer/screens/game/detail/screen.dart';
import 'package:jygf/ui_layer/screens/game/more/screen.dart.dart';
import 'package:jygf/ui_layer/screens/game/nav/screen.dart.dart';
import 'package:jygf/ui_layer/screens/game/screen.dart';
import 'package:jygf/ui_layer/screens/game/tag/screen.dart';
import 'package:jygf/ui_layer/screens/live_video/live_detail/screen.dart';
import 'package:jygf/ui_layer/screens/live_video/live_nav/screen.dart';
import 'package:jygf/ui_layer/screens/mine/ai_record/screen.dart';
import 'package:jygf/ui_layer/screens/mine/bind_email/screen.dart';
import 'package:jygf/ui_layer/screens/mine/vip_center/upgrade/screen.dart';
import 'package:jygf/ui_layer/screens/mine/welfare/widgets/tasks_view.dart';
import 'package:jygf/ui_layer/screens/rank/screen.dart';
import 'package:jygf/ui_layer/screens/vlog/screen.dart';
import 'package:jygf/ui_layer/screens/vlog/vlog_second_page.dart';
import 'package:jygf/ui_layer/screens/vlog/vlog_tag_screen.dart';
import 'package:jygf/ui_layer/screens/yellow_picture/yellow_picture_conten/album_tag_screen.dart';
import 'package:jygf/ui_layer/screens/yellow_picture/yellow_picture_conten/picture_more_content.dart';
import 'package:jygf/ui_layer/screens/yellow_picture/yellow_picture_conten/screen.dart';
import 'package:jygf/ui_layer/screens/yellow_picture/yellow_picture_reader/picture_preview.dart';
import 'package:jygf/ui_layer/screens/yellow_picture/yellow_picture_reader/yellow_picture_reader.dart';
import '../../domain/model/video_detail_model.dart';
import '../screens/community/module/screen.dart';
import '../screens/bit/screen.dart';
import '../screens/bit/detail/screen.dart';
import '../screens/bottom_navi_bar.dart';
import '../screens/community/detail/screen.dart';
import '../screens/community/issue/screen.dart';
import '../screens/community/original_screen/original_screen.dart';
import '../screens/community/community_screen/screen.dart';
import '../screens/community/tag_detail/screen.dart';
import '../screens/home/screen.dart';
import '../screens/local_video/screen.dart';
import '../screens/login/screen.dart';
import '../screens/media_viewer/screen.dart';
import '../screens/mine/agent/profit/screen.dart';
import '../screens/mine/agent/promote_data/screen.dart';
import '../screens/mine/agent/screen.dart';
import '../screens/mine/buy/screen.dart';
import '../screens/mine/coin_recharge/coin_detail/screen.dart';
import '../screens/mine/coin_recharge/screen.dart';
import '../screens/mine/collection/screen.dart';
import '../screens/mine/download/screen.dart';
import '../screens/mine/fill_code/screen.dart';
import '../screens/mine/follow/screen.dart';
import '../screens/mine/help/screen.dart';
import '../screens/mine/income_detail/screen.dart';
import '../screens/mine/message_center/chat_message/screen.dart';
import '../screens/mine/message_center/customer_service/screen.dart';
import '../screens/mine/message_center/customer_service/screen_net.dart';
import '../screens/mine/message_center/screen.dart';
import '../screens/mine/message_center/system_message/screen.dart';
import '../screens/mine/official_group/screen.dart';
import '../screens/mine/original_enter/screen.dart';
import '../screens/mine/posts/screen.dart';
import '../screens/mine/recharge_record/screen.dart';
import '../screens/mine/screen.dart';
import '../screens/mine/setup/screen.dart';
import '../screens/mine/share_to_user/record/screen.dart';
import '../screens/mine/share_to_user/screen.dart';
import '../screens/mine/vip_center/screen.dart';
import '../screens/mine/welfare/screen.dart';
import '../screens/mine/withdrawal/bank_list/screen.dart';
import '../screens/mine/withdrawal/record/screen.dart';
import '../screens/mine/withdrawal/screen.dart';
import '../screens/more_video/screen.dart';
import '../screens/restricted/screen.dart';
import '../screens/search/result/screen.dart';
import '../screens/search/screen.dart';
import '../screens/user_center/screen.dart';
import '../screens/video_detail/screen.dart';
import '../screens/webview/screen.dart';
import '../screens/welcome.dart';
import '../utils/common_utils.dart';
import 'paths.dart';
import 'router.dart';
part 'routes.g.dart';

@TypedGoRoute<WelcomeRoute>(path: AppRouterPaths.root)
class WelcomeRoute extends GoRouteData {
  const WelcomeRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state, child: const WelcomeScreen());
  }
}

@TypedStatefulShellRoute<StatefulShellRoute>(
  branches: [
    TypedStatefulShellBranch(
      routes: [
        TypedGoRoute<HomeRoute>(
          path: AppRouterPaths.home,
        ),
      ],
    ),
    TypedStatefulShellBranch(
      routes: [
        TypedGoRoute<CommunityRoute>(
          path: AppRouterPaths.community,
        ),
      ],
    ),
    TypedStatefulShellBranch(
      routes: [
        // TypedGoRoute<OriginAndGroupChatRoute>(
        TypedGoRoute<ACGRoute>(
          path: AppRouterPaths.acg,
        ),
      ],
    ),
    TypedStatefulShellBranch(
      routes: [
        TypedGoRoute<RestrictedRoute>(
          path: AppRouterPaths.anWang,
        ),
      ],
    ),
    // TypedStatefulShellBranch(
    //   routes: [
    //     TypedGoRoute<LiveBroadcastRoute>(
    //       path: AppRouterPaths.zhiBo,
    //     ),
    //   ],
    // ),
    TypedStatefulShellBranch(
      routes: [
        TypedGoRoute<VlogRoute>(
          path: AppRouterPaths.vlog,
        ),
      ],
    ),
    TypedStatefulShellBranch(
      routes: [
        TypedGoRoute<MineRoute>(
          path: AppRouterPaths.mine,
        ),
      ],
    ),
  ],
)
class StatefulShellRoute extends StatefulShellRouteData {
  const StatefulShellRoute();
  @override
  Widget builder(BuildContext context, GoRouterState state,
      StatefulNavigationShell navigationShell) {
    return BottomNaviBar(navigationShell: navigationShell);
  }
}

class HomeRoute extends GoRouteData {
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const HomeScreen();
}

class RestrictedRoute extends GoRouteData {
  const RestrictedRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const RestrictedScreen();
}

@TypedGoRoute<LiveBroadcastRoute>(path: AppRouterPaths.live)
class LiveBroadcastRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const LiveBroadcastRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state, child: const LiveBroadcastScreen());
  }
}

class VlogRoute extends GoRouteData {
  const VlogRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const VlogScreen();
}

@TypedGoRoute<VlogSecondRoute>(path: AppRouterPaths.vlogSecond)
class VlogSecondRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const VlogSecondRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state, child: const VlogSecondPage());
  }
}

@TypedGoRoute<VlogTagRoute>(path: AppRouterPaths.vlogTag)
class VlogTagRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const VlogTagRoute({
    required this.tag,
  });

  final String tag;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state, child: VlogTagScreen(tag: tag));
  }
}

@TypedGoRoute<GroupChatListContentRoute>(path: AppRouterPaths.soulGroupChatList)
class GroupChatListContentRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const GroupChatListContentRoute(this.$extra);

  final GroupsModel $extra;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state, child: GroupChatListContent(data: $extra));
  }
}

@TypedGoRoute<GroupChatTopMsgContentRoute>(
    path: AppRouterPaths.soulGroupChatTopMsg)
class GroupChatTopMsgContentRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const GroupChatTopMsgContentRoute(this.$extra);

  final GroupsMessageModel $extra;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state, child: GroupChatTopMsgContent(data: $extra));
  }
}

@TypedGoRoute<GroupChatDetailContentRoute>(
    path: AppRouterPaths.soulGroupDetailChatList)
class GroupChatDetailContentRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const GroupChatDetailContentRoute({
    required this.id,
    required this.ms,
  });

  final int id;
  final int ms;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state, child: GroupChatDetailContent(id: id, ms: ms));
  }
}

@TypedGoRoute<GroupMembersContentRoute>(
    path: AppRouterPaths.soulGroupMembersList)
class GroupMembersContentRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const GroupMembersContentRoute({
    required this.id,
  });

  final int id;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state, child: GroupMembersContent(id: id));
  }
}

class OriginAndGroupChatRoute extends GoRouteData {
  const OriginAndGroupChatRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const OriginAndGroupChatScreen();
}

@TypedGoRoute<CartoonRoute>(path: AppRouterPaths.cartoon)
class CartoonRoute extends GoRouteData {
  const CartoonRoute();

  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state, child: const AnimationVideo());
  }
}

@TypedGoRoute<CartoonMoreRoute>(path: AppRouterPaths.cartoonMore)
class CartoonMoreRoute extends GoRouteData {
  const CartoonMoreRoute(this.sort, this.title);

  final String sort;
  final String title;
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state,
        child: CartoonMoreScreen(
          sort: sort,
          title: title,
        ));
  }
}

@TypedGoRoute<CartoonDetailRoute>(path: AppRouterPaths.cartoonDetail)
class CartoonDetailRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const CartoonDetailRoute(this.$extra);

  final String $extra;

  Future<T?> push<T>(BuildContext context) =>
      context.removeDuplicatePush(location, extra: $extra);

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state, child: CartoonDetailScreen(id: $extra));
  }
}

@TypedGoRoute<GameRoute>(path: AppRouterPaths.game)
class GameRoute extends GoRouteData {
  const GameRoute();

  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state, child: const YellowGameScreen());
  }
}

@TypedGoRoute<GameMoreRoute>(path: AppRouterPaths.gameMore)
class GameMoreRoute extends GoRouteData {
  const GameMoreRoute(this.sort, this.title);

  final String sort;
  final String title;
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state,
        child: GameMoreScreen(
          sort: sort,
          title: title,
        ));
  }
}

@TypedGoRoute<GameNavRoute>(path: AppRouterPaths.gameNav)
class GameNavRoute extends GoRouteData {
  const GameNavRoute(this.type, this.title);

  final String type;
  final String title;
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state,
        child: GameNavScreen(
          type: type,
          title: title,
        ));
  }
}

@TypedGoRoute<GameDetailRoute>(path: AppRouterPaths.gameDetail)
class GameDetailRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const GameDetailRoute(this.$extra);

  final String $extra;

  Future<T?> push<T>(BuildContext context) =>
      context.removeDuplicatePush(location, extra: $extra);

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state, child: GameDetailScreen(id: $extra));
  }
}

@TypedGoRoute<GameTagRoute>(path: AppRouterPaths.gameTag)
class GameTagRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const GameTagRoute(this.tag);

  final String tag;

  Future<T?> push<T>(BuildContext context) =>
      context.removeDuplicatePush(location, extra: tag);

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state, child: GameTagScreen(tag: tag));
  }
}

class BitRoute extends GoRouteData {
  const BitRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const BitScreen();
}

class YchRoute extends GoRouteData {
  const YchRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const OriginalCommunityScreen();
}
class ACGRoute extends GoRouteData {
  const ACGRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const ACGScreen();
}

class CommunityRoute extends GoRouteData {
  const CommunityRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const CommunityScreen();
}

class MineRoute extends GoRouteData {
  const MineRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const MineScreen();
}

@TypedGoRoute<WebViewRoute>(path: AppRouterPaths.webView)
class WebViewRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const WebViewRoute(this.url);
  final String url;
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return WebViewScreen(url: url);
  }
}

@TypedGoRoute<BitPostDetailRoute>(path: AppRouterPaths.bitPostDetail)
class BitPostDetailRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const BitPostDetailRoute(this.id);

  final String id;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state, child: BitPostDetailScreen(id: id));
  }
}

@TypedGoRoute<VipCenterRoute>(path: AppRouterPaths.mineVipCenter)
class VipCenterRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  final int pageIndex;
  const VipCenterRoute({this.pageIndex = 0});

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state, child: VipCenterScreen(pageIndex: pageIndex));
  }
}

@TypedGoRoute<VipUpgradeRoute>(path: AppRouterPaths.mineVipUpgrade)
class VipUpgradeRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const VipUpgradeRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state, child: const VipUpgradeScreen());
  }
}

@TypedGoRoute<CoinRechargeRoute>(path: AppRouterPaths.mineCoinRecharge)
class CoinRechargeRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const CoinRechargeRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state, child: const CoinRechargeScreen());
  }
}

@TypedGoRoute<CoinDetailRoute>(path: AppRouterPaths.mineCoinDetail)
class CoinDetailRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const CoinDetailRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state, child: const CoinDetailScreen());
  }
}

@TypedGoRoute<RankRoute>(path: AppRouterPaths.rankList)
class RankRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const RankRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state, child: const RankScreen());
  }
}

@TypedGoRoute<RechargeRecordRoute>(path: AppRouterPaths.mineRechargeRecord)
class RechargeRecordRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const RechargeRecordRoute(this.type);
  final String type;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state, child: RechargeRecordScreen(type: type));
  }
}

@TypedGoRoute<CommunityIssueRoute>(path: AppRouterPaths.communityIssue)
class CommunityIssueRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const CommunityIssueRoute({
    required this.type,
    required this.org,
  });

  final CommunityIssueType type;
  final bool org;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state, child: CommunityIssueScreen(type: type, org: org));
  }
}

@TypedGoRoute<CommunityModuleRoute>(path: AppRouterPaths.communityModule)
class CommunityModuleRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const CommunityModuleRoute({
    required this.id,
    required this.type,
  });
  final int id;
  final String type;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state, child: CommunityModuleScreen(id: id, type: type));
  }
}

@TypedGoRoute<CommunityPostDetailRoute>(
    path: AppRouterPaths.communityTieztDetail)
class CommunityPostDetailRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const CommunityPostDetailRoute(this.id);

  final String id;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state, child: CommunityPostDetailScreen(id: id));
  }
}

@TypedGoRoute<LoginRoute>(path: AppRouterPaths.login)
class LoginRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const LoginRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state, child: const LoginScreen());
  }
}

@TypedGoRoute<MineSetupRoute>(path: AppRouterPaths.mineSetup)
class MineSetupRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const MineSetupRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state, child: const MineSetupScreen());
  }
}

@TypedGoRoute<MineShareToUserRoute>(path: AppRouterPaths.mineShareToUser)
class MineShareToUserRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const MineShareToUserRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state, child: const MineShareToUserScreen());
  }
}

@TypedGoRoute<MineShareToUserRecordRoute>(
    path: AppRouterPaths.mineShareToUserRecord)
class MineShareToUserRecordRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const MineShareToUserRecordRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state, child: const MineShareToUserRecordScreen());
  }
}

@TypedGoRoute<MineAgentRoute>(path: AppRouterPaths.mineAgent)
class MineAgentRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const MineAgentRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state, child: const MineAgentScreen());
  }
}

@TypedGoRoute<MineAgentProfitRoute>(path: AppRouterPaths.mineAgentProfit)
class MineAgentProfitRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const MineAgentProfitRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state, child: const MineAgentProfitScreen());
  }
}

@TypedGoRoute<MineAgentPromoteDataRoute>(
    path: AppRouterPaths.mineAgentPromoteData)
class MineAgentPromoteDataRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const MineAgentPromoteDataRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state, child: const MineAgentPromoteDataScreen());
  }
}

@TypedGoRoute<MineCustomerServiceRoute>(path: AppRouterPaths.customerService)
class MineCustomerServiceRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const MineCustomerServiceRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state, child: const MineCustomerServiceWebScreen()
        // const MineCustomerServiceScreen()
        );
  }
}

@TypedGoRoute<MineWithdrawalRoute>(path: AppRouterPaths.mineWithdrawal)
class MineWithdrawalRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const MineWithdrawalRoute(this.isAgent);

  final bool isAgent;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state, child: MineWithdrawalScreen(isAgent: isAgent));
  }
}

@TypedGoRoute<MineWithdrawalRecordRoute>(
    path: AppRouterPaths.mineWithdrawalRecord)
class MineWithdrawalRecordRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const MineWithdrawalRecordRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state, child: const MineWithdrawalRecordScreen());
  }
}

@TypedGoRoute<MineWithdrawalBankListRoute>(
    path: AppRouterPaths.mineWithdrawalBankList)
class MineWithdrawalBankListRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const MineWithdrawalBankListRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state, child: const MineWithdrawalBankListScreen());
  }
}

@TypedGoRoute<MineWelfareRoute>(path: AppRouterPaths.mineWelfare)
class MineWelfareRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const MineWelfareRoute({this.index = 0});
  final int index;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state, child: MineWelfareScreen(index: index));
  }
}

@TypedGoRoute<AIServerRoute>(path: AppRouterPaths.aiServer)
class AIServerRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const AIServerRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state, child: const AiServerScreen());
  }
}

@TypedGoRoute<AIMagicRoute>(path: AppRouterPaths.aiMagic)
class AIMagicRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const AIMagicRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state, child: const AIMagic());
  }
}

@TypedGoRoute<AIArtRoute>(path: AppRouterPaths.aiArt)
class AIArtRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const AIArtRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state, child: const AIArtScreen());
  }
}

@TypedGoRoute<AiNovelRoute>(path: AppRouterPaths.aiNovel)
class AiNovelRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const AiNovelRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state, child: const AiNovelPage());
  }
}

@TypedGoRoute<AiAudioRoute>(path: AppRouterPaths.aiAudio)
class AiAudioRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const AiAudioRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state, child: const AiVoicePage());
  }
}

@TypedGoRoute<AiNovelDetailRoute>(path: AppRouterPaths.aiNovelDetail)
class AiNovelDetailRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const AiNovelDetailRoute(this.id, this.generateTime);

  final String id;
  final String generateTime;
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state,
        child: AiNovelDetailPage(id: id, generateTime: generateTime));
  }
}

@TypedGoRoute<AIFaceSwapRoute>(path: AppRouterPaths.aiFaceSwap)
class AIFaceSwapRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const AIFaceSwapRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state, child: const AIFaceSwap());
  }
}

@TypedGoRoute<AIVideoFaceSwapRoute>(path: AppRouterPaths.aiVideoFaceSwap)
class AIVideoFaceSwapRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const AIVideoFaceSwapRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state, child: const AiVideoFaceSwap());
  }
}

@TypedGoRoute<AIOffDeRobeRoute>(path: AppRouterPaths.aiOffDeRobe)
class AIOffDeRobeRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const AIOffDeRobeRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state, child: const AIOffDeRobe());
  }
}

@TypedGoRoute<AIKissRoute>(path: AppRouterPaths.aiKiss)
class AIKissRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const AIKissRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state, child: const AIKissPage());
  }
}

@TypedGoRoute<MinePostRoute>(path: AppRouterPaths.minePost)
class MinePostRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const MinePostRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state, child: const MinePostScreen());
  }
}

@TypedGoRoute<MineIncomeDetailRoute>(path: AppRouterPaths.mineIncomeDetail)
class MineIncomeDetailRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const MineIncomeDetailRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state, child: const MineIncomeDetailScreen());
  }
}

@TypedGoRoute<MineCollectionRoute>(path: AppRouterPaths.mineCollection)
class MineCollectionRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const MineCollectionRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state, child: const MineCollectionScreen());
  }
}

@TypedGoRoute<UserCenterRoute>(path: AppRouterPaths.userCenter)
class UserCenterRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const UserCenterRoute(this.aff);

  final String aff;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state, child: UserCenterScreen(aff: aff));
  }
}

@TypedGoRoute<ChatMessageRoute>(path: AppRouterPaths.chatMessage)
class ChatMessageRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const ChatMessageRoute(
      {required this.nickName, required this.toUuid, required this.thumb});

  final String nickName;
  final String toUuid;
  final String thumb;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state,
        child: ChatMessageScreen(
          toUuid: toUuid,
          nickName: nickName,
          thumb: thumb,
        ));
  }
}

@TypedGoRoute<MineFollowingRoute>(path: AppRouterPaths.mineFollowing)
class MineFollowingRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const MineFollowingRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state, child: const MineFollowingScreen());
  }
}

@TypedGoRoute<OriginalEnterRoute>(path: AppRouterPaths.originalEnter)
class OriginalEnterRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const OriginalEnterRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state, child: const OriginalEnterScreen());
  }
}

@TypedGoRoute<CommunityTagDetailRoute>(path: AppRouterPaths.communityTagDetail)
class CommunityTagDetailRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const CommunityTagDetailRoute(this.id);

  final String id;

  Future<T?> push<T>(BuildContext context) =>
      context.removeDuplicatePush(location);

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state, child: CommunityTagDetailScreen(id: id));
  }
}

@TypedGoRoute<MineBuyRoute>(path: AppRouterPaths.mineBuy)
class MineBuyRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const MineBuyRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state, child: const MineBuyScreen());
  }
}

@TypedGoRoute<MineAIRecordRoute>(path: AppRouterPaths.mineAIRecord)
class MineAIRecordRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const MineAIRecordRoute({this.index = 0});

  final int index;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state, child: MineAIRecordScreen(index: index));
  }
}

@TypedGoRoute<VideoDetailRoute>(path: AppRouterPaths.videoDetail)
class VideoDetailRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const VideoDetailRoute(this.$extra);
  final String $extra;

  Future<T?> push<T>(BuildContext context) =>
      context.removeDuplicatePush(location, extra: $extra);

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state, child: VideoDetailScreen(id: $extra));
  }
}

@TypedGoRoute<VoicePalyerContentRoute>(path: AppRouterPaths.voicePlayerContent)
class VoicePalyerContentRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const VoicePalyerContentRoute(this.$extra);

  final VoiceModel $extra;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state, child: VioicPlayerContentView(data: $extra));
  }
}

@TypedGoRoute<LivesDetailRoute>(path: AppRouterPaths.livesDetail)
class LivesDetailRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const LivesDetailRoute(this.$extra);
  final String $extra;

  Future<T?> push<T>(BuildContext context) =>
      context.removeDuplicatePush(location, extra: $extra);

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state, child: LiveVideoDetailScreen(id: $extra));
  }
}

@TypedGoRoute<MineDownloadRoute>(path: AppRouterPaths.mineDownload)
class MineDownloadRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const MineDownloadRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state, child: const MineDownloadScreen());
  }
}

@TypedGoRoute<MineFillCodeRoute>(path: AppRouterPaths.mineFillCode)
class MineFillCodeRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const MineFillCodeRoute(this.title);
  final String title;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state, child: MineFillCodeScreen(title: title));
  }
}

@TypedGoRoute<MineBindEmailRoute>(path: AppRouterPaths.mineBindEmail)
class MineBindEmailRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const MineBindEmailRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state, child: const MineBindEmailScreen());
  }
}

@TypedGoRoute<MineHelpRoute>(path: AppRouterPaths.mineHelp)
class MineHelpRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const MineHelpRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state, child: const MineHelpScreen());
  }
}

@TypedGoRoute<MineOfficialGroupRoute>(path: AppRouterPaths.mineOfficialGroup)
class MineOfficialGroupRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const MineOfficialGroupRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state, child: const MineOfficialGroupScreen());
  }
}

@TypedGoRoute<SearchRoute>(path: AppRouterPaths.search)
class SearchRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const SearchRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state, child: const SearchScreen());
  }
}

@TypedGoRoute<SearchResultRoute>(path: AppRouterPaths.searchResult)
class SearchResultRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const SearchResultRoute(this.title);

  final String title;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state, child: SearchResultScreen(title: title));
  }
}

@TypedGoRoute<MoreVideoRoute>(path: AppRouterPaths.moreVideo)
class MoreVideoRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const MoreVideoRoute({
    required this.name,
    required this.id,
  });

  final String name;
  final String id;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state, child: MoreVideoScreen(name: name, id: id));
  }
}

@TypedGoRoute<MessageCenterRoute>(path: AppRouterPaths.mineMessageCenter)
class MessageCenterRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const MessageCenterRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state, child: const MessageCenterScreen());
  }
}

@TypedGoRoute<SystemMessageRoute>(path: AppRouterPaths.mineSystemMessage)
class SystemMessageRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const SystemMessageRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state, child: const SystemMessageScreen());
  }
}

@TypedGoRoute<MediaViewerRoute>(path: AppRouterPaths.mediaViewer)
class MediaViewerRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const MediaViewerRoute(this.$extra);
  final Map $extra;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state, child: MediaViewerScreen(pramas: $extra));
  }
}

@TypedGoRoute<LocalVideoRoute>(path: AppRouterPaths.localVideo)
class LocalVideoRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const LocalVideoRoute(this.$extra);
  final VideoData $extra;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state, child: LocalVideoScreen(data: $extra));
  }
}

@TypedGoRoute<LocalVoiceRoute>(path: AppRouterPaths.localVoice)
class LocalVoiceRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const LocalVoiceRoute(this.$extra);
  final VoiceModel $extra;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state, child: LocalVoicePlayer(data: $extra));
  }
}

extension _MyPushHelper on BuildContext {
  Future<T?> removeDuplicatePush<T>(String location, {Object? extra}) async {
    final router = GoRouter.of(this);

    final matchList = router.routerDelegate.currentConfiguration.matches;
    final newMatchList = matchList
        .where((element) => element.matchedLocation != location)
        .toList();
    matchList.clear();
    matchList.addAll(newMatchList);

    return push<T>(location, extra: extra);
  }
}

@TypedGoRoute<AIMagicDetailRoute>(path: AppRouterPaths.aiMagicDetail)
class AIMagicDetailRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const AIMagicDetailRoute(this.$extra);

  final AIMagicModel $extra;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state, child: AIMagicDetail(data: $extra));
  }  
}


@TypedGoRoute<MoreComicRoute>(path: AppRouterPaths.moreComic)
class MoreComicRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const MoreComicRoute(this.$extra);

  final RecComicModel $extra;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state, child: ComicMoreContent(data: $extra));
  }
}

@TypedGoRoute<ComicSortRoute>(path: AppRouterPaths.sortComic)
class ComicSortRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const ComicSortRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state, child: const ComicSortContent());
  }
}

@TypedGoRoute<ComicNewRoute>(path: AppRouterPaths.newComic)
class ComicNewRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const ComicNewRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state, child: const ComicNewContent());
  }
}

@TypedGoRoute<ComicEndRoute>(path: AppRouterPaths.endComic)
class ComicEndRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const ComicEndRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state, child: const ComicEndContent());
  }
}

@TypedGoRoute<ComicUpdatingRoute>(path: AppRouterPaths.updatingComic)
class ComicUpdatingRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const ComicUpdatingRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state, child: const ComicUpdatingContent());
  }
}

@TypedGoRoute<ComicRankRoute>(path: AppRouterPaths.rankComic)
class ComicRankRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const ComicRankRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state, child: const ComicRankContent());
  }
}

@TypedGoRoute<ComicDetailRoute>(path: AppRouterPaths.comicDetail)
class ComicDetailRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const ComicDetailRoute(this.$extra);

  final String $extra;

  Future<T?> push<T>(BuildContext context) =>
      context.removeDuplicatePush(location, extra: $extra);

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state, child: ComicDetalScreen(id: $extra));
  }
}

@TypedGoRoute<ComicReaderRoute>(path: AppRouterPaths.comicReader)
class ComicReaderRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const ComicReaderRoute({
    required this.$extra,
    required this.chapterIndex,
  });

  final ComicDetailModel $extra;
  final int chapterIndex;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state,
        child: ComicReaderContent(data: $extra, chapterIndex: chapterIndex));
  }
}

@TypedGoRoute<ComicChaptersRoute>(path: AppRouterPaths.comicChapters)
class ComicChaptersRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const ComicChaptersRoute(this.$extra);

  final ComicDetailModel $extra;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state, child: ComicChaptersContent(data: $extra));
  }
}

@TypedGoRoute<NovelDetailRoute>(path: AppRouterPaths.novelDetail)
class NovelDetailRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const NovelDetailRoute(this.$extra);

  final String $extra;

  Future<T?> push<T>(BuildContext context) =>
      context.removeDuplicatePush(location, extra: $extra);

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state, child: NovelDetalScreen(id: $extra));
  }
}

@TypedGoRoute<NovelChaptersRoute>(path: AppRouterPaths.novelChapters)
class NovelChaptersRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const NovelChaptersRoute(this.$extra);

  final NovelDetailModel $extra;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state, child: NovelChaptersContent(data: $extra));
  }
}

@TypedGoRoute<NovelReaderRoute>(path: AppRouterPaths.novelReader)
class NovelReaderRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const NovelReaderRoute({
    required this.$extra,
    required this.chapterIndex,
  });

  final NovelDetailModel $extra;
  final int chapterIndex;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state,
        child: NovelReaderContent(data: $extra, chapterIndex: chapterIndex));
  }
}

@TypedGoRoute<NovelSortRoute>(path: AppRouterPaths.novelSort)
class NovelSortRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const NovelSortRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state, child: const NovelSortContent());
  }
}

@TypedGoRoute<NovelNewRoute>(path: AppRouterPaths.novelNew)
class NovelNewRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const NovelNewRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state, child: const NovelNewContent());
  }
}

@TypedGoRoute<NovelEndRoute>(path: AppRouterPaths.novelEnd)
class NovelEndRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const NovelEndRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state, child: const NovelEndContent());
  }
}

@TypedGoRoute<NovelUpdatingRoute>(path: AppRouterPaths.noveUpdating)
class NovelUpdatingRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const NovelUpdatingRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state, child: const NovelUpdatingContent());
  }
}

@TypedGoRoute<MoreNovelRoute>(path: AppRouterPaths.moreNovel)
class MoreNovelRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const MoreNovelRoute(this.$extra);

  final RecNovelModel $extra;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state, child: NovelMoreContent(data: $extra));
  }
}

@TypedGoRoute<NovelVoicePalyerContentRoute>(
    path: AppRouterPaths.novelVoicePlayer)
class NovelVoicePalyerContentRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const NovelVoicePalyerContentRoute();

  // final VoiceModel $extra;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state, child: NovelVoicePlayerContent());
  }
}

@TypedGoRoute<ChatDetailRoute>(path: AppRouterPaths.chatDetail)
class ChatDetailRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const ChatDetailRoute(this.id);
  final int id;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ChatDetailScreen(id: id);
  }
}

@TypedGoRoute<ChatIssueRoute>(path: AppRouterPaths.chatIssue)
class ChatIssueRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const ChatIssueRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ChatIssueScreen();
  }
}

@TypedGoRoute<PictureMoreRoute>(path: AppRouterPaths.morePicture)
class PictureMoreRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const PictureMoreRoute(this.$extra);

  final RecAlbumModel $extra;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state, child: PictureMoreContent(data: $extra));
  }
}

@TypedGoRoute<PictureReaderRoute>(path: AppRouterPaths.pictureReader)
class PictureReaderRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const PictureReaderRoute(this.id);

  final String id;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state, child: YellowPictureReader(id: id));
  }
}

@TypedGoRoute<PicturePreViewRoute>(path: AppRouterPaths.picturePreView)
class PicturePreViewRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const PicturePreViewRoute(this.index, this.$extra);

  final List<Map> $extra;
  final int index;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state, child: PicturePreview(index: index, pictures: $extra));
  }
}

@TypedGoRoute<AlbumTagRoute>(path: AppRouterPaths.albumTag)
class AlbumTagRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const AlbumTagRoute({
    required this.tag,
  });

  final String tag;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state, child: AlbumTagScreen(tag: tag));
  }
}

@TypedGoRoute<YelllowPictureRoute>(path: AppRouterPaths.yelllowPicture)
class YelllowPictureRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const YelllowPictureRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state, child:const YellowPictureScreen());
  }
}

@TypedGoRoute<DateRoute>(path: AppRouterPaths.date)
class DateRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const DateRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state, child:const CircleCommunityScreen());
  }
}

@TypedGoRoute<ChatRoute>(path: AppRouterPaths.chat)
class ChatRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const ChatRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(
        state: state, child:const ChatScreen());
  }
}

@TypedGoRoute<TaskRoute>(path: AppRouterPaths.task)
class TaskRoute extends GoRouteData {
  static final GlobalKey<NavigatorState> $parentNavigatorKey =
      AppRouter.rootNavigatorKey;

  const TaskRoute();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CommonUtils.buildSlideTransitionPage(state: state, child:const TaskView());
  }
}