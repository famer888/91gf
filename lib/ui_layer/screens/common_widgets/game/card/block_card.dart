import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/domain/model/game/game_model.dart';
import 'package:jygf/domain/model/game/game_section/game_section_model.dart';
import 'package:jygf/domain/remote_domain/domains/game.dart';
import 'package:jygf/ui_layer/screens/common_widgets/game/card/game_card.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jygf/ui_layer/screens/image_paths.dart';
import 'package:jygf/ui_layer/utils/my_toast.dart';
import 'package:provider/provider.dart';

import '../../../../router/routes.dart';
import '../../../theme.dart';
import 'package:jygf/report/ui_layer/report_gesture_detector.dart';

class GameBlockCard extends StatefulWidget {
  const GameBlockCard({super.key, required this.data});

  final GameSectionGameModel data;

  @override
  State<GameBlockCard> createState() => _GameBlockCardState();
}

class _GameBlockCardState extends State<GameBlockCard> {
  late final _domain = context.read<GameDomain>();
  int page = 1;

  @override
  Widget build(BuildContext context) {
    if (widget.data.items.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 4.w,
              height: 17.w,
              decoration: BoxDecoration(
                gradient: MyTheme.topToBottomGradient,
                borderRadius: BorderRadius.circular(2.w),
              ),
            ),
            SizedBox(width: 6.w),
            Text(widget.data.title, style: MyTheme.white15bold),
            const Spacer(),
            ReportGestureDetector(
                onTap: () {
                  GameMoreRoute(widget.data.value, widget.data.title).push(context);
                  // CommonUtils.openRoute(context, data)
                  // String ss =
                  //     '/gameMore/${widget.data.value}/${widget.data.title}';

                  // // ss = '/gameNav/new/最新';
                  // context.push(ss);
                },
                child: Text(
                  'gd'.tr(),
                  style: MyTheme.white04_12,
                ))
          ],
        ),
        GridView.builder(
          padding: EdgeInsets.only(top: 10.w),
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 5.w,
            crossAxisSpacing: 10.w,
            childAspectRatio: GameCard.aspectRatio,
          ),
          itemCount: widget.data.items.length,
          scrollDirection: Axis.vertical,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            GameModel model = widget.data.items[index];
            return GameCard(data: model);
          },
        ),
        widget.data.items.isEmpty
            ? Container()
            : Container(
                padding: EdgeInsets.only(top: MyTheme.pagePadding, bottom: 10.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ReportGestureDetector(
                      onTap: _getData,
                      child: Container(
                        width: 150.w,
                        height: 35.w,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: MyTheme.gradient_90_135_colors),
                          borderRadius: BorderRadius.circular(18.w),
                        ),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 23.w,
                              height: 23.w,
                              child: MyImage.asset(MyImagePaths.appHyh, width: 23.w, height: 23.w),
                            ),
                            SizedBox(width: 3.w),
                            Text('hyh'.tr(), style: MyTheme.white14.w500),
                          ],
                        ),
                      ),
                    ),
                    ReportGestureDetector(
                      onTap: () {
                        GameMoreRoute(widget.data.value, widget.data.title).push(context);
                      },
                      child: Container(
                        width: 150.w,
                        height: 35.w,
                        decoration: BoxDecoration(gradient: MyTheme.dhButtonGradient, borderRadius: BorderRadius.circular(18.w)),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 23.w,
                              height: 23.w,
                              child: MyImage.asset(MyImagePaths.appMore, width: 23.w, height: 23.w),
                            ),
                            SizedBox(width: 3.w),
                            Text('ckgd'.tr(), style: MyTheme.white14.w500),
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
    int limit = widget.data.items.length;
    if (limit <= 6) {
      limit = 6;
    }
    final result = await _domain.gameMore(sort: widget.data.value, page: page, limit: limit);

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
