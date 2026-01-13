import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../domain/async_value.dart';
import '../../../../../domain/model/proxy_detail_model.dart';
import '../../../../../domain/remote_domain/domains/proxy.dart';
import '../../../../router/routes.dart';
import '../../../../utils/my_toast.dart';
import '../../../common_widgets/my_app_bar.dart';
import '../../../common_widgets/status/loading.dart';
import '../../../common_widgets/status/network_error.dart';
import '../../../image_paths.dart';
import '../../../theme.dart';
import 'package:jygf/report/ui_layer/report_gesture_detector.dart';


class MineAgentPromoteDataScreen extends StatefulWidget {
  const MineAgentPromoteDataScreen({super.key});

  @override
  State<MineAgentPromoteDataScreen> createState() =>
      _MineAgentPromoteDataScreenState();
}

class _MineAgentPromoteDataScreenState
    extends State<MineAgentPromoteDataScreen> {
  late final proxyDomain = context.read<ProxyDomain>();
  AsyncValue<ProxyDetail> _asyncValue = const AsyncInit();

  @override
  void initState() {
    _initData();
    super.initState();
  }

  Future _initData() async {
    if (_asyncValue.isLoading) return;
    setState(() {
      _asyncValue = const AsyncLoading();
    });

    final res = await proxyDomain.getProxyDetail();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: 'tgsj'.tr(context: context),
        rightWidget: ReportGestureDetector(
          onTap: () => const MineAgentProfitRoute().push(context),
          child: Text(
            'symx'.tr(context: context),
            style: MyTheme.gray15,
          ),
        ),
      ),
      body: _asyncValue.maybeWhen(
        orElse: () => const LoadingView(),
        error: (_, __) => NetworkErrorView(onTap: _initData),
        data: (data) {
          return ListView(
            padding: const EdgeInsets.all(18),
            children: [
              SizedBox(height: 20.w),
              _WithdrawalCard(data: data),
              SizedBox(height: 20.w),
              _PromoteDataArea(data: data),
            ],
          );
        },
      ),
    );
  }
}

class _WithdrawalCard extends StatelessWidget {
  const _WithdrawalCard({required this.data});

  final ProxyDetail data;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 141.w,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                MyImagePaths.appAgentDataHeaderbg,
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FractionallySizedBox(
                widthFactor: 0.7,
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                      children: [
                        Text(
                          'zsy'.tr(context: context),
                          style: TextStyle(
                            color:const Color.fromRGBO(255, 211, 211, 1),
                            fontSize: 11.sp,
                          ),
                        ),
                        SizedBox(height: 5.w),
                        Text(
                          data.allReward,
                          style: MyTheme.white24,
                        ),
                      ],
                    )),
                    Expanded(
                        child: Column(
                      children: [
                        Text(
                          'ktx'.tr(context: context),
                          style: TextStyle(
                            color:const Color.fromRGBO(255, 211, 211, 1),
                            fontSize: 11.sp,
                          ),
                        ),
                        SizedBox(height: 5.w),
                        Text(
                          data.money,
                          style: MyTheme.white24,
                        ),
                      ],
                    )),
                
                  ],
                ),
              ),
          Row(
            children: [
              _buildDataItem(
                context,
                label1: 'jrsy',
                label2: 'jrtgs',
                value1: data.today.reward,
                value2: data.today.invitedNum,
              ),
              Container(
                width: 1.w,
                height: 40.w,
                color: Colors.white.withOpacity(0.3),
                margin: EdgeInsets.symmetric(horizontal: 10.w),
              ),
              _buildDataItem(
                context,
                label1: 'dysy',
                label2: 'dytgs',
                value1: data.curMonth.reward,
                value2: data.curMonth.invitedNum,
              ),
            ],
          ),
            ],
          ),
        ),
        SizedBox(height: 20.w),
        ReportGestureDetector(
            onTap: () {
              const MineWithdrawalRoute(true).push(context);
            },
            child: Container(
            width: double.infinity,
            height: 40.w,
            decoration: BoxDecoration(
            gradient: MyTheme.gradient_90_114,
            borderRadius: BorderRadius.circular(29.w)),
            child: Center(child: Text('ljtx'.tr(),style: MyTheme.white15,)),
            ),

          ),
      ],
    );
  }

Widget _buildDataItem(
    BuildContext context, {
    required String label1,
    required String label2,
    required String value1,
    required String value2,
  }) {
    return Expanded(
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label1.tr(context: context), style: MyTheme.white11),
                SizedBox(height: 8.w),
                Text(label2.tr(context: context), style: MyTheme.white11),
              ],
            ),
            SizedBox(width: 8.w),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value1,
                  style: MyTheme.gold12.copyWith(fontSize: 11.sp),
                ),
                SizedBox(height: 8.w),
                Text(
                  value2,
                  style: MyTheme.gold12.copyWith(fontSize: 11.sp),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}

class _PromoteDataArea extends StatelessWidget {
  const _PromoteDataArea({required this.data});
  final ProxyDetail data;

  Widget _statItem(String title, num? value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.tr(),
            style: MyTheme.white07_12,
          ),
          SizedBox(height: 5.w),
          Text(
            (value ?? 0).toStringAsFixed(2),
            style: MyTheme.gold18M.copyWith(fontSize: 24.sp),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'tgztj'.tr(context: context),
          style: MyTheme.white255_18_M,
        ),
        SizedBox(height: 10.w),
        Row(
          children: [
            _statItem('ljysh', data.directProxyNum),
            _statItem('ljffyh', data.directPayNum),
          ],
        ),
      ],
    );
  }
}
