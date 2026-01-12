// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $welcomeRoute,
      $statefulShellRoute,
      $liveBroadcastRoute,
      $vlogSecondRoute,
      $vlogTagRoute,
      $groupChatListContentRoute,
      $groupChatTopMsgContentRoute,
      $groupChatDetailContentRoute,
      $groupMembersContentRoute,
      $cartoonRoute,
      $cartoonMoreRoute,
      $cartoonDetailRoute,
      $gameRoute,
      $blockDetailsRoute,
      $blockTagListRoute,
      $gameMoreRoute,
      $gameNavRoute,
      $gameDetailRoute,
      $gameTagRoute,
      $webViewRoute,
      $bitPostDetailRoute,
      $vipCenterRoute,
      $vipUpgradeRoute,
      $coinRechargeRoute,
      $coinDetailRoute,
      $rankRoute,
      $rechargeRecordRoute,
      $communityIssueRoute,
      $communityModuleRoute,
      $communityPostDetailRoute,
      $loginRoute,
      $mineSetupRoute,
      $mineShareToUserRoute,
      $mineShareToUserRecordRoute,
      $mineAgentRoute,
      $mineAgentProfitRoute,
      $mineAgentPromoteDataRoute,
      $mineCustomerServiceRoute,
      $mineWithdrawalRoute,
      $mineWithdrawalRecordRoute,
      $mineWithdrawalBankListRoute,
      $mineWelfareRoute,
      $aIServerRoute,
      $aIMagicRoute,
      $aIArtRoute,
      $aiNovelRoute,
      $aiAudioRoute,
      $aiNovelDetailRoute,
      $aIFaceSwapRoute,
      $aIVideoFaceSwapRoute,
      $aIOffDeRobeRoute,
      $aIKissRoute,
      $minePostRoute,
      $mineIncomeDetailRoute,
      $mineCollectionRoute,
      $userCenterRoute,
      $chatMessageRoute,
      $mineFollowingRoute,
      $originalEnterRoute,
      $communityTagDetailRoute,
      $mineBuyRoute,
      $mineAIRecordRoute,
      $videoDetailRoute,
      $voicePalyerContentRoute,
      $livesDetailRoute,
      $mineDownloadRoute,
      $mineFillCodeRoute,
      $mineBindEmailRoute,
      $mineHelpRoute,
      $mineOfficialGroupRoute,
      $searchRoute,
      $searchResultRoute,
      $moreVideoRoute,
      $messageCenterRoute,
      $systemMessageRoute,
      $mediaViewerRoute,
      $localVideoRoute,
      $localVoiceRoute,
      $aIMagicDetailRoute,
      $moreComicRoute,
      $comicSortRoute,
      $comicNewRoute,
      $comicEndRoute,
      $comicUpdatingRoute,
      $comicRankRoute,
      $comicDetailRoute,
      $comicReaderRoute,
      $comicChaptersRoute,
      $novelDetailRoute,
      $novelChaptersRoute,
      $novelReaderRoute,
      $novelSortRoute,
      $novelNewRoute,
      $novelEndRoute,
      $novelUpdatingRoute,
      $moreNovelRoute,
      $novelVoicePalyerContentRoute,
      $chatDetailRoute,
      $chatIssueRoute,
      $pictureMoreRoute,
      $pictureReaderRoute,
      $picturePreViewRoute,
      $albumTagRoute,
      $yelllowPictureRoute,
      $dateRoute,
      $chatRoute,
      $taskRoute,
    ];

RouteBase get $welcomeRoute => GoRouteData.$route(
      path: '/',
      factory: $WelcomeRouteExtension._fromState,
    );

extension $WelcomeRouteExtension on WelcomeRoute {
  static WelcomeRoute _fromState(GoRouterState state) => const WelcomeRoute();

