import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:jygf/domain/model/album_model.dart';
import 'package:jygf/domain/remote_domain/domains/album.dart';
import 'package:jygf/ui_layer/const.dart';
import 'package:jygf/ui_layer/screens/yellow_picture/card/yellow_picture_item_card.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_app_bar.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_list_view.dart';
import 'package:jygf/ui_layer/screens/common_widgets/screen_background.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/ui_layer/utils/my_toast.dart';

class PictureMoreContent extends StatefulWidget {
  const PictureMoreContent({super.key, required this.data});

  final RecAlbumModel data;

  @override
  State<PictureMoreContent> createState() => _PictureMoreContentState();
}

class _PictureMoreContentState extends State<PictureMoreContent> {
  late final _domain = context.read<AlbumDomain>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<List<AlbumItemsModel>?> _getData(
      {required int page, required int pageSize}) async {
    final result = await _domain.albumMoreList(
        sort: widget.data.value ?? 'rec',
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
            childAspectRatio: UILayerConst.pictureRatio,
            contentPadding: 10.w,
            crossAxisCount: 3,
            padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
            itemBuilder: (context, item, index) => YellowPictureItemCard(data: item),
            onFetchingMore: (currentPage, pageSize) => _getData(page: currentPage, pageSize: pageSize),
          )),
    );
  }
}