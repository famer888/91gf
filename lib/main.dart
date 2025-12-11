import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:jygf/domain/remote_domain/domains/aiaudio.dart';
import 'package:jygf/domain/remote_domain/domains/aidraw.dart';
import 'package:jygf/domain/remote_domain/domains/aikiss.dart';
import 'package:jygf/domain/remote_domain/domains/aimagic.dart';
import 'package:jygf/domain/remote_domain/domains/ainovel.dart';
import 'package:jygf/domain/remote_domain/domains/asmr.dart';
import 'package:jygf/domain/remote_domain/domains/cartoon.dart';
import 'package:jygf/domain/remote_domain/domains/comic.dart';
import 'package:jygf/domain/remote_domain/domains/game.dart';
import 'package:jygf/domain/remote_domain/domains/live.dart';
import 'package:jygf/domain/remote_domain/domains/rank.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:utils/utils.dart';

import 'data_layer/repo/repo.dart';
import 'domain/domain.dart';
import 'domain/remote_domain/domains/ai.dart';
import 'domain/remote_domain/domains/original.dart';
import 'ui_layer/notifiers/chat_notifier.dart';
import 'ui_layer/notifiers/home_config_notifier.dart';
import 'ui_layer/notifiers/user_notifier.dart';
import 'ui_layer/router/router.dart';
import 'ui_layer/screens/theme.dart';
import 'ui_layer/utils/common_utils.dart';
import 'ui_layer/utils/download_utils.dart';

import 'package:universal_html/html.dart' as html;

//防止键盘弹出时web界面被放大
void disableZoomOnWeb() {
  html.document.documentElement?.style.overflow = 'hidden';
  html.document.documentElement?.style.touchAction = 'manipulation';
  html.document.documentElement?.style.setProperty('user-select', 'none');
  html.document.documentElement?.style
      .setProperty('overscroll-behavior', 'contain');
}

