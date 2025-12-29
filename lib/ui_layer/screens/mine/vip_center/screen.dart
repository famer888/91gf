import 'package:bot_toast/bot_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jygf/ui_layer/screens/common_widgets/keep_alive_wrapper.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_tab_bar.dart';
import 'package:jygf/ui_layer/screens/image_paths.dart';
import 'package:infinite_carousel/infinite_carousel.dart';
import 'package:provider/provider.dart';

import '../../../../domain/api_validator.dart';
import '../../../../domain/async_value.dart';
import '../../../../domain/domain.dart';
import '../../../../domain/enum.dart';
import '../../../../domain/model/exp_of_vip_model.dart';
import '../../../../domain/model/product_vip_coin_model.dart';
import '../../../../domain/type_def.dart';
import '../../../notifiers/user_notifier.dart';
import '../../../router/routes.dart';
import '../../../utils/my_toast.dart';
import '../../common_widgets/colored_number_text.dart';
import '../../common_widgets/fixed_buy_button.dart';
import '../../common_widgets/gradient_text.dart';
import '../../common_widgets/member_vip.dart';
import '../../common_widgets/my_app_bar.dart';
import '../../common_widgets/my_avatar.dart';
import '../../common_widgets/my_image.dart';
import '../../common_widgets/partial_clickable_text.dart';
import '../../common_widgets/screen_background.dart';
import '../../common_widgets/status/loading.dart';
import '../../common_widgets/status/network_error.dart';
import '../../theme.dart';

class VipCenterScreen extends StatefulWidget {
  // 默认选中第一个页面
  final int pageIndex;
  const VipCenterScreen({super.key, this.pageIndex = 0});

  @override
  State<VipCenterScreen> createState() => _VipCenterScreenState();
}

class _VipCenterScreenState extends State<VipCenterScreen> {
  final _type = MyProductType.vip;
  late final _orderDomain = context.read<OrderDomain>();
  late final _signDomain = context.read<SignDomain>();

  AsyncValue<(ProductOfVipOrCoin, ExpOfVIPData)> _asyncValue =
      const AsyncInit();

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

    final results = await Future.wait([
      _orderDomain.getProduct(type: _type),
      _signDomain.getExpOfVIP(),
    ]);

    setState(() {
      if (results[0].isValid && results[1].isValid) {
        _asyncValue = AsyncData((
          results[0].data as ProductOfVipOrCoin,
          results[1].data as ExpOfVIPData,
        ));
      } else {
        _asyncValue = const AsyncError();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      child: Scaffold(
        appBar: MyAppBar(
          title: 'hyzx'.tr(context: context),
          rightWidget: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => RechargeRecordRoute(_type.id.toString()).push(context),
            child: Text('czjl'.tr(context: context), style: MyTheme.white14),
          ),
        ),
        body: _asyncValue.maybeWhen(
          data: (value) => _Body(
              productOfVIP: value.$1,
              expOfVIP: value.$2,
              initialIndex: widget.pageIndex),
          error: (_, __) => NetworkErrorView(onTap: _init),
          orElse: () => const LoadingView(),
        ),
      ),
    );
  }
}

class _Body extends StatefulWidget {
  final int initialIndex;
  const _Body(
      {required this.productOfVIP,
      required this.expOfVIP,
      this.initialIndex = 0});

