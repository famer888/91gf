import 'package:flutter/foundation.dart';

class BuildConfig {
  static const key = kIsWeb ? '2acf7e91e9864673' : 'b82b97395366e9ce' ;
  static const iv = kIsWeb ? '1c29882d3ddfcfd6' : 'fcc60c3f632a15d7'; 
  static const appKey = kIsWeb ? '5589d41f92a597d016b037ac37db243d' : 'da86568be9c6208a644870e12d6a5ef4';
  static const ver = kIsWeb ? 'v0' : 'v1';

  static const mediaKey = 'f5d965df75336270';
  static const mediaIv = '97b60394abc2fbe1';
  static const secretKey = '0cd8091ddd83a5a8';
  static const secretIv = 'c5546fcdd6f004b2';
  static const defaultFdsKey =
      'P/D/+MulHay6Jzah0AnECON76PVOS4idWjlv/W9FmBnsXsGE+wXTI/uP4UpmvvPD';

  /// 备用接口线路
  static final apiLines = kIsWeb
      ? [
          'https://wapi.91guifu.com/api.php',
        ]
      : [
          'https://api1.91guifu.com/api.php',
          'https://api2.91guifu.com/api.php',
          'https://api3.91guifu.com/api.php',
        ];

  /// 备用线路
  static const githubLine =
      'https://raw.githubusercontent.com/ailiu258099-blip/master/main/91guifu.txt';
  static final fdsKeyApi = [
    'https://wvseee.jsbacjr.com/fds.txt',
    'https://gitee.com/fdsaw/ffewelmcxww/raw/master/hj.txt',
  ];

  /// 跳转webview路径
  static const webViewPathName = 'ktloadwebview';

  static const affCodeKey = 'hjsq_aff';

  static const webBundleId = 'com.pwa.jygf';

  static const cacheKeys = (
    appBox: 'hjsqbox',
    chats: 'hjsqbox_Chats',
    videoBox: 'hjsq_video_box',
    imageBox: 'hjsqbox_ImageCache',
    imageCacheSalt: 'aQhW1oUSlY',
  );
}
