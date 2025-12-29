import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../domain/model/product_vip_coin_model.dart';
import '../../router/routes.dart';
import '../theme.dart';
import 'dialog/widgets/pay_dialog.dart';
import 'my_button.dart';

class FixedBuyButton extends StatefulWidget {
  const FixedBuyButton({
    super.key,
    required this.notifier,
    required this.products,
    required this.vipText,
  });

  final ValueNotifier<int> notifier;
  final List<Product> products;
  final String vipText;

  @override
  State<FixedBuyButton> createState() => _FixedBuyButtonState();
}

class _FixedBuyButtonState extends State<FixedBuyButton> {
  Future<void> _showPay(int selectedIndex) => showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) => PayDialog(
          product: widget.products[selectedIndex],
          tip: widget.vipText,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF111127), Color(0xFF111127)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: ValueListenableBuilder(
        valueListenable: widget.notifier,
        builder: (context, selectedIndex, child) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 10.w),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
                child: MyButton.gradient(
                  onPressed: () => _showPay(selectedIndex),
                  minimumSize: Size.fromHeight(40.w),
                  text:
                      "${'ljzf'.tr(context: context)} ¥${widget.products[selectedIndex].promoPriceYuan.split(".").first}",
                ),
              ),
              SizedBox(height: 10.w),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => const MineCustomerServiceRoute().push(context),
                child: Text.rich(
                  TextSpan(
                    text: 'zflx'.tr(context: context),
                    style: TextStyle(
                      color: const Color(0xFFc6c7c9),
                      fontSize: 10.sp,
                    ),
                    children: [
                      TextSpan(
                        text: 'zxkf'.tr(context: context),
                        style: TextStyle(
                          color: MyTheme.primaryColor,
                          fontSize: 10.sp,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.w)
            ],
          );
        },
      ),
    );
  }
}
