import 'package:bot_toast/bot_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:universal_html/html.dart' as html;

import '../../../../../domain/type_def.dart';
import '../../../../../domain/domain.dart';
import '../../../../../domain/model/product_vip_coin_model.dart';
import '../../../../notifiers/user_notifier.dart';
import '../../../../utils/common_utils.dart';
import '../../../../utils/my_toast.dart';
import '../../../image_paths.dart';
import '../../../theme.dart';
import '../../my_button.dart';
import '../../my_image.dart';
import 'regular_dialog.dart';

class PayDialog extends StatefulWidget {
  const PayDialog({super.key, required this.product, required this.tip});
  final Product product;
  final String tip;
  @override
  State<PayDialog> createState() => _PayDialogState();
}

class _PayDialogState extends State<PayDialog> {
  static const Map<String, String> _payIcons = {
    'alipay': MyImagePaths.appZfXfbN,
    'wechat': MyImagePaths.appZfMxN,
    'bankcard': MyImagePaths.appZfYtN,
    'usdt': MyImagePaths.appZfUsN,
    'agent': MyImagePaths.appZfAgnN,
    'money': MyImagePaths.appZfConN,
    'ecny': MyImagePaths.appZfEcnyN
  };

  Product get product => widget.product;
  html.WindowBase? winRef;
  dynamic origin = '${html.window.location.origin}/';
  late ValueNotifier<int?> paySelectedIndexNotifier = ValueNotifier(null);
  late final orderDomain = context.read<OrderDomain>();
  late final userNotifier = context.read<UserNotifier>();

  _payError() {
    CommonUtils.showDialog(
      context: context,
      builder: (context) => RegularDialog(
        title: 'ts'.tr(context: context),
        buttonText: 'zdl'.tr(context: context),
        content: DefaultTextStyle(
          style: MyTheme.white233_14,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('zfsb'.tr(context: context)),
              SizedBox(
                height: 14.w,
              ),
              Text('zfsby'.tr(context: context)),
              SizedBox(
                height: 14.w,
              ),
              Text('zfsbe'.tr(context: context))
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _send(int? selectedIndex) async {
    if (selectedIndex != null) {
      MyToast.showLoading(text: 'zzqqzf'.tr(context: context));
      if (product.pays[selectedIndex].channel == 'money') {
        try {
          final result =
              await orderDomain.onOrderExchange(productId: product.id);
          if (result.status == 1) {
            await userNotifier.init();
            BotToast.showText(text: 'dhhc'.tr());
          } else {
            BotToast.showText(text: result.msg!);
          }
        } catch (err) {
          BotToast.showText(text: 'dhhs'.tr());
        }
      } else {
        if (kIsWeb) {
          winRef = html.window.open('${origin}waiting.html', '_blank');
        }
        try {
          final result = await orderDomain.onCreatePaying(
              payType: 'online',
              payWay: product.pays[selectedIndex].channel,
              productId: product.id);
          if (kIsWeb) {
            BotToast.closeAllLoading();
            if (mounted) {
              context.pop();
            }
          }
          if (result.status != 1) {
            if (result.msg != null) {
              if (kIsWeb) {
                winRef?.close();
                _payError();
              }
              BotToast.showText(text: result.msg!);
            }
          } else {
            if (result.data != null && result.data['payUrl'] != null) {
              if (kIsWeb) {
                winRef?.location.href = result.data['payUrl'];
              } else {
                CommonUtils.launchUrl(result.data['payUrl']);
              }
            } else if (result.msg != null) {
              if (kIsWeb) {
                winRef?.close();
                _payError();
              }
              BotToast.showText(text: result.msg ?? '');
            } else {
              if (kIsWeb) {
                winRef?.close();
                _payError();
              }
              BotToast.showText(text: 'cddsb'.tr());
            }
          }
        } catch (_) {}
      }
      BotToast.closeAllLoading();
    } else {
      BotToast.showText(text: 'qxzzf'.tr());
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: paySelectedIndexNotifier,
      builder: (context, selectedIndex, child) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          decoration: BoxDecoration(
              color: MyTheme.bgColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(5.w))),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(top: 24.5.w, bottom: 19.5.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox.shrink(),
                        Text(
                          'xzzf'.tr(context: context),
                          style: MyTheme.white255_18_M,
                        ),
                        InkWell(
                          onTap: () => context.pop(),
                          child: Container(
                            alignment: Alignment.centerRight,
                            width: 44.w,
                            height: 44.w,
                            child: MyImage.asset(
                              MyImagePaths.appClose,
                              width: 14.w,
                              height: 14.w,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      text: 'zfje'.tr(context: context),
                      style: MyTheme.white255_14,
                      children: [
                        TextSpan(
                          text:
                              '${product.promoPriceYuan}${'y'.tr(context: context)}',
                          style: TextStyle(
                            color: MyTheme.gradient_90_114_colors.first,
                            fontSize: 14.sp,
                          ),
                        )
                      ],
                    ),
                  ),
                  ListView.builder(
                    padding: EdgeInsets.zero,
                    addAutomaticKeepAlives: false,
                    addRepaintBoundaries: false,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: product.pays.length,
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () => paySelectedIndexNotifier.value = index,
                      behavior: HitTestBehavior.translucent,
                      child: Padding(
                        padding: EdgeInsets.only(top: 20.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                MyImage.asset(
                                  _payIcons[product.pays[index].channel] ?? '',
                                  width: 40.sp,
                                  height: 40.sp,
                                ),
                                SizedBox(
                                  width: 10.5.sp,
                                ),
                                Text(
                                  product.pays[index].name,
                                  style: MyTheme.white255_15,
                                )
                              ],
                            ),
                            Icon(
                              selectedIndex == index
                                  ? Icons.check_circle
                                  : Icons.circle_outlined,
                              size: 20.w,
                              color: selectedIndex == index
                                  ? MyTheme.blueColor81_151_241
                                  : Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.w),
                  MyButton.gradient(
                    onPressed: () => _send(selectedIndex),
                    borderRadius: 20.w,
                    minimumSize: Size.fromHeight(40.w),
                    text: 'tj'.tr(context: context),
                  ),
                  SizedBox(height: 10.w),
                  Text(
                    'zfxts'.tr(context: context),
                    style: TextStyle(
                      color: const Color.fromRGBO(173, 173, 173, 1),
                      fontSize: 15.sp,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  SizedBox(height: 5.w),
                  Text(
                    widget.tip,
                    style: TextStyle(
                      color: const Color.fromRGBO(173, 173, 173, 1),
                      fontSize: 12.w,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  SizedBox(height: (kIsWeb ? 30 : 10).w)
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
