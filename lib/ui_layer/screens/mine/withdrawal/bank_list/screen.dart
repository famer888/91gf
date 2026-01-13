import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../domain/api_validator.dart';
import '../../../../../domain/domain.dart';
import '../../../../../domain/model/bank_card_model.dart';
import '../../../../../domain/type_def.dart';
import '../../../../utils/common_utils.dart';
import '../../../../utils/my_toast.dart';
import '../../../common_widgets/dialog/my_dialog.dart';
import '../../../common_widgets/dialog/widgets/regular_dialog.dart';
import '../../../common_widgets/my_app_bar.dart';
import '../../../common_widgets/my_image.dart';
import '../../../common_widgets/my_list_view.dart';
import '../../../image_paths.dart';
import '../../../theme.dart';
import 'package:jygf/report/ui_layer/report_gesture_detector.dart';


class MineWithdrawalBankListScreen extends StatefulWidget {
  const MineWithdrawalBankListScreen({super.key});

  @override
  State<MineWithdrawalBankListScreen> createState() =>
      _MineWithdrawalBankListScreenState();
}

class _MineWithdrawalBankListScreenState
    extends State<MineWithdrawalBankListScreen> {
  late final userDomain = context.read<UserDomain>();
  final hasBankCardNotifier = ValueNotifier(true);
  final selectedCardNotifier = ValueNotifier<BankCard?>(null);

  final listViewKey = GlobalKey<MyListViewState>();

  Future<List<BankCard>> getBankCardList({
    required int currentPage,
    required int limit,
  }) async {
    final res = await userDomain.cashBankCardList(
      page: currentPage,
      limit: limit,
    );

    if (res.isValid) {
      if (currentPage == 1) {
        if (res.data case final data? when data.list.isNotEmpty) {
          hasBankCardNotifier.value = true;
        } else {
          hasBankCardNotifier.value = false;
        }
      }
    } else if (res.msg case final msg?) {
      MyToast.showText(text: msg);
    }

    return res.data!.list;
  }

  void _showAddBankCardDialog() {
    final cardController = TextEditingController();
    final nameController = TextEditingController();

    Widget buildTextField(
        String hint, TextEditingController controller, TextInputType type) {
      return TextField(
        textAlign: TextAlign.left,
        controller: controller,
        style: MyTheme.white15bold,
        cursorColor: Colors.white,
        keyboardType: type,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
              horizontal: MyTheme.pagePadding, vertical: MyTheme.pagePadding),
          hintText: hint.tr(context: context),
          hintStyle: MyTheme.hexb3b3b3_15_M,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.w),
            borderSide:
                const BorderSide(color: Color.fromRGBO(153, 153, 153, 1)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.w),
            borderSide:
                const BorderSide(color: Color.fromRGBO(153, 153, 153, 1)),
          ),
        ),
      );
    }

    MyDialog.showDialog(
      context: context,
      child: RegularDialog(
        content: DefaultTextStyle(
          style: MyTheme.gray102_13,
          child: SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.center,
                child: Text(
                  'tjzh'.tr(context: context),
                  style: MyTheme.white244_20_M,
                ),
              ),
              SizedBox(height: 20.w),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('zhlx'.tr(context: context)),
                  Text('yhk'.tr(context: context))
                ],
              ),
              SizedBox(height: 30.w),
              Column(children: [
                buildTextField('srkh', cardController, TextInputType.number),
                SizedBox(height: 20.w),
                buildTextField('srxm', nameController, TextInputType.text),
              ]),
              SizedBox(height: 40.w),
              ReportGestureDetector(
                onTap: () => _sendAddBankCard(
                  card: cardController.text,
                  name: nameController.text,
                ),
                child: Container(
                  width: double.infinity,
                  height: 40.w,
                  decoration: BoxDecoration(
                    gradient: MyTheme.gradient_90_114,
                    borderRadius: BorderRadius.all(Radius.circular(20.w)),
                  ),
                  child: Center(
                    child: Text(
                      'qr'.tr(context: context),
                      style: MyTheme.white255_15,
                    ),
                  ),
                ),
              )
            ],
          )),
        ),
      ),
    );
  }

  Future<void> _sendAddBankCard({
    required String card,
    required String name,
  }) async {
    try {
      if (card.isNotEmpty && name.isNotEmpty) {
        MyToast.showLoading();
        final result = await userDomain.cashAddBankCard(card: card, name: name);
        if (result.isValid) {
          await listViewKey.currentState?.reloadPage();
        } else {
          MyToast.showText(text: result.msg!);
        }
        if (mounted) {
          context.pop();
        }
        MyToast.closeAllLoading();
      } else {
        MyToast.showText(text: 'qsrxx'.tr(context: context));
      }
    } catch (e) {
      MyToast.closeAllLoading();
    }
  }

  void _showDeleteBankCardDialog({required BankCard bankCard}) {
    MyDialog.showDialog(
      context: context,
      child: RegularDialog(
        backgroundColor: const Color(0xff23262f),
        title: 'sfsk'.tr(context: context),
        cancelText: 'qx'.tr(context: context),
        buttonText: 'sch'.tr(context: context),
        confirmOnTap: () => _sendDeleteBankCard(bankcard: bankCard),
        content: Center(
          child: Column(
            children: [
              Text(
                'qrsctxzh'.tr(context: context),
                style: MyTheme.white_13,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _sendDeleteBankCard({required BankCard bankcard}) async {
    try {
      MyToast.showLoading();
      final result = await userDomain.cashDeleteBankCard(cardId: bankcard.id!);

      if (result.isValid) {
        if (bankcard == selectedCardNotifier.value) {
          selectedCardNotifier.value = null;
        }
        await listViewKey.currentState?.reloadPage();
      } else if (result.msg case final msg?) {
        MyToast.showText(text: msg);
      }
      if (mounted) {
        context.pop();
      }
      MyToast.closeAllLoading();
    } catch (e) {
      MyToast.closeAllLoading();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(
          title: 'tx'.tr(context: context),
          rightWidget: ReportGestureDetector(
            onTap: _showAddBankCardDialog,
            child: Text(
              'tji'.tr(context: context),
              style: MyTheme.gray15,
            ),
          ),
        ),
        body: Stack(
          children: [
            MyListView.list(
              key: listViewKey,
              padding: EdgeInsets.zero,
              noMoreItemsIndicator: const SizedBox.shrink(),
              itemBuilder: (context, item, index) => MyBankCard(
                card: item,
                selectedBankCardNotifier: selectedCardNotifier,
                onDelete: () => _showDeleteBankCardDialog(bankCard: item),
              ),
              onFetchingMore: (currentPage, pageSize) =>
                  getBankCardList(currentPage: currentPage, limit: pageSize),
            ),
            SafeArea(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ValueListenableBuilder(
                    valueListenable: hasBankCardNotifier,
                    builder: (context, hasBankCard, child) => hasBankCard
                        ? const SizedBox.shrink()
                        : Padding(
                            padding: EdgeInsets.only(bottom: 20.w),
                            child: ReportGestureDetector(
                              onTap: _showAddBankCardDialog,
                              child: Container(
                                alignment: Alignment.center,
                                width: 324.w,
                                height: 40.w,
                                decoration: BoxDecoration(
                                    gradient: MyTheme.gradient_90_114,
                                    borderRadius: BorderRadius.circular(5.w)),
                                child: Text(
                                  'tjxzh'.tr(context: context),
                                  style: MyTheme.white255_15,
                                ),
                              ),
                            ),
                          )),
              ),
            ),
            SafeArea(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ValueListenableBuilder(
                    valueListenable: selectedCardNotifier,
                    builder: (context, selectedCard, child) {
                      return Offstage(
                        offstage: selectedCard != null ? false : true,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 20.w),
                          child: ReportGestureDetector(
                            onTap: () {
                              context.pop(selectedCardNotifier.value);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: 328.w,
                              height: 44.w,
                              decoration: BoxDecoration(
                                gradient: MyTheme.gradient_90_114,
                                borderRadius: BorderRadius.circular((44 / 2).w),
                              ),
                              child: Text(
                                'qrtz'.tr(context: context),
                                style: MyTheme.white234_15_M,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            )
          ],
        ));
  }
}

class MyBankCard extends StatefulWidget {
  const MyBankCard({
    super.key,
    required this.card,
    required this.selectedBankCardNotifier,
    required this.onDelete,
  });
  final BankCard card;
  final ValueNotifier selectedBankCardNotifier;
  final GestureTapCallback onDelete;
  @override
  State<MyBankCard> createState() => _MyBankCardState();
}

class _MyBankCardState extends State<MyBankCard> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: widget.selectedBankCardNotifier,
        builder: (_, currentCard, __) {
          final isSelected = currentCard == widget.card;
          return Padding(
            padding: EdgeInsets.only(top: MyTheme.pagePadding),
            child: ReportGestureDetector(
                onTap: () =>
                    widget.selectedBankCardNotifier.value = widget.card,
                child: Row(
                  children: [
                    SizedBox(
                      width: 50.w,
                      child: Center(
                        child: Container(
                          width: 25.w,
                          height: 25.w,
                          decoration: isSelected
                              ? BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color.fromRGBO(109, 239, 220, 1),
                                      Color.fromRGBO(94, 79, 236, 1)
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  borderRadius: BorderRadius.circular(25.w))
                              : const BoxDecoration(
                                  color: Colors.transparent,
                                ),
                          child: isSelected
                              ? const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                )
                              : SizedBox.square(
                                  dimension: 25.w,
                                  child: const Icon(
                                    Icons.circle_outlined,
                                    color: Color.fromRGBO(90, 75, 235, 1),
                                  ),
                                ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: MyTheme.pagePadding),
                          height: 110.w,
                          width: double.infinity,
                          child: Stack(children: [
                            Positioned.fill(
                                child: Container(
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.w),
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color.fromRGBO(102, 58, 226, 1),
                                      Color.fromRGBO(117, 126, 247, 1)
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  )),
                              width: double.infinity,
                              height: double.infinity,
                            )),
                            Container(
                                width: double.infinity,
                                height: double.infinity,
                                margin: EdgeInsets.only(
                                    left: MyTheme.pagePadding,
                                    top: MyTheme.pagePadding,
                                    bottom: MyTheme.pagePadding),
                                child: Stack(
                                  children: [
                                    Positioned.fill(
                                        child: Row(
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            SizedBox(
                                              width: 235.w,
                                              height: 10.w,
                                              child: FittedBox(
                                                fit: BoxFit.cover,
                                                child: Text(
                                                  CommonUtils.subStringFour(
                                                      '${widget.card.card}'),
                                                  style: MyTheme.white19_semi,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 235.w,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    '${widget.card.bank}',
                                                    style: MyTheme.white9255_15,
                                                  ),
                                                  Text(
                                                    '持卡人: '
                                                    '${widget.card.name}',
                                                    style:
                                                        MyTheme.white255_12_M,
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        Expanded(
                                            child: Center(
                                          child: ReportGestureDetector(
                                            onTap: widget.onDelete,
                                            child: MyImage.asset(
                                              MyImagePaths.appShch,
                                              width: 16.w,
                                              height: 16.w,
                                            ),
                                          ),
                                        ))
                                      ],
                                    )),
                                  ],
                                ))
                          ])),
                    ),
                  ],
                )),
          );
        });
  }
}
