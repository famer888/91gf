import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../domain/async_value.dart';
import '../../../../domain/domain.dart';
import '../../../../domain/model/official_group_model.dart';
import '../../../utils/common_utils.dart';
import '../../../utils/my_toast.dart';
import '../../common_widgets/my_app_bar.dart';
import '../../common_widgets/my_image.dart';
import '../../common_widgets/screen_background.dart';
import '../../common_widgets/status/loading.dart';
import '../../image_paths.dart';
import '../../theme.dart';
import 'package:jygf/report/ui_layer/report_gesture_detector.dart';


class MineOfficialGroupScreen extends StatefulWidget {
  const MineOfficialGroupScreen({super.key});

  @override
  State<MineOfficialGroupScreen> createState() =>
      _MineOfficialGroupScreenState();
}

class _MineOfficialGroupScreenState extends State<MineOfficialGroupScreen> {
  late final homeDomain = context.read<HomeDomain>();
  AsyncValue<List<OfficeContact>> _asyncValue = const AsyncInit();

  @override
  void initState() {
    _init();
    super.initState();
  }

  Future _init() async {
    final res = await homeDomain.getContactList();
    if (res.data?.officeContact?.data case final data?) {
      _asyncValue = AsyncData(data);
      if (mounted) {
        setState(() {});
      }
    } else if (mounted) {
      MyToast.showText(text: 'sjkzs'.tr());
      context.pop();
    }
  }

  Widget _contactItem({required OfficeContact itemData}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '${itemData.name}',
          style: MyTheme.white255_18_M,
        ),
        SizedBox(height: 8.w),
        Text('${itemData.decs}', style: MyTheme.gray95_12),
        Container(
          margin: EdgeInsets.only(
            top: 11.5.w,
            bottom: 20.w,
          ),
          padding: EdgeInsets.all(15.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.w),
            color: const Color.fromRGBO(255, 255, 255, 0.1),
          ),
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: (itemData.list ?? [])
                .map<Widget>((value) => AppInfo(
                      info: value,
                    ))
                .toList(),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      child: Scaffold(
        appBar: MyAppBar(
          title: 'jqkc'.tr(context: context),
        ),
        body: _asyncValue.maybeWhen(
            orElse: () => const LoadingView(),
            data: (data) {
              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: MyTheme.pagePadding,
                  vertical: 30.w,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: data.map((e) => _contactItem(itemData: e)).toList(),
                ),
              );
            }),
      ),
    );
  }
}

class AppInfo extends StatelessWidget {
  const AppInfo({super.key, required this.info});
  final Contact info;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              MyImage.asset(
                info.type == 'Telegram'
                    ? MyImagePaths.appWdLxtgN
                    : MyImagePaths.appWdLxpotao,
                width: 38.8.w,
                height: 38.8.w,
              ),
              SizedBox(width: 13.w),
              Flexible(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${info.name}',
                    style: MyTheme.white255_15_M,
                  ),
                  Text(
                    '${info.decs}',
                    style: MyTheme.gray150_12,
                  ),
                ],
              ))
            ],
          )),
          ReportGestureDetector(
            onTap: () {
              CommonUtils.launchUrl(info.url ?? '');
            },
            child: Container(
              height: 24.w,
              width: 58.w,
              decoration: BoxDecoration(
                gradient: MyTheme.gradient_90_118,
                borderRadius: BorderRadius.circular(4.w),
              ),
              child: Center(
                child: Text(
                  'ljjr'.tr(context: context),
                  style: MyTheme.white11,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