  final ProductOfVipOrCoin productOfVIP;
  final ExpOfVIPData expOfVIP;

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  final productSelectedNotifier = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return [
          const  SliverToBoxAdapter(
            child:  _UserInfoArea(),
          ),
        ];
      },
      body: TabBarWithView.line(
        indicatorType: IndicatorType.light,
        initialIndex: widget.initialIndex,
        tabBarPadding: EdgeInsets.symmetric(
            vertical: 5.w,
            horizontal: MyTheme.pagePadding),
        labelStyle: MyTheme.color93_163_247_16medium,
        unselectedLabelStyle: MyTheme.color141_144_154_16medium,
        tabBarHeight: 38.w,
        isScrollable: false,
        titles: [
          'khy'.tr(context: context),
          'jfdhvip'.tr(context: context)
        ],
        views: [
          KeepAliveWrapper(child: _openVipContent()),
          KeepAliveWrapper(child: _pointExchangeContent()),
        ],
      ),
    );
  }

  Widget _openVipContent() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _TitleHintText(
                  title: 'ktvpxs'.tr(context: context),
                  subTitle: 'zmzxs'.tr(context: context),
                ),
                _ProductCardArea(
                  products: widget.productOfVIP.products,
                  selectedNotifier: productSelectedNotifier,
                ),
                SizedBox(height: 20.w),
                // _DescriptionArea(
                //   notifier: productSelectedNotifier,
                //   products: widget.productOfVIP.products,
                // ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.w),
                        topRight: Radius.circular(30.w),
                      ),
                      color: MyTheme.blackColor29_2_24,
                      border: Border(
                        top: BorderSide(color: const Color.fromRGBO(154, 48, 133, 1), width: 1.w),
                      )
                      ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MyImage.asset(MyImagePaths.appVipL,
                              width: 42.w, height: 10.w),
                          SizedBox(width: 20.w),
                          Text('hytq'.tr(context: context),
                              style: MyTheme.white16mudium,
                              maxLines: 100,
                              textAlign: TextAlign.center),
                          SizedBox(width: 20.w),
                          MyImage.asset(MyImagePaths.appVipR,
                              width: 42.w, height: 10.w),
                        ],
                      ),
                      SizedBox(height: 15.w),
                      _RightArea(
                        notifier: productSelectedNotifier,
                        products: widget.productOfVIP.products,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.w),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
                  child: PartialClickableText(
                    prefixText: 'cztx'.tr(context: context),
                    afterFixText: 'zxkf'.tr(context: context),
                    prefixTextStyle: TextStyle(
                        color: const Color.fromRGBO(255, 255, 255, 1),
                        fontSize: 12.sp),
                    afterTextStyle: TextStyle(
                        color: const Color.fromRGBO(93, 163, 247, 1),
                        fontSize: 12.sp),
                    onTap: () {
                      const MineCustomerServiceRoute().push(context);
                    },
                  ),
                ),
                SizedBox(height: 25.w),
              ],
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

  Widget _pointExchangeContent() {
    return Column(
      children: [
        Selector<UserNotifier, int>(
          selector: (_, userNotifier) => userNotifier.member.exp ?? 0,
          builder: (BuildContext context, value, Widget? child) =>
              _TitleHintText(
            title: 'jfdh'.tr(context: context),
            subTitle: 'dqjf'.tr(context: context) + value.toString(),
          ),
        ),
        SizedBox(height: 13.w),
        Expanded(child: _ExpArea(expOfVipList: widget.expOfVIP.list)),
      ],
    );
  }
}

class _UserInfoArea extends StatelessWidget {
  const _UserInfoArea();

