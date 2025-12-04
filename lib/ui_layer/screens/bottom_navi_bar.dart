import 'dart:async';
import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper_null_safety_flutter3/flutter_swiper_null_safety_flutter3.dart';
import 'package:go_router/go_router.dart';
import 'package:jygf/domain/model/banner_model.dart';
import 'package:jygf/ui_layer/screens/asmr/voice_player/voice_player_manager.dart';
import 'package:jygf/ui_layer/screens/common_widgets/dialog/widgets/app_down_center_dialog.dart';
import 'package:jygf/ui_layer/screens/common_widgets/event_bus/event_bus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:safe_area_insets/safe_area_insets.dart';
import 'package:universal_html/html.dart' as html;

import '../../app_config.dart';
import '../../domain/domain.dart';
import '../../domain/enum.dart';
import '../../domain/model/home_data_model.dart';
import '../notifiers/home_config_notifier.dart';
import '../notifiers/user_notifier.dart';
import '../router/routes.dart';
import '../utils/common_utils.dart';
import '../utils/my_toast.dart';
import 'common_widgets/dialog/widgets/ad_dialog.dart';
import 'common_widgets/dialog/widgets/announcement_dialog.dart';
import 'common_widgets/dialog/widgets/download_apk_dialog.dart';
import 'common_widgets/dialog/widgets/update_dialog.dart';
import 'common_widgets/my_image.dart';
import 'common_widgets/pop_scope_wrapper.dart';
import 'common_widgets/status/loading.dart';
import 'image_paths.dart';
import 'theme.dart';

class BottomNaviBar extends StatefulWidget {
  const BottomNaviBar({
    required this.navigationShell,
    super.key = const ValueKey<String>('ScaffoldWithNavBar'),
  });
  final StatefulNavigationShell navigationShell;

  @override
  State<BottomNaviBar> createState() => _BottomNaviBarState();
}

class _BottomNaviBarState extends State<BottomNaviBar> {
  late final _userNotifier = context.read<UserNotifier>();
  late final homeConfigNotifier = context.read<HomeConfigNotifier>();
  late final targetVersion = homeConfigNotifier.homeData.versionMsg;
  late final domain = context.read<AppDomain>();
  late final cache = domain.cache;
  MyTokenStatus? currentTokenStatus;

  bool _isInit = false;
  late StreamSubscription<MyEvent> _subscription;

  bool get openLive => homeConfigNotifier.config.openLive == 1 ? true : false;

  @override
  void initState() {
    VoicePlayerManager.instance.topContext = context;
    _userNotifier.addListener(_userNotifierListener);
    _userNotifier.init();
    super.initState();

    if (!openLive) {
      //关闭直播模块时删除直播路由,默认显示直播模块
      widget.navigationShell.route.branches.removeAt(2);
    }

    // 订阅首页ASMR和种子下载点击事件
    _subscription = eventBus.on<MyEvent>().listen((event) {
      debugPrint('Received event: ${event.message}');
      const index = 2;
      if (event.message == 'asmr') {
        widget.navigationShell.goBranch(index,
            initialLocation: index == widget.navigationShell.currentIndex);
        Future.delayed(const Duration(milliseconds: 200), () {
          eventBus.fire(MyEvent('to-asmr'));
        });
      } else if (event.message == 'torrentDownload') {
        widget.navigationShell.goBranch(index,
            initialLocation: index == widget.navigationShell.currentIndex);
        Future.delayed(const Duration(milliseconds: 200), () {
          eventBus.fire(MyEvent('to-torrentDownload'));
        });
      }
    });
  }

  void _userNotifierListener() async {
    final status = _userNotifier.tokenStatus;
    if (currentTokenStatus != status) {
      currentTokenStatus = status;
      if (currentTokenStatus == MyTokenStatus.invalid) {
        CommonUtils.logoutStopVoicePlayer();
        MyToast.showText(text: 'dlsx'.tr());
        await _userNotifier.init();
        if (mounted) {
          const LoginRoute().push(context);
        }
      }
    }

    if (!_isInit && _userNotifier.isInit) {
      _isInit = true;
      if (_isInit) {
        _appStartCheck();
      }
    }
  }

