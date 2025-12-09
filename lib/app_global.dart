import 'package:flutter/widgets.dart';
import 'package:jygf/ui_layer/screens/theme.dart';

class AppGlobal {
  static String m3u8Encrypt = '0';

  static BuildContext? context;

  static int aff = 0;

  static List<Color> bgColores =  [
    const Color.fromRGBO(217, 208, 40, 1),
    MyTheme.bgColor,
    const Color.fromRGBO(232, 62, 204, 1),
    const Color.fromRGBO(62, 116, 232, 1),
    const Color.fromRGBO(195, 62, 232, 1),
  ];
  // 短视频带入的信息 list index api 等
  static Map shortVideosInfo = {'list': [], 'page': 0, 'index': 0, 'api': ''};
}
