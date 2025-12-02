import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../domain/api_validator.dart';
import '../../../../../domain/domain.dart';
import '../../../../../domain/model/income_detail_data_model.dart';
import '../../../../utils/common_utils.dart';
import '../../../../utils/my_toast.dart';
import '../../../common_widgets/my_list_view.dart';
import '../../../theme.dart';

class IncomeDetailView extends StatefulWidget {
  const IncomeDetailView({super.key, this.source = ''});
  final String source;

  @override
  State<IncomeDetailView> createState() => _IncomeDetailViewState();
}

class _IncomeDetailViewState extends State<IncomeDetailView> {
  late final _userDomain = context.read<UserDomain>();
  String _lastIx = '';

  Future<List<MineIncomeDetail>> _getData({
    required int currentPage,
    required int limit,
  }) async {
    final result = await _userDomain.earnTotalInfo(
      limit: limit,
      page: currentPage,
      lastIx: currentPage == 1 ? '' : _lastIx,
      source: widget.source,
    );

    _lastIx = result.data?.lastIx ?? '';

    if (result.msg case final msg? when !result.isValid) {
      MyToast.showText(text: msg);
    }

    return result.data!.list!;
  }

  @override
  Widget build(BuildContext context) {
    return MyListView.list(
      padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
      itemBuilder: (context, item, index) => MineIncomeDetailItem(
        data: item,
      ),
      onFetchingMore: (currentPage, pageSize) =>
          _getData(currentPage: currentPage, limit: pageSize),
    );
  }
}

class MineIncomeDetailItem extends StatelessWidget {
  const MineIncomeDetailItem({super.key, required this.data});
  final MineIncomeDetail data;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 62.w,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(data.sourceMember?.nickname ?? '',
                                  style: MyTheme.white255_13_M),
                              Expanded(
                                  child: Text('·${data.desc ?? ''}',
                                      style: MyTheme.graya3a2a2_11_M))
                            ],
                          ),
                          SizedBox(height: 7.w),
                          Text(
                              RelativeDateFormat.format(
                                  date: DateTime.parse(data.createdAt ?? '')),
                              style: MyTheme.graya3a2a2_12),
                        ],
                      ),
                    ],
                  ),
                ),
                Text('+${data.coinCnt ?? 0}${'jb'.tr(context: context)}',
                    style: MyTheme.blue80_13_M)
              ],
            ),
          ),
          Row(
            children: [
              SizedBox(width: 44.w),
              Expanded(
                child: Container(
                  height: 0.5.w,
                  color: const Color.fromRGBO(255, 255, 255, 0.1),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
