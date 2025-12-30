import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/domain/model/order_model.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jygf/ui_layer/screens/image_paths.dart';
import 'package:jygf/ui_layer/utils/common_utils.dart';
import 'package:jygf/ui_layer/utils/my_toast.dart';
import '../theme.dart';

enum OrderListItemType {
  coinRecharge,
  coinExpenditure, 
  vipRecharge,
  withdraw,
}

class OrderListItem extends StatelessWidget {
  const OrderListItem({super.key, required this.order, required this.type});
  final Order order;
  final OrderListItemType type;

  @override
  Widget build(BuildContext context) {

    final Color paywayColor = switch (order.payway) {
      '微信' => const Color.fromRGBO(56, 226, 37, 1),
      '支付宝' => const Color.fromRGBO(59, 150, 255, 1),
      _ => const Color.fromRGBO(153, 153, 153, 1),
    };

    Color descpColor = const Color.fromRGBO(255, 69, 0, 1);
    String descpPrefix = '';
    if (type == OrderListItemType.coinRecharge) {
      descpPrefix = '+';
    } else if (type == OrderListItemType.coinExpenditure) {
      if (order.payType == '增加') {
        descpPrefix = '+';
      } else if (order.payType == '减少') {
        descpPrefix = '-';
        descpColor = const Color.fromRGBO(56, 226, 37, 1);
      }
    }
    final String descp = '$descpPrefix${order.descp ?? ''}';
    final bool showOrderNumber = type != OrderListItemType.coinExpenditure;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 5.w),
        if (showOrderNumber)
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 5.w, horizontal: 14.w),
            decoration: BoxDecoration(
              color: MyTheme.white01Color,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.w),
                topRight: Radius.circular(8.w),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '订单编号: ${order.id}',
                  style: MyTheme.gray150_12,
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
                      style: MyTheme.gray150_12,
                    ),
                  ],
                ),
              )
              ],
            ),
          ),
        Container(
          decoration: BoxDecoration(
            color: MyTheme.white02Color,
            borderRadius: showOrderNumber
                ? BorderRadius.only(
                    bottomLeft: Radius.circular(8.w),
                    bottomRight: Radius.circular(8.w),
                  )
                : BorderRadius.circular(8.w),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.w, horizontal: 14.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      order.statusText ?? '',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    Text(
                      descp,
                      style: TextStyle(
                        color: descpColor,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 11.w),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      order.payway ?? '',
                      style: TextStyle(
                        color: paywayColor,
                        fontSize: 14.sp,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    Text(
                      order.createdAt ?? '',
                      style: MyTheme.gray153_12,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}