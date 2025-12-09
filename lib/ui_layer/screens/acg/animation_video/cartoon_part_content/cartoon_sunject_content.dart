import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/domain/model/cartoon/cartoon_model.dart';
import 'package:jygf/domain/model/live_model.dart';
import 'package:jygf/domain/remote_domain/domains/cartoon.dart';
import 'package:jygf/ui_layer/router/routes.dart';
import 'package:jygf/ui_layer/screens/common_widgets/cartoon/card/video_card.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_app_bar.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_avatar.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_list_view.dart';
import 'package:jygf/ui_layer/screens/common_widgets/screen_background.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/ui_layer/utils/common_utils.dart';
import 'package:jygf/ui_layer/utils/my_toast.dart';
import 'package:provider/provider.dart';

class CartoonSubjectContent extends StatefulWidget {
  const CartoonSubjectContent({super.key});

  @override
  State<CartoonSubjectContent> createState() => _CartoonSubjectContentState();
}

class _CartoonSubjectContentState extends State<CartoonSubjectContent> {
  late final _appDomain = context.read<CartoonDomain>();

  bool isInit = false;
  List<TipModel> tips = [];

  @override
  void initState() {
    super.initState();

    _getData(page: 1, pageSize: 15);
  }

  Future<List<CartoonModel>?> _getData({
    required int page,
    required int pageSize,
  }) async {
    final result =
        await _appDomain.cartoonMore(sort: 'see', page: page, limit: pageSize);

    if (!isInit) {
      setState(() {
        isInit = true;
      });
    }

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
        appBar: MyAppBar(
          title: 'zht'.tr(context: context),
        ),
        body: MyListView.list(
          contentPadding: 10.w,
          padding: EdgeInsets.symmetric(
              horizontal: MyTheme.pagePadding, vertical: 5.w),
          itemBuilder: (context, item, index) =>
              CartoonSubjectItemCard(data: item),
          onFetchingMore: (currentPage, pageSize) =>
              _getData(page: currentPage, pageSize: pageSize),
        ),
      ),
    );
  }
}

class CartoonSubjectItemCard extends StatelessWidget {
  const CartoonSubjectItemCard({super.key, required this.data});

  final CartoonModel data;

  String get imageUrl => CommonUtils.getThumb(data.toJson());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        CartoonMoreRoute('see', '${data.title}').push(context);
      },
      child: Container(
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
            color: MyTheme.white008Color,
            borderRadius: BorderRadius.all(Radius.circular(5.w))),
        child: Row(
          children: [
            MyAvatar(size: 80.w, thumb: imageUrl),
            SizedBox(width: 10.w),
            Expanded(
                child: Text(data.title ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: MyTheme.white16,
                    textAlign: TextAlign.right)),
          ],
        ),
      ),
    );
  }
}
