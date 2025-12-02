import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/domain/model/banner_model.dart';
import 'package:jygf/domain/model/cartoon/cartoon_model.dart';
import 'package:jygf/domain/model/live_model.dart';
import 'package:jygf/domain/model/navigator_model.dart';
import 'package:jygf/domain/model/part_nav_model.dart';
import 'package:jygf/domain/remote_domain/domains/cartoon.dart';
import 'package:jygf/ui_layer/notifiers/home_config_notifier.dart';
import 'package:jygf/ui_layer/screens/common_widgets/cartoon/card/video_card.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_app_bar.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_list_view.dart';
import 'package:jygf/ui_layer/screens/common_widgets/screen_background.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/ui_layer/utils/my_toast.dart';
import 'package:provider/provider.dart';

class CartoonMoreScreen extends StatefulWidget {
  const CartoonMoreScreen({super.key, required this.sort, required this.title});

  final String sort;
  final String title;

  @override
  State<CartoonMoreScreen> createState() => _CartoonMoreScreenState();
}

class _CartoonMoreScreenState extends State<CartoonMoreScreen> {
  late final _appDomain = context.read<CartoonDomain>();
  late final _homeConfig = context.read<HomeConfigNotifier>();
  final ValueNotifier<List<BannerModel>> bannersNotifier = ValueNotifier([]);
  final ValueNotifier<List<TipModel>> tipsNotifier = ValueNotifier([]);
  final ValueNotifier<List<PartModel>> partNotifier = ValueNotifier([]);
  late final List<NavigatorModel> titles = _homeConfig.config.sortNav ?? [];

  bool isInit = false;
  List<TipModel> tips = [];

  @override
  void initState() {
    super.initState();

    _getData(page: 1, pageSize: 15, sort: widget.sort);
  }

  Future<List<CartoonModel>?> _getData({
    required int page,
    required int pageSize,
    required String sort,
  }) async {
    final result =
        await _appDomain.cartoonMore(sort: sort, page: page, limit: pageSize);

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
          title: widget.title,
        ),
        body: MyListView.grid(
          padding: EdgeInsets.symmetric(
              horizontal: MyTheme.pagePadding, vertical: 8.w),
          childAspectRatio: CartoonVideoCard.aspectRatio,
          crossAxisSpacing: 8.w,
          itemBuilder: (context, item, index) => CartoonVideoCard(data: item),
          onFetchingMore: (currentPage, pageSize) => _getData(
              page: currentPage, pageSize: pageSize, sort: widget.sort),
        ),
      ),
    );
  }
}