  @override
  Widget build(BuildContext context) {
    final member = context.watch<UserNotifier>().member;
    final expiredTime = member.expiredAt.toString().split(' ')[0];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
      child: Column(
        children: [
          SizedBox(height: 10.w),
          Row(
            children: [
              MyAvatar(
                thumb: member.thumb,
                margin: 2,
                size: 50.w,
                gradient: const LinearGradient(
                  colors: [Color(0xffdfab8f), Color(0xffcf8856)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              SizedBox(width: 13.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            constraints: BoxConstraints(maxWidth: 150.w),
                            child: Text(
                              member.nickname,
                              style: TextStyle(
                                  // fontFamily: hanyi,
                                  color: const Color.fromRGBO(255, 255, 255, 1),
                                  fontSize: 15.sp,
                                  overflow: TextOverflow.ellipsis,
                                  fontWeight: FontWeight.w600,
                                  height: 1,
                                  decoration: TextDecoration.none),
                            ),
                          ),
                          SizedBox(width: 10.w),
                          MemberVipWidget(vipImage: member.vipImg),
                          if (member.vipUpgrade == 1)
                            GestureDetector(
                              onTap: () =>
                                  const VipUpgradeRoute().push(context),
                              child: Container(
                                margin: EdgeInsets.only(left: 5.w),
                                child: MyImage.asset(
                                  MyImagePaths.appMineVipUpgrade,
                                  width: 70.w,
                                  height: 22.w,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                        ],
                      ),
                    SizedBox(height: 10.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 2.0.w, horizontal: 6.0.w),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(4.w),
                              bottomRight: Radius.circular(10.w),
                              topRight: Radius.circular(10.w)),

                          gradient: const LinearGradient(colors: [
                            Color.fromRGBO(90, 135, 232, 1),
                            Color.fromRGBO(118, 90, 232, 1)
                          ])),
                      child: Text(
                        member.vipLevel < 2
                            ? 'khykp'.tr(context: context)
                            : '${'dqrq'.tr(context: context)} $expiredTime',
                        style: TextStyle(color: const Color.fromRGBO(239, 220, 255, 1), fontSize: 11.sp),
                      ),
                    ),
                    // Row(
                    //   children: [
                    //     Text(
                    //       member.vipLevel < 2
                    //           ? 'khykp'.tr(context: context)
                    //           : '${'dqrq'.tr(context: context)} $expiredTime',
                    //       style: MyTheme.gray163_12,
                    //     ),
                    //     // SizedBox(width: 5.w),
                    //     // Text(
                    //     //   "${'syxzcs'.tr(context: context)}${member.videoDownloadValue}",
                    //     //   style: MyTheme.gray163_12,
                    //     // )
                    //   ],
                    // ),
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: 10.w),
          Container(
            // margin: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
            alignment: Alignment.centerLeft,
            child: Wrap(
              runSpacing: 8.0.w,
              children: [
                Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 2.0.w, horizontal: 6.0.w),
                  decoration: const BoxDecoration(
                      color: MyTheme.white01Color,
                      borderRadius: BorderRadius.all(Radius.circular(45))),
                  child: ColoredNumberText(
                    ('cspsyxz')
                        .tr()
                        .replaceAll("00", "${member.videoLongDownValue ?? 0}"),
                    normalTextStyle: MyTheme.white11,
                    colorTextStyle: MyTheme.white11.copyWith(color: MyTheme.primaryColor),
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 2.0.w, horizontal: 6.0.w),
                  decoration: const BoxDecoration(
                      color: MyTheme.white01Color,
                      borderRadius: BorderRadius.all(Radius.circular(45))),
                  child: ColoredNumberText(
                    ('dmsyxz')
                        .tr()
                        .replaceAll("00", "${member.cartoonDownValue ?? 0}"),
                    normalTextStyle: MyTheme.white11,
                    colorTextStyle: MyTheme.white11.copyWith(color: MyTheme.primaryColor),
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 2.0.w, horizontal: 6.0.w),
                  decoration: const BoxDecoration(
                      color: MyTheme.white01Color,
                      borderRadius: BorderRadius.all(Radius.circular(45))),
                  child: ColoredNumberText(
                    ('asyxz')
                        .tr()
                        .replaceAll("00", "${member.voiceDownValue ?? 0}"),
                    normalTextStyle: MyTheme.white11,
                    colorTextStyle: MyTheme.white11.copyWith(color: MyTheme.primaryColor),
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 2.0.w, horizontal: 6.0.w),
                  decoration: const BoxDecoration(
                      color: MyTheme.white01Color,
                      borderRadius: BorderRadius.all(Radius.circular(45))),
                  child: ColoredNumberText(
                    ('aimf0c').tr().replaceAll("00", "${member.aiMagicValue}"),
                    normalTextStyle: MyTheme.white11,
                    colorTextStyle: MyTheme.white11.copyWith(color: MyTheme.primaryColor),
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 2.0.w, horizontal: 6.0.w),
                  decoration: const BoxDecoration(
                      color: MyTheme.white01Color,
                      borderRadius: BorderRadius.all(Radius.circular(45))),
                  child: ColoredNumberText(
                    ('aitysy0c').tr().replaceAll("00", "${member.stripValue}"),
                    normalTextStyle: MyTheme.white11,
                    colorTextStyle: MyTheme.white11.copyWith(color: MyTheme.primaryColor),
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 2.0.w, horizontal: 6.0.w),
                  decoration: const BoxDecoration(
                      color: MyTheme.white01Color,
                      borderRadius: BorderRadius.all(Radius.circular(45))),
                  child: ColoredNumberText(
                    ('aijw0c').tr().replaceAll("00", "${member.aiKissValue}"),
                    normalTextStyle: MyTheme.white11,
                    colorTextStyle: MyTheme.white11.copyWith(color: MyTheme.primaryColor),
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 2.0.w, horizontal: 6.0.w),
                  decoration: const BoxDecoration(
                      color: MyTheme.white01Color,
                      borderRadius: BorderRadius.all(Radius.circular(45))),
                  child: ColoredNumberText(
                    ('tphlsy0c')
                        .tr()
                        .replaceAll("00", "${member.imgFaceValue}"),
                    normalTextStyle: MyTheme.white11,
                    colorTextStyle: MyTheme.white11.copyWith(color: MyTheme.primaryColor),
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 2.0.w, horizontal: 6.0.w),
                  decoration: const BoxDecoration(
                      color: MyTheme.white01Color,
                      borderRadius: BorderRadius.all(Radius.circular(45))),
                  child: ColoredNumberText(
                    ('aixs0c').tr().replaceAll("00", "${member.aiNovelValue}"),
                      normalTextStyle: MyTheme.white11,
                    colorTextStyle: MyTheme.white11.copyWith(color: MyTheme.primaryColor),
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 2.0.w, horizontal: 6.0.w),
                  decoration: const BoxDecoration(
                      color: MyTheme.white01Color,
                      borderRadius: BorderRadius.all(Radius.circular(45))),
                  child: ColoredNumberText(
                    ('aiyy0c').tr().replaceAll("00", "${member.aiAudioValue}"),
                    normalTextStyle: MyTheme.white11,
                    colorTextStyle: MyTheme.white11.copyWith(color: MyTheme.primaryColor),
                  ),
                ),
                Container(
                  padding:
                    EdgeInsets.symmetric(vertical: 2.0.w, horizontal: 6.0.w),
                  decoration: const BoxDecoration(
                      color: MyTheme.white01Color,
                      borderRadius: BorderRadius.all(Radius.circular(45))),
                  child: ColoredNumberText(
                    ('sphlsy0c')
                        .tr()
                        .replaceAll("00", "${member.aiVideoFaceValue}"),
                    normalTextStyle: MyTheme.white11,
                    colorTextStyle: MyTheme.white11.copyWith(color: MyTheme.primaryColor),
                  ),
                ),
                Container(
                  padding:
                    EdgeInsets.symmetric(vertical: 2.0.w, horizontal: 6.0.w),
                  decoration: const BoxDecoration(
                      color: MyTheme.white01Color,
                      borderRadius: BorderRadius.all(Radius.circular(45))),
                  child: ColoredNumberText(
                    ('aihh0c').tr().replaceAll("00", "${member.aiDrawValue}"),
                    normalTextStyle: MyTheme.white11,
                    colorTextStyle: MyTheme.white11.copyWith(color: MyTheme.primaryColor),
                  ),
                ),
              ]
                  .map((e) => Container(
                      margin: EdgeInsets.only(right: MyTheme.pagePadding),
                      child: e))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _TitleHintText extends StatelessWidget {
  const _TitleHintText({
    required this.title,
    required this.subTitle,
  });

  final String title;
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(color: Colors.white, fontSize: 15.sp),
          ),
          Text(
            subTitle,
            style: TextStyle(color: Colors.white, fontSize: 15.sp),
          )
        ],
      ),
    );
  }
}

class _ProductCardArea extends StatelessWidget {
  const _ProductCardArea({
    required this.products,
    required this.selectedNotifier,
  });

