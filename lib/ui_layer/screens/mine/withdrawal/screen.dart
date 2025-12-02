import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../domain/api_validator.dart';
import '../../../../domain/async_value.dart';
import '../../../../domain/domain.dart';
import '../../../../domain/model/bank_card_model.dart';
import '../../../../domain/model/cash_withdraw_rule_model.dart';
import '../../../../domain/result.dart';
import '../../../../domain/type_def.dart';
import '../../../router/routes.dart';
import '../../../utils/common_utils.dart';
import '../../../utils/my_toast.dart';
import '../../common_widgets/dialog/my_dialog.dart';
import '../../common_widgets/dialog/widgets/regular_dialog.dart';
import '../../common_widgets/my_app_bar.dart';
import '../../common_widgets/my_image.dart';
import '../../common_widgets/screen_background.dart';
import '../../common_widgets/status/loading.dart';
import '../../common_widgets/status/network_error.dart';
import '../../image_paths.dart';
import '../../theme.dart';

class MineWithdrawalScreen extends StatefulWidget {
  const MineWithdrawalScreen({super.key, required this.isAgent});

  final bool isAgent;

  @override
  State<MineWithdrawalScreen> createState() => _MineWithdrawalScreenState();
}

class _MineWithdrawalScreenState extends State<MineWithdrawalScreen> {
  final _textController = TextEditingController();

  AsyncValue<CashWithdrawRule> _asyncValue = const AsyncInit();

  bool get isAgent => widget.isAgent;

  late final withdrawDomain = context.read<WithdrawDomain>();
  late final userDomain = context.read<UserDomain>();
  late final orderDomain = context.read<OrderDomain>();

  /// 计算后所有需要扣除的money
  final _sumAllResultMoney = ValueNotifier<int>(0);

  /// 提现到账money
  final _sumResultMoney = ValueNotifier<int>(0);

  final _currentBankCard = ValueNotifier<BankCard?>(null);

  @override
  void initState() {
    _initData();
    super.initState();
  }

  Future _initData() async {
    if (_asyncValue.isLoading) return;
    setState(() {
      _asyncValue = const AsyncLoading();
    });

    final res = (await Future.wait(
            [withdrawDomain.cashWithdrawRule(), _getDefaultBankCard()]))[0]
        as Result<CashWithdrawRule>;
    if (res.data case final data?) {
      _asyncValue = AsyncData(data);
    } else {
      if (res.msg case final msg?) {
        MyToast.showText(text: msg);
      }
      _asyncValue = const AsyncError();
    }

    if (mounted) {
      setState(() {});
    }
  }

  Future _getDefaultBankCard() async {
    try {
      final res = await userDomain.cashBankCardList(page: 1, limit: 10);
      if (res.isValid) {
        if (res.data?.list case final list? when list.isNotEmpty) {
          for (BankCard bankCard in res.data!.list) {
            if (bankCard.isDefault == 1) {
              _currentBankCard.value = bankCard;
              break;
            }
          }
        }
      } else if (res.msg case final msg?) {
        MyToast.showText(text: msg);
      }
    } catch (_) {}
  }

