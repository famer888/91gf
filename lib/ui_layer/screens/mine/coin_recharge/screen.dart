import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
              child: Column(
                children: [
                  const _TopArea(),
                  SizedBox(height: 20.w),
                  _ProductArea(
                    products: widget.productOfVIP.products,
                    productSelectedNotifier: productSelectedNotifier,
                  ),
                  SizedBox(height: 30.w)
                ],
              ),
            ),
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
      height: 100.w,
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.symmetric(
              vertical: 20.w,
            ),
            height: 60.w,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.all(Radius.circular(30.w)),
            ),
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 20.w),
                Text(
                  'jbye'.tr(context: context),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.sp,
                  ),
                ),
                SizedBox(width: 10.w),
                Container(width: 0.5.w, height: 24.w, color: Colors.white),
                SizedBox(width: 10.w),
                Expanded(
                  child: Selector<UserNotifier, String>(
                      selector: (_, userNotifier) =>
                          '${userNotifier.member.money}',
                      builder: (context, money, child) {
                        return Text(
                          money,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 38.w,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis,
                          ),
                          maxLines: 1,
                        );
                      }),
                ),
                SizedBox(width: 10.w),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => const CoinDetailRoute().push(context),
                  child: Text(
                    'jbmx'.tr(context: context),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.sp,
                    ),
                  ),
                ),
                SizedBox(width: 20.w)
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
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
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
    final price = widget.product.priceYuan.split('.').first;
    final isSelected = widget.isSelected;
    return Stack(
      children: [
        Column(
          children: [
            SizedBox(
              height: 8.w,
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                    color: isSelected
                        ? const Color(0xFFdaa78b)
                        : Colors.transparent,
                    width: 2.0),
                gradient: LinearGradient(
                  colors: isSelected
                      ? const [Color(0xFFffefdc), Color(0xFFf7dcbc)]
                      : const [Color(0xFF2a2a42), Color(0xFF2a2a42)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(13.w),
              ),
              width: 114.w,
              height: 120.w,
              padding: EdgeInsets.symmetric(vertical: 10.w),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.product.pName,
                      style:
                          isSelected ? MyTheme.brown72_18 : MyTheme.brown248_18,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '¥',
                          style: TextStyle(
                              fontSize: ScreenUtil().setWidth(18),
                              color: isSelected
                                  ? const Color(0xFF48170e)
                                  : const Color(
                                      0xFFffffff,
                                    ),
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          promoPrice,
                          style: TextStyle(
                              fontSize: 30.sp,
                              color: isSelected
                                  ? const Color(0xFF48170e)
                                  : const Color(0xFFffffff),
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Text(
                      price,
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: isSelected
                            ? const Color(0xFF7f3b29)
                            : const Color(0xFFa1a1b2),
                        decoration: TextDecoration.lineThrough,
                        decorationColor: isSelected
                            ? const Color(0xFF7f3b29)
                            : const Color(0xFFa1a1b2),
                      ),
                    )
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
                gradient: MyTheme.gradient_228_246,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.w),
                  bottomRight: Radius.circular(10.w),
                ),
              ),
              child: Center(
                child: Text(
                  widget.product.giveTip,
                  style: TextStyle(
                    color: const Color.fromRGBO(46, 24, 12, 1),
                    fontSize: 10.sp,
                    decoration: TextDecoration.none,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          )
      ],
    );
  }
}