  String get location => GoRouteData.$location(
        '/',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $statefulShellRoute => StatefulShellRouteData.$route(
      factory: $StatefulShellRouteExtension._fromState,
      branches: [
        StatefulShellBranchData.$branch(
          routes: [
            GoRouteData.$route(
              path: '/home',
              factory: $HomeRouteExtension._fromState,
            ),
          ],
        ),
        StatefulShellBranchData.$branch(
          routes: [
            GoRouteData.$route(
              path: '/community',
              factory: $CommunityRouteExtension._fromState,
            ),
          ],
        ),
        StatefulShellBranchData.$branch(
          routes: [
            GoRouteData.$route(
              path: '/acg',
              factory: $ACGRouteExtension._fromState,
            ),
          ],
        ),
        StatefulShellBranchData.$branch(
          routes: [
            GoRouteData.$route(
              path: '/anWang',
              factory: $RestrictedRouteExtension._fromState,
            ),
          ],
        ),
        StatefulShellBranchData.$branch(
          routes: [
            GoRouteData.$route(
              path: '/vlog',
              factory: $VlogRouteExtension._fromState,
            ),
          ],
        ),
        StatefulShellBranchData.$branch(
          routes: [
            GoRouteData.$route(
              path: '/mine',
              factory: $MineRouteExtension._fromState,
            ),
          ],
        ),
      ],
    );

extension $StatefulShellRouteExtension on StatefulShellRoute {
  static StatefulShellRoute _fromState(GoRouterState state) =>
      const StatefulShellRoute();
}

extension $HomeRouteExtension on HomeRoute {
  static HomeRoute _fromState(GoRouterState state) => const HomeRoute();

  String get location => GoRouteData.$location(
        '/home',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $CommunityRouteExtension on CommunityRoute {
  static CommunityRoute _fromState(GoRouterState state) =>
      const CommunityRoute();

  String get location => GoRouteData.$location(
        '/community',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $ACGRouteExtension on ACGRoute {
  static ACGRoute _fromState(GoRouterState state) => const ACGRoute();

  String get location => GoRouteData.$location(
        '/acg',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $RestrictedRouteExtension on RestrictedRoute {
  static RestrictedRoute _fromState(GoRouterState state) =>
      const RestrictedRoute();

  String get location => GoRouteData.$location(
        '/anWang',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $VlogRouteExtension on VlogRoute {
  static VlogRoute _fromState(GoRouterState state) => const VlogRoute();

  String get location => GoRouteData.$location(
        '/vlog',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $MineRouteExtension on MineRoute {
  static MineRoute _fromState(GoRouterState state) => const MineRoute();

  String get location => GoRouteData.$location(
        '/mine',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $liveBroadcastRoute => GoRouteData.$route(
      path: '/liveVideo',
      parentNavigatorKey: LiveBroadcastRoute.$parentNavigatorKey,
      factory: $LiveBroadcastRouteExtension._fromState,
    );

extension $LiveBroadcastRouteExtension on LiveBroadcastRoute {
  static LiveBroadcastRoute _fromState(GoRouterState state) =>
      const LiveBroadcastRoute();

  String get location => GoRouteData.$location(
        '/liveVideo',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $vlogSecondRoute => GoRouteData.$route(
      path: '/vlogSecond',
      parentNavigatorKey: VlogSecondRoute.$parentNavigatorKey,
      factory: $VlogSecondRouteExtension._fromState,
    );

extension $VlogSecondRouteExtension on VlogSecondRoute {
  static VlogSecondRoute _fromState(GoRouterState state) =>
      const VlogSecondRoute();

  String get location => GoRouteData.$location(
        '/vlogSecond',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $vlogTagRoute => GoRouteData.$route(
      path: '/vlogTag/:tag',
      parentNavigatorKey: VlogTagRoute.$parentNavigatorKey,
      factory: $VlogTagRouteExtension._fromState,
    );

extension $VlogTagRouteExtension on VlogTagRoute {
  static VlogTagRoute _fromState(GoRouterState state) => VlogTagRoute(
        tag: state.pathParameters['tag']!,
      );

  String get location => GoRouteData.$location(
        '/vlogTag/${Uri.encodeComponent(tag)}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $groupChatListContentRoute => GoRouteData.$route(
      path: '/soulGroupChatList',
      parentNavigatorKey: GroupChatListContentRoute.$parentNavigatorKey,
      factory: $GroupChatListContentRouteExtension._fromState,
    );

extension $GroupChatListContentRouteExtension on GroupChatListContentRoute {
  static GroupChatListContentRoute _fromState(GoRouterState state) =>
      GroupChatListContentRoute(
        state.extra as GroupsModel,
      );

  String get location => GoRouteData.$location(
        '/soulGroupChatList',
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}

RouteBase get $groupChatTopMsgContentRoute => GoRouteData.$route(
      path: '/soulGroupChatTopMsg',
      parentNavigatorKey: GroupChatTopMsgContentRoute.$parentNavigatorKey,
      factory: $GroupChatTopMsgContentRouteExtension._fromState,
    );

extension $GroupChatTopMsgContentRouteExtension on GroupChatTopMsgContentRoute {
  static GroupChatTopMsgContentRoute _fromState(GoRouterState state) =>
      GroupChatTopMsgContentRoute(
        state.extra as GroupsMessageModel,
      );

  String get location => GoRouteData.$location(
        '/soulGroupChatTopMsg',
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}

RouteBase get $groupChatDetailContentRoute => GoRouteData.$route(
      path: '/soulGroupDetailChatList',
      parentNavigatorKey: GroupChatDetailContentRoute.$parentNavigatorKey,
      factory: $GroupChatDetailContentRouteExtension._fromState,
    );

extension $GroupChatDetailContentRouteExtension on GroupChatDetailContentRoute {
  static GroupChatDetailContentRoute _fromState(GoRouterState state) =>
      GroupChatDetailContentRoute(
        id: int.parse(state.uri.queryParameters['id']!),
        ms: int.parse(state.uri.queryParameters['ms']!),
      );

  String get location => GoRouteData.$location(
        '/soulGroupDetailChatList',
        queryParams: {
          'id': id.toString(),
          'ms': ms.toString(),
        },
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $groupMembersContentRoute => GoRouteData.$route(
      path: '/soulGroupMembersList',
      parentNavigatorKey: GroupMembersContentRoute.$parentNavigatorKey,
      factory: $GroupMembersContentRouteExtension._fromState,
    );

extension $GroupMembersContentRouteExtension on GroupMembersContentRoute {
  static GroupMembersContentRoute _fromState(GoRouterState state) =>
      GroupMembersContentRoute(
        id: int.parse(state.uri.queryParameters['id']!),
      );

  String get location => GoRouteData.$location(
        '/soulGroupMembersList',
        queryParams: {
          'id': id.toString(),
        },
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $cartoonRoute => GoRouteData.$route(
      path: '/cartoon',
      parentNavigatorKey: CartoonRoute.$parentNavigatorKey,
      factory: $CartoonRouteExtension._fromState,
    );

extension $CartoonRouteExtension on CartoonRoute {
  static CartoonRoute _fromState(GoRouterState state) => const CartoonRoute();

  String get location => GoRouteData.$location(
        '/cartoon',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $cartoonMoreRoute => GoRouteData.$route(
      path: '/cartoonMore/:sort/:title',
      parentNavigatorKey: CartoonMoreRoute.$parentNavigatorKey,
      factory: $CartoonMoreRouteExtension._fromState,
    );

extension $CartoonMoreRouteExtension on CartoonMoreRoute {
  static CartoonMoreRoute _fromState(GoRouterState state) => CartoonMoreRoute(
        state.pathParameters['sort']!,
        state.pathParameters['title']!,
      );

  String get location => GoRouteData.$location(
        '/cartoonMore/${Uri.encodeComponent(sort)}/${Uri.encodeComponent(title)}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $cartoonDetailRoute => GoRouteData.$route(
      path: '/cartoonDetail',
      parentNavigatorKey: CartoonDetailRoute.$parentNavigatorKey,
      factory: $CartoonDetailRouteExtension._fromState,
    );

extension $CartoonDetailRouteExtension on CartoonDetailRoute {
  static CartoonDetailRoute _fromState(GoRouterState state) =>
      CartoonDetailRoute(
        state.extra as String,
      );

  String get location => GoRouteData.$location(
        '/cartoonDetail',
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}

RouteBase get $gameRoute => GoRouteData.$route(
      path: '/game',
      parentNavigatorKey: GameRoute.$parentNavigatorKey,
      factory: $GameRouteExtension._fromState,
    );

extension $GameRouteExtension on GameRoute {
  static GameRoute _fromState(GoRouterState state) => const GameRoute();

  String get location => GoRouteData.$location(
        '/game',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $blockDetailsRoute => GoRouteData.$route(
      path: '/heiLiaoDetail',
      parentNavigatorKey: BlockDetailsRoute.$parentNavigatorKey,
      factory: $BlockDetailsRouteExtension._fromState,
    );

extension $BlockDetailsRouteExtension on BlockDetailsRoute {
  static BlockDetailsRoute _fromState(GoRouterState state) => BlockDetailsRoute(
        id: int.parse(state.uri.queryParameters['id']!),
      );

  String get location => GoRouteData.$location(
        '/heiLiaoDetail',
        queryParams: {
          'id': id.toString(),
        },
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $blockTagListRoute => GoRouteData.$route(
      path: '/heiLiaoTagList',
      parentNavigatorKey: BlockTagListRoute.$parentNavigatorKey,
      factory: $BlockTagListRouteExtension._fromState,
    );

extension $BlockTagListRouteExtension on BlockTagListRoute {
  static BlockTagListRoute _fromState(GoRouterState state) => BlockTagListRoute(
        tag: state.uri.queryParameters['tag']!,
      );

  String get location => GoRouteData.$location(
        '/heiLiaoTagList',
        queryParams: {
          'tag': tag,
        },
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $gameMoreRoute => GoRouteData.$route(
      path: '/gameMore/:sort/:title',
      parentNavigatorKey: GameMoreRoute.$parentNavigatorKey,
      factory: $GameMoreRouteExtension._fromState,
    );

extension $GameMoreRouteExtension on GameMoreRoute {
  static GameMoreRoute _fromState(GoRouterState state) => GameMoreRoute(
        state.pathParameters['sort']!,
        state.pathParameters['title']!,
      );

  String get location => GoRouteData.$location(
        '/gameMore/${Uri.encodeComponent(sort)}/${Uri.encodeComponent(title)}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $gameNavRoute => GoRouteData.$route(
      path: '/gameNav/:type/:title',
      parentNavigatorKey: GameNavRoute.$parentNavigatorKey,
      factory: $GameNavRouteExtension._fromState,
    );

extension $GameNavRouteExtension on GameNavRoute {
  static GameNavRoute _fromState(GoRouterState state) => GameNavRoute(
        state.pathParameters['type']!,
        state.pathParameters['title']!,
      );

  String get location => GoRouteData.$location(
        '/gameNav/${Uri.encodeComponent(type)}/${Uri.encodeComponent(title)}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $gameDetailRoute => GoRouteData.$route(
      path: '/gameDetail',
      parentNavigatorKey: GameDetailRoute.$parentNavigatorKey,
      factory: $GameDetailRouteExtension._fromState,
    );

extension $GameDetailRouteExtension on GameDetailRoute {
  static GameDetailRoute _fromState(GoRouterState state) => GameDetailRoute(
        state.extra as String,
      );

  String get location => GoRouteData.$location(
        '/gameDetail',
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}

RouteBase get $gameTagRoute => GoRouteData.$route(
      path: '/gameTag/:tag',
      parentNavigatorKey: GameTagRoute.$parentNavigatorKey,
      factory: $GameTagRouteExtension._fromState,
    );

extension $GameTagRouteExtension on GameTagRoute {
  static GameTagRoute _fromState(GoRouterState state) => GameTagRoute(
        state.pathParameters['tag']!,
      );

  String get location => GoRouteData.$location(
        '/gameTag/${Uri.encodeComponent(tag)}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $webViewRoute => GoRouteData.$route(
      path: '/ktloadwebview/:url',
      parentNavigatorKey: WebViewRoute.$parentNavigatorKey,
      factory: $WebViewRouteExtension._fromState,
    );

extension $WebViewRouteExtension on WebViewRoute {
  static WebViewRoute _fromState(GoRouterState state) => WebViewRoute(
        state.pathParameters['url']!,
      );

  String get location => GoRouteData.$location(
        '/ktloadwebview/${Uri.encodeComponent(url)}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $bitPostDetailRoute => GoRouteData.$route(
      path: '/bitPostDetail/:id',
      parentNavigatorKey: BitPostDetailRoute.$parentNavigatorKey,
      factory: $BitPostDetailRouteExtension._fromState,
    );

extension $BitPostDetailRouteExtension on BitPostDetailRoute {
  static BitPostDetailRoute _fromState(GoRouterState state) =>
      BitPostDetailRoute(
        state.pathParameters['id']!,
      );

  String get location => GoRouteData.$location(
        '/bitPostDetail/${Uri.encodeComponent(id)}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $vipCenterRoute => GoRouteData.$route(
      path: '/mineVipCenter',
      parentNavigatorKey: VipCenterRoute.$parentNavigatorKey,
      factory: $VipCenterRouteExtension._fromState,
    );

extension $VipCenterRouteExtension on VipCenterRoute {
  static VipCenterRoute _fromState(GoRouterState state) => VipCenterRoute(
        pageIndex: _$convertMapValue(
                'page-index', state.uri.queryParameters, int.parse) ??
            0,
      );

  String get location => GoRouteData.$location(
        '/mineVipCenter',
        queryParams: {
          if (pageIndex != 0) 'page-index': pageIndex.toString(),
        },
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

T? _$convertMapValue<T>(
  String key,
  Map<String, String> map,
  T Function(String) converter,
) {
  final value = map[key];
  return value == null ? null : converter(value);
}

RouteBase get $vipUpgradeRoute => GoRouteData.$route(
      path: '/mineVipUpgrade',
      parentNavigatorKey: VipUpgradeRoute.$parentNavigatorKey,
      factory: $VipUpgradeRouteExtension._fromState,
    );

extension $VipUpgradeRouteExtension on VipUpgradeRoute {
  static VipUpgradeRoute _fromState(GoRouterState state) =>
      const VipUpgradeRoute();

  String get location => GoRouteData.$location(
        '/mineVipUpgrade',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $coinRechargeRoute => GoRouteData.$route(
      path: '/mineCoinRecharge',
      parentNavigatorKey: CoinRechargeRoute.$parentNavigatorKey,
      factory: $CoinRechargeRouteExtension._fromState,
    );

extension $CoinRechargeRouteExtension on CoinRechargeRoute {
  static CoinRechargeRoute _fromState(GoRouterState state) =>
      const CoinRechargeRoute();

  String get location => GoRouteData.$location(
        '/mineCoinRecharge',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $coinDetailRoute => GoRouteData.$route(
      path: '/mineCoinDetail',
      parentNavigatorKey: CoinDetailRoute.$parentNavigatorKey,
      factory: $CoinDetailRouteExtension._fromState,
    );

extension $CoinDetailRouteExtension on CoinDetailRoute {
  static CoinDetailRoute _fromState(GoRouterState state) =>
      const CoinDetailRoute();

  String get location => GoRouteData.$location(
        '/mineCoinDetail',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $rankRoute => GoRouteData.$route(
      path: '/rankList',
      parentNavigatorKey: RankRoute.$parentNavigatorKey,
      factory: $RankRouteExtension._fromState,
    );

extension $RankRouteExtension on RankRoute {
  static RankRoute _fromState(GoRouterState state) => const RankRoute();

  String get location => GoRouteData.$location(
        '/rankList',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $rechargeRecordRoute => GoRouteData.$route(
      path: '/mineRechargeRecord/:type',
      parentNavigatorKey: RechargeRecordRoute.$parentNavigatorKey,
      factory: $RechargeRecordRouteExtension._fromState,
    );

extension $RechargeRecordRouteExtension on RechargeRecordRoute {
  static RechargeRecordRoute _fromState(GoRouterState state) =>
      RechargeRecordRoute(
        state.pathParameters['type']!,
      );

  String get location => GoRouteData.$location(
        '/mineRechargeRecord/${Uri.encodeComponent(type)}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $communityIssueRoute => GoRouteData.$route(
      path: '/communityIssue/:type/:topicType',
      parentNavigatorKey: CommunityIssueRoute.$parentNavigatorKey,
      factory: $CommunityIssueRouteExtension._fromState,
    );

extension $CommunityIssueRouteExtension on CommunityIssueRoute {
  static CommunityIssueRoute _fromState(GoRouterState state) =>
      CommunityIssueRoute(
        type: _$CommunityIssueTypeEnumMap
            ._$fromName(state.pathParameters['type']!),
        topicType: _$CommunityIssueTopicTypeEnumMap
            ._$fromName(state.pathParameters['topicType']!),
      );

  String get location => GoRouteData.$location(
        '/communityIssue/${Uri.encodeComponent(_$CommunityIssueTypeEnumMap[type]!)}/${Uri.encodeComponent(_$CommunityIssueTopicTypeEnumMap[topicType]!)}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

const _$CommunityIssueTypeEnumMap = {
  CommunityIssueType.image: 'image',
  CommunityIssueType.video: 'video',
  CommunityIssueType.imageAndText: 'image-and-text',
};

const _$CommunityIssueTopicTypeEnumMap = {
  CommunityIssueTopicType.community: 'community',
  CommunityIssueTopicType.date: 'date',
  CommunityIssueTopicType.original: 'original',
};

extension<T extends Enum> on Map<T, String> {
  T _$fromName(String value) =>
      entries.singleWhere((element) => element.value == value).key;
}

RouteBase get $communityModuleRoute => GoRouteData.$route(
      path: '/communityModule',
      parentNavigatorKey: CommunityModuleRoute.$parentNavigatorKey,
      factory: $CommunityModuleRouteExtension._fromState,
    );

extension $CommunityModuleRouteExtension on CommunityModuleRoute {
  static CommunityModuleRoute _fromState(GoRouterState state) =>
      CommunityModuleRoute(
        id: int.parse(state.uri.queryParameters['id']!),
        topicType: int.parse(state.uri.queryParameters['topic-type']!),
      );

  String get location => GoRouteData.$location(
        '/communityModule',
        queryParams: {
          'id': id.toString(),
          'topic-type': topicType.toString(),
        },
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $communityPostDetailRoute => GoRouteData.$route(
      path: '/communityTieztDetail/:id',
      parentNavigatorKey: CommunityPostDetailRoute.$parentNavigatorKey,
      factory: $CommunityPostDetailRouteExtension._fromState,
    );

extension $CommunityPostDetailRouteExtension on CommunityPostDetailRoute {
  static CommunityPostDetailRoute _fromState(GoRouterState state) =>
      CommunityPostDetailRoute(
        state.pathParameters['id']!,
      );

  String get location => GoRouteData.$location(
        '/communityTieztDetail/${Uri.encodeComponent(id)}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $loginRoute => GoRouteData.$route(
      path: '/login',
      parentNavigatorKey: LoginRoute.$parentNavigatorKey,
      factory: $LoginRouteExtension._fromState,
    );

extension $LoginRouteExtension on LoginRoute {
  static LoginRoute _fromState(GoRouterState state) => const LoginRoute();

  String get location => GoRouteData.$location(
        '/login',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $mineSetupRoute => GoRouteData.$route(
      path: '/mineSetup',
      parentNavigatorKey: MineSetupRoute.$parentNavigatorKey,
      factory: $MineSetupRouteExtension._fromState,
    );

extension $MineSetupRouteExtension on MineSetupRoute {
  static MineSetupRoute _fromState(GoRouterState state) =>
      const MineSetupRoute();

  String get location => GoRouteData.$location(
        '/mineSetup',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $mineShareToUserRoute => GoRouteData.$route(
      path: '/mineShareToUser',
      parentNavigatorKey: MineShareToUserRoute.$parentNavigatorKey,
      factory: $MineShareToUserRouteExtension._fromState,
    );

extension $MineShareToUserRouteExtension on MineShareToUserRoute {
  static MineShareToUserRoute _fromState(GoRouterState state) =>
      const MineShareToUserRoute();

  String get location => GoRouteData.$location(
        '/mineShareToUser',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $mineShareToUserRecordRoute => GoRouteData.$route(
      path: '/mineShareToUserRecord',
      parentNavigatorKey: MineShareToUserRecordRoute.$parentNavigatorKey,
      factory: $MineShareToUserRecordRouteExtension._fromState,
    );

extension $MineShareToUserRecordRouteExtension on MineShareToUserRecordRoute {
  static MineShareToUserRecordRoute _fromState(GoRouterState state) =>
      const MineShareToUserRecordRoute();

  String get location => GoRouteData.$location(
        '/mineShareToUserRecord',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $mineAgentRoute => GoRouteData.$route(
      path: '/mineAgent',
      parentNavigatorKey: MineAgentRoute.$parentNavigatorKey,
      factory: $MineAgentRouteExtension._fromState,
    );

extension $MineAgentRouteExtension on MineAgentRoute {
  static MineAgentRoute _fromState(GoRouterState state) =>
      const MineAgentRoute();

  String get location => GoRouteData.$location(
        '/mineAgent',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $mineAgentProfitRoute => GoRouteData.$route(
      path: '/mineAgentProfit',
      parentNavigatorKey: MineAgentProfitRoute.$parentNavigatorKey,
      factory: $MineAgentProfitRouteExtension._fromState,
    );

extension $MineAgentProfitRouteExtension on MineAgentProfitRoute {
  static MineAgentProfitRoute _fromState(GoRouterState state) =>
      const MineAgentProfitRoute();

  String get location => GoRouteData.$location(
        '/mineAgentProfit',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $mineAgentPromoteDataRoute => GoRouteData.$route(
      path: '/mineAgentPromoteData',
      parentNavigatorKey: MineAgentPromoteDataRoute.$parentNavigatorKey,
      factory: $MineAgentPromoteDataRouteExtension._fromState,
    );

extension $MineAgentPromoteDataRouteExtension on MineAgentPromoteDataRoute {
  static MineAgentPromoteDataRoute _fromState(GoRouterState state) =>
      const MineAgentPromoteDataRoute();

  String get location => GoRouteData.$location(
        '/mineAgentPromoteData',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $mineCustomerServiceRoute => GoRouteData.$route(
      path: '/customerService',
      parentNavigatorKey: MineCustomerServiceRoute.$parentNavigatorKey,
      factory: $MineCustomerServiceRouteExtension._fromState,
    );

extension $MineCustomerServiceRouteExtension on MineCustomerServiceRoute {
  static MineCustomerServiceRoute _fromState(GoRouterState state) =>
      const MineCustomerServiceRoute();

  String get location => GoRouteData.$location(
        '/customerService',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $mineWithdrawalRoute => GoRouteData.$route(
      path: '/mineWithdrawal/:isAgent',
      parentNavigatorKey: MineWithdrawalRoute.$parentNavigatorKey,
      factory: $MineWithdrawalRouteExtension._fromState,
    );

extension $MineWithdrawalRouteExtension on MineWithdrawalRoute {
  static MineWithdrawalRoute _fromState(GoRouterState state) =>
      MineWithdrawalRoute(
        _$boolConverter(state.pathParameters['isAgent']!),
      );

  String get location => GoRouteData.$location(
        '/mineWithdrawal/${Uri.encodeComponent(isAgent.toString())}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

bool _$boolConverter(String value) {
  switch (value) {
    case 'true':
      return true;
    case 'false':
      return false;
    default:
      throw UnsupportedError('Cannot convert "$value" into a bool.');
  }
}

RouteBase get $mineWithdrawalRecordRoute => GoRouteData.$route(
      path: '/mineWithdrawalRecord',
      parentNavigatorKey: MineWithdrawalRecordRoute.$parentNavigatorKey,
      factory: $MineWithdrawalRecordRouteExtension._fromState,
    );

extension $MineWithdrawalRecordRouteExtension on MineWithdrawalRecordRoute {
  static MineWithdrawalRecordRoute _fromState(GoRouterState state) =>
      const MineWithdrawalRecordRoute();

  String get location => GoRouteData.$location(
        '/mineWithdrawalRecord',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $mineWithdrawalBankListRoute => GoRouteData.$route(
      path: '/mineWithdrawalBankList',
      parentNavigatorKey: MineWithdrawalBankListRoute.$parentNavigatorKey,
      factory: $MineWithdrawalBankListRouteExtension._fromState,
    );

extension $MineWithdrawalBankListRouteExtension on MineWithdrawalBankListRoute {
  static MineWithdrawalBankListRoute _fromState(GoRouterState state) =>
      const MineWithdrawalBankListRoute();

  String get location => GoRouteData.$location(
        '/mineWithdrawalBankList',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $mineWelfareRoute => GoRouteData.$route(
      path: '/mineWelfare/:index',
      parentNavigatorKey: MineWelfareRoute.$parentNavigatorKey,
      factory: $MineWelfareRouteExtension._fromState,
    );

extension $MineWelfareRouteExtension on MineWelfareRoute {
  static MineWelfareRoute _fromState(GoRouterState state) => MineWelfareRoute(
        index: int.parse(state.pathParameters['index']!) ?? 0,
      );

  String get location => GoRouteData.$location(
        '/mineWelfare/${Uri.encodeComponent(index.toString())}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $aIServerRoute => GoRouteData.$route(
      path: '/aiServer',
      parentNavigatorKey: AIServerRoute.$parentNavigatorKey,
      factory: $AIServerRouteExtension._fromState,
    );

extension $AIServerRouteExtension on AIServerRoute {
  static AIServerRoute _fromState(GoRouterState state) => const AIServerRoute();

  String get location => GoRouteData.$location(
        '/aiServer',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $aIMagicRoute => GoRouteData.$route(
      path: '/aiMagic',
      parentNavigatorKey: AIMagicRoute.$parentNavigatorKey,
      factory: $AIMagicRouteExtension._fromState,
    );

extension $AIMagicRouteExtension on AIMagicRoute {
  static AIMagicRoute _fromState(GoRouterState state) => const AIMagicRoute();

  String get location => GoRouteData.$location(
        '/aiMagic',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $aIArtRoute => GoRouteData.$route(
      path: '/aiArt',
      parentNavigatorKey: AIArtRoute.$parentNavigatorKey,
      factory: $AIArtRouteExtension._fromState,
    );

extension $AIArtRouteExtension on AIArtRoute {
  static AIArtRoute _fromState(GoRouterState state) => const AIArtRoute();

  String get location => GoRouteData.$location(
        '/aiArt',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $aiNovelRoute => GoRouteData.$route(
      path: '/aiNovel',
      parentNavigatorKey: AiNovelRoute.$parentNavigatorKey,
      factory: $AiNovelRouteExtension._fromState,
    );

extension $AiNovelRouteExtension on AiNovelRoute {
  static AiNovelRoute _fromState(GoRouterState state) => const AiNovelRoute();

  String get location => GoRouteData.$location(
        '/aiNovel',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $aiAudioRoute => GoRouteData.$route(
      path: '/aiAudio',
      parentNavigatorKey: AiAudioRoute.$parentNavigatorKey,
      factory: $AiAudioRouteExtension._fromState,
    );

extension $AiAudioRouteExtension on AiAudioRoute {
  static AiAudioRoute _fromState(GoRouterState state) => const AiAudioRoute();

  String get location => GoRouteData.$location(
        '/aiAudio',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $aiNovelDetailRoute => GoRouteData.$route(
      path: '/aiNovelDetail',
      parentNavigatorKey: AiNovelDetailRoute.$parentNavigatorKey,
      factory: $AiNovelDetailRouteExtension._fromState,
    );

extension $AiNovelDetailRouteExtension on AiNovelDetailRoute {
  static AiNovelDetailRoute _fromState(GoRouterState state) =>
      AiNovelDetailRoute(
        state.uri.queryParameters['id']!,
        state.uri.queryParameters['generate-time']!,
      );

  String get location => GoRouteData.$location(
        '/aiNovelDetail',
        queryParams: {
          'id': id,
          'generate-time': generateTime,
        },
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $aIFaceSwapRoute => GoRouteData.$route(
      path: '/aiFaceSwap',
      parentNavigatorKey: AIFaceSwapRoute.$parentNavigatorKey,
      factory: $AIFaceSwapRouteExtension._fromState,
    );

extension $AIFaceSwapRouteExtension on AIFaceSwapRoute {
  static AIFaceSwapRoute _fromState(GoRouterState state) =>
      const AIFaceSwapRoute();

  String get location => GoRouteData.$location(
        '/aiFaceSwap',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $aIVideoFaceSwapRoute => GoRouteData.$route(
      path: '/aiVideoFaceSwap',
      parentNavigatorKey: AIVideoFaceSwapRoute.$parentNavigatorKey,
      factory: $AIVideoFaceSwapRouteExtension._fromState,
    );

extension $AIVideoFaceSwapRouteExtension on AIVideoFaceSwapRoute {
  static AIVideoFaceSwapRoute _fromState(GoRouterState state) =>
      const AIVideoFaceSwapRoute();

  String get location => GoRouteData.$location(
        '/aiVideoFaceSwap',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $aIOffDeRobeRoute => GoRouteData.$route(
      path: '/aiOffDeRobe',
      parentNavigatorKey: AIOffDeRobeRoute.$parentNavigatorKey,
      factory: $AIOffDeRobeRouteExtension._fromState,
    );

extension $AIOffDeRobeRouteExtension on AIOffDeRobeRoute {
  static AIOffDeRobeRoute _fromState(GoRouterState state) =>
      const AIOffDeRobeRoute();

  String get location => GoRouteData.$location(
        '/aiOffDeRobe',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $aIKissRoute => GoRouteData.$route(
      path: '/aiKiss',
      parentNavigatorKey: AIKissRoute.$parentNavigatorKey,
      factory: $AIKissRouteExtension._fromState,
    );

extension $AIKissRouteExtension on AIKissRoute {
  static AIKissRoute _fromState(GoRouterState state) => const AIKissRoute();

  String get location => GoRouteData.$location(
        '/aiKiss',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $minePostRoute => GoRouteData.$route(
      path: '/minePost',
      parentNavigatorKey: MinePostRoute.$parentNavigatorKey,
      factory: $MinePostRouteExtension._fromState,
    );

extension $MinePostRouteExtension on MinePostRoute {
  static MinePostRoute _fromState(GoRouterState state) => const MinePostRoute();

  String get location => GoRouteData.$location(
        '/minePost',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $mineIncomeDetailRoute => GoRouteData.$route(
      path: '/mineIncomeDetail',
      parentNavigatorKey: MineIncomeDetailRoute.$parentNavigatorKey,
      factory: $MineIncomeDetailRouteExtension._fromState,
    );

extension $MineIncomeDetailRouteExtension on MineIncomeDetailRoute {
  static MineIncomeDetailRoute _fromState(GoRouterState state) =>
      const MineIncomeDetailRoute();

  String get location => GoRouteData.$location(
        '/mineIncomeDetail',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $mineCollectionRoute => GoRouteData.$route(
      path: '/mineCollection',
      parentNavigatorKey: MineCollectionRoute.$parentNavigatorKey,
      factory: $MineCollectionRouteExtension._fromState,
    );

extension $MineCollectionRouteExtension on MineCollectionRoute {
  static MineCollectionRoute _fromState(GoRouterState state) =>
      const MineCollectionRoute();

  String get location => GoRouteData.$location(
        '/mineCollection',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $userCenterRoute => GoRouteData.$route(
      path: '/userCenter/:aff',
      parentNavigatorKey: UserCenterRoute.$parentNavigatorKey,
      factory: $UserCenterRouteExtension._fromState,
    );

extension $UserCenterRouteExtension on UserCenterRoute {
  static UserCenterRoute _fromState(GoRouterState state) => UserCenterRoute(
        state.pathParameters['aff']!,
      );

  String get location => GoRouteData.$location(
        '/userCenter/${Uri.encodeComponent(aff)}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $chatMessageRoute => GoRouteData.$route(
      path: '/chatMessage/:toUuid/:nickName/:thumb',
      parentNavigatorKey: ChatMessageRoute.$parentNavigatorKey,
      factory: $ChatMessageRouteExtension._fromState,
    );

extension $ChatMessageRouteExtension on ChatMessageRoute {
  static ChatMessageRoute _fromState(GoRouterState state) => ChatMessageRoute(
        nickName: state.pathParameters['nickName']!,
        toUuid: state.pathParameters['toUuid']!,
        thumb: state.pathParameters['thumb']!,
      );

  String get location => GoRouteData.$location(
        '/chatMessage/${Uri.encodeComponent(toUuid)}/${Uri.encodeComponent(nickName)}/${Uri.encodeComponent(thumb)}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $mineFollowingRoute => GoRouteData.$route(
      path: '/mineFollowing',
      parentNavigatorKey: MineFollowingRoute.$parentNavigatorKey,
      factory: $MineFollowingRouteExtension._fromState,
    );

extension $MineFollowingRouteExtension on MineFollowingRoute {
  static MineFollowingRoute _fromState(GoRouterState state) =>
      const MineFollowingRoute();

  String get location => GoRouteData.$location(
        '/mineFollowing',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $originalEnterRoute => GoRouteData.$route(
      path: '/originalEnter',
      parentNavigatorKey: OriginalEnterRoute.$parentNavigatorKey,
      factory: $OriginalEnterRouteExtension._fromState,
    );

extension $OriginalEnterRouteExtension on OriginalEnterRoute {
  static OriginalEnterRoute _fromState(GoRouterState state) =>
      const OriginalEnterRoute();

  String get location => GoRouteData.$location(
        '/originalEnter',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $communityTagDetailRoute => GoRouteData.$route(
      path: '/communityTagDetail/:id',
      parentNavigatorKey: CommunityTagDetailRoute.$parentNavigatorKey,
      factory: $CommunityTagDetailRouteExtension._fromState,
    );

extension $CommunityTagDetailRouteExtension on CommunityTagDetailRoute {
  static CommunityTagDetailRoute _fromState(GoRouterState state) =>
      CommunityTagDetailRoute(
        state.pathParameters['id']!,
      );

  String get location => GoRouteData.$location(
        '/communityTagDetail/${Uri.encodeComponent(id)}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $mineBuyRoute => GoRouteData.$route(
      path: '/mineBuy',
      parentNavigatorKey: MineBuyRoute.$parentNavigatorKey,
      factory: $MineBuyRouteExtension._fromState,
    );

extension $MineBuyRouteExtension on MineBuyRoute {
  static MineBuyRoute _fromState(GoRouterState state) => const MineBuyRoute();

  String get location => GoRouteData.$location(
        '/mineBuy',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $mineAIRecordRoute => GoRouteData.$route(
      path: '/minAIRecord',
      parentNavigatorKey: MineAIRecordRoute.$parentNavigatorKey,
      factory: $MineAIRecordRouteExtension._fromState,
    );

extension $MineAIRecordRouteExtension on MineAIRecordRoute {
  static MineAIRecordRoute _fromState(GoRouterState state) => MineAIRecordRoute(
        index:
            _$convertMapValue('index', state.uri.queryParameters, int.parse) ??
                0,
      );

  String get location => GoRouteData.$location(
        '/minAIRecord',
        queryParams: {
          if (index != 0) 'index': index.toString(),
        },
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $videoDetailRoute => GoRouteData.$route(
      path: '/videoDetail',
      parentNavigatorKey: VideoDetailRoute.$parentNavigatorKey,
      factory: $VideoDetailRouteExtension._fromState,
    );

extension $VideoDetailRouteExtension on VideoDetailRoute {
  static VideoDetailRoute _fromState(GoRouterState state) => VideoDetailRoute(
        state.extra as String,
      );

  String get location => GoRouteData.$location(
        '/videoDetail',
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}

RouteBase get $voicePalyerContentRoute => GoRouteData.$route(
      path: '/voicePlayerContent',
      parentNavigatorKey: VoicePalyerContentRoute.$parentNavigatorKey,
      factory: $VoicePalyerContentRouteExtension._fromState,
    );

extension $VoicePalyerContentRouteExtension on VoicePalyerContentRoute {
  static VoicePalyerContentRoute _fromState(GoRouterState state) =>
      VoicePalyerContentRoute(
        state.extra as VoiceModel,
      );

  String get location => GoRouteData.$location(
        '/voicePlayerContent',
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}

RouteBase get $livesDetailRoute => GoRouteData.$route(
      path: '/livesDetail',
      parentNavigatorKey: LivesDetailRoute.$parentNavigatorKey,
      factory: $LivesDetailRouteExtension._fromState,
    );

extension $LivesDetailRouteExtension on LivesDetailRoute {
  static LivesDetailRoute _fromState(GoRouterState state) => LivesDetailRoute(
        state.extra as String,
      );

  String get location => GoRouteData.$location(
        '/livesDetail',
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}

RouteBase get $mineDownloadRoute => GoRouteData.$route(
      path: '/mineDownload',
      parentNavigatorKey: MineDownloadRoute.$parentNavigatorKey,
      factory: $MineDownloadRouteExtension._fromState,
    );

extension $MineDownloadRouteExtension on MineDownloadRoute {
  static MineDownloadRoute _fromState(GoRouterState state) =>
      const MineDownloadRoute();

  String get location => GoRouteData.$location(
        '/mineDownload',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $mineFillCodeRoute => GoRouteData.$route(
      path: '/mineFillCode/:title',
      parentNavigatorKey: MineFillCodeRoute.$parentNavigatorKey,
      factory: $MineFillCodeRouteExtension._fromState,
    );

extension $MineFillCodeRouteExtension on MineFillCodeRoute {
  static MineFillCodeRoute _fromState(GoRouterState state) => MineFillCodeRoute(
        state.pathParameters['title']!,
      );

  String get location => GoRouteData.$location(
        '/mineFillCode/${Uri.encodeComponent(title)}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $mineBindEmailRoute => GoRouteData.$route(
      path: '/mine_bind_email',
      parentNavigatorKey: MineBindEmailRoute.$parentNavigatorKey,
      factory: $MineBindEmailRouteExtension._fromState,
    );

extension $MineBindEmailRouteExtension on MineBindEmailRoute {
  static MineBindEmailRoute _fromState(GoRouterState state) =>
      const MineBindEmailRoute();

  String get location => GoRouteData.$location(
        '/mine_bind_email',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $mineHelpRoute => GoRouteData.$route(
      path: '/mineHelp',
      parentNavigatorKey: MineHelpRoute.$parentNavigatorKey,
      factory: $MineHelpRouteExtension._fromState,
    );

extension $MineHelpRouteExtension on MineHelpRoute {
  static MineHelpRoute _fromState(GoRouterState state) => const MineHelpRoute();

  String get location => GoRouteData.$location(
        '/mineHelp',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $mineOfficialGroupRoute => GoRouteData.$route(
      path: '/mineOfficialGroup',
      parentNavigatorKey: MineOfficialGroupRoute.$parentNavigatorKey,
      factory: $MineOfficialGroupRouteExtension._fromState,
    );

extension $MineOfficialGroupRouteExtension on MineOfficialGroupRoute {
  static MineOfficialGroupRoute _fromState(GoRouterState state) =>
      const MineOfficialGroupRoute();

  String get location => GoRouteData.$location(
        '/mineOfficialGroup',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $searchRoute => GoRouteData.$route(
      path: '/search',
      parentNavigatorKey: SearchRoute.$parentNavigatorKey,
      factory: $SearchRouteExtension._fromState,
    );

extension $SearchRouteExtension on SearchRoute {
  static SearchRoute _fromState(GoRouterState state) => const SearchRoute();

  String get location => GoRouteData.$location(
        '/search',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $searchResultRoute => GoRouteData.$route(
      path: '/searchResult/:title',
      parentNavigatorKey: SearchResultRoute.$parentNavigatorKey,
      factory: $SearchResultRouteExtension._fromState,
    );

extension $SearchResultRouteExtension on SearchResultRoute {
  static SearchResultRoute _fromState(GoRouterState state) => SearchResultRoute(
        state.pathParameters['title']!,
      );

  String get location => GoRouteData.$location(
        '/searchResult/${Uri.encodeComponent(title)}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $moreVideoRoute => GoRouteData.$route(
      path: '/moreVideo/:name/:id',
      parentNavigatorKey: MoreVideoRoute.$parentNavigatorKey,
      factory: $MoreVideoRouteExtension._fromState,
    );

extension $MoreVideoRouteExtension on MoreVideoRoute {
  static MoreVideoRoute _fromState(GoRouterState state) => MoreVideoRoute(
        name: state.pathParameters['name']!,
        id: state.pathParameters['id']!,
      );

  String get location => GoRouteData.$location(
        '/moreVideo/${Uri.encodeComponent(name)}/${Uri.encodeComponent(id)}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $messageCenterRoute => GoRouteData.$route(
      path: '/mineMessageCenter',
      parentNavigatorKey: MessageCenterRoute.$parentNavigatorKey,
      factory: $MessageCenterRouteExtension._fromState,
    );

extension $MessageCenterRouteExtension on MessageCenterRoute {
  static MessageCenterRoute _fromState(GoRouterState state) =>
      const MessageCenterRoute();

  String get location => GoRouteData.$location(
        '/mineMessageCenter',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $systemMessageRoute => GoRouteData.$route(
      path: '/mineSystemMessage',
      parentNavigatorKey: SystemMessageRoute.$parentNavigatorKey,
      factory: $SystemMessageRouteExtension._fromState,
    );

extension $SystemMessageRouteExtension on SystemMessageRoute {
  static SystemMessageRoute _fromState(GoRouterState state) =>
      const SystemMessageRoute();

  String get location => GoRouteData.$location(
        '/mineSystemMessage',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $mediaViewerRoute => GoRouteData.$route(
      path: '/mediaViewer',
      parentNavigatorKey: MediaViewerRoute.$parentNavigatorKey,
      factory: $MediaViewerRouteExtension._fromState,
    );

extension $MediaViewerRouteExtension on MediaViewerRoute {
  static MediaViewerRoute _fromState(GoRouterState state) => MediaViewerRoute(
        state.extra as Map<dynamic, dynamic>,
      );

  String get location => GoRouteData.$location(
        '/mediaViewer',
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}

RouteBase get $localVideoRoute => GoRouteData.$route(
      path: '/localVideo',
      parentNavigatorKey: LocalVideoRoute.$parentNavigatorKey,
      factory: $LocalVideoRouteExtension._fromState,
    );

extension $LocalVideoRouteExtension on LocalVideoRoute {
  static LocalVideoRoute _fromState(GoRouterState state) => LocalVideoRoute(
        state.extra as VideoData,
      );

  String get location => GoRouteData.$location(
        '/localVideo',
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}

RouteBase get $localVoiceRoute => GoRouteData.$route(
      path: '/localVoice',
      parentNavigatorKey: LocalVoiceRoute.$parentNavigatorKey,
      factory: $LocalVoiceRouteExtension._fromState,
    );

extension $LocalVoiceRouteExtension on LocalVoiceRoute {
  static LocalVoiceRoute _fromState(GoRouterState state) => LocalVoiceRoute(
        state.extra as VoiceModel,
      );

  String get location => GoRouteData.$location(
        '/localVoice',
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}

RouteBase get $aIMagicDetailRoute => GoRouteData.$route(
      path: '/aiMagicDetail',
      parentNavigatorKey: AIMagicDetailRoute.$parentNavigatorKey,
      factory: $AIMagicDetailRouteExtension._fromState,
    );

extension $AIMagicDetailRouteExtension on AIMagicDetailRoute {
  static AIMagicDetailRoute _fromState(GoRouterState state) =>
      AIMagicDetailRoute(
        state.extra as AIMagicModel,
      );

  String get location => GoRouteData.$location(
        '/aiMagicDetail',
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}

RouteBase get $moreComicRoute => GoRouteData.$route(
      path: '/moreComic',
      parentNavigatorKey: MoreComicRoute.$parentNavigatorKey,
      factory: $MoreComicRouteExtension._fromState,
    );

extension $MoreComicRouteExtension on MoreComicRoute {
  static MoreComicRoute _fromState(GoRouterState state) => MoreComicRoute(
        state.extra as RecComicModel,
      );

  String get location => GoRouteData.$location(
        '/moreComic',
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}

RouteBase get $comicSortRoute => GoRouteData.$route(
      path: '/sortComic',
      parentNavigatorKey: ComicSortRoute.$parentNavigatorKey,
      factory: $ComicSortRouteExtension._fromState,
    );

extension $ComicSortRouteExtension on ComicSortRoute {
  static ComicSortRoute _fromState(GoRouterState state) =>
      const ComicSortRoute();

  String get location => GoRouteData.$location(
        '/sortComic',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $comicNewRoute => GoRouteData.$route(
      path: '/newComic',
      parentNavigatorKey: ComicNewRoute.$parentNavigatorKey,
      factory: $ComicNewRouteExtension._fromState,
    );

extension $ComicNewRouteExtension on ComicNewRoute {
  static ComicNewRoute _fromState(GoRouterState state) => const ComicNewRoute();

  String get location => GoRouteData.$location(
        '/newComic',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $comicEndRoute => GoRouteData.$route(
      path: '/endComic',
      parentNavigatorKey: ComicEndRoute.$parentNavigatorKey,
      factory: $ComicEndRouteExtension._fromState,
    );

extension $ComicEndRouteExtension on ComicEndRoute {
  static ComicEndRoute _fromState(GoRouterState state) => const ComicEndRoute();

  String get location => GoRouteData.$location(
        '/endComic',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $comicUpdatingRoute => GoRouteData.$route(
      path: '/updatingComic',
      parentNavigatorKey: ComicUpdatingRoute.$parentNavigatorKey,
      factory: $ComicUpdatingRouteExtension._fromState,
    );

extension $ComicUpdatingRouteExtension on ComicUpdatingRoute {
  static ComicUpdatingRoute _fromState(GoRouterState state) =>
      const ComicUpdatingRoute();

  String get location => GoRouteData.$location(
        '/updatingComic',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $comicRankRoute => GoRouteData.$route(
      path: '/rankComic',
      parentNavigatorKey: ComicRankRoute.$parentNavigatorKey,
      factory: $ComicRankRouteExtension._fromState,
    );

extension $ComicRankRouteExtension on ComicRankRoute {
  static ComicRankRoute _fromState(GoRouterState state) =>
      const ComicRankRoute();

  String get location => GoRouteData.$location(
        '/rankComic',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $comicDetailRoute => GoRouteData.$route(
      path: '/comicDetail',
      parentNavigatorKey: ComicDetailRoute.$parentNavigatorKey,
      factory: $ComicDetailRouteExtension._fromState,
    );

extension $ComicDetailRouteExtension on ComicDetailRoute {
  static ComicDetailRoute _fromState(GoRouterState state) => ComicDetailRoute(
        state.extra as String,
      );

  String get location => GoRouteData.$location(
        '/comicDetail',
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}

RouteBase get $comicReaderRoute => GoRouteData.$route(
      path: '/comicReader',
      parentNavigatorKey: ComicReaderRoute.$parentNavigatorKey,
      factory: $ComicReaderRouteExtension._fromState,
    );

extension $ComicReaderRouteExtension on ComicReaderRoute {
  static ComicReaderRoute _fromState(GoRouterState state) => ComicReaderRoute(
        chapterIndex: int.parse(state.uri.queryParameters['chapter-index']!),
        $extra: state.extra as ComicDetailModel,
      );

  String get location => GoRouteData.$location(
        '/comicReader',
        queryParams: {
          'chapter-index': chapterIndex.toString(),
        },
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}

RouteBase get $comicChaptersRoute => GoRouteData.$route(
      path: '/comicChapters',
      parentNavigatorKey: ComicChaptersRoute.$parentNavigatorKey,
      factory: $ComicChaptersRouteExtension._fromState,
    );

extension $ComicChaptersRouteExtension on ComicChaptersRoute {
  static ComicChaptersRoute _fromState(GoRouterState state) =>
      ComicChaptersRoute(
        state.extra as ComicDetailModel,
      );

  String get location => GoRouteData.$location(
        '/comicChapters',
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}

RouteBase get $novelDetailRoute => GoRouteData.$route(
      path: '/novelDetail',
      parentNavigatorKey: NovelDetailRoute.$parentNavigatorKey,
      factory: $NovelDetailRouteExtension._fromState,
    );

extension $NovelDetailRouteExtension on NovelDetailRoute {
  static NovelDetailRoute _fromState(GoRouterState state) => NovelDetailRoute(
        state.extra as String,
      );

  String get location => GoRouteData.$location(
        '/novelDetail',
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}

RouteBase get $novelChaptersRoute => GoRouteData.$route(
      path: '/novelChapters',
      parentNavigatorKey: NovelChaptersRoute.$parentNavigatorKey,
      factory: $NovelChaptersRouteExtension._fromState,
    );

extension $NovelChaptersRouteExtension on NovelChaptersRoute {
  static NovelChaptersRoute _fromState(GoRouterState state) =>
      NovelChaptersRoute(
        state.extra as NovelDetailModel,
      );

  String get location => GoRouteData.$location(
        '/novelChapters',
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}

RouteBase get $novelReaderRoute => GoRouteData.$route(
      path: '/novelReader',
      parentNavigatorKey: NovelReaderRoute.$parentNavigatorKey,
      factory: $NovelReaderRouteExtension._fromState,
    );

extension $NovelReaderRouteExtension on NovelReaderRoute {
  static NovelReaderRoute _fromState(GoRouterState state) => NovelReaderRoute(
        chapterIndex: int.parse(state.uri.queryParameters['chapter-index']!),
        $extra: state.extra as NovelDetailModel,
      );

  String get location => GoRouteData.$location(
        '/novelReader',
        queryParams: {
          'chapter-index': chapterIndex.toString(),
        },
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}

RouteBase get $novelSortRoute => GoRouteData.$route(
      path: '/novelSort',
      parentNavigatorKey: NovelSortRoute.$parentNavigatorKey,
      factory: $NovelSortRouteExtension._fromState,
    );

extension $NovelSortRouteExtension on NovelSortRoute {
  static NovelSortRoute _fromState(GoRouterState state) =>
      const NovelSortRoute();

  String get location => GoRouteData.$location(
        '/novelSort',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $novelNewRoute => GoRouteData.$route(
      path: '/novelNew',
      parentNavigatorKey: NovelNewRoute.$parentNavigatorKey,
      factory: $NovelNewRouteExtension._fromState,
    );

extension $NovelNewRouteExtension on NovelNewRoute {
  static NovelNewRoute _fromState(GoRouterState state) => const NovelNewRoute();

  String get location => GoRouteData.$location(
        '/novelNew',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $novelEndRoute => GoRouteData.$route(
      path: '/novelEnd',
      parentNavigatorKey: NovelEndRoute.$parentNavigatorKey,
      factory: $NovelEndRouteExtension._fromState,
    );

extension $NovelEndRouteExtension on NovelEndRoute {
  static NovelEndRoute _fromState(GoRouterState state) => const NovelEndRoute();

  String get location => GoRouteData.$location(
        '/novelEnd',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $novelUpdatingRoute => GoRouteData.$route(
      path: '/noveUpdating',
      parentNavigatorKey: NovelUpdatingRoute.$parentNavigatorKey,
      factory: $NovelUpdatingRouteExtension._fromState,
    );

extension $NovelUpdatingRouteExtension on NovelUpdatingRoute {
  static NovelUpdatingRoute _fromState(GoRouterState state) =>
      const NovelUpdatingRoute();

  String get location => GoRouteData.$location(
        '/noveUpdating',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $moreNovelRoute => GoRouteData.$route(
      path: '/moreNovel',
      parentNavigatorKey: MoreNovelRoute.$parentNavigatorKey,
      factory: $MoreNovelRouteExtension._fromState,
    );

extension $MoreNovelRouteExtension on MoreNovelRoute {
  static MoreNovelRoute _fromState(GoRouterState state) => MoreNovelRoute(
        state.extra as RecNovelModel,
      );

  String get location => GoRouteData.$location(
        '/moreNovel',
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}

RouteBase get $novelVoicePalyerContentRoute => GoRouteData.$route(
      path: '/novelVoicePlayer',
      parentNavigatorKey: NovelVoicePalyerContentRoute.$parentNavigatorKey,
      factory: $NovelVoicePalyerContentRouteExtension._fromState,
    );

extension $NovelVoicePalyerContentRouteExtension
    on NovelVoicePalyerContentRoute {
  static NovelVoicePalyerContentRoute _fromState(GoRouterState state) =>
      const NovelVoicePalyerContentRoute();

  String get location => GoRouteData.$location(
        '/novelVoicePlayer',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $chatDetailRoute => GoRouteData.$route(
      path: '/chatDetail',
      parentNavigatorKey: ChatDetailRoute.$parentNavigatorKey,
      factory: $ChatDetailRouteExtension._fromState,
    );

extension $ChatDetailRouteExtension on ChatDetailRoute {
  static ChatDetailRoute _fromState(GoRouterState state) => ChatDetailRoute(
        int.parse(state.uri.queryParameters['id']!),
      );

  String get location => GoRouteData.$location(
        '/chatDetail',
        queryParams: {
          'id': id.toString(),
        },
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $chatIssueRoute => GoRouteData.$route(
      path: '/chatIssue',
      parentNavigatorKey: ChatIssueRoute.$parentNavigatorKey,
      factory: $ChatIssueRouteExtension._fromState,
    );

extension $ChatIssueRouteExtension on ChatIssueRoute {
  static ChatIssueRoute _fromState(GoRouterState state) =>
      const ChatIssueRoute();

  String get location => GoRouteData.$location(
        '/chatIssue',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $pictureMoreRoute => GoRouteData.$route(
      path: '/morePicture',
      parentNavigatorKey: PictureMoreRoute.$parentNavigatorKey,
      factory: $PictureMoreRouteExtension._fromState,
    );

extension $PictureMoreRouteExtension on PictureMoreRoute {
  static PictureMoreRoute _fromState(GoRouterState state) => PictureMoreRoute(
        state.extra as RecAlbumModel,
      );

  String get location => GoRouteData.$location(
        '/morePicture',
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}

RouteBase get $pictureReaderRoute => GoRouteData.$route(
      path: '/pictureReader',
      parentNavigatorKey: PictureReaderRoute.$parentNavigatorKey,
      factory: $PictureReaderRouteExtension._fromState,
    );

extension $PictureReaderRouteExtension on PictureReaderRoute {
  static PictureReaderRoute _fromState(GoRouterState state) =>
      PictureReaderRoute(
        state.uri.queryParameters['id']!,
      );

  String get location => GoRouteData.$location(
        '/pictureReader',
        queryParams: {
          'id': id,
        },
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $picturePreViewRoute => GoRouteData.$route(
      path: '/picturePreView',
      parentNavigatorKey: PicturePreViewRoute.$parentNavigatorKey,
      factory: $PicturePreViewRouteExtension._fromState,
    );

extension $PicturePreViewRouteExtension on PicturePreViewRoute {
  static PicturePreViewRoute _fromState(GoRouterState state) =>
      PicturePreViewRoute(
        int.parse(state.uri.queryParameters['index']!),
        state.extra as List<Map<dynamic, dynamic>>,
      );

  String get location => GoRouteData.$location(
        '/picturePreView',
        queryParams: {
          'index': index.toString(),
        },
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}

RouteBase get $albumTagRoute => GoRouteData.$route(
      path: '/albumTag/:tag',
      parentNavigatorKey: AlbumTagRoute.$parentNavigatorKey,
      factory: $AlbumTagRouteExtension._fromState,
    );

extension $AlbumTagRouteExtension on AlbumTagRoute {
  static AlbumTagRoute _fromState(GoRouterState state) => AlbumTagRoute(
        tag: state.pathParameters['tag']!,
      );

  String get location => GoRouteData.$location(
        '/albumTag/${Uri.encodeComponent(tag)}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $yelllowPictureRoute => GoRouteData.$route(
      path: '/yelllowPicture',
      parentNavigatorKey: YelllowPictureRoute.$parentNavigatorKey,
      factory: $YelllowPictureRouteExtension._fromState,
    );

extension $YelllowPictureRouteExtension on YelllowPictureRoute {
  static YelllowPictureRoute _fromState(GoRouterState state) =>
      const YelllowPictureRoute();

  String get location => GoRouteData.$location(
        '/yelllowPicture',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $dateRoute => GoRouteData.$route(
      path: '/date',
      parentNavigatorKey: DateRoute.$parentNavigatorKey,
      factory: $DateRouteExtension._fromState,
    );

extension $DateRouteExtension on DateRoute {
  static DateRoute _fromState(GoRouterState state) => const DateRoute();

  String get location => GoRouteData.$location(
        '/date',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $chatRoute => GoRouteData.$route(
      path: '/chat',
      parentNavigatorKey: ChatRoute.$parentNavigatorKey,
      factory: $ChatRouteExtension._fromState,
    );

extension $ChatRouteExtension on ChatRoute {
  static ChatRoute _fromState(GoRouterState state) => const ChatRoute();

  String get location => GoRouteData.$location(
        '/chat',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $taskRoute => GoRouteData.$route(
      path: '/task',
      parentNavigatorKey: TaskRoute.$parentNavigatorKey,
      factory: $TaskRouteExtension._fromState,
    );

extension $TaskRouteExtension on TaskRoute {
  static TaskRoute _fromState(GoRouterState state) => const TaskRoute();

  String get location => GoRouteData.$location(
        '/task',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}
