import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../router/routes.dart';
import '../../utils/common_utils.dart';
import '../../utils/my_toast.dart';
import '../common_widgets/screen_background.dart';
import '../common_widgets/my_image.dart';
import '../image_paths.dart';
import '../theme.dart';

import 'package:universal_html/html.dart' as html;
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'fake_native_widget.dart' if (dart.library.html) 'real_web_widget.dart' as ui;
import 'package:jygf/report/ui_layer/report_gesture_detector.dart';

class InAppWebViewScreen extends StatefulWidget {
  const InAppWebViewScreen({super.key, required this.url, this.needNav = true});
  final String url;
  final bool? needNav;

  @override
  State<InAppWebViewScreen> createState() => _InAppWebViewScreenState();
}

class _InAppWebViewScreenState extends State<InAppWebViewScreen> {
  String titleText = '';
  late WebViewController _controller;

  late html.EventListener _listener;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (kIsWeb) {
      _listener = (event) {
        if (event is! html.MessageEvent) return;
        jumpToPage(event.data.toString());
      };
    }
  }

  @override
  void dispose() {
    if (kIsWeb) {
      _listener = (event) {
        if (event is! html.MessageEvent) return;
        jumpToPage(event.data.toString());
      };
      html.window.removeEventListener('message', _listener);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      child: Scaffold(
        appBar: widget.needNav == true
            ? AppBar(
                title: Text(
                  titleText,
                  style: MyTheme.white255_18_B,
                ),
                backgroundColor: MyTheme.bgColor,
                leading: ReportGestureDetector(
                  onTap: () {
                    context.pop();
                  },
                  child: Center(
                    child: MyImage.asset(
                      width: 20.w,
                      height: 20.w,
                      MyImagePaths.appBackIcon,
                    ),
                  ),
                ),
                iconTheme: const IconThemeData(color: Colors.white),
              )
            : null,
        backgroundColor: MyTheme.bgColor,
        body: _buildWebWidget(),
      ),
    );
  }

  Widget _buildWebWidget() {
    return InAppWebView(
      initialSettings: InAppWebViewSettings(
        javaScriptEnabled: true,
        // Android 常用
        useHybridComposition: true, // 透明/黑屏常用解法
        mediaPlaybackRequiresUserGesture: false,
        clearCache: true,
        transparentBackground: false, // 防止你以为“全透明”
      ),
      initialUrlRequest:
          URLRequest(url: WebUri(widget.url, forceToStringRawValue: true)),
      onWebViewCreated: (controller) {},

      // 可选：拦截 window.open 的新窗口
      onCreateWindow: (controller, createWindowAction) async {
        final url = createWindowAction.request.url?.toString();
        if (url != null) {
          jumpOutLink(url);

          // final uri = Uri.parse(url);
          // launchUrl(uri, mode: LaunchMode.externalApplication);
        }
        return true; // 自己处理了
      },
    );
  }

  void jumpToPage(String msg) {
    switch (msg) {
      case 'openRecharge':
        const CoinRechargeRoute().push(context);
        break;
      case 'openVip':
        const VipCenterRoute().push(context);
        break;
      case 'toInvite':
        const MineShareToUserRoute().push(context);
        break;
      default:
        MyToast.showText(text: msg.toString());
    }
  }

  void jumpOutLink(String msg) {
    CommonUtils.launchUrl(msg);
  }
}
