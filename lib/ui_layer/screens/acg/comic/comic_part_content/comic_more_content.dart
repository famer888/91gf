import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:jygf/domain/model/comic_model.dart';
import 'package:jygf/domain/remote_domain/domains/comic.dart';
import 'package:jygf/ui_layer/const.dart';
import 'package:jygf/ui_layer/screens/acg/comic/card/comic_item_card.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_app_bar.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_list_view.dart';
import 'package:jygf/ui_layer/screens/common_widgets/screen_background.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/ui_layer/utils/my_toast.dart';

class ComicMoreContent extends StatefulWidget {
  const ComicMoreContent({super.key, required this.data});

  final RecComicModel data;

  @override
  State<ComicMoreContent> createState() => _ComicMoreContentState();
}

class _ComicMoreContentState extends State<ComicMoreContent> {
  late final _domain = context.read<ComicDomain>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<List<ComicItemsModel>?> _getData(
      {required String sort, required int page, required int pageSize}) async {
    final result = await _domain.comicMoreChangeList(
      sort: sort,
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
          appBar: MyAppBar(title: widget.data.title),
          body: MyListView.grid(
            childAspectRatio: UILayerConst.comicRatio,
            contentPadding: 10.w,
            crossAxisCount: 3,
            padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
            itemBuilder: (context, item, index) => ComicItemCard(data: item),
            onFetchingMore: (currentPage, pageSize) => _getData(
                sort: widget.data.value ?? '', page: currentPage, pageSize: pageSize),
          )),
    );
  }
}