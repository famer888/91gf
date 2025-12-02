import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
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
          itemBuilder: (context, item, index) {
            if (index == 0) {
              return Column(
                children: [
                  DefaultTextStyle(
                    textAlign: TextAlign.center,
                    style: MyTheme.white255_15,
                    child: Row(
                      children: [
                        Expanded(child: Text('tgm'.tr(context: context))),
                        Expanded(child: Text('sjh'.tr(context: context))),
                        Expanded(child: Text('zt'.tr(context: context))),
                        Expanded(child: Text('sj'.tr(context: context))),
                      ],
                    ),
                  ),
                  ShareRecordItem(data: item)
                ],
              );
            }
            return ShareRecordItem(data: item);
          },
          onFetchingMore: (currentPage, pageSize) =>
              _getData(currentPage: currentPage, limit: pageSize),
        ),
      ),
    );
  }
}

class ShareRecordItem extends StatelessWidget {
  const ShareRecordItem({super.key, required this.data});
  final ProxyInviteRecord data;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: MyTheme.pagePadding / 2.0),
      child: DefaultTextStyle(
        style: MyTheme.gray153_13,
        textAlign: TextAlign.center,
        child: Row(
          children: [
            Expanded(child: Text(data.affCode)),
            Expanded(child: Text(data.phone)),
            Expanded(child: Text(data.regStatus)),
            Expanded(child: Text(data.logDate, maxLines: 2)),
          ],
        ),
      ),
    );
  }
}
