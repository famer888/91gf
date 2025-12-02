import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../domain/api_validator.dart';
import '../../../../../domain/domain.dart';
import '../../../../../domain/model/proxy_profit_model.dart';
import '../../../../utils/my_toast.dart';
import '../../../common_widgets/my_app_bar.dart';
import '../../../common_widgets/my_list_view.dart';
import '../../../common_widgets/screen_background.dart';
import '../../../theme.dart';

class MineAgentProfitScreen extends StatefulWidget {
  const MineAgentProfitScreen({super.key});

  @override
  State<MineAgentProfitScreen> createState() => _MineAgentProfitScreenState();
}

class _MineAgentProfitScreenState extends State<MineAgentProfitScreen> {
  late final appDomain = context.read<ProxyDomain>();

  Future<List<ProxyProfit>> getProxyProfitList({
    required int currentPage,
    required int limit,
  }) async {
    final result =
        await appDomain.getProxyProfitList(page: currentPage, limit: limit);
    if (!result.isValid) {
      MyToast.showText(text: result.msg!);
    }
    return result.data!;
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      child: Scaffold(
        appBar: MyAppBar(
          title: 'yjmx'.tr(context: context),
        ),
        body: MyListView.list(
          padding: EdgeInsets.zero,
          itemBuilder: (context, item, index) => _Tile(data: item),
          onFetchingMore: (currentPage, pageSize) =>
              getProxyProfitList(currentPage: currentPage, limit: pageSize),
        ),
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({required this.data});
  final ProxyProfit data;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(
              horizontal: MyTheme.pagePadding, vertical: 13.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${data.nickName}',
                    style: MyTheme.white244_16,
                  ),
                  Text(
                    ("${switch (data.type) {
                      ProxyProfitType.income => "+",
                      ProxyProfitType.expenditure => "-",
                      _ => ''
                    }}${data.amount}"),
                    style: MyTheme.teal103224185_20_M,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    switch (data.source) {
                      ProxyProfitSource.withdrawal => 'tx'.tr(context: context),
                      ProxyProfitSource.refundWithdrawal =>
                        'txtk'.tr(context: context),
                      ProxyProfitSource.agentCommission =>
                        'dlfc'.tr(context: context),
                      _ => ''
                    },
                    style: MyTheme.gray153_12,
                  ),
                  Text(
                    '${data.createdAt}',
                    style: MyTheme.gray153_12,
                  ),
                ],
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
          height: 0.5.w,
          color: const Color.fromRGBO(21, 21, 42, 1),
        )
      ],
    );
  }
}
