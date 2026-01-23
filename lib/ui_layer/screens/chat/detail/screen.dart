import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper_null_safety_flutter3/flutter_swiper_null_safety_flutter3.dart';
import 'package:go_router/go_router.dart';
import 'package:jygf/domain/model/chat/chat_detail_model.dart';
import 'package:jygf/domain/model/common_media_model.dart';
import 'package:jygf/domain/model/media_model.dart';
import 'package:jygf/domain/model/member_model.dart';
import 'package:jygf/domain/model/post/post_media_model.dart';
import 'package:jygf/domain/remote_domain/domains/chat.dart';
import 'package:jygf/domain/type_def.dart';
import 'package:jygf/ui_layer/notifiers/user_notifier.dart';
import 'package:jygf/ui_layer/router/routes.dart';
import 'package:jygf/ui_layer/screens/common_widgets/dialog/my_dialog.dart';
import 'package:jygf/ui_layer/screens/common_widgets/dialog/widgets/regular_dialog.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_app_bar.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_button.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jygf/ui_layer/screens/common_widgets/screen_background.dart';
import 'package:jygf/ui_layer/screens/common_widgets/status/loading.dart';
import 'package:jygf/ui_layer/screens/common_widgets/status/network_error.dart';
import 'package:jygf/ui_layer/screens/image_paths.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/ui_layer/utils/common_utils.dart';
import 'package:jygf/ui_layer/utils/my_toast.dart';
import 'package:provider/provider.dart';
import 'package:jygf/report/ui_layer/report_gesture_detector.dart';


class ChatDetailScreen extends StatefulWidget {
  const ChatDetailScreen({super.key, required this.id});

  final int id;
  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen>
    with WidgetsBindingObserver {
  late final _domain = context.read<ChatDomain>();
  late final _userNotifier = context.read<UserNotifier>();

  bool isHud = true;
  bool netError = false;
  bool noMore = false;

  bool isReplay = false;
  String commid = '0';
  String tip = 'wyddxf'.tr();
  int _selectedIndex = 0;

  late ChatInfoModel data;
  List<CommonMediaModel> _medias = [];

  Map picMap = {};

  void getData() async {
    final result = await _domain.chatDetail(id: widget.id);
    isHud = false;

    if (result.data?.chat case final girlData when girlData != null) {
      data = girlData;
      _medias = girlData.medias ?? [];

      netError = false;
      if (mounted) setState(() {});
    }
    else {
      netError = true;
      if (mounted) setState(() {});
    }
  }

  //收藏
  void postCollectData() async {
    final result = await _domain.chatFavorite(id: widget.id);

    if (result.status == 1) {
      data.isFavorite = data.isFavorite == 0 ? 1 : 0;
      int favoriteFct = data.favoriteFct ?? 0;
      favoriteFct += data.isFavorite == 1 ? 1 : -1;
      if (favoriteFct < 0) {
        favoriteFct = 0;
      }
      data.favoriteFct = favoriteFct;
      setState(() {});
    }
    else {
      MyToast.showText(text: result.msg ?? '');
    }
  }

  //购买
  void buyChat() async {
    final userNotifier = context.read<UserNotifier>();

    Member? user = userNotifier.member;
    final userCoins = user.money; //用户剩余金币

    bool isInsufficient = userCoins < data.coins!;

    MyDialog.showDialog(
      context: context,
      child: RegularDialog(
        buttonText: isInsufficient ? tr('qwcz') : tr('gmgk'),
        cancelText: 'qx'.tr(),
        title: 'ts'.tr(),
        content: Column(children: [
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(children: [
              TextSpan(
                text: '${data.coins}${'jbjs'.tr()}',
                style: MyTheme.white08_15,
              ),
            ]),
          ),
          Text(
            "${'ktvpzk'.tr()}: $userCoins",
            style: MyTheme.white08_15,
          ),
        ]),
        confirmOnTap: () {
          //前往充值
          context.pop();

          if (isInsufficient) {
            const CoinRechargeRoute().push(context);
          }
          else {
            reqChatBuy(userCoins - data.coins!);
          }
        },
        cancelOnTap: () {
          //取消
          context.pop();
        },
      ),
    );
  }

