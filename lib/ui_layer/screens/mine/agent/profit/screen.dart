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
          contentPadding: 0,
          itemBuilder: (context, item, index) {
            if (index == 0) {
              return Column(
                children: [
                  SizedBox(height: 10.w),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10.w),
                    decoration: BoxDecoration(
                      color: MyTheme.white02Color,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.w),
                        topRight: Radius.circular(10.w),
                      ),
                    ),
                    child: DefaultTextStyle(
                      textAlign: TextAlign.center,
                      style: MyTheme.white255_15,
                      child:const Row(
                        children: [
                          Expanded(child: Text('用户')),
                          Expanded(child: Text('类型')),
                          Expanded(child: Text('收益')),
                          Expanded(child: Text('时间')),
                        ],
                      ),
                    ),
                  ),
                  ProfitRecordItem(data: item, index: index),
                ],
              );
            }
            return ProfitRecordItem(data: item, index: index);
          },
          onFetchingMore: (currentPage, pageSize) =>
              getProxyProfitList(currentPage: currentPage, limit: pageSize),
        ),
      ),
    );
  }
}

class ProfitRecordItem extends StatelessWidget {
  const ProfitRecordItem({super.key, required this.data, required this.index});
  final ProxyProfit data;
  final int index;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = index % 2 == 1
        ? MyTheme.white015Color
        : MyTheme.white008Color;

    String getTypeText() {
      return switch (data.source) {
        ProxyProfitSource.withdrawal => 'tx'.tr(context: context),
        ProxyProfitSource.refundWithdrawal => 'txtk'.tr(context: context),
        ProxyProfitSource.agentCommission => 'dlfc'.tr(context: context),
        _ => '',
      };
    }

    String getAmountText() {
      final prefix = switch (data.type) {
        ProxyProfitType.income => '+',
        ProxyProfitType.expenditure => '-',
        _ => '',
      };
      return '$prefix${data.amount}';
    }

    return Container(
      padding: EdgeInsets.symmetric(vertical: 13.w),
      decoration: BoxDecoration(
        color: backgroundColor,
      ),
      child: DefaultTextStyle(
        style: MyTheme.white255_13,
        textAlign: TextAlign.center,
        child: Row(
          children: [
            Expanded(
              child: Text(
                data.nickName ?? '',
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(child: Text(getTypeText())),
            Expanded(
              child: Text(
                getAmountText(),
                style: data.type == ProxyProfitType.income
                    ? MyTheme.red13
                    : MyTheme.green0_13_M,
              ),
            ),
            Expanded(
              child: Text(
                data.createdAt ?? '',
                style: MyTheme.gray153_12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