void main() async {
  if (kIsWeb) disableZoomOnWeb();

  /// 初始化仓库，必须放在最前面
  final appRepo = AppRepo();
  await appRepo.init();
  disableUrlStrategy();

  /// 初始化多语系
  await EasyLocalization.ensureInitialized();

  /// 强制竖屏
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  /// 设置屏幕状态栏、导航列底色
  CommonUtils.setStatusBar(isLight: true);

  runApp(
    MultiProvider(
      providers: [
        Provider<AppDomain>(lazy: false, create: (_) => appRepo),
        Provider<CacheDomain>(lazy: false, create: (_) => appRepo.cache),
        Provider<HomeDomain>(lazy: false, create: (_) => appRepo),
        Provider<UserDomain>(lazy: false, create: (_) => appRepo),
        Provider<ElementDomain>(lazy: false, create: (_) => appRepo),
        Provider<DynamicDomain>(lazy: false, create: (_) => appRepo),
        Provider<CommunityDomain>(lazy: false, create: (_) => appRepo),
        Provider<SeedDomain>(lazy: false, create: (_) => appRepo),
        Provider<OrderDomain>(lazy: false, create: (_) => appRepo),
        Provider<SignDomain>(lazy: false, create: (_) => appRepo),
        Provider<AccountDomain>(lazy: false, create: (_) => appRepo),
        Provider<ProxyDomain>(lazy: false, create: (_) => appRepo),
        Provider<WithdrawDomain>(lazy: false, create: (_) => appRepo),
        Provider<SearchDomain>(lazy: false, create: (_) => appRepo),
        Provider<MvDomain>(lazy: false, create: (_) => appRepo),
        Provider<VlogDomain>(lazy: false, create: (_) => appRepo),
        Provider<CartoonDomain>(lazy: false, create: (_) => appRepo),
        Provider<GameDomain>(lazy: false, create: (_) => appRepo),
        Provider<MessageDomain>(lazy: false, create: (_) => appRepo),
        Provider<PrivilegeDomain>(lazy: false, create: (_) => appRepo),
        Provider<OriginalDomain>(lazy: false, create: (_) => appRepo),
        Provider<LiveDomain>(lazy: false, create: (_) => appRepo),
        Provider<AIDomain>(lazy: false, create: (_) => appRepo),
        Provider<AIMagicDomain>(lazy: false, create: (_) => appRepo),
        Provider<AIDrawDomain>(lazy: false, create: (_) => appRepo),
        Provider<AIKissDomain>(lazy: false, create: (_) => appRepo),
        Provider<AINovelDomain>(lazy: false, create: (_) => appRepo),
        Provider<AIAudioDomain>(lazy: false, create: (_) => appRepo),
        Provider<ASMRDomain>(lazy: false, create: (_) => appRepo),
        Provider<RankDomain>(lazy: false, create: (_) => appRepo),
        Provider<ComicDomain>(lazy: false, create: (_) => appRepo),
        Provider<DownloadUtil>(
            lazy: false, create: (_) => DownloadUtil(cache: appRepo.cache)),
        ChangeNotifierProvider(create: (_) => HomeConfigNotifier(appRepo)),
        ChangeNotifierProvider(create: (_) => UserNotifier(appRepo)),
        ChangeNotifierProxyProvider<UserNotifier, ChatNotifier?>(
          lazy: false,
          update: (context, value, previous) {
            if (!value.isInit) {
              return null;
            }

            return previous?.member.uuid == value.member.uuid
                ? previous!
                : ChatNotifier(
                    cache: appRepo.cache,
                    member: value.member,
                    oauthType: appRepo.getOAuthType(),
                    oauthId: appRepo.getOAuthId(),
                  );
          },
          create: (BuildContext context) => null,
        ),
      ],
      child: EasyLocalization(
        supportedLocales: const [Locale('zh', 'CN')],
        fallbackLocale: const Locale('zh', 'CN'),
        path: 'assets/translations',
        child: Container(
          color: Colors.black,
          alignment: Alignment.center,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: kIsWeb ? 430 : double.infinity,
            ),
            child: ScreenUtilInit(
              enableScaleText: () => !kIsWeb,
              enableScaleWH: () => !kIsWeb,
              designSize: const Size(375, 667),
              child: const MyApp(),
              builder: (_, child) => child!,
            ),
          ),
        ),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final botToastBuilder = BotToastInit();

    return MaterialApp.router(
      routerConfig: AppRouter.router,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      onGenerateTitle: (context) => 'yybt'.tr(context: context),
      theme: ThemeData(
        progressIndicatorTheme: const ProgressIndicatorThemeData(color: MyTheme.jellyCyanColor103224185),
        splashColor: Colors.transparent,
        scaffoldBackgroundColor: MyTheme.bgColor,
        canvasColor: MyTheme.bgColor, // Canvas 背景色
        colorScheme: const ColorScheme.light(
          surface: MyTheme.whiteColor, // ColorScheme 背景色
        ),
        highlightColor: Colors.transparent,
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: MyTheme.cyanColor00edfd,
          selectionColor: MyTheme.cyanColor00edfd.withOpacity(0.5),
          selectionHandleColor: MyTheme.cyanColor00edfd,
        ),
        inputDecorationTheme: InputDecorationTheme(
          disabledBorder: MyTheme.inputBorder,
          focusedBorder: MyTheme.inputBorder,
          enabledBorder: MyTheme.inputBorder,
          border: MyTheme.inputBorder,
          isDense: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 8.w),
        ),
        primarySwatch: const MaterialColor(
          0xFF000000, //改了不好看
          <int, Color>{
            50: Color(0xFF000000),
            100: Color(0xFF000000),
            200: Color(0xFF000000),
            300: Color(0xFF000000),
            400: Color(0xFF000000),
            500: Color(0xFF000000),
            600: Color(0xFF000000),
            700: Color(0xFF000000),
            800: Color(0xFF000000),
            900: Color(0xFF000000),
          },
        ),
      ),
      debugShowCheckedModeBanner: false, // 设置为false来移除右上角的DEBUG横幅
      builder: (context, widget) {
        widget = botToastBuilder(context, widget!);
        widget = MediaQuery(
          //设置文字大小不随系统设置改变
          data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
          child: widget,
        );
        return widget;
      },
      scrollBehavior: ScrollConfiguration.of(context).copyWith(
        physics: const BouncingScrollPhysics(),
      ),
    );
  }
}
