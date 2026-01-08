import 'dart:ui';

import 'package:utils/utils.dart';

void dPrint(dynamic obj) {
  HttpConfig.instance.logger?.call(obj);
}

class HttpConfig {
  /// most basic
  String? Function()? apiBaseURL;
  String? Function()? apiToken;
  Map<String, dynamic> baseParams = {};

  /// picture cache
  Box? imageCacheBox; // 图片
  Color? dialogBackgroundColor; // 弹框背景

  /// clear token
  void Function()? clearTokenFunc;

  /// print loger
  void Function(String)? logger;

  /// show prompt
  void Function(String)? showPrompt;

  String Function()? fds;

  /// resource upload param
  String uploadMp4Url = '';
  String uploadMp4Key = '';
  String uploadImgUrl = '';
  String uploadImgKey = '';
  String version = '';

  /// HttpConfig single instance
  static final HttpConfig _instance = HttpConfig._();
  HttpConfig._();
  static HttpConfig get instance => _instance;
}
