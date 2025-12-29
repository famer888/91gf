import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jygf/ui_layer/screens/image_paths.dart';
import 'package:provider/provider.dart';

import '../../../../domain/async_value.dart';
import '../../../../domain/domain.dart';
import '../../../../domain/enum.dart';
import '../../../../domain/model/product_vip_coin_model.dart';
import '../../../notifiers/user_notifier.dart';
import '../../../router/routes.dart';
import '../../common_widgets/fixed_buy_button.dart';
import '../../common_widgets/my_app_bar.dart';
import '../../common_widgets/screen_background.dart';
import '../../common_widgets/status/loading.dart';
import '../../common_widgets/status/network_error.dart';
import '../../theme.dart';

class CoinRechargeScreen extends StatefulWidget {
  const CoinRechargeScreen({super.key});

  @override
  State<CoinRechargeScreen> createState() => _CoinRechargeScreenState();
}

class _CoinRechargeScreenState extends State<CoinRechargeScreen> {
  final _type = MyProductType.coin;
  final productSelectedNotifier = ValueNotifier(0);
  late final _orderDomain = context.read<OrderDomain>();

  AsyncValue<ProductOfVipOrCoin> _asyncValue = const AsyncInit();

  @override
  void initState() {
    _init();
    super.initState();
  }

  Future<void> _init() async {
    if (_asyncValue.isLoading) return;

    setState(() {
      _asyncValue = const AsyncLoading();
    });

    final result = await _orderDomain.getProduct(type: _type);
    if (mounted) {
      setState(() {
        if (result.data case final data?) {
          _asyncValue = AsyncData(data);
        } else {
          _asyncValue = const AsyncError();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
        child: Scaffold(
      appBar: MyAppBar(
        title: 'jbcz'.tr(context: context),
        rightWidget: GestureDetector(
          onTap: () => RechargeRecordRoute(_type.id.toString()).push(context),
          child: Text(
            'czjl'.tr(context: context),
            style: MyTheme.gray150_14,
          ),
        ),
      ),
      body: _asyncValue.maybeWhen(
        data: (value) => _Body(productOfVIP: value),
        error: (_, __) => NetworkErrorView(onTap: _init),
        orElse: () => const LoadingView(),
      ),
    ));
  }
}

class _Body extends StatefulWidget {
  const _Body({required this.productOfVIP});
  final ProductOfVipOrCoin productOfVIP;

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  final productSelectedNotifier = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            children: [
              SizedBox(height: 20.w),
              const _TopArea(),
              // SizedBox(height: 20.w),
              _ProductArea(
                products: widget.productOfVIP.products,
                productSelectedNotifier: productSelectedNotifier,
              ),
              // SizedBox(height: 30.w)
            ],
          ),
        ),
        FixedBuyButton(
          notifier: productSelectedNotifier,
          products: widget.productOfVIP.products,
          vipText: widget.productOfVIP.vipText,
        ),
      ],
    );
  }
}