  reqChatBuy(int money) async {
    final result = await _domain.chatBuy(id: widget.id);

    if (result.status == 1) {
      data.contact = result.data['contact'];

      _userNotifier.setMoney(money: money);

      setState(() {});
    }
    else {
      MyToast.showText(text: result.msg ?? '');
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    final member = _userNotifier.member;
    return ScreenBackground(
      child: Stack(children: [
        Scaffold(
          body: netError
              ? NetworkErrorView(
                  text: 'wlcw'.tr(),
                  onTap: getData,
                )
              : isHud
                    ? const LoadingView()
                    : SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 1.sw,
                              child: Stack(children: [
                                Swiper(
                                  itemCount: _medias.length,
                                  itemBuilder: (context, index) {
                                    return ReportGestureDetector(
                                      onTap: () {
                                        if (_medias[index].mediaType != 1) {
                                          return;
                                        }
      
                                        List<MediaModel> pics = [];
                                        for (var element in _medias) {
                                          if (element.mediaType == 1) {
                                            pics.add(MediaModel.fromJson({
                                              'media_url': element.mediaUrl
                                            }));
                                          }
                                        }
      
                                        Map pPicMap = Map.from(picMap);
                                        pPicMap['resources'] = pics;
      
                                        int jumpIndex = 0;
                                        for (var i = 0; i < pics.length; i++) {
                                          if (pics[i].mediaUrl ==
                                              _medias[index].mediaUrl) {
                                            jumpIndex = i;
                                            break;
                                          }
                                        }
                                        pPicMap['index'] = jumpIndex;
      
                                        MediaViewerRoute({
                                          'resources': pics,
                                          'index': jumpIndex
                                        }).push(context);
                                      },
                                      child: Image.network(
                                          _medias[index].mediaCover ?? '',
                                        fit: BoxFit.fitHeight,
                                      ),
                                      // child: ClipRect(
                                      //   child: Image.network(
                                      //     CommonUtils.clipImageUrl(
                                      //       _medias[index].mediaCover ?? '',
                                      //       inputWidth: 1.sw,
                                      //     ),
                                      //     width: double.infinity,
                                      //     fit: BoxFit.cover,
                                      //     alignment: Alignment.topCenter,
                                      //     errorBuilder: (context, error, stackTrace) {
                                      //       return Container();
                                      //     },
                                      //   ),
                                      // ),
                                    );
                                  },
                                  onIndexChanged: (index) {
                                    _selectedIndex = index;
                                    setState(() {});
                                  },
                                ),
                                Positioned(
                                  right: 10.w,
                                  bottom: 10.w,
                                  child: Container(
                                    width: 33.w,
                                    height: 16.w,
                                    decoration: BoxDecoration(
                                      color: MyTheme.white02Color,
                                      borderRadius: BorderRadius.circular(2.w),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${_selectedIndex + 1} / ${_medias.length}',
                                        style: MyTheme.white10,
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: MyTheme.pagePadding),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: 15.w),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${data.name}',
                                              style: MyTheme.white16bold,
                                            ),
                                            SizedBox(height: 5.w),
                                            Text(
                                              (data.payFct.toString()) + 'rlg'.tr(),
                                              style: MyTheme.white08_15,
                                            ),
                                          ],
                                        ),
                                        Row(children: [
                                          ReportGestureDetector(
                                            onTap: () {
                                              const MineShareToUserRoute()
                                                  .push(context);
                                            },
                                            child: SizedBox(
                                              height: 17.w,
                                              width: 45.w,
                                              child: Row(children: [
                                                MyImage.asset(
                                                  MyImagePaths.appChatShare,
                                                  width: 15.w,
                                                  height: 15.w,
                                                ),
                                                const Spacer(),
                                                Text(
                                                  'fx'.tr(),
                                                  style: MyTheme.white04_12,
                                                )
                                              ]),
                                            ),
                                          ),
                                          SizedBox(width: 12.w),
                                          ReportGestureDetector(
                                            behavior: HitTestBehavior.translucent,
                                            onTap: postCollectData,
                                            child: SizedBox(
                                              height: 17.w,
                                              width: 45.w,
                                              child: Row(children: [
                                                MyImage.asset(
                                                  data.isFavorite == 1
                                                    ? MyImagePaths.appGameCollectOn
                                                    : MyImagePaths.appAlbumCollectN,
                                                  width: 15.w,
                                                  height: 15.w,
                                                ),
                                                const Spacer(),
                                                Text(
                                                  CommonUtils.renderFixedNumber(
                                                      data.favoriteFct ?? 0),
                                                  style: MyTheme.white04_12,
                                                ),
                                              ]),
                                            ),
                                          ),
                                        ])
                                      ],
                                    ),
                                  ),
                                  Container(
                                    color: MyTheme.white05Color,
                                    height: 0.2.w,
                                    margin: EdgeInsets.only(top: 7.w),
                                  ),
                                  SizedBox(height: 15.w),
                                  Text(
                                    'grzl'.tr(),
                                    style: MyTheme.white16bold,
                                  ),
                                  SizedBox(height: 7.5.w),
                                  RichText(
                                    text: TextSpan(
                                      style: TextStyle(
                                        color: MyTheme.white06Color,
                                        fontSize: 14.sp,
                                        height: 1.6,
                                      ),
                                      children: [
                                        TextSpan(text: '${'grzl'.tr()}：', style:const  TextStyle(color: Colors.white)),
                                        TextSpan(text: '${data.age}${'sold'.tr()}/${data.cup}${'bzcup'.tr()}/${data.weight}${'k'.tr()}/${data.height}${'c'.tr()}'),
                                        TextSpan(text: '\n${'xfqk'.tr()}：', style:const  TextStyle(color: Colors.white)),
                                        TextSpan(text: '${data.price}'),
                                        TextSpan(text: '\n${'fwsj'.tr()}：', style:const  TextStyle(color: Colors.white)),
                                        TextSpan(text: '${data.time}'),
                                        TextSpan(text: '\n${'fwxm'.tr()}：', style:const  TextStyle(color: Colors.white)),
                                        TextSpan(text: '${data.option}'),
                                        TextSpan(text: '\n${'jiesao'.tr()}：', style:const TextStyle(color: Colors.white)),
                                        TextSpan(text: '${data.price}'),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 15.w),
                                 // '${data.contact}'.isEmpty
                                     member.chatPrivilege != 1 ? Column(children: [
                                          CommonUtils.dashedBorder(
                                            color: MyTheme.primaryColor,
                                            borderRadius: BorderRadius.circular(8.w),
                                            child: Container(
                                              alignment: Alignment.center,
                                              clipBehavior: Clip.hardEdge,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(8.w),
                                                color: MyTheme.white02Color,
                                              ),
                                              height: 70.w,
                                              width: 343.w,
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  MyImage.asset(
                                                    MyImagePaths.appGameLock,
                                                    width: 16.w,
                                                  ),
                                                  SizedBox(width: 10.w),
                                                  Text(
                                                    'lxfsyyc'.tr(),
                                                    style: TextStyle(
                                                      color: MyTheme.primaryColor,
                                                      fontSize: 14.sp,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.symmetric(
                                              vertical: 15.w,
                                      
                                            ),
                                            child: MyButton.gradient(
                                              minimumSize: Size.fromHeight(40.w),
                                              onPressed: () async {
                                          buyChat();
                                        },
                                              borderRadius: 20.w,
                                              text: data.type == 1 // 0： 免费 1:VIP 2:金币
                                                  ? 'vmfjs'.tr()
                                                  : '${data.coins}${'jbjs'.tr()}',
                                            ),
                                          )
                                        ])
                                      : CommonUtils.dashedBorder(
                                        color: MyTheme.primaryColor,
                                        borderRadius: BorderRadius.circular(8.w),
                                        child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(8.w),
                                              color: MyTheme.white02Color,
                                            ),
                                            height: 70.w,
                                            width: double.infinity,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 15.w),
                                            child: Center(
                                              child: RichText(
                                                maxLines: 999,
                                                text: TextSpan(children: [
                                                  TextSpan(text: '${'lxfs'.tr()}: ', style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 13.sp,
                                                      fontWeight: FontWeight.w500,
                                                    ),),  
                                                  TextSpan(
                                                    text: data.contact,
                                                    style: TextStyle(
                                                      color: MyTheme.yellow255123Color,
                                                      fontSize: 13.sp,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                  WidgetSpan(
                                                    child: ReportGestureDetector(
                                                      behavior:
                                                      HitTestBehavior.translucent,
                                                      onTap: () {
                                                        CommonUtils.copyToClipboard(
                                                            text: '${data.contact}');
                                              
                                                        MyToast.showText(
                                                            text: 'yfz'.tr());
                                                      },
                                                      child: Text(
                                                        '（${'djfz'.tr()}）',
                                                        style: TextStyle(
                                                          color: MyTheme.primaryColor,
                                                          fontSize: 13.sp,
                                                          fontWeight: FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ]),
                                              ),
                                            ),
                                          ),
                                      ),
                                  SizedBox(height: 15.w),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
        ),
        const MyAppBar(),
      ]),
    );
  }
}
