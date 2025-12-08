import 'package:bot_toast/bot_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jygf/domain/model/member_model.dart';
import 'package:jygf/ui_layer/router/routes.dart';
import 'package:jygf/ui_layer/screens/ai_server/widgets/dialog/ai_server_dialog.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_app_bar.dart';
import 'package:jygf/ui_layer/screens/common_widgets/screen_background.dart';
import 'package:jygf/ui_layer/utils/common_utils.dart';
import 'package:provider/provider.dart';

import '../../../../domain/model/ai_server_face_model.dart';
import '../../../../domain/model/banner_model.dart';
import '../../../../domain/model/navigator_model.dart';
import '../../../../domain/remote_domain/domains/ai.dart';
import '../../../notifiers/home_config_notifier.dart';
import '../../../notifiers/user_notifier.dart';
import '../../../utils/my_toast.dart';
import '../../common_widgets/general_banner.dart';
import '../../common_widgets/my_filter_tab_bar.dart';
import '../../common_widgets/my_image.dart';
import '../../common_widgets/my_list_view.dart';
import '../../image_paths.dart';
import '../../theme.dart';

class AIFaceSwap extends StatefulWidget {
  const AIFaceSwap({
    super.key,
  });

  @override
  State<AIFaceSwap> createState() => _AIFaceSwapState();
}

class _AIFaceSwapState extends State<AIFaceSwap> {
  late final aiDomain = context.read<AIDomain>();
  late final _homeConfig = context.read<HomeConfigNotifier>();
  late final userNotifier = context.read<UserNotifier>();
  late List<FaceNavigatorModel> faceNav = [];
  late List<FaceSortModel> titles = [];
  late int faceCoinsValue = _homeConfig.config.faceCoins;
  final ValueNotifier<List<BannerModel>> bannersNotifier = ValueNotifier([]);
  late List<FaceNavigatorModel> topics = [];
  bool isInit = false;
  String sortValue = 'desc';
  int tabIndex = 0;
  FaceNavigatorModel navs = FaceNavigatorModel(id: 0, name: '');
  Map uploadObject = {};

  @override
  void initState() {
    super.initState();

    faceNav = _homeConfig.config.faceTopNav ?? [];
    titles = _homeConfig.config.faceSortNav ?? [];

    for (FaceSortModel item in titles) {
      item.sort = null;
    }

    topics = faceNav;
    if (faceNav.isNotEmpty) {
      navs = faceNav[0];
    }
  }

  @override
  void dispose() {
    //显式停止播放器,防止视频格式异常导致播放器一直在播放错误无法释放
    super.dispose();
  }

  void onChangeNav(FaceNavigatorModel item) {
    navs = item;
    setState(() {});
  }

  void slideChageTabs(int index) {
    // tabIndex = index;
  }

  void onChangeTabs(int index) {
    final item = titles[index];
    String? sort = item.sort;

    if (tabIndex == index) {
      if (item.type == 1) {
        return;
      }
      if (sort == null) {
        sortValue = 'asc';
        item.sort = sortValue;
      } else if (sort == 'asc') {
        sortValue = 'desc';
        item.sort = sortValue;
      } else if (sort == 'desc') {
        sortValue = 'asc';
        item.sort = sortValue;
      }

      setState(() {});
    }

    tabIndex = index;
  }

  Future<List<FaceMaterials>?> _getData(
      {required int page, required int pageSize, required String value}) async {
    final result = await aiDomain.faceMaterialList(
      id: navs.id,
      page: page,
      limit: pageSize,
      type: value,
      sort: sortValue,
    );

    if (!isInit) {
      setState(() {
        isInit = true;
      });
    }

    if (result.status == 1) {
      if (result.data?.banners case final data?
          when data.isNotEmpty && bannersNotifier.value.isEmpty) {
        bannersNotifier.value = data;
      }

      return result.data!.materials;
    } else {
      MyToast.showText(text: result.msg ?? '');
    }
    return null;
  }