  final List<Product> products;
  final ValueNotifier selectedNotifier;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 188.w,
      child: InfiniteCarousel.builder(
        itemCount: products.length,
        itemExtent: 150.w,
        center: false,
        velocityFactor: 0.8,
        loop: true,
        itemBuilder: (context, index, realIndex) {
          return GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              selectedNotifier.value = index;
            },
            child: ValueListenableBuilder(
              valueListenable: selectedNotifier,
              builder: (context, isSelected, child) {
                return _ProductItem(
                    product: products[index], isSelected: isSelected == index);
              },
            ),
          );
        },
      ),
      // ListView.separated(
      //   padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
      //   separatorBuilder: (context, index) => SizedBox(width: 15.w),
      //   physics: const BouncingScrollPhysics(),
      //   scrollDirection: Axis.horizontal,
      //   itemCount: products.length,
      //   itemBuilder: (context, index) => GestureDetector(
      //     behavior: HitTestBehavior.translucent,
      //     onTap: () => selectedNotifier.value = index,
      //     child: ValueListenableBuilder(
      //       valueListenable: selectedNotifier,
      //       builder: (context, isSelected, child) {
      //         return _ProductItem(
      //           product: products[index],
      //           isSelected: isSelected == index,
      //         );
      //       },
      //     ),
      //   ),
      // ),
    );
  }
}