  Future<void> _appStartCheck() async {
    // 本地调试 / 非 Release 环境下，直接跳过开屏弹窗广告和推荐/公告弹窗
    // （即 Debug / Profile 模式都会跳过，只在正式 Release 包中展示）
    if (!kReleaseMode) {
      // 保留必要的本地调试初始化（如缓存处理），但不弹广告
      cache.clearImageCacheIfNeed();
      if (!kIsWeb) _initDownloadStatus();
      return;
    }

    // 打开的时候就清除一下缓存
    cache.clearImageCacheIfNeed();
    // 处理剪贴板内容
    _getClipboardText();

    /// 弹窗优先级： 更新 -> 广告 -> 推荐APP -> 公告
    _checkUpdateAnnouncement();

    if (!kIsWeb) _initDownloadStatus();
  }

  Future<void> _getClipboardText() async {
    if (kIsWeb) {
      final uri = Uri.parse(html.window.location.href);
      final affCode = uri.queryParameters[BuildConfig.affCodeKey] ?? '';
      if (affCode.isNotEmpty) {
        domain.toInvitation(affCode: affCode);
      }
    } else {
      final result = await Clipboard.getData(Clipboard.kTextPlain);
      if (result?.text?.split(':') case final clipTextList?
          when clipTextList.length > 1 &&
              clipTextList[0] == BuildConfig.affCodeKey) {
        if (clipTextList[1] case final affCode when affCode.isNotEmpty) {
          domain.toInvitation(affCode: affCode);
        }
      }
    }
  }

  /// 活动弹窗
  void _showActivityDialog({required int index}) {
    final popAds = homeConfigNotifier.homeData.popAds;
    final int adsLength = popAds?.length ?? 0;
    final bool isLastAd = index == adsLength - 1;
    if (popAds?.isNotEmpty == true) {
      if (index < adsLength) {
        final Notice? notice = popAds?[index];
        BotToast.showWidget(
            toastBuilder: (cancelFunc) => AdDialog(
                  cancel: () {
                    cancelFunc();
                    if (isLastAd) {
                      _showAppDownCenterDialog();
                    } else {
                      _showActivityDialog(index: index + 1);
                    }
                  },
                  confirm: () {
                    cancelFunc();
                    if (notice?.redirect_type != 1) {
                      //跳转内部结束继续弹窗
                      if (isLastAd) {
                        _showAppDownCenterDialog();
                      } else {
                        _showActivityDialog(index: index + 1);
                      }
                    }
                    _adOnTap(notice: notice);
                  },
                  adUrl: notice?.imgUrl ?? '',
                  adWidth: notice?.width,
                  adHeight: notice?.height,
                ));
      }
    } else {
      _showAppDownCenterDialog();
    }
  }

  /// 检查更新
  Future<void> _checkUpdateAnnouncement() async {
    if (targetVersion?.version case final version?) {
      final packageInfo = await PackageInfo.fromPlatform();
      final String localVersion = packageInfo.version;
      final currentVersion = localVersion.replaceAll('.', '');

      final String targetNumber = version.replaceAll('.', '');

      final needUpdate = (int.tryParse(targetNumber) ?? 0) >
          (int.tryParse(currentVersion) ?? 0);

      if (kIsWeb) {
        _showActivityDialog(index: 0); //web端直接去展示广告
        return;
      }
      if (needUpdate) {
        _showAppUpdateDialog();
        return;
      }

      _showActivityDialog(index: 0); // 无更新，展示广告
    }
  }

  /// 更新弹窗
  void _showAppUpdateDialog() {
    final Config config = homeConfigNotifier.config;

    BotToast.showWidget(
        toastBuilder: (cancelFunc) => UpdateDialog(
              cancel: () {
                cancelFunc();
                _showActivityDialog(index: 0);
              },
              confirm: () {
                cancelFunc();
                if (kIsWeb) {
                  CommonUtils.launchUrl(config.officeSite ?? '');
                } else {
                  if (Platform.isAndroid) {
                    BotToast.showWidget(
                      toastBuilder: (cancelFunc) => DownloadApkDialog(
                        version: targetVersion?.version ?? '',
                        url: targetVersion?.apk ?? '',
                      ),
                    );
                  } else {
                    CommonUtils.launchUrl(targetVersion?.apk ?? '');
                  }
                }
              },
              tips: targetVersion?.tips ?? '',
              mustUpdate: targetVersion?.must == 1,
              officialWebUrl: config.officeSite ?? '',
              solution: config.solution ?? '',
            ));
  }

