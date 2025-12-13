import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:jygf/domain/api_validator.dart';
import 'package:jygf/domain/model/album_model.dart';
import 'package:jygf/domain/model/member_model.dart';
import 'package:jygf/domain/remote_domain/domains/album.dart';
import 'package:jygf/domain/remote_domain/domains/user.dart';
import 'package:jygf/ui_layer/notifiers/user_notifier.dart';
import 'package:jygf/ui_layer/router/routes.dart';
import 'package:jygf/ui_layer/screens/yellow_picture/yellow_picture_reader/picture_comment_sheet.dart';
import 'package:jygf/ui_layer/screens/common_widgets/dialog/my_dialog.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_app_bar.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jygf/ui_layer/screens/image_paths.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/ui_layer/utils/common_utils.dart';
import 'package:jygf/ui_layer/utils/my_toast.dart';

class YellowPictureReader extends StatefulWidget {
  const YellowPictureReader({super.key, required this.id});

  final String id;

  @override
  State<YellowPictureReader> createState() => _YellowPictureReaderState();
}

class _YellowPictureReaderState extends State<YellowPictureReader> {
  late final _domain = context.read<AlbumDomain>();
  late final domain = context.read<UserDomain>();

  List<AlbumPictureModel> pictures = [];
  AlbumDetailModel? data;
  bool isInit = false;
  bool showControl = true; //控制器的隐藏显示
  final GlobalKey _key = GlobalKey();
  double _height = 0.0;

  @override
  void initState() {
    super.initState();
    getCurrentPicsData();
  }

