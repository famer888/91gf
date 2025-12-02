import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider/provider.dart';

import '../../../domain/api_validator.dart';
import '../../../domain/enum.dart';
import '../../../domain/model/media_model.dart';
import '../../../domain/model/video_detail_model.dart';
import '../../../domain/remote_domain/domains/community.dart';
import '../../../domain/type_def.dart';
import '../../utils/common_utils.dart';
import '../../utils/my_toast.dart';
import '../common_widgets/my_image.dart';
import '../common_widgets/video_player/shortv_mv_player.dart';
import '../image_paths.dart';
import '../theme.dart';

class MediaViewerScreen extends StatefulWidget {
  const MediaViewerScreen({super.key, required this.pramas});
  final Map pramas;
  @override
  State<MediaViewerScreen> createState() => _MediaViewerScreenState();
}

class _MediaViewerScreenState extends State<MediaViewerScreen> {
  PhotoViewScaleState scaleState = PhotoViewScaleState.initial;
  bool hasPop = false;
  int currentIndex = 0;
  late PageController _controller;
  List<GlobalKey> keyList = [];
  List<TransformationController> transformationControllerList = [];
  int _selectedIndex = 0;

  void setupData() {
    widget.pramas['resources'].forEach((item) {
      GlobalKey key = GlobalKey();
      TransformationController transformationController =
          TransformationController();
      transformationControllerList.add(transformationController);
      keyList.add(key);
    });
    _controller = PageController(initialPage: widget.pramas['index']);
    _selectedIndex = currentIndex = widget.pramas['index'];
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    setupData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Stack(
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onHorizontalDragUpdate: (e) {},
                onTap: () {
                  if (scaleState == PhotoViewScaleState.initial) {
                    context.pop();
                  }
                },
                onVerticalDragUpdate: (e) {
                  if (scaleState == PhotoViewScaleState.initial) {
                    if (e.delta.dy > 5 && hasPop == false) {
                      hasPop = true;
                      context.pop();
                    }
                  }
                },
                child: PhotoViewGallery.builder(
                  scrollPhysics: const BouncingScrollPhysics(),
                  pageController: _controller,
                  itemCount: widget.pramas['resources'].length,
                  onPageChanged: (index) {
                    _selectedIndex = index;
                    setState(() {});
                  },
                  scaleStateChangedCallback: (value) {
                    scaleState = value;
                  },
                  builder: (context, index) {
                    var e = widget.pramas['resources'][index] as MediaModel;
                    return PhotoViewGalleryPageOptions.customChild(
                      initialScale: 1.0,
                      minScale: 1.0,
                      maxScale: 10.0,
                      child: e.type == MyMediaType.video
                          ? ShortVPlayer(data: e)
                          : MyImage.network(
                              CommonUtils.getThumb(e.toJson()),
                              fit: BoxFit.contain,
                            ),
                    );
                  },
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                child: IgnorePointer(
                  child: Container(
                    height: 80.w,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromRGBO(0, 0, 0, 0.6),
                          Color.fromRGBO(0, 0, 0, 0.0)
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                  child: Column(
                children: [
                  Container(
                      height:
                          kIsWeb ? 10.w : MediaQuery.of(context).padding.top),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
                    height: MyTheme.navbarHegiht,
                    child: Stack(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              child: SizedBox(
                                height: double.infinity,
                                child: Icon(Icons.close,
                                    size: 24.w, color: Colors.white),
                              ),
                              onTap: () {
                                context.pop();
                              },
                            ),
                            Text(
                              '${_selectedIndex + 1} / ${widget.pramas['resources'].length}',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16.sp),
                            )
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ))
            ],
          ),
        ],
      ),
    );
  }
}

class ShortVPlayer extends StatefulWidget {
  const ShortVPlayer({
    super.key,
    required this.data,
  });
  final MediaModel data;

  @override
  State<ShortVPlayer> createState() => _ShortVPlayerState();
}

class _ShortVPlayerState extends State<ShortVPlayer> {
  late final _domain = context.read<CommunityDomain>();

  /// 社区 - 点击商家联系方式/解锁商家联系方式
  Future<void> _pay() async {
    MyToast.showLoading();
    final result = await _domain.reqGetPostURL(id: widget.data.pid ?? 0);
    MyToast.closeAllLoading();
    if (result.isValid) {
      if (mounted) {
        setState(() {
          widget.data.mediaUrl = result.data['url'] ?? '';
        });
      }
    } else {
      MyToast.showText(text: result.msg ?? '');
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.data;
    return data.mediaUrl.isEmpty && (data.unlockCoins ?? 0) > 0
        ? Stack(
            children: [
              Center(
                child: MyImage.network(
                  data.cover,
                  fit: BoxFit.contain,
                ),
              ),
              Container(color: Colors.black87),
              Center(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: _pay,
                  child: Container(
                    height: 34.w,
                    width: 130.w,
                    decoration: BoxDecoration(
                        color: const Color.fromRGBO(255, 252, 136, 0.7),
                        borderRadius: BorderRadius.all(Radius.circular(17.w))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MyImage.asset(MyImagePaths.appVideoCoinN,
                            width: 18.w, height: 17.w),
                        SizedBox(width: 2.w),
                        Text("${data.unlockCoins}${tr('jbjsgk')}",
                            style: MyTheme.black12)
                      ],
                    ),
                  ),
                ),
              )
            ],
          )
        : Builder(builder: (_) {
            final e = widget.data;
            final videoInfo = VideoData(
              source240: e.mediaUrl,
              previewUrl: '',
              coverThumbHorizontal: e.cover,
              coverThumbVerticle: e.cover,
              title: '',
            );

            return ShortvMvPlayer(
              info: videoInfo,
              needCheckAspectRatio: true,
              noBack: true,
              needSlide: false,//防止滑动冲突，导致无法滑动到照片页
            );
          });
  }
}
