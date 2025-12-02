import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:jygf/domain/api_validator.dart';
import 'package:jygf/domain/domain.dart';
import 'package:jygf/domain/model/member_model.dart';
import 'package:jygf/domain/model/soul_group_model.dart';
import 'package:jygf/domain/type_def.dart';
import 'package:jygf/ui_layer/notifiers/home_config_notifier.dart';
import 'package:jygf/ui_layer/notifiers/user_notifier.dart';
import 'package:jygf/ui_layer/router/routes.dart';
import 'package:jygf/ui_layer/screens/common_widgets/dialog/my_dialog.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_avatar.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/ui_layer/utils/common_utils.dart';
import 'package:jygf/ui_layer/utils/my_toast.dart';

class SoulGroudListCard extends StatefulWidget {
  const SoulGroudListCard({super.key, required this.data});

  final GroupsModel data;

  @override
  State<SoulGroudListCard> createState() => _SoulGroudListCardState();
}

class _SoulGroudListCardState extends State<SoulGroudListCard> {
  late final userNotifier = context.read<UserNotifier>();
  late final homeNotifier = context.read<HomeConfigNotifier>();

  @override
  Widget build(BuildContext context) {
    String unreadCtStr = '${widget.data.unreadCt ?? 0}';
    if ((widget.data.unreadCt ?? 0) >= 99) {
      unreadCtStr = '+99';
    }

    return Column(children: [
      GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          setState(() {
            widget.data.unreadCt = 0;
          });
          if (widget.data.isJoin == 1) {
            //已加入可直接加入群聊
            GroupChatListContentRoute(widget.data).push(context);
          } else {
            _showAlertVp();
          }
        },
        child: Container(
          decoration: BoxDecoration(
              color: MyTheme.white008Color,
              borderRadius: BorderRadius.circular(15.w)),
          padding: EdgeInsets.all(MyTheme.pagePadding),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  MyAvatar(size: 75.w, thumb: widget.data.thumb),
                  (widget.data.unreadCt ?? 0) > 0
                      ? Positioned(
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 5.w),
                            decoration: BoxDecoration(
                                color: MyTheme.redColorVIP,
                                borderRadius: BorderRadius.circular(10.w)),
                            child: Text(unreadCtStr, style: MyTheme.white11),
                          ))
                      : Container()
                ],
              ),
              SizedBox(width: 9.5.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${widget.data.title}', style: MyTheme.white15),
                    SizedBox(height: 3.w),
                    Text('${widget.data.desc}', style: MyTheme.white04_12),
                    SizedBox(height: 3.w),
                    SizedBox(
                      height: 27.w,
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                                'ID: ${widget.data.id}     ${CommonUtils.renderNumber(widget.data.affFCt ?? 0)}${tr('rzw')}',
                                style: MyTheme.white04_11),
                          ),
                          widget.data.isJoin == 1
                              ? Container()
                              : GestureDetector(
                                  onTap: () {
                                    //加入聊天
                                    _showAlertVp(isBtnJoin: true);
                                  },
                                  child: Container(
                                      width: 68.w,
                                      height: 27.w,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          gradient: MyTheme.gradient_228_246,
                                          borderRadius:
                                              BorderRadius.circular(15.w)),
                                      child: Text(tr('jrlt'),
                                          style: MyTheme.white12medium)),
                                )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ]);
  }

  Future _joinSoulGroup(int id, {int? money}) async {
    late final domain = context.read<AppDomain>();

    final param = Map.from({})..['id'] = id;
    final res = await domain.getConstructByApiLink(
      apiLink: 'chatgroup/join_group',
      params: param,
    );

    if (res.isValid) {
      final int? isJoin = res.data['is_join'] ?? 0;
      widget.data.isJoin = isJoin;
      widget.data.affFCt = (widget.data.affFCt ?? 0) + 1;

      if (money != null) {
        //通过金币购买成功，刷新用户余额
        userNotifier.setMoney(money: money);
      }

      // eventBus.fire(MyEvent('RrefrehSoulGroup',
      //     param: {'isNotNeedRefresh': true})); //发通知去群广场界面/我加入的列表界面刷新数据
    } else {
      MyToast.showText(text: res.msg ?? '');
    }

    setState(() {});
  }

  void _showAlertVp({bool? isBtnJoin}) {
    Member user = userNotifier.member;
    int money = user.money;
    int needmoney = homeNotifier.config.joinChatGroupCoins ?? 0;
    bool isInsufficient = money < needmoney;

    if (widget.data.isAccess == 1) {
      if (isBtnJoin == true) {
        //通过点击加入群聊按钮，可直接可加入群聊
        _joinSoulGroup(widget.data.id ?? 0);
      } else {
        MyDialog.showAnimationDialog(
            confirmTxt: 'ljjr'.tr(context: context),
            setContent: () {
              return Text('请您先加入群聊！',
                  style: MyTheme.black13,
                  maxLines: 3,
                  textAlign: TextAlign.center);
            },
            confirm: () {
              _joinSoulGroup(widget.data.id ?? 0);
            });
      }
    } else {
      MyDialog.showAnimationDialog(
          cancelTxt: 'czvip'.tr(context: context),
          confirmTxt: isInsufficient
              ? 'qwcz'.tr(context: context)
              : 'ljjr'.tr(context: context),
          setContent: () {
            return Column(
              children: [
                Text(widget.data.payTip ?? '',
                    style: MyTheme.black13,
                    maxLines: 3,
                    textAlign: TextAlign.center),
                SizedBox(height: 15.w),
                Text("$needmoney${'jb'.tr(context: context)}",
                    style: MyTheme.orange247_15M, textAlign: TextAlign.center),
                SizedBox(height: 15.w),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("${'ktvpzk'.tr(context: context)}：$money",
                        style: MyTheme.black13),
                  ],
                ),
              ],
            );
          },
          cancel: () {
            const VipCenterRoute().push(context);
          },
          confirm: () {
            if (isInsufficient) {
              const CoinRechargeRoute().push(context);
            } else {
              //余额足够，通过金币直接加入
              _joinSoulGroup(widget.data.id ?? 0, money: money - needmoney);
            }
          });
    }
  }
}
