import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jygf/domain/enum.dart';
import 'package:provider/provider.dart';
import 'package:jygf/domain/api_validator.dart';
import 'package:jygf/domain/domain.dart';
import 'package:jygf/domain/model/media_model.dart';
import 'package:jygf/domain/model/member_model.dart';
import 'package:jygf/domain/model/soul_group_model.dart';
import 'package:jygf/domain/type_def.dart';
// import 'package:jygf/ui_layer/notifiers/ai_chat_notifier.dart';
import 'package:jygf/ui_layer/notifiers/home_config_notifier.dart';
import 'package:jygf/ui_layer/notifiers/user_notifier.dart';
import 'package:jygf/ui_layer/router/routes.dart';
import 'package:jygf/ui_layer/screens/common_widgets/event_bus/event_bus.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_app_bar.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_avatar.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jygf/ui_layer/screens/common_widgets/screen_background.dart';
import 'package:jygf/ui_layer/screens/image_paths.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/ui_layer/utils/common_utils.dart';
import 'package:jygf/ui_layer/utils/my_toast.dart';

class GroupChatListContent extends StatefulWidget {
  const GroupChatListContent({
    super.key,
    required this.data,
  });

  final GroupsModel data;

  @override
  State<GroupChatListContent> createState() => _GroupChatListContentState();
}