class _ProductItem extends StatelessWidget {
  final Product product;
  final bool isSelected;

  const _ProductItem({required this.product, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    final promoPrice = product.promoPriceYuan.split('.').first;
    final price = '¥${product.priceYuan.split('.').first}';

    return Stack(
      children: [
        Column(
          children: [
            SizedBox(height: 8.w),
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(9.1.w),
                  child: SizedBox(
                      width: 140.w,
                      height: 180.w,
                      child: MyImage.network(product.bgImg,
                          width: 140.w, height: 180.w)),
                ),
                if (!isSelected)
                  Container(
                      width: 140.w,
                      height: 180.w,
                      decoration: const BoxDecoration(
                          color: Color.fromRGBO(0, 0, 0, 0.5))),
              ],
            ),
            // Container(
            //   width: 114.w,
            //   height: 120.w,
            //   padding: EdgeInsets.symmetric(vertical: 10.w),
            //   decoration: BoxDecoration(
            //       border: Border.all(color: isSelected ? const Color(0xFFdaa78b) : Colors.transparent, width: 2.0),
            //       // color: widget.product == widget.selP
            //       //     ? Color(0xFFFFEFDC)
            //       //     : Color(0xFF36394A),
            //       gradient: LinearGradient(
            //         colors: isSelected ? [const Color(0xFFffefdc), const Color(0xFFf7dcbc)] : [const Color(0xFF2a2a42), const Color(0xFF2a2a42)],
            //         begin: Alignment.topCenter,
            //         end: Alignment.bottomCenter,
            //       ),
            //       borderRadius: BorderRadius.circular(7)),
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Text(
            //         product.pName,
            //         style: isSelected ? MyTheme.brown72_18 : MyTheme.brown248_18,
            //       ),
            //       Row(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: [
            //           Text(
            //             '¥',
            //             style: TextStyle(
            //                 fontSize: 18.sp, color: isSelected ? const Color(0xFF48170e) : const Color(0xFFffffff), fontWeight: FontWeight.bold),
            //           ),
            //           Text(
            //             promoPrice,
            //             style: TextStyle(
            //                 fontSize: 30.sp, color: isSelected ? const Color(0xFF48170e) : const Color(0xFFffffff), fontWeight: FontWeight.bold),
            //           ),
            //         ],
            //       ),
            //       Text(
            //         price,
            //         style: TextStyle(
            //           fontSize: 15.sp,
            //           color: isSelected ? const Color(0xFF7f3b29) : const Color(0xFFa1a1b2),
            //           decoration: TextDecoration.lineThrough,
            //           decorationColor: isSelected ? const Color(0xFF7f3b29) : const Color(0xFFa1a1b2),
            //         ),
            //       )
            //     ],
            //   ),
            // ),
          ],
        ),
        // if (product.giveTip.isNotEmpty)
        //   Positioned(
        //     top: 8.5.w,
        //     left: 0.5.w,
        //     child: Container(
        //       padding: EdgeInsets.symmetric(horizontal: 4.w),
        //       height: 20.w,
        //       decoration: BoxDecoration(
        //         gradient: MyTheme.vip_gradient_228_246,
        //         borderRadius: BorderRadius.only(
        //           topLeft: Radius.circular(10.w),
        //           bottomRight: Radius.circular(10.w),
        //         ),
        //       ),
        //       child: Center(
        //         child: Text(
        //           product.giveTip,
        //           style: TextStyle(
        //             color: const Color.fromRGBO(46, 24, 12, 1),
        //             fontSize: 10.sp,
        //             decoration: TextDecoration.none,
        //             fontWeight: FontWeight.w500,
        //           ),
        //         ),
        //       ),
        //     ),
        //   )
      ],
    );
  }
}

