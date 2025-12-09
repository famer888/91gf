import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:jygf/domain/model/bit_nav_model.dart';
import 'package:jygf/domain/model/home_data_model.dart';
import 'package:jygf/domain/model/novel_model.dart';
import 'package:jygf/domain/remote_domain/domains/novel.dart';
import 'package:jygf/ui_layer/const.dart';
import 'package:jygf/ui_layer/notifiers/home_config_notifier.dart';
import 'package:jygf/ui_layer/screens/acg/novel/card/novel_item_card.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_app_bar.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_list_view.dart';
import 'package:jygf/ui_layer/screens/common_widgets/screen_background.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/ui_layer/utils/my_toast.dart';

///分类界面
class NovelSortContent extends StatefulWidget {
  const NovelSortContent({super.key});

  @override
  State<NovelSortContent> createState() => _NovelSortContentState();
}

class _NovelSortContentState extends State<NovelSortContent> {
  late final _domain = context.read<NovelDomain>();
  late final _homeConfig = context.read<HomeConfigNotifier>();
  late final novelTypeNavs = _homeConfig.config.novelTypeNav ?? [];

  Map _filterTempMap = {
    'theme_id': 'all',
    'end': 'all',
    'sort': 'all',
  };

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
    final result = await _domain.novelTypeList(
        themeId: _filterTempMap['theme_id'],
        end: _filterTempMap['end'],
        sort: _filterTempMap['sort'],
        page: page,
        limit: pageSize);

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
          appBar: MyAppBar(title: 'fl'.tr(context: context)),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
            child: Column(
              children: [
                ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: novelTypeNavs.length,
                    itemBuilder: (context, index) {
                      ComicTypeNav itemModel = novelTypeNavs[index];
                      List items = List.from(itemModel.items);
                      return SizedBox(
                        height: 40.w,
                        child: Row(
                          children: [
                            Text(itemModel.title, style: MyTheme.white15bold),
                            SizedBox(width: 30.w),
                            Expanded(
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: items.length,
                                    itemBuilder: (context, iIndex) {
                                      BitNavModel item = items[iIndex];
                                      return GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        onTap: () {
                                          if (_filterTempMap[itemModel.value] ==
                                              item.value) {
                                          } else {
                                            _filterTempMap[itemModel.value] =
                                                item.value;
                                            _getData(page: 1, pageSize: 15);
                                          }
                                          setState(() {});
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(right: 30.w),
                                          child: Center(
                                            child: FittedBox(
                                              child: Text(
                                                item.title ?? '',
                                                style: _filterTempMap[
                                                            itemModel.value] ==
                                                        item.value
                                                    ? MyTheme.jellyCyan_15
                                                    : MyTheme.white08_15, 
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }))
                          ],
                        ),
                      );
                    }),
                SizedBox(height: 5.w),
                Expanded(
                  child: MyListView.grid(
                    key: UniqueKey(),
                    childAspectRatio: UILayerConst.pictureRatio,
                    contentPadding: 10.w,
                    crossAxisCount: 3,
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, item, index) =>
                        NovelItemCard(data: item),
                    onFetchingMore: (currentPage, pageSize) =>
                        _getData(page: currentPage, pageSize: pageSize),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