  /// 活动弹窗点击事件
  void _adOnTap({Notice? notice}) {
    if (notice == null) return;
    final json = notice.toJson();
    CommonUtils.openRoute(context, json);
  }

  ///推荐app下载列表弹窗
  void _showAppDownCenterDialog() {
    final homeData = homeConfigNotifier.homeData;

    if (homeData.noticeApps?.isNotEmpty ?? false) {
      BotToast.showWidget(
          toastBuilder: (cancelFunc) => AppDownCenterDialog(
                cancel: () {
                  cancelFunc();
                  _showAnnouncementDialog(); //app推荐下载弹窗展示完后再展示公告
                },
              ));
    } else {
      _showAnnouncementDialog(); //app推荐为空直接展示公告
    }
  }

  /// 系统公告弹窗
  void _showAnnouncementDialog() {
    if (targetVersion?.mstatus != 1) return;

    BotToast.showWidget(
        toastBuilder: (cancelFunc) => AnnouncementDialog(
              cancel: () {
                cancelFunc();
              },
              confirm: () {
                cancelFunc();
                const MineAgentRoute().push(context);
              },
              text: homeConfigNotifier.homeData.versionMsg?.message ?? '',
            ));
  }

  // 初始化下载状态
  Future<void> _initDownloadStatus() async {
    if (await cache.readDownloadVideoTasks() case final tasks) {
      for (var task in tasks) {
        task['downloading'] = false;
        task['isWaiting'] = false;
      }
      await cache.upsertDownloadVideoTasks(tasks: tasks);
    }
  }

  @override
  void dispose() {
    _subscription.cancel(); // 取消订阅
    _userNotifier.removeListener(_userNotifierListener);
    super.dispose();
  }

  late final appDomain = context.read<AppDomain>();

  @override
  Widget build(BuildContext context) {
    return Selector<UserNotifier, bool>(
      builder: (_, isInit, child) {
        if (!isInit) {
          return const PopScopeWrapper(
            child: Scaffold(
              body: LoadingView(),
            ),
          );
        }
        return kIsWeb ? WebSafeAreaInsets(child: child!) : child!;
      },
      child: PopScopeWrapper(
        child: Stack(
          children: [
            Scaffold(
              backgroundColor: Colors.transparent,
              body: widget.navigationShell,
              bottomNavigationBar: DecoratedBox(
                decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Color.fromRGBO(39, 39, 39, 1),
                        spreadRadius: 0.0,
                        offset: Offset(0.0, -0.5),
                        blurRadius: 0.0),
                  ],
                ),
                child: BottomNavigationBar(
                  backgroundColor: MyTheme.bgColor,
                  elevation: 0,
                  type: BottomNavigationBarType.fixed,
                  selectedFontSize: 11.sp,
                  unselectedFontSize: 11.sp,
                  unselectedItemColor: MyTheme.white05Color,
                  selectedItemColor: MyTheme.jellyCyanColor103224185,
                  items: <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: const _Icon(MyImagePaths.appTabHomeN),
                      activeIcon: const _Icon(MyImagePaths.appTabHomeS),
                      label: 'sy'.tr(context: context),
                    ),
                    BottomNavigationBarItem(
                      icon: const _Icon(MyImagePaths.appTabEcyN),
                      activeIcon: const _Icon(MyImagePaths.appTabEcyS),
                      label: 'ych'.tr(context: context),
                    ),
                    BottomNavigationBarItem(
                      icon: const _Icon(MyImagePaths.appTabShequN),
                      activeIcon: const _Icon(MyImagePaths.appTabShequS),
                      label: 'ym'.tr(context: context),
                    ),
                    BottomNavigationBarItem(
                      icon: const _Icon(MyImagePaths.appTabLlsN),
                      activeIcon: const _Icon(MyImagePaths.appTabLlsS),
                      label: 'lld'.tr(context: context),
                    ),
                    if (openLive)
                      BottomNavigationBarItem(
                        icon: const _Icon(MyImagePaths.appTabFxN),
                        activeIcon: const _Icon(MyImagePaths.appTabFxS),
                        label: 'faxia'.tr(context: context),
                      ),
                    BottomNavigationBarItem(
                      icon: const _Icon(MyImagePaths.appTabWodeN),
                      activeIcon: const _Icon(MyImagePaths.appTabWodeS),
                      label: 'wd'.tr(context: context),
                    ),
                  ],
                  currentIndex: widget.navigationShell.currentIndex,
                  onTap: _goBranch,
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              floatingActionButton:
                  kIsWeb && !CommonUtils.isPWA() && !CommonUtils.isIosWkWebView()
                      ? Padding(
                          padding: EdgeInsets.only(bottom: 10.w),
                          child: GestureDetector(
                            onTap: () {
                              CommonUtils.downLoadApp(context);
                            },
                            child: Container(
                              height: 30.w,
                              width: 200.w,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: MyTheme.white255Color,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.w))),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  MyImage.asset(MyImagePaths.appLogoIcon,
                                      width: 18.w, height: 18.w),
                                  SizedBox(width: 5.w),
                                  Text('mrdxdk'.tr(context: context),
                                      style: MyTheme.black1434)
                                ],
                              ),
                            ),
                          ),
                        )
                      : const SizedBox(),
            ),
            //悬浮广告位
            Positioned(
              right: 13.w,
              bottom: 110.w,
              child: TopADWidget(toADs: homeConfigNotifier.config.buoy ?? []),
            )
          ],
        ),
      ),
      selector: (_, userNotifier) => userNotifier.isInit,
    );
  }

  void _goBranch(int index) {
    widget.navigationShell.goBranch(index,
        initialLocation: index == widget.navigationShell.currentIndex);
  }
}