class _DescriptionArea extends StatelessWidget {
  const _DescriptionArea({required this.notifier, required this.products});

  final ValueNotifier<int> notifier;
  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: notifier,
        builder: (context, selectedIndex, child) {
          final description = products[selectedIndex].description;
          var descriptionList = [];
          if (description.isNotEmpty) {
            descriptionList = description.split('#');
          }
          return description.isEmpty
              ? Container(height: 36.w)
              : Padding(
                  padding: EdgeInsets.only(
                      left: MyTheme.pagePadding,
                      top: MyTheme.pagePadding,
                      right: MyTheme.pagePadding,
                      bottom: 30.w),
                  child: Column(
                    children: descriptionList
                        .map((e) => Center(
                              child: Text(e,
                                  style: MyTheme.white08_14_M,
                                  maxLines: 100,
                                  textAlign: TextAlign.center),
                            ))
                        .toList(),
                  ),
                );
        });
  }
}

class _RightArea extends StatelessWidget {
  const _RightArea({
    required this.notifier,
    required this.products,
  });

  final ValueNotifier<int> notifier;
  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: notifier,
        builder: (context, selectedIndex, child) {
          return ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
            shrinkWrap: true,
            itemCount: products[selectedIndex].rights.length,
            separatorBuilder: (context, index) =>
                Container(height: 12, color: Colors.transparent),
            // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            //   crossAxisCount: 2,
            //   childAspectRatio: 166 / 70,
            //   crossAxisSpacing: 10.w,
            //   mainAxisSpacing: 10.w,
            // ),
            primary: false,
            itemBuilder: (context, index) => _RightItem(
              logo: products[selectedIndex].rights[index].img,
              title: products[selectedIndex].rights[index].name,
              subTitle: products[selectedIndex].rights[index].desc,
            ),
          );
        });
  }
}

class _RightItem extends StatelessWidget {
  const _RightItem({
    required this.title,
    required this.subTitle,
    required this.logo,
  });

  final String title;
  final String subTitle;
  final String logo;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
            width: 50.w,
            height: 50.w,
            child: MyImage.network(logo, fit: BoxFit.fitHeight)),
        SizedBox(width: 8.w),
        Expanded(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  child: kIsWeb
                      ? Text(
                          title,
                          style: TextStyle(
                              color: const Color.fromRGBO(48, 161, 255, 1),
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              overflow: TextOverflow.ellipsis,
                              decoration: TextDecoration.none),
                          maxLines: 1,
                          textAlign: TextAlign.center,
                        )
                      : GradientText(
                          title,
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          style: MyTheme.white06_15_Blod,
                          gradient: const LinearGradient(
                            colors: [
                              Color.fromRGBO(48, 161, 255, 1),
                              Color.fromRGBO(87, 155, 241, 1),
                            ],
                          ),
                        ),
                ),
                SizedBox(height: 6.w),
                SizedBox(
                  child: Text(
                    subTitle,
                    style: TextStyle(
                        color: const Color.fromRGBO(255, 255, 255, 1),
                        fontSize: 12.sp,
                        overflow: TextOverflow.ellipsis,
                        decoration: TextDecoration.none),
                    maxLines: 2,
                    textAlign: TextAlign.center,
                  ),
                )
              ]),
        )
      ],
    );
  }
}

class _ExpArea extends StatelessWidget {
  const _ExpArea({
    required this.expOfVipList,
  });

  final List<ExpOfVIP> expOfVipList;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 172 / 95.0,
        crossAxisSpacing: 6.w,
        mainAxisSpacing: 10.w,
      ),
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemCount: expOfVipList.length,
      itemBuilder: (context, index) => _ExpItem(exp: expOfVipList[index]),
    );
  }
}