class _GroupChatListContentState extends State<GroupChatListContent>
    with WidgetsBindingObserver {
  late final _appDomain = context.read<AppDomain>();
  late final FocusNode _focusNode;
  final TextEditingController _controllerText = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late final _homeConfig = context.read<HomeConfigNotifier>();
  List<GroupsMessageModel> _messages = [];

  bool isKeyboardVisible = false;

  late final configNotifier = context.read<HomeConfigNotifier>();
  late final userNotifier = context.read<UserNotifier>();
  late final member = userNotifier.member;
  final GlobalKey _globalKey = GlobalKey();

  double bottomInset = 0.0;

  int pullUpRefreshTimestamp = 0;
  int pullDownRefreshTimestamp = 0;
  bool pullDownRefreshNoMore = false;

  bool _isLoadingNewMasg = false;

  GroupsMessageModel? _topMasg; //置顶消息

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    _focusNode = FocusNode();

    _initChatList();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !_isLoadingNewMasg) {
        _getPullUpMsg();
      }
    });
  }

  Future<void> _initChatList() async {
    await _getCurrentTimerMsg();
  }

  @override
  void didChangeMetrics() {
    // 检测键盘的显示状态
    bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
    // if (bottomInset > 0.0) {
    //   _scrollToBottom();
    // }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _scrollController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  //获取时间戳节点
  Future<void> _getCurrentTimerMsg() async {
    final param = Map.from({})..['id'] = widget.data.id;

    final result = await _appDomain.getConstructByApiLink(
      apiLink: 'chatgroup/msg',
      params: param,
    );
    if (result.status == 1) {
      pullUpRefreshTimestamp =
          result['data']['next'] ?? 0; //当前的微秒级记录节点：用于上拉接口参数ms
      pullDownRefreshTimestamp =
          result['data']['ms'] ?? 0; //最新的微秒级时间戳节点: 用于下拉接口参数ms
      final List<GroupsMessageModel> msgs = result.data['msgs']
              ?.map<GroupsMessageModel>((x) => GroupsMessageModel.fromJson(x))
              .toList() ??
          [];
      _topMasg = result['data']['top'] == null
          ? null
          : GroupsMessageModel.fromJson(result['data']['top']);
      _messages = msgs;
      await _getPullDownMsg();
    } else {
      MyToast.showText(text: result.msg ?? '');
    }

    if (mounted) {
      setState(() {});
    }
    _scrollToBottom();
  }

  //下拉刷新
  Future<void> _getPullDownMsg() async {
    if (pullDownRefreshNoMore) {
      return;
    }

    final param = Map.from({})
      ..['ms'] = pullDownRefreshTimestamp
      ..['id'] = widget.data.id;

    final result = await _appDomain.getConstructByApiLink(
      apiLink: 'chatgroup/history',
      params: param,
    );
    if (result.status == 1) {
      pullDownRefreshTimestamp =
          result['data']['ms'] ?? 0; //最新的微秒级时间戳节点: 用于下拉接口参数ms
      final List<GroupsMessageModel> msgs = result.data['msgs']
              ?.map<GroupsMessageModel>((x) => GroupsMessageModel.fromJson(x))
              .toList() ??
          [];
      if (msgs.isEmpty) {
        pullDownRefreshNoMore = true;
      }
      _messages.insertAll(0, msgs); //插入前面
    } else {
      MyToast.showText(text: result.msg ?? '');
    }

    if (mounted) {
      setState(() {});
    }
  }

  //上拉刷新
  Future<void> _getPullUpMsg() async {
    _isLoadingNewMasg = true;

    final param = Map.from({})
      ..['ms'] = pullUpRefreshTimestamp
      ..['id'] = widget.data.id;

    final result = await _appDomain.getConstructByApiLink(
      apiLink: 'chatgroup/new',
      params: param,
    );

    if (result.status == 1) {
      pullUpRefreshTimestamp =
          result['data']['next'] ?? 0; //最新的微秒级时间戳节点: 用于上拉接口参数ms
      final List<GroupsMessageModel> msgs = result.data['msgs']
              ?.map<GroupsMessageModel>((x) => GroupsMessageModel.fromJson(x))
              .toList() ??
          [];

      msgs.map((e) {
        if (e.isUser == false) {
          _messages.add(e); //插入后面
        }
      });

      _isLoadingNewMasg = false;
    } else {
      MyToast.showText(text: result.msg ?? '');
    }

    if (mounted) {
      setState(() {});
      // _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
        child: Scaffold(
            appBar: MyAppBar(
              titleWidget: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(widget.data.title ?? '', style: MyTheme.white18bold),
                    Text(
                        '${CommonUtils.renderNumber(widget.data.affFCt ?? 0)}${tr('wcy')}',
                        style: MyTheme.white07_10),
                  ],
                ),
              ),
              rightWidget: widget.data.isJoin == 1
                  ? InkWell(
                      onTap: () {
                        _showRightMenue();
                      },
                      child: Container(
                        alignment: Alignment.centerRight,
                        width: 50.w,
                        height: 44.w,
                        child: MyImage.asset(
                            key: _globalKey,
                            MyImagePaths.appAsmrMore,
                            width: 22.w,
                            height: 22.w),
                      ),
                    )
                  : Container(),
            ),
            body: Column(
              children: [
                _topMasg != null
                    ? GestureDetector(
                        onTap: () {
                          GroupChatTopMsgContentRoute(_topMasg!).push(context);
                        },
                        child: Container(
                          color: MyTheme.white008Color,
                          padding: EdgeInsets.symmetric(
                              horizontal: MyTheme.pagePadding, vertical: 6.w),
                          height: 55.w,
                          width: 1.sw,
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  // mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(tr('zdxx'),
                                        style: TextStyle(
                                          color: MyTheme.blueColor64,
                                          fontSize: 13.sp,
                                        )),
                                    Text(
                                      _topMasg?.msg ?? '',
                                      style: MyTheme.white07_13,
                                      maxLines: 1,
                                    )
                                  ],
                                ),
                              ),
                              MyImage.asset(MyImagePaths.appIssueArrow,
                                  width: 15, height: 15.w)
                            ],
                          ),
                        ),
                      )
                    : Container(),
                Expanded(
                  child: RefreshIndicator(
                    displacement: 0.w,
                    edgeOffset: -10.w,
                    color: MyTheme.blueColor64,
                    backgroundColor: Colors.transparent,
                    strokeWidth: 2,
                    onRefresh: _getPullDownMsg,
                    child: ListView.builder(
                        padding: EdgeInsets.only(top: MyTheme.pagePadding),
                        controller: _scrollController,
                        itemCount: _messages.length,
                        itemBuilder: (context, index) {
                          return ChatBubble(message: _messages[index]);
                        }),
                  ),
                ),
                _bottomView()
              ],
            )));
  }

  Future<void> _scrollToBottom() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        if (_scrollController.hasClients) {
          Future.microtask(() {
            _scrollController
                .jumpTo(_scrollController.position.maxScrollExtent);
            // 或者使用 animateTo 进行平滑滚动
            // _scrollController.animateTo(
            //   _scrollController.position.maxScrollExtent,
            //   duration: const Duration(milliseconds: 300),
            //   curve: Curves.easeOut,
            // );
            FocusScope.of(context).requestFocus(_focusNode);
          });
        }
      }
    });
  }

  Future<void> _sendMessage(int type, String txt) async {
    String userInput = _controllerText.text.trim();

    if (userInput.isEmpty && type == 1) {
      if (bottomInset <= 0.0) {
        FocusScope.of(context).unfocus();
        Future.delayed(const Duration(milliseconds: 100), () {
          FocusScope.of(context).requestFocus(_focusNode);
        });
      }
      MyToast.showText(text: tr('wyddxf'));
      return;
    }

    final param = Map.from({})
      ..['type'] = type // 1普通文字; type == 2 图片
      ..['txt'] = txt // "测试内容"  /  "/new/xiao/20201117/2020111718110525410.png"
      ..['id'] = widget.data.id;

    final result = await _appDomain.getConstructByApiLink(
      apiLink: 'chatgroup/send_msg',
      params: param,
    );
    if (result.status == 1) {
      GroupsMessageModel msg = GroupsMessageModel(
          msg: type == 1 ? userInput : _homeConfig.config.imgBase + txt,
          thumb: '',
          nickname: '',
          isUser: true,
          type: type,
          createdAt: CommonUtils.getCurrentTimer());

      _messages.add(msg);

      _controllerText.clear();
      setState(() {});
      _scrollToBottom();
    } else {
      MyToast.showText(text: result.msg ?? '');
    }

    setState(() {});
  }

  _showRightMenue() {
    _focusNode.unfocus();

    RelativeRect? widgetPosition;
    final RenderBox? renderBox =
        _globalKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final position = renderBox.localToGlobal(Offset.zero);
      final size = renderBox.size;
      widgetPosition = RelativeRect.fromLTRB(
          position.dx,
          position.dy + size.height,
          position.dx + size.width,
          position.dy + size.height);
    }
    showMenu(
        context: context,
        color: const Color.fromRGBO(34, 36, 47, 1), // 设置背景颜色
        position: widgetPosition!,
        items: [
          PopupMenuItem(
            height: 32.w,
            child:
                Text('groupckxq'.tr(context: context), style: MyTheme.white13),
            onTap: () {
              //查看聊天详情
              _focusNode.unfocus();
              GroupChatDetailContentRoute(
                      id: widget.data.id ?? 0, ms: pullUpRefreshTimestamp)
                  .push(context);
            },
          ),
          PopupMenuItem(
            height: 32.w,
            child: Text('qkjl'.tr(context: context), style: MyTheme.white13),
            onTap: () {
              //清空历史记录
              _focusNode.unfocus();
              _cleanSoulGroupMsg();
            },
          ),
          PopupMenuItem(
            height: 32.w,
            child: Text('tccq'.tr(context: context), style: MyTheme.white13),
            onTap: () {
              //退出此群
              _focusNode.unfocus();
              _outSoulGroup();
            },
          ),
        ]);
  }

  Future _cleanSoulGroupMsg() async {
    late final domain = context.read<AppDomain>();

    final param = Map.from({})
      ..['ms'] = pullUpRefreshTimestamp
      ..['id'] = widget.data.id;
    final res = await domain.getConstructByApiLink(
      apiLink: 'chatgroup/del_msg',
      params: param,
    );

    if (res.isValid) {
      _messages = [];
      _initChatList();
    } else {
      MyToast.showText(text: res.msg ?? '');
    }

    setState(() {});
  }

  Future _outSoulGroup() async {
    late final domain = context.read<AppDomain>();

    final param = Map.from({})..['id'] = widget.data.id;
    final res = await domain.getConstructByApiLink(
      apiLink: 'chatgroup/exit_group',
      params: param,
    );

    if (res.isValid) {
      eventBus.fire(MyEvent('RrefrehSoulGroup')); //发通知去群广场界面/我加入的列表界面刷新数据
      context.pop();
    } else {
      MyToast.showText(text: res.msg ?? '');
    }

    setState(() {});
  }

  Future _joinSoulGroup(int id) async {
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
      eventBus.fire(MyEvent('RrefrehSoulGroup')); //发通知去群广场界面/我加入的列表界面刷新数据
    } else {
      MyToast.showText(text: res.msg ?? '');
    }
    setState(() {
      _scrollToBottom();
    });
  }

  Widget _bottomView() {
    return widget.data.isJoin == 0
        ? GestureDetector(
            onTap: () {
              //加入聊天
              _joinSoulGroup(widget.data.id ?? 0);
            },
            child: Container(
                width: 1.sw,
                height: 60.w,
                alignment: Alignment.center,
                color: const Color.fromRGBO(44, 42, 57, 1),
                child: Text('+ ${tr('jrlt')}', style: MyTheme.white15semibold)),
          )
        : Container(
            padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
            color: MyTheme.blackColor38,
            child: SizedBox(
              height: 50.w,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 36.w,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(18.w),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.w),
                              child: TextField(
                                focusNode: _focusNode,
                                autofocus: true,
                                controller: _controllerText,
                                style: MyTheme.white255_14,
                                cursorColor: MyTheme.blueColor64,
                                textInputAction: TextInputAction.done,
                                decoration: InputDecoration(
                                  hintText: 'groupInput'.tr(context: context),
                                  hintStyle: MyTheme.gray180_15_M,
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 17.5.w,
                            height: 17.w,
                            child: GestureDetector(
                              onTap: _imagePickerAssets,
                              child: MyImage.asset(
                                MyImagePaths.appCustomerServiceSelectImg,
                                width: 17.5.w,
                                height: 17.w,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 7.w),
                  GestureDetector(
                    onTap: () {
                      _sendMessage(1, _controllerText.text);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: MyTheme.redColorVIP,
                          borderRadius:
                              BorderRadius.all(Radius.circular(12.5.w))),
                      width: 44.w,
                      height: 25.w,
                      child: Text(tr('fasong'), style: MyTheme.white12),
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  Future _imagePickerAssets() async {
    if (await CommonUtils.pickImage() case final xFile?) {
      MyToast.showLoading(text: 'fasz'.tr());
      final uploadImageRes = await _homeConfig.uploadImage(xFile);

      if (uploadImageRes != null && uploadImageRes['code'] == 1) {
        final url = "${_homeConfig.config.imgBase}${uploadImageRes['msg']}";
        final localImage = Image.network(url);

        localImage.image
            .resolve(const ImageConfiguration())
            .addListener(ImageStreamListener((info, _) async {
          String newUrl = '$url??${info.image.width}_${info.image.height}';
          String sendUrl =
              newUrl.replaceAll(_homeConfig.config.imgBase, ''); // 不需要全路径

          //发送图片
          await _sendMessage(2, sendUrl);

          MyToast.closeAllLoading();
        }));
      } else {
        MyToast.showText(text: uploadImageRes?['msg'] ?? 'failed');
        MyToast.closeAllLoading();
      }
    }
  }
}

class ChatBubble extends StatelessWidget {
  final GroupsMessageModel message;

  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: message.isUser ?? false
          ? Padding(
              padding: EdgeInsets.only(
                left: MyTheme.pagePadding,
                right: MyTheme.pagePadding,
                bottom: MyTheme.pagePadding,
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(width: 40.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            message.type == 1
                                ? Container(
                                    padding: EdgeInsets.all(10.w),
                                    decoration: BoxDecoration(
                                        color: const Color(0xff0073C5),
                                        borderRadius:
                                            BorderRadius.circular(5.w)),
                                    child: Text(message.msg ?? '',
                                        maxLines: 1000, style: MyTheme.white14),
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      //点击图片浏览大图
                                      _goPictureView(
                                          context, message.msg ?? '');
                                    },
                                    child: MyImage.network(message.msg ?? '',
                                        width: 160.w,
                                        height: 160.w,
                                        borderRadius: 5.w),
                                  ),
                            SizedBox(height: 3.w),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                message.createdAt ?? '',
                                style: MyTheme.white04_10,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10.w),
                      ClipOval(
                        child: Container(
                          width: 40.w,
                          height: 40.w,
                          color: Colors.white10,
                          child: Selector<UserNotifier, Member>(
                            selector: (_, config) => config.member,
                            builder: (context, member, child) => MyAvatar(
                              thumb: member.thumb,
                              size: 40,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          : Padding(
              padding: EdgeInsets.only(
                left: MyTheme.pagePadding,
                right: MyTheme.pagePadding,
                bottom: MyTheme.pagePadding,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipOval(
                    child: GestureDetector(
                      onTap: () {
                        UserCenterRoute('${message.aff}').push(context);
                      },
                      child: Container(
                        width: 40.w,
                        height: 40.w,
                        color: Colors.white10,
                        child: MyImage.network(message.thumb ?? ''),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message.nickname ?? '',
                          style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 5.w),
                        message.type == 1
                            ? Container(
                                padding: EdgeInsets.all(10.w),
                                decoration: BoxDecoration(
                                    color: const Color(0xff0073C5),
                                    borderRadius: BorderRadius.circular(5.w)),
                                child: Text(message.msg ?? '',
                                    maxLines: 1000, style: MyTheme.white14),
                              )
                            : GestureDetector(
                                onTap: () {
                                  //点击图片浏览大图
                                  _goPictureView(context, message.msg ?? '');
                                },
                                child: MyImage.network(message.msg ?? '',
                                    width: 160.w,
                                    height: 160.w,
                                    borderRadius: 5.w),
                              ),
                        SizedBox(height: 3.w),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            message.createdAt ?? '',
                            style: MyTheme.white04_10,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }

  /// 前往图片浏览页
  void _goPictureView(BuildContext context, String imgStr) {
    List<MediaModel> medias = [
      MediaModel(
          mediaUrl: imgStr,
          cover: imgStr,
          type: MyMediaType.image,
          thumbWidth: 375,
          thumbHeight: 667)
    ];
    MediaViewerRoute({'resources': medias, 'index': 1}).push(context);
  }
}

class TypewriterText extends StatefulWidget {
  final String text;
  final Function onFinish;
  final bool render;

  const TypewriterText(
      {super.key,
      required this.text,
      required this.onFinish,
      required this.render});

  @override
  State<TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<TypewriterText> {
  final _typingDuration = const Duration(milliseconds: 30);
  final _deletingDuration = const Duration(milliseconds: 10);
  late String _displayedText;
  late String _incomingText;
  late String _outgoingText;

  @override
  void initState() {
    _incomingText = widget.text;
    _outgoingText = '';
    _displayedText = '';
    animateText();
    super.initState();
  }

  void animateText() async {
    if (widget.render) {
      _displayedText = widget.text;
      return;
    }
    final backwardLength = _outgoingText.length;
    if (backwardLength > 0) {
      for (var i = backwardLength; i >= 0; i--) {
        await Future.delayed(_deletingDuration);
        _displayedText = _outgoingText.substring(0, i);
        setState(() {});
      }
    }
    final forwardLength = _incomingText.length;
    if (forwardLength > 0) {
      for (var i = 0; i <= forwardLength; i++) {
        await Future.delayed(_typingDuration);
        _displayedText = _incomingText.substring(0, i);
        if (mounted) {
          setState(() {});
        }
        if (i % 15 == 0) {
          widget.onFinish.call();
        }
      }
    }
  }

  @override
  void didUpdateWidget(covariant TypewriterText oldWidget) {
    if (oldWidget.text != widget.text) {
      _outgoingText = oldWidget.text;
      _incomingText = widget.text;
      animateText();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _displayedText,
      style: TextStyle(
          color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.w400),
    );
  }
}