  @override
  void dispose() {
    super.dispose();
  }

//获取当前图集详情数据
  Future<void> getCurrentPicsData() async {
    MyToast.showLoading();
    final result = await _domain.albumDetail(id: int.parse(widget.id));
    MyToast.closeAllLoading();
    if (result.status == 1) {
      isInit = true;
      data = result.data?.detail;
      pictures = result.data?.detail?.pics ?? [];

      if ((data?.likeFct == 0 && data?.isLike == 1) || data?.likeFct == null) {
        data?.likeFct = 1;
      }
    } else {
      MyToast.showText(text: result.msg ?? '');
    }
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Positioned.fill(child: GestureDetector(
            onTap: () {
              _changeShowControl();
            },
            child: pictureListView())),
        AnimatedPositioned(
            top: showControl ? 0 : -(MyTheme.statusHeight),
            left: 0,
            right: 0,
            duration: const Duration(milliseconds: 250),
            child: Container(
              color: MyTheme.white08Color,
              height: MyTheme.statusHeight,
            )),
        AnimatedPositioned(
            top: showControl
                ? 0
                : -(MyTheme.statusHeight + MyTheme.navbarHegiht),
            left: 0,
            right: 0,
            duration: const Duration(milliseconds: 250),
            child: Container(
                color: MyTheme.white08Color,
                height: MyTheme.statusHeight + MyTheme.navbarHegiht,
                child: MyAppBar(
                    title: data?.title,
                    // backgroundColor: MyTheme.blackColor07,
                    rightWidget: GestureDetector(
                      child: Image.asset(
                        MyImagePaths.appNavShare,
                        width: 25.w,
                        height: 25.w,
                      ),
                      onTap: () {
                        const MineShareToUserRoute().push(context);
                      },
                    )))),
        AnimatedPositioned(
            bottom: showControl ? 0 : -_height,
            left: 0,
            right: 0,
            duration: const Duration(milliseconds: 250),
            child: isInit ? cofigUserView() : Container()),
      ],
    ));
  }

  _changeShowControl() {
    _getHeight();
    setState(() => showControl = !showControl);
  }

  void _getHeight() {
    final RenderBox renderBox = _key.currentContext?.findRenderObject() as RenderBox;
    setState(() {
      _height = renderBox.size.height;
    });
  }

  Widget cofigUserView() {
    return Container(
      key: _key,
      padding: EdgeInsets.all(MyTheme.pagePadding),
      color: MyTheme.white08Color,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // MyAvatar(size: 50.w, thumb: 'thumb'),
              // SizedBox(width: 9.w),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    // Text('樱井宁宁', style: MyTheme.white15),
                    RichText(
                        text: TextSpan(children: [
                      TextSpan(
                          text: '${data?.photoCt ?? 0}',
                          style: MyTheme.white16),
                      TextSpan(
                          text: 'zhang'.tr(context: context),
                          style: MyTheme.white04_12)
                    ])),
                    Text(data?.createdAt ?? '', style: MyTheme.white04_12),
                  ]))
            ],
          ),
          SizedBox(height: 13.w),
          Builder(builder: (context) {
            if ((data?.tag ?? '').isEmpty) {
              return Container();
            }
            List tags = (data?.tag ?? '').split(',');
            // if (tags.length > 3) {
            //   tags = tags.sublist(0, 3);
            // }
            return Wrap(
              runSpacing: 10.w,
              spacing: 10.w,
              children: tags
                  .map(
                    (tag) => GestureDetector(
                      onTap: () {
                        AlbumTagRoute(tag: tag).push(context);
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.w),
                        decoration: BoxDecoration(
                          color: MyTheme.white008Color,
                          borderRadius: BorderRadius.circular(5.w),
                        ),
                        child: Text(
                          tag,
                          style: MyTheme.white07_12,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            );
          }),
          (data?.tag ?? '').isEmpty ? Container() : SizedBox(height: 13.w),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 13.w),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [
                    MyImage.asset(MyImagePaths.appComicView,
                        width: 20.w, height: 20.w),
                    SizedBox(width: 3.w),
                    Text(
                      '${CommonUtils.renderFixedNumber(data?.viewFct ?? 0)}',
                      style: MyTheme.white12,
                      maxLines: 1,
                    )
                  ]),
                  GestureDetector(
                    onTap: () {
                      //点赞
                      _changeLike();
                    },
                    child: Row(children: [
                      MyImage.asset(
                          data?.isLike == 1
                              ? MyImagePaths.appShortLikeH
                              : MyImagePaths.appShortLikeN,
                          width: 20.w,
                          height: 20.w),
                      SizedBox(width: 3.w),
                      Text(
                        '${CommonUtils.renderFixedNumber(data?.likeFct ?? 0)}',
                        style: MyTheme.white12,
                        maxLines: 1,
                      )
                    ]),
                  ),
                  GestureDetector(
                    onTap: () {
                      //收藏
                      _changeFavorite();
                    },
                    child: Row(children: [
                      MyImage.asset(
                          data?.isFavorite == 1
                              ? MyImagePaths.appGameCollectOn
                              : MyImagePaths.appGameCollectOff,
                          width: 22.w,
                          height: 22.w),
                      SizedBox(width: 3.w),
                      Text(
                        '${CommonUtils.renderFixedNumber(data?.favoriteFct ?? 0)}',
                        style: MyTheme.white12,
                        maxLines: 1,
                      )
                    ]),
                  ),
                  GestureDetector(
                    onTap: () {
                      //评论
                      _showCommentSheet(context: context);
                    },
                    child: Row(children: [
                      MyImage.asset(MyImagePaths.appComicComment,
                          width: 22.w, height: 22.w),
                      SizedBox(width: 3.w),
                      Text(
                        '${CommonUtils.renderFixedNumber(data?.commentCt ?? 0)}',
                        style: MyTheme.white12,
                        maxLines: 1,
                      )
                    ]),
                  ),
                ]),
          ),
          // SizedBox(height: 5.w),
        ],
      ),
    );
  }

  _showCommentSheet({required BuildContext context}) {
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (ctx, setBottomSheetState) {
            return PictureCommentSheet(id: data?.id ?? 0);
          });
        });
  }

  Future<void> _changeLike() async {
    final result = await domain.userLike(type: 10, id: data?.id ?? 0);
    if (result.status == 1) {
      final oldValue = data?.isLike ?? 0;
      final newValue = oldValue == 0 ? 1 : 0;
      data?.isLike = newValue;
      if (newValue == 1) {
        data?.likeFct = (data?.likeFct ?? 0) + 1;
      } else {
        data?.likeFct = (data?.likeFct ?? 0) - 1;
      }
      if (mounted) {
        setState(() {});
      }
    } else {
      MyToast.showText(text: result.msg ?? '');
    }
  }

  Future<void> _changeFavorite() async {
    final result = await domain.userFavorite(type: 10, id: data?.id ?? 0);
    if (result.status == 1) {
      final oldValue = data?.isFavorite ?? 0;
      final newValue = oldValue == 0 ? 1 : 0;
      data?.isFavorite = newValue;
      if (newValue == 1) {
        data?.favoriteFct = (data?.favoriteFct ?? 0) + 1;
      } else {
        data?.favoriteFct = (data?.favoriteFct ?? 0) - 1;
      }
      if (mounted) {
        setState(() {});
      }
    } else {
      MyToast.showText(text: result.msg ?? '');
    }
  }

  Widget pictureListView() {
    return ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(vertical: 10.w),
        itemCount: pictures.length,
        itemBuilder: (context, index) {
          AlbumPictureModel model = pictures[index];

          double width = 1.sw - MyTheme.pagePadding * 2;
          final thumbWidth = (model.thumbW ?? 0).toDouble();
          final thumbHeight = (model.thumbH ?? 0).toDouble();
          final w = thumbWidth == 0.0 ? width : thumbWidth;
          final h = thumbHeight == 0.0 ? width * 1.5 : thumbHeight;
          final rota = w / h;//图片宽高比

          return Container(
            width: width, //宽度固定
            height: width / rota, //根据图片宽高比计算
            margin: EdgeInsets.only(bottom: 10.w),
            // clipBehavior: Clip.hardEdge,
            // decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.w)),
            child: Builder(builder: (context) {
              Widget ww = GestureDetector(
                // onTap: () {
                //   List<Map> picList =
                //       List.from(pictures.map((e) => e.toJson()).toList());
                //   if (data?.isPay != 1 && picList.length > 3) {
                //     picList = picList.sublist(0, 3);
                //   }
                //   PicturePreViewRoute(index, picList).push(context);
                // },
                child: MyImage.network(
                  model.thumb ?? '',
                  fit: ((model.thumbH == 0) || (model.thumbW == 0)) ? BoxFit.fitWidth : BoxFit.cover,
                ),
              );
              if (data?.isPay == 0 && index > 2) {
                ww = coverWithBlur(ww);
              }
              return ww;
            }),
          );
        });
  }

  Widget coverWithBlur(Widget child) {
    return Stack(
      children: [
        child,
        Positioned(
            top: -5,
            bottom: -5,
            left: -5,
            right: -5,
            child: CommonUtils.blurCover(onTap: () {
              _changeShowControl();
            })),
        Positioned(
          child: GestureDetector(
            onTap: buyAlbum,
            child: Center(
              child: FittedBox(
                child: Container(
                  height: 40.w,
                  padding: EdgeInsets.symmetric(horizontal: 13.w),
                  decoration: BoxDecoration(
                      color: data?.type == 1
                          ? MyTheme.redColorVIP
                          : MyTheme.jellyCyanColor,
                      borderRadius: BorderRadius.all(Radius.circular(20.w))),
                  alignment: Alignment.center,
                  child: data?.type == 1
                      ? RichText(
                          text: TextSpan(children: [
                          TextSpan(
                              text: 'vipgktj'.tr(context: context),
                              style: MyTheme.white14),
                        ]))
                      : RichText(
                          text: TextSpan(children: [
                          TextSpan(
                              text: 'zf'.tr(context: context),
                              style: MyTheme.white14),
                          TextSpan(
                              text: '${data?.coins ?? 0}',
                              style: MyTheme.white16),
                          TextSpan(
                              text: 'jbgktj'.tr(context: context),
                              style: MyTheme.white14),
                        ])),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  //金币购买/开通VIP
  buyAlbum() {
    final userNotifier = context.read<UserNotifier>();
    Member user = userNotifier.member;
    int money = user.money;
    int needmoney = data?.coins ?? 0;
    bool isInsufficient = money < needmoney;
    if (data?.type == 2) {
      MyDialog.showAnimationDialog(
          cancelTxt: 'qx'.tr(context: context),
          confirmTxt: isInsufficient
              ? 'qwcz'.tr(context: context)
              : 'gmgk'.tr(context: context),
          setContent: () {
            return Column(
              children: [
                Text(
                    'dqtjxhfajb'
                        .tr(context: context)
                        .replaceAll('a', '$needmoney'),
                    style: MyTheme.black15,
                    maxLines: 10,
                    textAlign: TextAlign.center),
                SizedBox(height: 15.w),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("${'ktvpzk'.tr(context: context)}：$money",
                        style: MyTheme.black15, textAlign: TextAlign.center),
                  ],
                ),
              ],
            );
          },
          confirm: () {
            if (isInsufficient) {
              const CoinRechargeRoute().push(context);
            } else {
              byVideoRes(money - needmoney); //直接购买
            }
          });
    } else {
      MyDialog.showAnimationDialog(
          cancelTxt: 'fxlvip'.tr(context: context),
          confirmTxt: 'czvip'.tr(context: context),
          setContent: () {
            return Text('vipgktj'.tr(context: context),
                style: MyTheme.black15,
                maxLines: 10,
                textAlign: TextAlign.center);
          },
          cancel: () {
            const MineShareToUserRoute().push(context);
          },
          confirm: () {
            const VipCenterRoute().push(context);
          });
    }
  }

  Future<void> byVideoRes(int money) async {
    MyToast.showLoading(text: 'gmzz'.tr(context: context));
    final userNotifier = context.read<UserNotifier>();
    final res = await _domain.albumBuy(id: data?.id ?? 0);
    MyToast.closeAllLoading();
    if (res.isValid) {
      userNotifier.setMoney(money: money);
      data?.isPay = 1; //更改图集权限
      setState(() {});
    } else {
      MyToast.showText(text: res.msg ?? '');
    }
  }
}