class _ExpItem extends StatefulWidget {
  final ExpOfVIP exp;

  const _ExpItem({
    required this.exp,
  });

  @override
  State<_ExpItem> createState() => _ExpItemState();
}

class _ExpItemState extends State<_ExpItem> {
  late final signDomain = context.read<SignDomain>();
  late final userNotifier = context.read<UserNotifier>();

  Future<void> _sendExpCoverVIP() async {
    if (userNotifier.member.exp != 0) {
      MyToast.showLoading(text: 'gmdd'.tr(context: context));
      final result = await signDomain.expConvertVIP(id: widget.exp.id);
      BotToast.closeAllLoading();
      if (result.status == 1) {
        await userNotifier.init();
        if (mounted) {
          context.pop();
        }
      }
      MyToast.showText(text: result.msg ?? '');
    } else {
      MyToast.showText(text: 'jfyebz'.tr(context: context));
    }
  }

  @override
  Widget build(BuildContext context) {
    final itemWidth =
        (MediaQuery.sizeOf(context).width - MyTheme.pagePadding * 2 - 6) / 2;
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(6.w),
          child: _buildProductImage(widget.exp, itemWidth),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // SizedBox(height: 10.w),
              Container(
                width: itemWidth - 20.w,
                height: 50.w,
                // color: Colors.deepOrange,
                child: Stack(
                  children: [
                    // Positioned.fill(
                    //   child: ClipRRect(
                    //     borderRadius: BorderRadius.circular(6.w),
                    //     child: MyImage.asset(
                    //       MyImagePaths.appMineCzItem,
                    //       // width: itemWidth - 20.w,
                    //       // height: 60.w,
                    //       fit: BoxFit.fill,
                    //     ),
                    //   ),
                    // ),
                    Positioned.fill(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // SizedBox(height: 7.w),
                                  Text(
                                    widget.exp.vipStr,
                                    style: TextStyle(
                                      color:
                                          const Color.fromRGBO(255, 236, 90, 1),
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  // SizedBox(height: 5.w),
                                  Text(
                                    getDesc(widget.exp),
                                    style: TextStyle(
                                        color: const Color.fromRGBO(
                                            255, 255, 255, 1),
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w500,
                                        overflow: TextOverflow.ellipsis),
                                    maxLines: 1,
                                  ),
                                  // SizedBox(height: 7.w),
                                ],
                              ),
                            ),
                            SizedBox(width: 10.w),
                            SizedBox.square(
                              dimension: 34.w,
                              child: MyImage.network(
                                widget.exp.icon ?? '',
                                fit: BoxFit.contain,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // SizedBox(height: 10.w),
              Row(
                children: [
                  Text(
                    widget.exp.expStr,
                    style: TextStyle(
                      color: const Color.fromRGBO(255, 255, 255, 1),
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: _sendExpCoverVIP,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 4.w, horizontal: 8.w),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(30.w)),
                          gradient: MyTheme.dhButtonGradient),
                      child: Center(
                        child: RichText(
                            text: TextSpan(
                                text: 'ljdh'.tr(context: context),
                                style: MyTheme.white255_12)),
                      ),
                    ),
                  ),
                  // SizedBox(width: 10.w),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProductImage(ExpOfVIP exp, double itemWidth) {
    return (exp.bgImg != null && exp.bgImg!.isNotEmpty)
        ? MyImage.network(exp.bgImg!,
            width: itemWidth, height: 196, fit: BoxFit.fill)
        : MyImage.asset(MyImagePaths.appMineCzBg,
            width: itemWidth, height: 196, fit: BoxFit.fill);
  }

  String getDesc(ExpOfVIP exp) {
    if (exp.desc == null || exp.desc!.isEmpty) {
      final title = widget.exp.vipStr;
      if (title == '3天VIP' || title == '60天VIP') {
        return 'cyqzzy'.tr(context: context);
      } else if (title == '10金币' || title == '20金币') {
        return 'qzjbty'.tr(context: context);
      } else if (title == '1次AI脱衣') {
        return '1cty'.tr(context: context);
      }
    } else {
      return exp.desc!;
    }
    return '';
  }
}
