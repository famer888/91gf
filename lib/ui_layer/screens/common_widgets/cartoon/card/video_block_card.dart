import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:jygf/domain/model/cartoon/cartoon_section_model.dart';
import 'package:jygf/domain/model/cartoon/cartoon_model.dart';
import 'package:jygf/domain/remote_domain/domains/cartoon.dart';
import 'package:jygf/ui_layer/screens/common_widgets/cartoon/card/video_card.dart';
import 'package:jygf/ui_layer/utils/my_toast.dart';
import '../../../../router/routes.dart';
import '../../../theme.dart';

class CartoonVideoBlockCard extends StatefulWidget {
  const CartoonVideoBlockCard({super.key, required this.data});

  final CartoonSectionVideoModel data;

  @override
  State<CartoonVideoBlockCard> createState() => _CartoonVideoBlockCardState();
}

class _CartoonVideoBlockCardState extends State<CartoonVideoBlockCard> {
  late final _domain = context.read<CartoonDomain>();
  int page = 1;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 4.w,
              height: 17.w,
              decoration: BoxDecoration(
                  // gradient: MyTheme.topToBottomGradient,
                  borderRadius: BorderRadius.circular(2.w)),
            ),
            SizedBox(width: 6.w),
            Text(
              widget.data.title,
              style: MyTheme.white15bold,
            ),
            const Spacer(),
            GestureDetector(
                onTap: () {
                  CartoonMoreRoute(
                          widget.data.value, widget.data.title)
                      .push(context);
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
            childAspectRatio: CartoonVideoCard.aspectRatio,
          ),
          itemCount: widget.data.items.length,
          scrollDirection: Axis.vertical,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            CartoonModel model = widget.data.items[index];
            return CartoonVideoCard(data: model);
          },
        ),
        widget.data.items.isEmpty
            ? Container()
            : Container(
                padding:
                    EdgeInsets.only(top: MyTheme.pagePadding, bottom: 10.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: _getData,
                      child: Container(
                        width: 150.w,
                        height: 30.w,
                        decoration: BoxDecoration(
                            color: MyTheme.white008Color,
                            borderRadius: BorderRadius.circular(15.w)),
                        alignment: Alignment.center,
                        child: Text(
                          'hyh'.tr(),
                          style: MyTheme.white12,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        CartoonMoreRoute(
                                widget.data.value, widget.data.title)
                            .push(context);
                      },
                      child: Container(
                        width: 150.w,
                        height: 30.w,
                        decoration: BoxDecoration(
                            color: MyTheme.white008Color,
                            borderRadius: BorderRadius.circular(15.w)),
                        alignment: Alignment.center,
                        child: Text(
                          'ckgd'.tr(),
                          style: MyTheme.white12,
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
    final result = await _domain.cartoonMore(
        sort: widget.data.value, page: page, limit: widget.data.items.length);

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
