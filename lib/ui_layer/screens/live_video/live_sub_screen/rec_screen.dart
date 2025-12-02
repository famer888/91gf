import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/domain/model/banner_model.dart';
import 'package:jygf/domain/model/bit_nav_model.dart';
import 'package:jygf/domain/model/live_model.dart';
import 'package:jygf/domain/remote_domain/domains/live.dart';
import 'package:jygf/ui_layer/screens/common_widgets/general_banner.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_list_view.dart';
import 'package:jygf/ui_layer/screens/live_video/live_card/rec_live_video_card.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/ui_layer/utils/common_utils.dart';
import 'package:jygf/ui_layer/utils/my_toast.dart';
import 'package:provider/provider.dart';


class RecLiveVideoView extends StatefulWidget {
  const RecLiveVideoView({super.key, required this.nav, required this.moreClickCallBack});

  final BitNavModel nav;
  final Function(String title) moreClickCallBack;

  @override
  State<RecLiveVideoView> createState() => _RecLiveVideoViewState();
}

class _RecLiveVideoViewState extends State<RecLiveVideoView> {
  late final _domain = context.read<LiveDomain>();
  final ValueNotifier<List<BannerModel>> _bannersNotifier = ValueNotifier([]);
  final ValueNotifier<List<TipModel>> _tipsNotifier = ValueNotifier([]);

  Future<List<ThemesModel>?> _getData(
      {required int page, required int pageSize}) async {
    final result = await _domain.getLiveRecListComment(
      page: page,
      limit: pageSize,
    );
    if (mounted) {
      setState(() {});
    }

    if (result.status == 1) {
      if (result.data?.banners case final data?
          when data.isNotEmpty && _bannersNotifier.value.isEmpty) {
        _bannersNotifier.value = data;
      }
      if (result.data?.tips case final data?
          when data.isNotEmpty && _tipsNotifier.value.isEmpty) {
        _tipsNotifier.value = data;
      }

      return result.data?.themes;
    } else {
      MyToast.showText(text: result.msg ?? '');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return MyListView.list(
      header: _Header(
          bannersNotifier: _bannersNotifier, tipsNotifier: _tipsNotifier),
      contentPadding: 5.w,
      padding: EdgeInsets.symmetric(
          vertical: MyTheme.pagePadding, horizontal: MyTheme.pagePadding),
      itemBuilder: (context, item, index) =>
          RecLiveVideoCard(model: item, moreClickCallBack: () {
            widget.moreClickCallBack.call(item.name ?? '');
          }),
      onFetchingMore: (currentPage, pageSize) =>
          _getData(page: currentPage, pageSize: pageSize),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.bannersNotifier, required this.tipsNotifier});

  final ValueNotifier<List<BannerModel>> bannersNotifier;
  final ValueNotifier<List<TipModel>> tipsNotifier;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 6.w),
        ValueListenableBuilder(
          valueListenable: bannersNotifier,
          builder: (context, banners, child) {
            if (banners.isEmpty) return const SizedBox.shrink();
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
              child: GeneralBannerAppsListWidget(data: banners),
            );
          },
        ),
        SizedBox(height: 4.w),
        ValueListenableBuilder(
          valueListenable: tipsNotifier,
          builder: (context, tips, child) {
            return CommonUtils.buildNotifyWidget(tips);
          },
        ),
      ],
    );
  }
}