  Future<void> imagePickerAssets() async {
    if (await CommonUtils.pickImage() case final xFile?) {
      MyToast.showLoading(text: 'scz'.tr());
      final result = await _homeConfig.uploadImage(xFile);
      if (result != null && result['code'] == 1) {
        final url = "${result['msg']}";

        final image = await decodeImageFromList(await xFile.readAsBytes());

        uploadObject = {
          'media_url': url,
          'url': _homeConfig.config.imgBase + url,
          'thumb_width': image.width,
          'thumb_height': image.height,
        };

        if (mounted) {
          setState(() {});
        }
      } else {
        MyToast.showText(text: result?['msg'] ?? 'failed');
      }
      MyToast.closeAllLoading();
    }
  }

  Future<void> onOpenMaterialDetail(FaceMaterials item) async {
    const String uploadMaxSize = '2M';
    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      builder: (context) => StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        return DecoratedBox(
          decoration: BoxDecoration(
            color: const Color.fromRGBO(29, 2, 24, 1),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.w),
              topRight: Radius.circular(30.w),
            ),
          border:const Border(top: BorderSide(color: Color.fromRGBO(154, 48, 133, 1), width: 1)),
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(15.w),
              child: ListView(
                shrinkWrap: true,
                // mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 5.w),
                    width: double.infinity,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${'mob'.tr()}-${item.title}',
                            style: MyTheme.white13),
                        const SizedBox.shrink(),
                        InkWell(
                          onTap: () => context.pop(),
                          child: Container(
                            alignment: Alignment.centerRight,
                            width: 44.w,
                            height: 44.w,
                            child: MyImage.asset(
                              MyImagePaths.appIssueClose,
                              width: 11.w,
                              height: 11.w,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5.w),
                  SizedBox(
                    height: 140.w,
                    child: MyImage.network(
                      item.thumb,
                      fit: BoxFit.fitHeight,
                      borderRadius: 6.w,
                      backgroundColor: MyTheme.white01Color,
                    ),
                  ),
                  SizedBox(height: 10.w),
                  Row(
                    children: [
                      Text('sclbxx'.tr(context: context),
                          style: MyTheme.white13),
                      const SizedBox.shrink(),
                    ],
                  ),
                  SizedBox(height: 10.w),
                  GestureDetector(
                    onTap: () {
                      imagePickerAssets().then((e) {
                        setState(() {});
                      });
                    },
                    child: CommonUtils.dashedBorder(
                      color: MyTheme.white03Color,
                      borderRadius: BorderRadius.all(Radius.circular(6.w)),
                      child: Container(
                        width: double.infinity,
                        height: 140.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(6.w)),
                          color: MyTheme.white01Color,
                        ),
                        child: uploadObject.isEmpty
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  MyImage.asset(MyImagePaths.appAiUpload,
                                  width: 45.w,
                                  height: 45.w,
                                  ),
                                  Text('djscrwxx'.tr(context: context),
                                      style: MyTheme.white13),
                                  Text(
                                      'tpdxbcg'.tr(context: context) +
                                          uploadMaxSize,
                                      style: TextStyle(
                                          fontSize: 10.sp,
                                          color: const Color(0xff9f9f9f))),
                                ],
                              )
                            : Stack(
                                children: [
                                  MyImage.network(
                                    uploadObject['url'],
                                    fit: BoxFit.fitHeight,
                                    borderRadius: 6.w,
                                    backgroundColor: MyTheme.imageBgColor,
                                  ),
                                  Positioned(
                                      top: 0,
                                      right: 0,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            uploadObject = {};
                                          });
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(5.w),
                                          decoration: const BoxDecoration(
                                              color: Color(0xFF3094FF)),
                                          child: Center(
                                              child: Icon(
                                            Icons.delete_forever,
                                            size: 20.sp,
                                            color: Colors.white,
                                          )),
                                        ),
                                      ))
                                ],
                              ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.w),
                  TipText(content: 'zyss'.tr(context: context)),
                  TipText(content: 'zyss1'.tr(context: context)),
                  TipText(content: 'zyss2'.tr(context: context)),
                  TipText(content: 'zyss3'.tr(context: context)),
                  TipText(content: 'zyss4'.tr(context: context)),
                  TipText(content: 'zyss5'.tr(context: context)),
                  SizedBox(height: 10.w),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      UploadFaceTip(
                          thumb: MyImagePaths.uploadFaceRight,
                          title: 'zqwzl'.tr(context: context)),
                      UploadFaceTip(
                          thumb: MyImagePaths.uploadFaceError1,
                          title: 'zdlb'.tr(context: context)),
                      UploadFaceTip(
                          thumb: MyImagePaths.uploadFaceError2,
                          title: 'zdyj'.tr(context: context))
                    ],
                  ),
                  SizedBox(height: 10.w),
                  Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text('${'xhjb'.tr(context: context)}：',
                            style: MyTheme.white13),
                        Text('$faceCoinsValue', style: MyTheme.nav_active_14),
                        SizedBox(width: 10.w),
                        Text('${'mfcs'.tr(context: context)}：',
                            style: MyTheme.white13),
                        Selector<UserNotifier, int>(
                            selector: (_, config) => config.member.imgFaceValue,
                            builder: (context, number, child) {
                              return Text('$number',
                                  style: MyTheme.nav_active_14);
                            }),
                        const Expanded(child: SizedBox()),
                        GestureDetector(
                          onTap: () async {
                            if (uploadObject.isEmpty) {
                              AiServerDialog.showTip(context, 'qsctp'.tr());    
                              return;
                            }
                            MyToast.showLoading();

                            Member? user = userNotifier.member;
                            final userCoins = user.money; //用户剩余金币

                            final result = await aiDomain.changeFace(
                                id: item.id,
                                thumb: uploadObject['media_url'],
                                thumbW: uploadObject['thumb_width'],
                                thumbH: uploadObject['thumb_height']);
                            BotToast.closeAllLoading();
                            if (result.status == 1) {
                              setState(() {
                                uploadObject = {};
                              });
                              final imgFaceValue =
                                  userNotifier.member.imgFaceValue - 1;
                              if (imgFaceValue >= 0) {
                                //更新用户剩余次数
                                userNotifier.setImgFaceValue(num: imgFaceValue);
                              } else {
                                //免费次数不够直接扣金币，刷新用户金币余额
                                userNotifier.setMoney(
                                    money: userNotifier.member.money -
                                        faceCoinsValue); //更新用户的金币数量
                              }
                              AiServerDialog.showSubmitSuccess(context);
                            } else {
                              if (result.msg != '余额不足') {
                                MyToast.showText(text: result.msg ?? '提交失败');
                                return;
                              }
                              //余额不足，提示金币不足
                              AiServerDialog.showBalanceNotEnough(context, userCoins);
                              return;
                            }
                          },
                          child: Container(
                            width: 115.w,
                            height: 40.w,
                            padding: EdgeInsets.symmetric(vertical: 10.w),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.w)),
                                gradient: MyTheme.gradient_90_114),
                            child: Center(
                              child: Text('ljzz'.tr(context: context),
                                  style: MyTheme.white15bold),
                            ),
                          ),
                        )
                      ]),
                  SizedBox(height: 10.w)
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      child: Scaffold(
          appBar: MyAppBar(
            title: 'AI换脸',
            rightWidget: TextButton(
              onPressed: () {
                const MineAIRecordRoute(index: 3).push(context);
              },
              child: Center(
                child: Text(
                  'wdai'.tr(),
                  style: MyTheme.white255_13,
                ),
              ),
            ),
          ),
          body: NestedScrollView(
            headerSliverBuilder: (_, __) => [
              SliverToBoxAdapter(
                child: _Header(
                  bannersNotifier: bannersNotifier,
                  topics: topics,
                  onLinkNavTap: onChangeNav,
                  currentNav: navs,
                ),
              ),
            ],
            body: TabFilterBarWithView.fillColor(
              fillCorlor: Colors.transparent,
              isScrollable: true,
              // key: ValueKey(navs),
              tabBarPadding: EdgeInsets.symmetric(
                  vertical: 10.w, horizontal: MyTheme.pagePadding),
              tabBarHeight: 32.w,
              labelStyle: MyTheme.white12,
              unselectedLabelStyle: MyTheme.whiteOpacity612w400,
              onTapTab: onChangeTabs,
              slideChageTab: slideChageTabs,
              titles: isInit ? titles : [],
              views: [
                for (final FaceSortModel nav in titles)
                  MyListView.grid(
                      key: UniqueKey(),
                      padding:
                          EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
                      childAspectRatio: 170 / 250,
                      itemBuilder: (context, item, index) => MaterrialCard(
                            data: item,
                            onTap: onOpenMaterialDetail,
                            index: index,
                          ),
                      onFetchingMore: (currentPage, pageSize) => _getData(
                            page: currentPage,
                            pageSize: pageSize,
                            value: nav.value,
                          ))
                // MyListView.masonryGrid(
                //     key: UniqueKey(),
                //     padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
                //     itemBuilder: (context, item, index) => MaterrialCard(
                //           data: item,
                //           onTap: onOpenMaterialDetail,
                //           index: index,
                //         ),
                //     onFetchingMore: (currentPage, pageSize) => _getData(
                //           page: currentPage,
                //           pageSize: pageSize,
                //           value: nav.value,
                //         ))
              ],
            ),
          )),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.bannersNotifier,
    required this.topics,
    required this.onLinkNavTap,
    required this.currentNav,
  });

  final ValueNotifier<List<BannerModel>> bannersNotifier;
  final List<FaceNavigatorModel> topics;
  final Function(FaceNavigatorModel) onLinkNavTap;
  final FaceNavigatorModel currentNav;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 6.w),
        ValueListenableBuilder(
          valueListenable: bannersNotifier,
          builder: (context, banners, child) {
            if (banners.isEmpty) return const SizedBox.shrink();
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
              child: GeneralBannerAppsListWidget(data: banners),
            );
          },
        ),
        SizedBox(height: 10.w),
        Padding(
          padding: EdgeInsets.only(bottom: 5.w),
          child: GridView.builder(
              shrinkWrap: true,
              addRepaintBoundaries: false,
              addAutomaticKeepAlives: false,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: topics.length,
              padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 80.w / 35.w,
                mainAxisSpacing: 5.w,
                crossAxisSpacing: 5.w,
              ),
              itemBuilder: (context, index) {
                final topic = topics[index];
                return GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    onLinkNavTap(topic);
                  },
                  child: DecoratedBox(
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.w),
                      ),
                      gradient: topic.id == currentNav.id
                          ? MyTheme.gradient_90_114
                          : MyTheme.gradient_90_114_15,
                    ),
                    child: Center(
                      child: Text(
                        topic.name,
                        style: topic.id == currentNav.id
                            ? MyTheme.white255_13_B
                            : MyTheme.white13,
                      ),
                    ),
                  ),
                );
              }),
        ),
      ],
    );
  }
}

