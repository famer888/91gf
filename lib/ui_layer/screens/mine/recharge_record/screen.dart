import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/ui_layer/screens/common_widgets/order_list_item.dart';
import 'package:provider/provider.dart';

import '../../../../domain/domain.dart';
import '../../../../domain/model/order_model.dart';
import '../../../router/routes.dart';
import '../../../utils/common_utils.dart';
import '../../../utils/my_toast.dart';
import '../../common_widgets/my_app_bar.dart';
import '../../common_widgets/my_image.dart';
import '../../common_widgets/my_list_view.dart';
import '../../common_widgets/screen_background.dart';
import '../../image_paths.dart';
import '../../theme.dart';

class RechargeRecordScreen extends StatefulWidget {
  const RechargeRecordScreen({super.key, required this.type});
  final String type;
  @override
  State<RechargeRecordScreen> createState() => _RechargeRecordScreenState();
}

class _RechargeRecordScreenState extends State<RechargeRecordScreen> {
  late final _orderDomain = context.read<OrderDomain>();

  Future<List<Order>?> _getData(
      {required int page, required int pageSize}) async {
    final result = await _orderDomain.getOrderList(
      page: page,
      type: widget.type,
      limit: pageSize,
    );

    return result.data;
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
        child: Scaffold(
      appBar: MyAppBar(
        showDiver: true,
        title: 'czjl'.tr(context: context),
        rightWidget: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => const MineCustomerServiceRoute().push(context),
          child: Text(
            'lxkf'.tr(context: context),
            style: MyTheme.gray150_14,
          ),
        ),
      ),
      body: MyListView.list(
        padding: EdgeInsets.all(MyTheme.pagePadding),
        contentPadding: 16.w,
        itemBuilder: (context, item, index) => OrderListItem(order: item, type: OrderListItemType.coinRecharge),
        onFetchingMore: (currentPage, pageSize) =>
            _getData(page: currentPage, pageSize: pageSize),
      ),
    ));
  }
}

class OrderItem extends StatelessWidget {
  const OrderItem({super.key, required this.order});
  final Order order;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 18.5.w, horizontal: 14.w),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(21, 21, 42, 1),
        borderRadius: BorderRadius.circular(5.w),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${'ddbh'.tr(context: context)}：${order.id}',
                style: MyTheme.white23_12,
              ),
              GestureDetector(
                onTap: () {
                  CommonUtils.copyToClipboard(
                      text: '${'ddbh'.tr(context: context)}：${order.id}');
                  MyToast.showText(text: 'fzcgl'.tr(context: context));
                },
                child: Row(
                  children: [
                    MyImage.asset(
                      MyImagePaths.appCopy,
                      width: 15.w,
                      height: 10.w,
                    ),
                    SizedBox(
                      width: 6.w,
                    ),
                    Text(
                      'fzdh'.tr(context: context),
                      style: TextStyle(
                          color: const Color.fromRGBO(0, 72, 255, 1),
                          fontSize: 12.sp,
                          overflow: TextOverflow.ellipsis,
                          decoration: TextDecoration.none),
                    ),
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            height: 10.w,
          ),
          CustomPaint(
            size: Size(double.infinity, 0.5.w),
            painter: CurvePainter(),
          ),
          SizedBox(
            height: 14.5.w,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${order.descp}',
                style: MyTheme.gray168_16_M,
              ),
              Text('${order.amount}', style: MyTheme.gray168_16_M),
            ],
          ),
          SizedBox(
            height: 11.5.w,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${order.createdAt}', style: MyTheme.gray153_12),
              Text(
                '${order.statusText}',
                style: MyTheme.gray153_12,
              ),
            ],
          )
        ],
      ),
    );
  }
}

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Colors.black12;
    paint.style = PaintingStyle.fill; // Change this to fill

    var path = Path();

    path.moveTo(0, 0);
    path.quadraticBezierTo(size.width / 2, size.height / 2, size.width, 0);
    path.quadraticBezierTo(size.width / 2, -size.height / 2, 0, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
