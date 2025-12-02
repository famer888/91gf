import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:jygf/app_global.dart';
import 'package:jygf/domain/api_validator.dart';
import 'package:jygf/domain/model/follow_user_model.dart';
import 'package:jygf/domain/model/vlog_model.dart';
import 'package:jygf/domain/remote_domain/domains/vlog.dart';
import 'package:jygf/ui_layer/const.dart';
import 'package:jygf/ui_layer/router/routes.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_list_view.dart';
import 'package:jygf/ui_layer/screens/vlog/card/vlog_card.dart';
import 'package:jygf/ui_layer/screens/vlog/card/vlog_focus_rec_card.dart';
import 'package:jygf/ui_layer/screens/vlog/card/vlog_focus_user_view.dart';
import 'package:jygf/ui_layer/screens/image_paths.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/ui_layer/utils/common_utils.dart';
import 'package:jygf/ui_layer/utils/my_toast.dart';

class VlogFocusPage extends StatefulWidget {
  const VlogFocusPage({super.key});

  @override
  State<VlogFocusPage> createState() => _VlogFocusPageState();
}

class _VlogFocusPageState extends State<VlogFocusPage> {
  late final vlogDomain = context.read<VlogDomain>();
  final ValueNotifier<List<FollowingUserData>> followUserNotifier =
      ValueNotifier([]);

  final List<VlogModel> _vlogs = [];

  int _page = 1;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<List<T>?> _getRecommendBloggerData<T>(
      {required int page, required int limit}) async {
    final res = await vlogDomain.vlogFollowList(page: page, limit: limit);

    _page = page;

    if (res.isValid) {
      if (page == 1) {
        _vlogs.clear();
        followUserNotifier.value = res.data?.myFollow ?? [];
        setState(() {});
      }

      final vlogs = res.data?.bloggerVlogs ?? [];

      _vlogs.addAll(vlogs);

      if (followUserNotifier.value.isNotEmpty && T == VlogModel) {
        return vlogs as List<T>;
      }

      if (followUserNotifier.value.isEmpty && T == RecommendBloggerModel) {
        return res.data!.recommendBlogger as List<T>;
      }
    } else if (res.msg case final msg? when msg.isNotEmpty) {
      MyToast.showText(text: msg);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
            child: const Divider(
                thickness: 0.5, height: 0.5, color: MyTheme.white02Color),
          ),
          Expanded(
            child: followUserNotifier.value.isNotEmpty
                ? Column(
                    children: [
                      _Header(followUserNotifier: followUserNotifier),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: MyTheme.pagePadding),
                          child: MyListView.masonryGrid(
                            padding: EdgeInsets.symmetric(
                                horizontal: MyTheme.pagePadding),
                            itemBuilder: (context, item, index) => VlogCard(
                                data: item,
                                onTapFunc: (type) {
                                  if (type == 1) {
                                    //点击短视频视频
                                    AppGlobal.shortVideosInfo = {
                                      'list': _vlogs,
                                      'page': _page,
                                      'index': index,
                                      'api': 'vlog/list_follow2',
                                      'params': {
                                        'limit': 15,
                                      }
                                    };
                                    const VlogSecondRoute().push(context);
                                  } else {
                                    //广告类型
                                    CommonUtils.openRoute(
                                        context, item.toJson());
                                  }
                                }),
                            onFetchingMore: (currentPage, pageSize) =>
                                _getRecommendBloggerData<VlogModel>(
                                    page: currentPage, limit: pageSize),
                          ),
                        ),
                      ),
                    ],
                  )
                : MyListView.list(
                    header: _Header(followUserNotifier: followUserNotifier),
                    padding:
                        EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
                    itemBuilder: (context, item, index) =>
                        VlogFocusRecCard(data: item),
                    onFetchingMore: (currentPage, pageSize) =>
                        _getRecommendBloggerData<RecommendBloggerModel>(
                            page: currentPage, limit: pageSize),
                  ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatefulWidget {
  const _Header({required this.followUserNotifier});

  final ValueNotifier<List<FollowingUserData>> followUserNotifier;

  @override
  State<_Header> createState() => _HeaderState();
}

class _HeaderState extends State<_Header> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 13.w),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('wdgz'.tr(context: context),
                  style: MyTheme.white255_15_semibold),
              widget.followUserNotifier.value.isEmpty
                  ? Container()
                  : InkWell(
                      onTap: () {
                        //关注界面
                        const MineFollowingRoute().push(context);
                      },
                      child: Text('gd'.tr(context: context),
                          style: MyTheme.jellyCyan_15)),
            ],
          ),
          ValueListenableBuilder(
            valueListenable: widget.followUserNotifier,
            builder: (context, parts, child) {
              if (parts.isEmpty) {
                return Container(
                    padding: EdgeInsets.only(bottom: 10.w),
                    width: 1.sw,
                    height: 100.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MyImage.asset(MyImagePaths.appNoData,
                            width: 200.w, height: 60.w),
                        SizedBox(height: 5.w),
                        Text('zwsj'.tr(context: context),
                            style: MyTheme.white07_14),
                      ],
                    ));
              }
              return VlogFocusUserView(focusArr: parts);
            },
          ),
          widget.followUserNotifier.value.isNotEmpty
              ? Container()
              : Text('tjbz'.tr(context: context),
                  style: MyTheme.white255_15_semibold),
          widget.followUserNotifier.value.isNotEmpty
              ? Container()
              : SizedBox(height: 10.w),
        ],
      ),
    );
  }
}