class MaterrialCard extends StatelessWidget {
  const MaterrialCard(
      {super.key,
      required this.data,
      required this.onTap,
      required this.index});

  final FaceMaterials data;
  final Function(FaceMaterials) onTap;

  final int index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(data),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                MyImage.network(
                  data.thumb,
                  fit: BoxFit.cover,
                  borderRadius: 6.w,
                  backgroundColor: MyTheme.imageBgColor,
                ),
                data.isHot == 1
                    ? Positioned(
                        left: 7.5.w,
                        top: 5.w,
                        child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          height: 19.w,
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(255, 56, 106, 0.8),
                            borderRadius: BorderRadius.all(Radius.circular(4.w)),
                          ),
                          child: Text('rm'.tr(context: context),
                              style: MyTheme.white12),
                        ))
                    : Container(),
                Positioned(
                    right: 7.5.w,
                    bottom: 6.w,
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      height: 19.w,
                      decoration: BoxDecoration(
                        gradient: MyTheme.gradient_90_114,
                        borderRadius: BorderRadius.all(Radius.circular(19.w)),
                      ),
                      child: Text('${'sycs'.tr(context: context)}${data.usedFct}',
                          style: MyTheme.white12medium),
                    ))
              ],
            ),
          ),
          SizedBox(height: 5.w),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              data.title,
              style: MyTheme.white13,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
    );
  }
}

class UploadFaceTip extends StatelessWidget {
  const UploadFaceTip({super.key, required this.thumb, required this.title});

  final String thumb;
  final String title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          Image.asset(
            thumb,
            width: 60.w,
            fit: BoxFit.fitHeight,
          ),
          SizedBox(height: 10.w),
          Text(
            title,
            style: MyTheme.white13,
          )
        ],
      ),
    );
  }
}

class TipText extends StatelessWidget {
  const TipText({super.key, required this.content});

  final String content;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(content, style: MyTheme.white11),
        const SizedBox.shrink(),
      ],
    );
  }
}
