import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:jygf/domain/model/comic_model.dart';
import 'package:jygf/domain/remote_domain/domains/comic.dart';
import 'package:jygf/ui_layer/const.dart';
import 'package:jygf/ui_layer/router/routes.dart';
import 'package:jygf/ui_layer/screens/acg/comic/card/comic_item_card.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jygf/ui_layer/screens/image_paths.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/ui_layer/utils/common_utils.dart';
import 'package:jygf/ui_layer/utils/my_toast.dart';

class ComicReItemCard extends StatefulWidget {
  const ComicReItemCard({super.key, required this.data});

  final RecComicModel data;

  @override
  State<ComicReItemCard> createState() => _ComicReItemCardState();
}

class _ComicReItemCardState extends State<ComicReItemCard> {
  String get imageUrl => CommonUtils.getThumb(widget.data.toJson());
  late final _domain = context.read<ComicDomain>();
  int page = 1;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min, // 让 Column 高度自适应
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 10.w),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              widget.data.title ?? '',
              style: MyTheme.white15_M,
            ),
            GestureDetector(
              onTap: () {
                //更多点击
                MoreComicRoute(widget.data).push(context);
              },
              child: Text(
                'gd'.tr(context: context),
                style: MyTheme.white04_12,
              ),
            )
          ]),
        ),
        (widget.data.items?.isEmpty ?? false)
            ? Container()
            : Flexible(
                fit: FlexFit.loose, // 允许子组件根据内容大小调整高度
                child: GridView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.data.items!.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: UILayerConst.comicRatio,
                      mainAxisSpacing: 10.w,
                      crossAxisSpacing: 10.w,
                    ),
                    itemBuilder: (context, index) {
                      final partsItem = widget.data.items?[index];
                      return ComicItemCard(data: partsItem!);
                    }),
              ),
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(top: MyTheme.pagePadding, bottom: 10.w),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  //换一换
                  _getData();
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: MyTheme.white008Color,
                      borderRadius: BorderRadius.all(Radius.circular(5.w))),
                  alignment: Alignment.center,
                  width: (1.sw - MyTheme.pagePadding * 2 - 8.w) / 2,
                  height: 35.w,
                  child:
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MyImage.asset(MyImagePaths.appChangeIcon, width: 16.w, height: 16.w),
                      SizedBox(width: 5.w),
                      Text('hyh'.tr(context: context), style: MyTheme.white14),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              GestureDetector(
                onTap: () {
                  //查看更多
                  MoreComicRoute(widget.data).push(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: MyTheme.white008Color,
                      borderRadius: BorderRadius.all(Radius.circular(5.w))),
                  alignment: Alignment.center,
                  width: (1.sw - MyTheme.pagePadding * 2 - 8.w) / 2,
                  height: 35.w,
                  child:
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MyImage.asset(MyImagePaths.appMoreIcon, width: 16.w, height: 16.w),
                      SizedBox(width: 5.w),
                      Text('ckgd'.tr(context: context), style: MyTheme.white14),
                    ],
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  //换一换
  Future<void> _getData() async {
    page++;
    int limit = widget.data.items?.length ?? 0;
    if (limit <= 6) { limit = 6; }
    final result = await _domain.comicMoreChangeList(
        sort: widget.data.value ?? '', page: page, limit: limit);

    if (result.status == 1) {
      final tp = result.data ?? [];
      if (tp.isEmpty) {
        page = 1;
      } else {
        widget.data.items = tp;
      }
    } else {
      MyToast.showText(text: result.msg ?? '');
    }

    setState(() {});
  }
}
