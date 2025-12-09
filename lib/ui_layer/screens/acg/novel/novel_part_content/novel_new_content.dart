import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:jygf/domain/model/novel_model.dart';
import 'package:jygf/domain/remote_domain/domains/novel.dart';
import 'package:jygf/ui_layer/const.dart';
import 'package:jygf/ui_layer/screens/acg/novel/card/novel_item_card.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_app_bar.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_list_view.dart';
import 'package:jygf/ui_layer/screens/common_widgets/screen_background.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/ui_layer/utils/my_toast.dart';

///最新界面
class NovelNewContent extends StatefulWidget {

  const NovelNewContent({super.key});

  @override
  State<NovelNewContent> createState() => _NovelNewContentState();
}

class _NovelNewContentState extends State<NovelNewContent> {
  late final _domain = context.read<NovelDomain>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<List<NovelItemsModel>?> _getData(
      {required int page, required int pageSize}) async {
    final result = await _domain.novelNewList(
        page: page,
        limit: pageSize
    );

    if (result.status == 1) {
      return result.data;
    } else {
      MyToast.showText(text: result.msg ?? '');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      child: Scaffold(
          appBar: MyAppBar(title: 'zxpx'.tr(context: context)),
          body: MyListView.grid(
            childAspectRatio: UILayerConst.pictureRatio,
            contentPadding: 10.w,
            crossAxisCount: 3,
            padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
            itemBuilder: (context, item, index) => NovelItemCard(data: item),
            onFetchingMore: (currentPage, pageSize) => _getData(page: currentPage, pageSize: pageSize),
          )),
    );
  }
}