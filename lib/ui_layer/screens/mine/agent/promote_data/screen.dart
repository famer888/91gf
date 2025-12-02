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
import '../../../common_widgets/my_image.dart';
import '../../../common_widgets/status/loading.dart';
import '../../../common_widgets/status/network_error.dart';
import '../../../image_paths.dart';
import '../../../theme.dart';

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
        rightWidget: GestureDetector(
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
              _WithdrawalCard(data: data),
              SizedBox(height: 20.w),
              _DataArea(data: data),
              SizedBox(height: 40.w),
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
    return Container(
      height: 157.w,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            MyImagePaths.appDlPenal,
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            children: [
              Expanded(
                  child: Column(
                children: [
                  Text(
                    'ktx'.tr(context: context),
                    style: MyTheme.brown1187551_12_semi,
                  ),
                  SizedBox(height: 5.w),
                  Text(
                    data.money,
                    style: MyTheme.brown1187551_24_semi,
                  ),
                ],
              )),
              Container(
                width: 0.5.w,
                height: 45.w,
                color: const Color(0xffba957d),
              ),
              Expanded(
                  child: Column(
                children: [
                  Text(
                    'zsy'.tr(context: context),
                    style: MyTheme.brown1187551_12_semi,
                  ),
                  SizedBox(height: 5.w),
                  Text(
                    data.allReward,
                    style: MyTheme.brown1187551_24_semi,
                  ),
                ],
              ))
            ],
          ),
          GestureDetector(
            onTap: () {
              const MineWithdrawalRoute(true).push(context);
            },
            child: MyImage.asset(
              MyImagePaths.appLjtx,
              fit: BoxFit.cover,
              width: 216.w,
              height: 35.w,
            ),
          ),
        ],
      ),
    );
  }
}

class _DataArea extends StatelessWidget {
  const _DataArea({required this.data});

  final ProxyDetail data;

  Widget _tile(String title, String data) {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          data,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          title.tr(),
          style: MyTheme.white12medium,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 24.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(5.w),
      ),
      child: GridView.count(
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        shrinkWrap: true,
        childAspectRatio: 190 / 65.0,
        mainAxisSpacing: 26.w,
        crossAxisSpacing: 50.w,
        children: [
          _tile('dysy', data.curMonth.reward),
          _tile('dytgs', data.curMonth.invitedNum),
          _tile('jrsy', data.today.reward),
          _tile('jrtgs', data.today.invitedNum),
        ],
      ),
    );
  }
}

class _PromoteDataArea extends StatelessWidget {
  const _PromoteDataArea({required this.data});
  final ProxyDetail data;

  Widget _tile(String title, String data) {
    return Container(
        padding: EdgeInsets.only(top: 10.w, bottom: 10.w, right: 40.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title.tr(),
              style: MyTheme.hexffdbb2_13,
            ),
            Text(
              data,
              style: MyTheme.white255_15_M,
            ),
          ],
        ));
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
        _tile('ljysh', '${data.directProxyNum}'),
        _tile('ljffyh', '${data.directPayNum}'),
      ],
    );
  }
}
