import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../domain/api_validator.dart';
import '../../../../../domain/async_value.dart';
import '../../../../../domain/remote_domain/domains/message.dart';
import '../../../../../domain/remote_domain/domains/user.dart';
import '../../../../notifiers/home_config_notifier.dart';
import '../../../../utils/common_utils.dart';
import '../../../../utils/my_toast.dart';
import '../../../common_widgets/my_app_bar.dart';
import '../../../common_widgets/my_image.dart';
import '../../../common_widgets/screen_background.dart';
import '../../../common_widgets/status/empty_data.dart';
import '../../../common_widgets/status/loading.dart';
import '../../../common_widgets/status/network_error.dart';
import '../../../image_paths.dart';
import '../../../theme.dart';
import '../../../webview/inapp_screen.dart';
import '../../../webview/screen.dart';

class MineCustomerServiceWebScreen extends StatefulWidget {
  const MineCustomerServiceWebScreen({super.key});

  @override
  State<MineCustomerServiceWebScreen> createState() =>
      _MineCustomerServiceWebScreenState();
}

class _MineCustomerServiceWebScreenState
    extends State<MineCustomerServiceWebScreen> {
  late final _userDomain = context.read<UserDomain>();

  AsyncValue _asyncValue = const AsyncInit();

  final focusNode = FocusNode();

  final textEditingController = TextEditingController();

  String _serviceUrl = '';

  @override
  void initState() {
    _initData();
    super.initState();
  }

  Future<void> _initData() async {
    final result = await _userDomain.customerConf();
    if (result.data case final resultData?) {
      _serviceUrl = resultData['url'] ?? '';
      _asyncValue = const AsyncData(null);
    } else {
      if (result.msg case final msg?) {
        MyToast.showText(text: msg);
      }
      _asyncValue = const AsyncError();
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      child: Scaffold(
        appBar: MyAppBar(
          title: 'zxkf'.tr(context: context),
        ),
        body: Column(
          children: [
            Expanded(
              child: _asyncValue.maybeWhen(
                orElse: () => const LoadingView(),
                error: (_, __) => NetworkErrorView(onTap: _initData),
                data: (_) => _serviceUrl.isEmpty
                    ? const PageEmptyDataView()
                    :
                    // WebViewScreen(url: _serviceUrl)

                    InAppWebViewScreen(
                        url: _serviceUrl,
                        needNav: false,
                      ),

                //  WebViewScreen(url: _serviceUrl, needNav: false,),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
