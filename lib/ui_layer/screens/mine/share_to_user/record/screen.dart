import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../domain/api_validator.dart';
import '../../../../../domain/domain.dart';
import '../../../../../domain/model/proxy_invite_record_model.dart';
import '../../../../router/routes.dart';
import '../../../../utils/my_toast.dart';
import '../../../common_widgets/my_app_bar.dart';
import '../../../common_widgets/my_list_view.dart';
import '../../../common_widgets/screen_background.dart';
import '../../../theme.dart';

class MineShareToUserRecordScreen extends StatefulWidget {
  const MineShareToUserRecordScreen({super.key});

  @override
  State<MineShareToUserRecordScreen> createState() =>
      _MineShareToUserRecordScreenState();
}

class _MineShareToUserRecordScreenState
    extends State<MineShareToUserRecordScreen> {
  late final _domain = context.read<ProxyDomain>();

  Future<List<ProxyInviteRecord>> _getData({
    required int currentPage,
    required int limit,
  }) async {
    final result = await _domain.getProxyInviteRecord(
      currentPage: currentPage,
      limit: limit,
    );

    if (result.msg case final msg? when !result.isValid) {
      MyToast.showText(text: msg);
    }

    return result.data!.list;
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      child: Scaffold(
        appBar: MyAppBar(
          title: 'yqjl'.tr(context: context),
          rightWidget: GestureDetector(
            onTap: () => const MineCustomerServiceRoute().push(context),
            child: Text(
              'lxkf'.tr(context: context),
              style: MyTheme.gray15,
            ),
          ),
        ),
        body: MyListView.list(
          contentPadding: 0,
          itemBuilder: (context, item, index) {
            if (index == 0) {
              return Column(
                children: [
                  SizedBox(height: 10.w),
                  Text('yqjlsyjz'.tr(context: context), style: MyTheme.white_13),
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
                      child: Row(
                        children: [
                          Expanded(child: Text('tgm'.tr(context: context))),
                          Expanded(child: Text('sjh'.tr(context: context))),
                          Expanded(child: Text('zt'.tr(context: context))),
                        ],
                      ),
                    ),
                  ),
                  ShareRecordItem(data: item, index: index)
                ],
              );
            }
            return ShareRecordItem(data: item, index: index);
          },
          onFetchingMore: (currentPage, pageSize) =>
              _getData(currentPage: currentPage, limit: pageSize),
        ),
      ),
    );
  }
}

class ShareRecordItem extends StatelessWidget {
  const ShareRecordItem({super.key, required this.data, required this.index});
  final ProxyInviteRecord data;
  final int index;
  @override
  Widget build(BuildContext context) {
    final backgroundColor = index % 2 == 1 
        ? MyTheme.white015Color 
        : MyTheme.white008Color;
    
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
            Expanded(child: Text(data.affCode)),
            Expanded(child: Text(data.phone)),
            Expanded(child: Text(data.regStatus,style:data.regStatus == '已注册' ? MyTheme.green0_13_M : MyTheme.red13,)),
          ],
        ),
      ),
    );
  }
}
