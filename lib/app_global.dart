import 'package:flutter/widgets.dart';
import 'package:jygf/domain/model/home_data_model.dart';

class AppGlobal {
  static String m3u8Encrypt = '0';

  static BuildContext? context;

  static int aff = 0;

  // 短视频带入的信息 list index api 等
  static Map shortVideosInfo = {'list': [], 'page': 0, 'index': 0, 'api': ''};

  static ReportConfig? reportConfig;
  static String reportAppId = '';
  static String reportTraceId = '';

  /// 安装埋点是否已上报（与本地 install 缓存键同步）
  static String installFlag = '';
  static String affXCode = '';

  static String officeSite = '';
}
