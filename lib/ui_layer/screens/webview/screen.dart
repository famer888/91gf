import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../router/routes.dart';
import '../../utils/my_toast.dart';
import '../common_widgets/screen_background.dart';
import '../common_widgets/my_image.dart';
import '../image_paths.dart';
import '../theme.dart';

import "package:universal_html/html.dart" as html;
import 'fake_native_widget.dart' if (dart.library.html) 'real_web_widget.dart'
    as ui;

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key, required this.url, this.needNav = true});
  final String url;

  final bool? needNav;

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
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
    }
    html.window.removeEventListener('message', _listener);
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
                leading: GestureDetector(
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
        body: kIsWeb ? _buildHtmlWidget() : _buildNativeWidget(),
      ),
    );
  }

  Widget _buildNativeWidget() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..addJavaScriptChannel('FlutterChannel', onMessageReceived: (js) {
        jumpToPage(js.message.toString());
      })
      ..loadRequest(Uri.parse(Uri.decodeComponent(widget.url)));
    return WebViewWidget(
        controller: _controller,
        gestureRecognizers: Set()
          ..add(
            Factory<VerticalDragGestureRecognizer>(
              () => VerticalDragGestureRecognizer(),
            ),
          ));
  }

  Widget _buildHtmlWidget() {
    final String viewType =
        'iframeElement-${DateTime.now().millisecondsSinceEpoch}';
    final html.IFrameElement element = html.IFrameElement();
    element.src = Uri.decodeComponent(widget.url);
    element.style.border = 'none';
    element.style.width = '100%';
    element.style.height = '100%';

    html.window.addEventListener('message', _listener);

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      viewType,
      (int viewId) => element,
    );
    Widget current = HtmlElementView(
      viewType: viewType,
      key: UniqueKey(),
    );
    return Stack(children: [
      IgnorePointer(
        ignoring: true,
        child: Center(child: current),
      ),
    ]);
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
}
