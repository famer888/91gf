import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jygf/domain/model/navigator_model.dart';
import 'package:jygf/ui_layer/screens/common_widgets/video_player/shortv_player.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider/provider.dart';
import 'package:jygf/app_global.dart';
import 'package:jygf/domain/domain.dart';
import 'package:jygf/domain/model/vlog_model.dart';
import 'package:jygf/domain/type_def.dart';
import 'package:jygf/ui_layer/notifiers/home_config_notifier.dart';
import 'package:jygf/ui_layer/screens/common_widgets/status/empty_data.dart';
import 'package:jygf/ui_layer/screens/common_widgets/status/loading.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/ui_layer/screens/video_detail/screen.dart';
import 'package:jygf/ui_layer/utils/common_utils.dart';
import 'package:jygf/ui_layer/utils/my_toast.dart';

class VlogPlayScreen extends StatefulWidget {
  VlogPlayScreen(
      {super.key,
      this.apiUrl = '',
      this.param,
      this.noMore = false,
      this.userGlobalData = false,
      this.keepBottomBlank = false,
      this.selSortIndex});

  final String apiUrl;
  Map? param;
  final bool noMore;
  final bool userGlobalData; // 用不用 AppGlobal.shortVideosInfo
  final bool keepBottomBlank; // 底部要不要留白
  int? selSortIndex;

  @override
  State<VlogPlayScreen> createState() => VlogPlayScreenState();
}

class VlogPlayScreenState extends State<VlogPlayScreen> {
  int page = 1;
  bool isHud = true;
  bool noMore = false;
  bool isAction = false;

  late StreamSubscription discrip;

  PageController? _pageController;
  String _apiUrl = '';
  dynamic _param = {};

  int? _singlePlay; // 1: 禁止上下滑动切换

  List<VlogModel> array = [];

  late final vlogDomain = context.read<VlogDomain>();
  late final _appDomain = context.read<AppDomain>();

  late final config = context.read<HomeConfigNotifier>().config;
  late final vlogSorts = config.vlogSortNav ?? [];

  @override
  void initState() {
    super.initState();
    noMore = widget.noMore;

    if (widget.userGlobalData) {
      array = AppGlobal.shortVideosInfo['list'];
      page = AppGlobal.shortVideosInfo['page'];
      _apiUrl = AppGlobal.shortVideosInfo['api'] ?? '';
      _param = AppGlobal.shortVideosInfo['params'] ?? {};
      int initialIndex = AppGlobal.shortVideosInfo['index'];
      _pageController = PageController(initialPage: initialIndex);
      isHud = false;

      VlogModel e = array[initialIndex];
      _singlePlay = e.mvType; //长视频不能滑动切换

      if (array.length - initialIndex < 4 && !isAction) {
        isAction = true;
        page++;
        getData();
      }
    } else {
      _apiUrl = widget.apiUrl;
      getData();
    }

    // if (!kIsWeb) {
    //   discrip = eventBus.on<MyEvent>().listen((event) {
    //     if (event.message == 'enter_vlog_page_event') {
    //       if (event.arg["type"] == "leave") {
    //         PreloadUtils.removeCurrentTask();
    //       } else {
    //         if (mounted) setState(() {});
    //       }
    //     }
    //   });
    // }
  }

  Future<void> getData() async {
    if (noMore) return;

    Map param = Map.from(_param);
    param.addAll({"page": page});
    if (widget.selSortIndex != null) {
      final NavigatorModel m = vlogSorts[widget.selSortIndex ?? 0];
      param.addAll({"sort": m.type});
    } else {
      final NavigatorModel m = vlogSorts.first;
      param.addAll({"sort": m.type});
    }
    final res = await _appDomain.getConstructByApiLink(
      apiLink: _apiUrl,
      params: param,
    );
    if (res.status == 1) {
      if (res.data == null) {
        isAction = false;
        return;
      }

      dynamic data = res.data;
      if (_apiUrl.contains('list_follow2')) {
        data = res.data['blogger_mvs'];
      }

      List<VlogModel> tp =
          (data as List).map((x) => VlogModel.fromJson(x)).toList();
      if (page == 1) {
        array = tp;
      } else if (tp.isNotEmpty) {
        array.addAll(tp);
      } else {
        noMore = true;
      }
      isHud = false;
      isAction = false;
      if (mounted) setState(() {});
    } else {
      MyToast.showText(text: res.msg ?? '');
    }
  }

  Future<void> headerRefresh() async {
    page = 1;
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return isHud
        ? const LoadingView()
        : array.isEmpty
            ? const PageEmptyDataView()
            : RefreshIndicator(
                color: MyTheme.primaryColor,
                backgroundColor: Colors.transparent,
                strokeWidth: 2,
                onRefresh: headerRefresh,
                child: PhotoViewGallery.builder(
                    scrollPhysics: _singlePlay == 1
                        ? const NeverScrollableScrollPhysics()
                        : const BouncingScrollPhysics(),
                    itemCount: array.length,
                    scrollDirection: Axis.vertical,
                    pageController: _pageController,
                    onPageChanged: (index) async {
                      CommonUtils.log("$index --- ${array.length}");

                      VlogModel e = array[index];
                      setState(() {
                        _singlePlay = e.mvType; //长视频不能滑动切换
                      });

                      // changeURL(index);
                      if (array.length - index < 4 && !isAction) {
                        isAction = true;
                        page++;
                        getData();
                      }
                    },
                    builder: (cx, index) {
                      VlogModel e = array[index];

                      if (e.imgUrl != null) {
                        return PhotoViewGalleryPageOptions.customChild(
                            initialScale: 1.0,
                            minScale: 1.0,
                            maxScale: 1.0,
                            disableGestures: true,
                            child: CommonUtils.adModuleInShortFlowUI(
                              context,
                              e,
                            ));
                      }

                      if (!kIsWeb) {
                        preloadShortV(array, index);
                      }

                      return PhotoViewGalleryPageOptions.customChild(
                        initialScale: 1.0,
                        minScale: 1.0,
                        maxScale: 1.0,
                        disableGestures: true,
                        child: e.mvType == 1
                            ? VideoDetailScreen(id: '${e.id}') //, noback: true)
                            : ShortVPlayer(
                                info: e,
                                keepBottomBlank: widget.keepBottomBlank,
                              ),
                      );
                    }),
              );
  }

  // 对列表中 当前视频 前1后2进行预加载
  Future<void> preloadShortV(List<VlogModel> array, int index) async {
    if (array.length <= index) return;

    List<VlogModel> preloadArray = [];
    // 取出前num个数据
    int numInFront = 1;
    for (int i = numInFront; i > 0; i--) {
      if (index - i >= 0) {
        preloadArray.insert(0, array[index - i]);
      }
    }
    // 取出后num个数据
    int numInBehind = 2;
    for (int i = numInBehind; i > 0; i--) {
      if (index + i < array.length) {
        preloadArray.insert(0, array[index + i]);
      }
    }

    // 将当前播放的视频，插到第一个
    preloadArray.insert(0, array[index]);
    if (preloadArray.isNotEmpty) {
      // await PreloadUtils.receivePreloadData(preloadArray);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    if (!kIsWeb) {
      // PreloadUtils.removeCurrentTask();
      // discrip.cancel();
    }
    super.dispose();
  }
}