class _Icon extends StatelessWidget {
  const _Icon(this.path);

  final String path;
  @override
  Widget build(BuildContext context) {
    final size = 23.w;

    return Padding(
      padding: const EdgeInsets.only(bottom: 2.0),
      child: MyImage.asset(
        path,
        width: size,
        height: size,
      ),
    );
  }
}

//悬浮广告view
class TopADWidget extends StatefulWidget {
  const TopADWidget({super.key, required this.toADs});

  final List<BannerModel> toADs;

  @override
  State<StatefulWidget> createState() => _TopADWidgetState();
}

class _TopADWidgetState extends State<TopADWidget> {

  bool offstage = false;

  @override
  Widget build(BuildContext context) {
    return widget.toADs.isEmpty
        ? Container()
        : _buildButton();
  }

  Widget _buildButton() {
    // 本地调试 / 非 Release 环境下不显示首页悬浮广告
    if (!kReleaseMode) {
      return const SizedBox.shrink();
    }

    return Offstage(
      offstage: offstage,
      child: SizedBox(
        width: 120.w,
        height: 120.w,
        child: Stack(
          children: [
            Positioned.fill(
                child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.all(15.w),
                  decoration: BoxDecoration(
                    // color: Colors.red,
                      borderRadius: BorderRadius.all(Radius.circular(5.w))),
                  child: Swiper(
                    autoplay: widget.toADs.length > 1,
                    loop: widget.toADs.length > 1,
                    itemBuilder: (BuildContext context, int index) {
                      double w = 80.w;
                      return GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          CommonUtils.openRoute(context, widget.toADs[index].toJson());
                        },
                        child: SizedBox(
                            width: w,
                            height: w,
                            child: MyImage.network(CommonUtils.getThumb(widget.toADs[index].toJson()),
                              borderRadius: 5.w,
                            )),
                      );
                    },
                    itemCount: widget.toADs.length,
                    pagination: widget.toADs.length > 1
                        ? SwiperPagination(
                        margin: EdgeInsets.only(bottom: 5.w),
                        builder:
                        SwiperCustomPagination(builder: (context, config) {
                          int count = widget.toADs.length;
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(count, (index) {
                              return config.activeIndex == index
                                  ? Container(
                                width: 4.w,
                                height: 4.w,
                                margin: EdgeInsets.only(right: 4.w),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(2.w)),
                                ),
                              )
                                  : Container(
                                width: 4.w,
                                height: 4.w,
                                margin: EdgeInsets.only(right: 4.w),
                                decoration: BoxDecoration(
                                  color: MyTheme.grayColor150,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(2.w)),
                                ),
                              );
                            }),
                          );
                        }))
                        : null,
                  ),
                )),
            Positioned(
                right: 0,
                top: 0,
                width: 20.w,
                height: 20.w,
                child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      setState(() {
                        offstage = true;
                      });
                    },
                    child: const MyImage.asset(MyImagePaths.appDialogClose)))
          ],
        ),
      ),
    );
  }
}