class _TopArea extends StatelessWidget {
  const _TopArea();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 167.w,
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
            child: Container(
              height: 167.w,
              decoration: const BoxDecoration(
                image: DecorationImage(image: AssetImage(MyImagePaths.appCoinRechargebg), fit: BoxFit.fill),
              ),
            ),
          ),
          Positioned(
            top: 10.w,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 25.w),
                Text('jbye'.tr(context: context), style: TextStyle(color: MyTheme.whiteColor, fontSize: 16.sp, fontWeight: FontWeight.w700)),
                SizedBox(width: 30.w),
                Expanded(
                  child: Selector<UserNotifier, String>(
                    selector: (_, userNotifier) => '${userNotifier.member.money}',
                    builder: (context, money, child) {
                      return Text(money, style: TextStyle(color: MyTheme.goldColor255_211_123, fontSize: 38.w, fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis), maxLines: 1);
                    },
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 20.w),
              child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => const CoinDetailRoute().push(context),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.w),
                      gradient: MyTheme.gradient_90_118,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 1.w),
                    child: Text('jbmx'.tr(context: context), style: MyTheme.white_13),
                  ),
                ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Stack(
              children: [
                ClipPath(
                  clipper: TopConcaveClipperWithBorder(borderWidth: 1.0),
                  child: Container(
                    width: double.infinity,
                    height: 60.w,
                    color: const Color.fromRGBO(40, 5, 34, 1),
                  ),
                ),
                ClipPath(
                  clipper: TopConcaveClipper(),
                  child: CustomPaint(
                    size: Size(double.infinity, 50.w),
                    painter: TopBorderPainter(
                      borderColor: const Color.fromRGBO(154, 48, 133, 1.0),
                      borderWidth: 1.0,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _ProductArea extends StatelessWidget {
  const _ProductArea({
    required this.products,
    required this.productSelectedNotifier,
  });

  final List<Product> products;
  final ValueNotifier<int> productSelectedNotifier;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: productSelectedNotifier,
        builder: (context, isSelectedIndex, child) {
          return Expanded(
            child: Container(
              color: const Color.fromRGBO(40, 5, 34, 1),
              child: GridView.builder(
                padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 13,
                  crossAxisSpacing: 13,
                  childAspectRatio: 94 / 114,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) => GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => productSelectedNotifier.value = index,
                  child: _CoinItem(
                    product: products[index],
                    isSelected: isSelectedIndex == index,
                  ),
                ),
              ),
            ),
          );
        });
  }
}

class _CoinItem extends StatefulWidget {
  const _CoinItem({
    required this.product,
    required this.isSelected,
  });

  final Product product;
  final bool isSelected;

  @override
  State<_CoinItem> createState() => _CoinItemState();
}

class _CoinItemState extends State<_CoinItem> {
  @override
  Widget build(BuildContext context) {
    final promoPrice = widget.product.promoPriceYuan.split('.').first;
    // final price = widget.product.priceYuan.split('.').first;
    final isSelected = widget.isSelected;
    return Stack(
      children: [
        Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: isSelected ? const Color.fromRGBO(255, 226, 98, 1) : Colors.transparent,
                  width: 2.0,
                ),
                gradient: const LinearGradient(
                  colors: [Color.fromRGBO(165, 56, 139, 1), Color.fromRGBO(19, 43, 115, 1)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(13.w),
              ),
              width: 114.w,
              height: 130.w,
              padding: EdgeInsets.symmetric(vertical: 10.w),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    MyImage.asset(MyImagePaths.appCoinRechargeItemIcon, width: 47.w, height: 47.w),
                    Text(widget.product.pName, style: MyTheme.white14Medium),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('¥', style: MyTheme.white_13),
                        Text(promoPrice, style: MyTheme.white_13),
                      ],
                    ),
                    // Text(
                    //   price,
                    //   style: TextStyle(
                    //     fontSize: 15.sp,
                    //     color: isSelected
                    //         ? const Color(0xFF7f3b29)
                    //         : const Color(0xFFa1a1b2),
                    //     decoration: TextDecoration.lineThrough,
                    //     decorationColor: isSelected
                    //         ? const Color(0xFF7f3b29)
                    //         : const Color(0xFFa1a1b2),
                    //   ),
                    // )
                  ],
                ),
              ),
            )
          ],
        ),
        if (widget.product.giveTip.isNotEmpty)
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              height: 20.w,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color.fromRGBO(255, 36, 91, 1), Color.fromRGBO(255, 197, 73, 1)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.w),
                  bottomRight: Radius.circular(10.w),
                ),
              ),
              child: Center(
                child: Text(widget.product.giveTip, style: MyTheme.white10),
              ),
            ),
          )
      ],
    );
  }
}
class TopConcaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    double curveHeight = 40.0;

    path.lineTo(0, 0); 
    path.quadraticBezierTo(
      size.width / 2, curveHeight * 2,
      size.width, 0,
    );
    
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class TopConcaveClipperWithBorder extends CustomClipper<Path> {
  final double borderWidth;

  TopConcaveClipperWithBorder({required this.borderWidth});

  @override
  Path getClip(Size size) {
    Path path = Path();
    double curveHeight = 40.0; 
    double topOffset = borderWidth; 

    path.lineTo(0, topOffset); 
    path.quadraticBezierTo(
      size.width / 2, topOffset + curveHeight * 2, 
      size.width, topOffset,
    );
    
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    if (oldClipper is TopConcaveClipperWithBorder) {
      return oldClipper.borderWidth != borderWidth;
    }
    return true;
  }
}

// 顶部边框绘制器，沿着裁剪路径的曲线绘制边框
class TopBorderPainter extends CustomPainter {
  final Color borderColor;
  final double borderWidth;

  TopBorderPainter({
    required this.borderColor,
    required this.borderWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = borderColor
      ..strokeWidth = borderWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Path path = Path();
    double curveHeight = 40.0;

    path.moveTo(0, borderWidth / 2);
    path.quadraticBezierTo(
      size.width / 2, borderWidth / 2 + curveHeight * 2,
      size.width, borderWidth / 2,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(TopBorderPainter oldDelegate) {
    return oldDelegate.borderColor != borderColor ||
        oldDelegate.borderWidth != borderWidth;
  }
}