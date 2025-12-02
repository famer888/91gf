import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../domain/model/banner_model.dart';
import '../../utils/common_utils.dart';
import '../theme.dart';
import 'my_image.dart';

class InfiniteBannerList extends StatefulWidget {
  final List<BannerModel> banners;
  final int columNumber;

  const InfiniteBannerList({required this.banners, required this.columNumber, super.key});

  @override
  State<InfiniteBannerList> createState() => _InfiniteBannerListState();
}

class _InfiniteBannerListState extends State<InfiniteBannerList> {
  final ScrollController _controller = ScrollController();
  bool _isUserTouching = false;
  bool _autoScrollRunning = false;
  bool _isVisible = true; // 当前是否在屏幕可见范围内

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAutoScroll();
    });
  }

  void _startAutoScroll() {
    if (_autoScrollRunning) return;
    _autoScrollRunning = true;

    const scrollSpeed = 1.0; // 每帧滚动像素数
    const interval = Duration(milliseconds: 32);

    Future.doWhile(() async {
      if (!mounted) return false;
      await Future.delayed(interval);

      // 若不可见或用户正在触摸，则暂停
      if (!_isVisible || _isUserTouching) return true;

      if (_controller.hasClients) {
        final max = _controller.position.maxScrollExtent;
        final pos = _controller.position.pixels;

        if (pos >= max - 1) {
          final middle = max / 2;
          _controller.jumpTo(middle);
        } else {
          _controller.jumpTo(pos + scrollSpeed);
        }
      }
      return true;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _autoScrollRunning = false;
    VisibilityDetectorController.instance
        .forget(ValueKey('InfiniteBannerList_${widget.hashCode}'));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final itemWidth = (ScreenUtil().screenWidth -
            (widget.columNumber + 1) * 7 -
            MyTheme.pagePadding * 2) /
        widget.columNumber;

    return VisibilityDetector(
      key: ValueKey('InfiniteBannerList_${widget.hashCode}'),
      onVisibilityChanged: (info) {
        if (!mounted) return; // 防止销毁后继续调用
        final visibleFraction = info.visibleFraction;
        final newVisible = visibleFraction > 0.1; // 超过10%算可见
        if (newVisible != _isVisible) {
          setState(() => _isVisible = newVisible);
        }
      },
      child: Listener(
        onPointerDown: (_) => _isUserTouching = true,
        onPointerUp: (_) => _isUserTouching = false,
        onPointerCancel: (_) => _isUserTouching = false,
        child: SizedBox(
          height: itemWidth + 28,
          child: ListView.builder(
            controller: _controller,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: widget.banners.length * 2,
            itemBuilder: (context, index) {
              final banner = widget.banners[index % widget.banners.length];
              return GestureDetector(
                onTap: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  CommonUtils.openRoute(context, banner.toJson());
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox.square(
                        dimension: itemWidth,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: MyImage.network(
                            CommonUtils.getThumb(banner.toJson()),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        banner.name ?? banner.title ?? "",
                        style: const TextStyle(
                          color: Colors.white,
                          overflow: TextOverflow.ellipsis,
                          decoration: TextDecoration.none,
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}