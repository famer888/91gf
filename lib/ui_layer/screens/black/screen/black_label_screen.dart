import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/domain/remote_domain/domains/black_domain.dart';
import 'package:jygf/ui_layer/screens/black/model/black_model.dart';
import 'package:jygf/ui_layer/screens/black/widgets/black_item_widget.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_app_bar.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_list_view.dart';
import 'package:jygf/ui_layer/screens/common_widgets/screen_background.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/ui_layer/utils/my_toast.dart';
import 'package:provider/provider.dart';

class BlackLabelScreen extends StatefulWidget {
  final String tag;
  const BlackLabelScreen({super.key, required this.tag});

  @override
  State<BlackLabelScreen> createState() => _BlackLabelScreenState();
}

class _BlackLabelScreenState extends State<BlackLabelScreen> {
  late final _screenUtils = ScreenUtil();
  late final _blockDomain = context.read<BlackDomain>();

  @override
  void dispose() {
    super.dispose();
  }

  Future<List<BlackListItemModel>?> _getBlackLabelList({int page = 1, int limit = 10}) async {
    final res = await _blockDomain.getBlackLabelList(tag: widget.tag, page: page, limit: limit);
    if (res.status == 1) {
      final data = res.data;
      if (data != null) {
        return data.list;
      } else {
        return [];
      }
    } else {
      MyToast.showText(text: res.msg ?? '');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      child: Scaffold(
        appBar: MyAppBar(title: widget.tag),
        body: MyListView.list(
          padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding, vertical: 8.w),
          itemBuilder: (context, item, index) => Container(
            padding: EdgeInsets.only(bottom: 12.w),
            child: BlackItemWidget(item: item, itemWidth: (_screenUtils.screenWidth - MyTheme.pagePadding * 2)),
          ),
          isNeedMore: true,
          onFetchingMore: (currentPage, pageSize) {
            final res = _getBlackLabelList(page: currentPage, limit: pageSize);
            return res;
          },
        ),
      ),
    );
  }
}
