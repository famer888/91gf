import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/report/ui_layer/report_general_banner.dart';
import 'package:provider/provider.dart';

import '../../../../../domain/async_value.dart';
import '../../../../../domain/domain.dart';
import '../../../../../domain/model/app_center_model.dart';
import '../../../../utils/common_utils.dart';
import '../../../../utils/my_toast.dart';
import '../../../common_widgets/my_image.dart';
import '../../../common_widgets/my_list_view.dart';
import '../../../common_widgets/status/loading.dart';
import '../../../common_widgets/status/network_error.dart';
import '../../../theme.dart';
import 'package:jygf/report/ui_layer/report_gesture_detector.dart';


class AppCenterView extends StatefulWidget {
  const AppCenterView({super.key});

  @override
  State<AppCenterView> createState() => _AppCenterViewState();
}

class _AppCenterViewState extends State<AppCenterView> {
  late final homeDomain = context.read<HomeDomain>();

  AsyncValue<AppCenterModel> _asyncValue = const AsyncInit();

  @override
  void initState() {
    _initData();
    super.initState();
  }

  Future _initData() async {
    if (_asyncValue.isLoading) return;
    setState(() {
      _asyncValue = AsyncLoading(value: _asyncValue.data);
    });

    final res = await homeDomain.getAppCenter();

    if (res.data case final data?) {
      _asyncValue = AsyncData(data);
    } else {
      if (res.msg case final msg?) {
        MyToast.showText(text: msg);
      }
      _asyncValue = const AsyncError();
    }

    if (mounted) {
      setState(() {});
    }
  }

  Widget _buildDataView(AppCenterModel data) {
    final banner = data.banner;
    final recommend = data.recommend;
    final common = data.common;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: [
        MyIndicator(onRefresh: _initData),
        SliverPadding(
          padding: EdgeInsets.only(
            left: MyTheme.pagePadding,
            right: MyTheme.pagePadding,
            bottom: 50.w,
          ),
          sliver: SliverList.list(children: [
            banner.isEmpty
                ? const SizedBox.shrink()
                : Padding(
                    padding: EdgeInsets.only(bottom: 10.w),
                    child: ReportGeneralAppsListVidget(data: banner),
                  ),
            recommend.isEmpty
                ? const SizedBox.shrink()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20.w),
                      Text('xswtj'.tr(context: context),
                          style: MyTheme.white16bold),
                      GridView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.only(top: 10.w),
                          itemCount: recommend.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 5,
                            mainAxisSpacing: 20.w,
                            crossAxisSpacing: 15.w,
                            childAspectRatio: 100 / 155,
                          ),
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final e = recommend[index];
                            return ReportGestureDetector(
                              onTap: () {
                                homeDomain.reqAdClickCount(
                                  id: e['report_id'],
                                  type: e['report_type'],
                                );
                                CommonUtils.launchUrl(e['link_url']);
                              },
                              child: Column(
                                children: [
                                  SizedBox(
                                    width: 60.w,
                                    height: 60.w,
                                    child: MyImage.network(
                                      CommonUtils.getThumb(e),
                                      borderRadius: 14.w,
                                    ),
                                  ),
                                  SizedBox(height: 5.w),
                                  Text(
                                    e['title'],
                                    style: MyTheme.white15,
                                    maxLines: 1,
                                  )
                                ],
                              ),
                            );
                          })
                    ],
                  ),
            common.isEmpty
                ? const SizedBox.shrink()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20.w),
                      Text(
                        'hrgc'.tr(context: context),
                        style: MyTheme.yellow16w600,
                      ),
                      GridView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.symmetric(vertical: 10.w),
                          itemCount: common.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 15.w,
                            crossAxisSpacing: 30.w,
                            childAspectRatio: 100 / 30,
                          ),
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final e = common[index];
                            return ReportGestureDetector(
                              onTap: () {
                                homeDomain.reqAdClickCount(
                                    id: e['report_id'], type: e['report_type']);
                                CommonUtils.launchUrl(e['link_url']);
                              },
                              child: Row(
                                children: [
                                  SizedBox(
                                    height: 50.w,
                                    width: 50.w,
                                    child: MyImage.network(
                                      CommonUtils.getThumb(e),
                                      borderRadius: 25.w,
                                    ),
                                  ),
                                  SizedBox(width: 7.w),
                                  Text(
                                    e['title'],
                                    style: MyTheme.white15,
                                  )
                                ],
                              ),
                            );
                          })
                    ],
                  )
          ]),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _asyncValue.maybeWhen(
      error: (_, __) => NetworkErrorView(onTap: _initData),
      orElse: () => const LoadingView(),
      loading: (data) {
        if (data == null) return const LoadingView();
        return _buildDataView(data);
      },
      data: _buildDataView,
    );
  }
}
