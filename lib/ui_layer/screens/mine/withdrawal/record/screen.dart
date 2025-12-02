import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../domain/api_validator.dart';
import '../../../../../domain/domain.dart';
import '../../../../../domain/model/mine_withdrawal_record_model.dart';
import '../../../../utils/my_toast.dart';
import '../../../common_widgets/my_app_bar.dart';
import '../../../common_widgets/my_list_view.dart';
import '../../../common_widgets/screen_background.dart';
import '../../../theme.dart';

class MineWithdrawalRecordScreen extends StatefulWidget {
  const MineWithdrawalRecordScreen({super.key});

  @override
  State<MineWithdrawalRecordScreen> createState() =>
      _MineWithdrawalRecordScreenState();
}

class _MineWithdrawalRecordScreenState
    extends State<MineWithdrawalRecordScreen> {
  late final orderDomain = context.read<OrderDomain>();

  Future<List<MineWithdrawalRecord>> getCashWithdrawList({
    required int currentPage,
    required int limit,
  }) async {
    final res =
        await orderDomain.cashWithdrawList(page: currentPage, limit: limit);

    if (res.msg case final msg? when !res.isValid) {
      MyToast.showText(text: msg);
    }

    return res.data!;
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      child: Scaffold(
        appBar: MyAppBar(
          title: 'txjl'.tr(context: context),
        ),
        body: MyListView.list(
          itemBuilder: (context, item, index) {
            if (index == 0) {
              return Column(
                children: [
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
                    height: 30.w,
                    child: DefaultTextStyle(
                      textAlign: TextAlign.center,
                      style: MyTheme.white15,
                      child: Row(
                        children: [
                          Expanded(
                              child: Text(
                            'sj'.tr(context: context),
                            textAlign: TextAlign.left,
                          )),
                          Expanded(
                              child: Text(
                            'zt'.tr(context: context),
                            textAlign: TextAlign.center,
                          )),
                          Expanded(
                            child: Text(
                              'je2'.tr(context: context),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  MineAgentCashRecordItem(
                    data: item,
                  )
                ],
              );
            }
            return MineAgentCashRecordItem(
              data: item,
            );
          },
          onFetchingMore: (currentPage, pageSize) =>
              getCashWithdrawList(currentPage: currentPage, limit: pageSize),
        ),
      ),
    );
  }
}

class MineAgentCashRecordItem extends StatelessWidget {
  const MineAgentCashRecordItem({super.key, required this.data});
  final MineWithdrawalRecord data;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: MyTheme.pagePadding,
      ),
      height: 50.w,
      child: Column(
        children: [
          Expanded(
            child: DefaultTextStyle(
              textAlign: TextAlign.center,
              style: MyTheme.hexa3a2a2_12,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      flex: 2,
                      child: FittedBox(
                        child: Text(
                          data.updatedAt,
                          style: MyTheme.gray208_13,
                          maxLines: 1,
                          textAlign: TextAlign.left,
                        ),
                      )),
                  Expanded(
                      child: Center(
                    child: Text(data.statusStr,
                        textAlign: TextAlign.center,
                        style: (data.statusStr == '成功')
                            ? MyTheme.gray208_13
                            : MyTheme.hexff2a8a_12),
                  )),
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      width: 60.w,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          data.amount,
                          textAlign: TextAlign.center,
                          style: MyTheme.teal103224185_18_M,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 0.5,
            color: const Color.fromRGBO(31, 31, 31, 1),
          )
        ],
      ),
    );
  }
}
