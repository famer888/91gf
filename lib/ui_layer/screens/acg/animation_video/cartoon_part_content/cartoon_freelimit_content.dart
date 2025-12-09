import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/domain/model/cartoon/cartoon_model.dart';
import 'package:jygf/domain/model/live_model.dart';
import 'package:jygf/domain/remote_domain/domains/cartoon.dart';
import 'package:jygf/ui_layer/screens/common_widgets/cartoon/card/video_card.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_app_bar.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_list_view.dart';
import 'package:jygf/ui_layer/screens/common_widgets/screen_background.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/ui_layer/utils/my_toast.dart';
import 'package:provider/provider.dart';

class CartoonFreelimitContent extends StatefulWidget {
  const CartoonFreelimitContent({super.key});

  @override
  State<CartoonFreelimitContent> createState() => _CartoonFreelimitContentState();
}

class _CartoonFreelimitContentState extends State<CartoonFreelimitContent> {
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
          title: 'xm'.tr(context: context),
        ),
        body: MyListView.grid(
          padding: EdgeInsets.symmetric(
              horizontal: MyTheme.pagePadding, vertical: 5.w),
          childAspectRatio: CartoonVideoCard.aspectRatio,
          crossAxisSpacing: 8.w,
          itemBuilder: (context, item, index) => CartoonVideoCard(data: item),
          onFetchingMore: (currentPage, pageSize) => _getData(
              page: currentPage, pageSize: pageSize),
        ),
      ),
    );
  }
}