  void showWithdrawDialog() {
    final amount = _textController.text.trim();
    if (amount.isEmpty) {
      MyToast.showText(text: 'srje'.tr(context: context));
      return;
    }

    final card = _currentBankCard.value;
    if (card == null) {
      MyToast.showText(text: 'xzc'.tr(context: context));
      return;
    }

    MyDialog.showDialog(
      context: context,
      child: RegularDialog(
        buttonText: 'qr'.tr(context: context),
        title: 'ts'.tr(context: context),
        cancelText: 'qx'.tr(context: context),
        confirmOnTap: () async {
          if (context.mounted) {
            context.pop();
          }
          await sendWithdraw(amount: int.parse(amount), cardId: card.id!);
        },
        content: Text(
          '${'sftxd'.tr(context: context)}\n${card.bank} ${CommonUtils.subStringFour('${card.card}')}',
          style: MyTheme.graya3a2a2_15,
          maxLines: 3,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Future<void> sendWithdraw({required int amount, required int cardId}) async {
    try {
      MyToast.showLoading();
      final res = await orderDomain.incomeApplyWithdraw(
          cardId: cardId, amount: amount, type: widget.isAgent ? 1 : 2);
      if (res.isValid) {
      } else if (res.msg case final msg?) {
        MyToast.showText(text: msg);
      }

      MyToast.closeAllLoading();
    } catch (e) {
      MyToast.closeAllLoading();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      child: Scaffold(
        appBar: MyAppBar(
          title: (isAgent ? 'dltx' : 'sytx').tr(context: context),
          rightWidget: GestureDetector(
            onTap: () => const MineWithdrawalRecordRoute().push(context),
            child: Text(
              'txjl'.tr(context: context),
              style: MyTheme.gray15,
            ),
          ),
        ),
        body: _asyncValue.maybeWhen(
          error: (_, __) => NetworkErrorView(onTap: _initData),
          orElse: () => const LoadingView(),
          data: (data) => GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
              child: Stack(
                children: [
                  Positioned.fill(
                      child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 28.w),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Column(
                              children: [
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                          text:
                                              '${'ktye'.tr(context: context)}: ',
                                          style: MyTheme.hexa3a2a2_13),
                                      TextSpan(
                                        text: isAgent
                                            ? '${data.proxyMoney}'
                                            : '${data.incomeMoney}',
                                        style: MyTheme.jellyCyan_18_M,
                                      ),
                                      TextSpan(
                                          text: 'y'.tr(context: context),
                                          style: MyTheme.hexa3a2a2_13),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 15.w),
                        Text('txye'.tr(context: context),
                            style: MyTheme.white255_15_M),
                        SizedBox(height: 10.w),
                        Container(
                          height: 60.w,
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(5.w),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: MyTheme.pagePadding),
                          child: TextField(
                            onChanged: (value) {
                              value = value.isEmpty ? '0' : value;
                              setState(() {
                                _sumResultMoney.value = int.parse(value);
                                _sumAllResultMoney.value =
                                    (_sumResultMoney.value /
                                            (1 - (data.proxyRate ?? 0)))
                                        .ceil();
                              });
                            },
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            maxLength: 8,
                            controller: _textController,
                            style: MyTheme.copper25,
                            cursorColor: Colors.white,
                            textAlignVertical: TextAlignVertical.top,
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                              counter: const SizedBox.shrink(),
                              hintText: 'srje'.tr(context: context),
                              hintStyle: MyTheme.hexa3a2a2_15,
                              focusedBorder: const UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent),
                              ),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 11.5.w),
                        Row(
                          children: [
                            Text(
                              'xhj'.tr(context: context) +
                                  'kc'.tr(context: context),
                              style: MyTheme.gray143_13,
                            ),
                            ValueListenableBuilder(
                              builder: (_, value, __) {
                                return Text(
                                  '$value',
                                  style: MyTheme.jellyCyan_13,
                                );
                              },
                              valueListenable: _sumAllResultMoney,
                            ),
                            const Text(' '),
                            Text(
                              '${'dzhj'.tr(context: context)}: ',
                              style: MyTheme.gray143_13,
                            ),
                            ValueListenableBuilder(
                                valueListenable: _sumResultMoney,
                                builder: (_, value, __) {
                                  return Text(
                                    '$value',
                                    style: MyTheme.jellyCyan_13,
                                  );
                                }),
                            Text(
                              'y'.tr(context: context),
                              style: MyTheme.jellyCyan_13,
                            )
                          ],
                        ),
                        SizedBox(height: 25.w),
                        GestureDetector(
                          onTap: () async {
                            if (await const MineWithdrawalBankListRoute()
                                    .push(context)
                                case final BankCard card) {
                              _currentBankCard.value = card;
                            }
                          },
                          child: Container(
                            height: 60.w,
                            padding: EdgeInsets.symmetric(
                                horizontal: MyTheme.pagePadding),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.w),
                              color: Colors.white.withOpacity(0.2),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ValueListenableBuilder(
                                    valueListenable: _currentBankCard,
                                    builder: (_, value, __) {
                                      return value != null
                                          ? Text(
                                              '${value.bank} ${CommonUtils.subStringFour('${value.card}')}',
                                              style: MyTheme.white244_14)
                                          : Text('xztx'.tr(context: context),
                                              style: MyTheme.hexa3a2a2_15);
                                    }),
                                MyImage.asset(
                                  MyImagePaths.appYjt,
                                  width: 6.w,
                                  height: 10.w,
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 24.w),
                        Text('txgz'.tr(context: context),
                            style: MyTheme.white255_15_M),
                        SizedBox(height: 5.w),
                        Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            (isAgent
                                    ? data.ruleProxyText
                                    : data.ruleCoinsText) ??
                                data.ruleText ??
                                '',
                            style: MyTheme.black118_12,
                            strutStyle: StrutStyle(
                                forceStrutHeight: true,
                                height: 1.w,
                                leading: 0.9),
                          ),
                        )
                      ],
                    ),
                  )),
                  SafeArea(
                      child: Container(
                    alignment: Alignment.bottomCenter,
                    margin: EdgeInsets.only(bottom: 20.w),
                    child: Offstage(
                      offstage: false,
                      child: GestureDetector(
                        onTap: () {
                          showWithdrawDialog();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: 328.w,
                          height: 44.w,
                          decoration: BoxDecoration(
                              gradient: MyTheme.gradient_90_114,
                              borderRadius: BorderRadius.circular(5.w)),
                          child: Text(
                            isAgent
                                ? 'qrtz'.tr(context: context)
                                : 'fqtz'.tr(context: context),
                            style: MyTheme.white234_15_M,
                          ),
                        ),
                      ),
                    ),
                  ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
