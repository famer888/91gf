import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:android_id/android_id.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';
import 'package:jygf/data_layer/data_source/remote/aidraw_service.dart';
import 'package:jygf/data_layer/data_source/remote/aimagic_service.dart';
import 'package:jygf/data_layer/data_source/remote/ainovel_service.dart';
import 'package:jygf/data_layer/data_source/remote/aiaudio_service.dart';
import 'package:jygf/data_layer/data_source/remote/asmr_service.dart';
import 'package:jygf/data_layer/data_source/remote/aikiss_service.dart';
import 'package:jygf/data_layer/data_source/remote/cartoon_service.dart';
import 'package:jygf/data_layer/data_source/remote/comic_service.dart';
import 'package:jygf/data_layer/data_source/remote/game_service.dart';
import 'package:jygf/data_layer/data_source/remote/live_service.dart';
import 'package:jygf/data_layer/data_source/remote/novel_service.dart';
import 'package:jygf/data_layer/data_source/remote/rank_service.dart';
import 'package:jygf/data_layer/repo/r2_uploader.dart';
import 'package:jygf/domain/model/ai/ai_draw_model.dart';
import 'package:jygf/domain/model/ai/ai_draw_record_model.dart';
import 'package:jygf/domain/model/ai/ai_magic_model.dart';
import 'package:jygf/domain/model/ai/ai_magic_record_model.dart';
import 'package:jygf/domain/model/ai_model.dart';
import 'package:jygf/domain/model/comic_model.dart';
import 'package:jygf/domain/model/live_model.dart';
import 'package:jygf/domain/model/live_video_detail_model.dart';
import 'package:jygf/domain/model/novel_model.dart';
import 'package:jygf/domain/model/post/circle/circle_post_nav_model.dart';
import 'package:jygf/domain/model/vlog_model.dart';
import 'package:jygf/domain/model/voice_model.dart';
import 'package:jygf/domain/remote_domain/domains/aidraw.dart';
import 'package:jygf/domain/remote_domain/domains/aimagic.dart';
import 'package:jygf/domain/remote_domain/domains/ainovel.dart';
import 'package:jygf/domain/remote_domain/domains/asmr.dart';
import 'package:jygf/domain/remote_domain/domains/aiaudio.dart';
import 'package:jygf/domain/remote_domain/domains/cartoon.dart';
import 'package:jygf/domain/remote_domain/domains/comic.dart';
import 'package:jygf/domain/remote_domain/domains/game.dart';

import 'package:jygf/domain/remote_domain/domains/live.dart';
import 'package:jygf/domain/remote_domain/domains/novel.dart';
import 'package:jygf/domain/remote_domain/domains/rank.dart';
import 'package:http_parser/http_parser.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:utils/utils.dart';
import 'package:universal_html/html.dart' as html;

import '../../app_config.dart';
import '../../crypto.dart';
import '../../domain/enum.dart';
import '../../domain/model/ai_server_face_model.dart';
import '../../domain/model/app_center_model.dart';
import '../../domain/model/bank_card_model.dart';
import '../../domain/model/bit_detail_model.dart';
import '../../domain/model/bit_nav_model.dart';
import '../../domain/model/cash_withdraw_rule_model.dart';
import '../../domain/model/coin_detail_model.dart';
import '../../domain/model/collection_model.dart';
import '../../domain/model/community_nav_model.dart';
import '../../domain/model/community_with_banner_model.dart';
import '../../domain/model/creator_info_model.dart';
import '../../domain/model/element_model.dart';
import '../../domain/model/exp_of_vip_model.dart';
import '../../domain/model/feed/feed_model.dart';
import '../../domain/model/feedback_data_model.dart';
import '../../domain/model/follow_user_model.dart';
import '../../domain/model/home_data_model.dart';
import '../../domain/model/income_detail_data_model.dart';
import '../../domain/model/member_model.dart';
import '../../domain/model/mine_withdrawal_record_model.dart';
import '../../domain/model/notice_message.dart';
import '../../domain/model/official_group_model.dart';
import '../../domain/model/order_model.dart';
import '../../domain/model/post_model.dart';
import '../../domain/model/posts_with_banners_model.dart';
import '../../domain/model/product_vip_coin_model.dart';
import '../../domain/model/proxy_detail_model.dart';
import '../../domain/model/proxy_invite_record_model.dart';
import '../../domain/model/proxy_profit_model.dart';
import '../../domain/model/review_data_model.dart';
import '../../domain/model/search_model.dart';
import '../../domain/model/system_notice_model.dart';
import '../../domain/model/tiezt_model.dart';
import '../../domain/model/topic_detail_model.dart';
import '../../domain/model/topic_model.dart';
import '../../domain/model/topics_with_banners_model.dart';
import '../../domain/model/video_comment_model.dart';
import '../../domain/model/video_detail_model.dart';
import '../../domain/model/welfare_task_model.dart';
import '../../domain/model/game/game_model.dart';
import '../../domain/model/game/game_detail_model.dart';
import '../../domain/model/game/game_comment_model.dart';

import '../../domain/model/cartoon/cartoon_model.dart';
import '../../domain/model/cartoon/cartoon_detail_model.dart';
import '../../domain/model/cartoon/cartoon_comment_model.dart';

import '../../domain/remote_domain/domains/ai.dart';
import '../../domain/remote_domain/domains/aikiss.dart';
import '../../domain/remote_domain/domains/original.dart';
import '../../domain/result.dart';
import '../../domain/type_def.dart';
import '../../domain/domain.dart';
import '../../logger.dart';
import '../data_source/remote/account_service.dart';
import '../data_source/remote/ai_service.dart';
import '../data_source/remote/community_service.dart';
import '../data_source/remote/dynamic_service.dart';
import '../data_source/remote/element_service.dart';
import '../data_source/remote/home_service.dart';
import '../data_source/remote/message_service.dart';
import '../data_source/remote/mv_service.dart';
import '../data_source/remote/vlog_service.dart';
import '../data_source/remote/order_service.dart';
import '../data_source/remote/original_service.dart';
import '../data_source/remote/privilege_service.dart';
import '../data_source/remote/proxy_service.dart';
import '../data_source/remote/search_service.dart';
import '../data_source/remote/seed_service.dart';
import '../data_source/remote/sign_service.dart';
import '../data_source/remote/user_service.dart';
import '../data_source/remote/withdraw_service.dart';
import 'http_interceptor.dart';
import 'utils.dart';
part 'cache.dart';
part 'mixin/home_mixin.dart';
part 'mixin/user_mixin.dart';
part 'mixin/element_mixin.dart';
part 'mixin/dynamic_mixin.dart';
part 'mixin/community_mixin.dart';
part 'mixin/seed_mixin.dart';
part 'mixin/order_mixin.dart';
part 'mixin/sign_mixin.dart';
part 'mixin/account_mixin.dart';
part 'mixin/proxy_mixin.dart';
part 'mixin/withdraw_mixin.dart';
part 'mixin/search_mixin.dart';
part 'mixin/mv_mixin.dart';
part 'mixin/vlog_mixin.dart';
part 'mixin/cartoon_mixin.dart';
part 'mixin/game_mixin.dart';
part 'mixin/message_mixin.dart';
part 'mixin/privilege_mixin.dart';
part 'mixin/original_mixim.dart';
part 'mixin/live_mixin.dart';
part 'mixin/ai_mixin.dart';
part 'mixin/asmr_mixin.dart';
part 'mixin/rank_mixin.dart';
part 'mixin/aimagic_mixin.dart';
part 'mixin/aidraw_mixin.dart';
part 'mixin/ainovel_mixin.dart';
part 'mixin/aiaudio_mixin.dart';
part 'mixin/aikiss_mixin.dart';
part 'mixin/comic_mixin.dart';
part 'mixin/novel_mixin.dart';

class AppRepo extends _BaseAppRepo
    with
        _Home,
        _User,
        _Element,
        _Dynamic,
        _Community,
        _Seed,
        _Order,
        _Sign,
        _Account,
        _Proxy,
        _Withdraw,
        _Search,
        _Mv,
        _Vlog,
        _Cartoon,
        _Game,
        _Message,
        _Privilege,
        _Original,
        _Live,
        _AI,
        _AIMagic,
        _AINovel,
        _AIAudio,
        _AIDraw,
        _AIKiss,
        _Asmr,
        _Rank,
        _Comic,
        _Novel {}

abstract class _BaseAppRepo implements AppDomain {
  late final _homeService = HomeService(_apiDio);
  late final _userService = UserService(_apiDio);
  late final _elementService = ElementService(_apiDio);
  late final _dynamicService = DynamicService(_apiDio);
  late final _communityService = CommunityService(_apiDio);
  late final _seedService = SeedService(_apiDio);
  late final _orderService = OrderService(_apiDio);
  late final _signService = SignService(_apiDio);
  late final _accountService = AccountService(_apiDio);
  late final _proxyService = ProxyService(_apiDio);
  late final _withdrawService = WithdrawService(_apiDio);
  late final _searchService = SearchService(_apiDio);
  late final _mvService = MvService(_apiDio);
  late final _vlogService = VlogService(_apiDio);
  late final _cartoonService = CartoonService(_apiDio);
  late final _gameService = GameService(_apiDio);
  late final _messageService = MessageService(_apiDio);
  late final _privilegeService = PrivilegeService(_apiDio);
  late final _originalService = OriginalService(_apiDio);
  late final _liveService = LiveService(_apiDio);
  late final _aiService = AIService(_apiDio);
  late final _aiMagicService = AIMagicService(_apiDio);
  late final _ainovelService = AINovelService(_apiDio);
  late final _aiaudioService = AIAudioService(_apiDio);
  late final _asmrService = ASMRService(_apiDio);
  late final _rankService = RankService(_apiDio);
  late final _aidrawService = AIDrawService(_apiDio);
  late final _aikissService = AIKissService(_apiDio);
  late final _comicService = ComicService(_apiDio);
  late final _novelService = NovelService(_apiDio);

  final _cacheManager = _CacheManager();

  @override
  late final tokenStatusStream =
      _tokenValidStreamController.stream.asBroadcastStream();

  final _tokenValidStreamController = StreamController<MyTokenStatus?>();

  late final _apiDio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
      contentType: Headers.formUrlEncodedContentType,
    ),
  );

  /// 未加密网路服务/上传资源
  late final _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 300),
    ),
  );

  bool _isInitialized = false;
  Json _appInfo = {};

  @override
  Json get info => _appInfo;

  @override
  CacheDomain get cache => _cacheManager;

  Future<void> init() async {
    if (_isInitialized) return;
    _isInitialized = true;
    await _cacheManager.init();
    _appInfo = await _getAppInfo();

    _apiDio.interceptors.add(AutoEncryptAndDecryptInterceptor(_appInfo));
    _apiDio.interceptors.add(
      InterceptorsWrapper(
        onResponse: (response, handler) async {
          if (response.data case final Map data when data['msg'] == 'token无效') {
            await _cleanToken();
            _tokenValidStreamController.sink.add(MyTokenStatus.invalid);
          }
          return handler.next(response);
        },
      ),
    );
  }

  Future _cleanToken() async {
    try {
      if (_appInfo.token != null) {
        _appInfo.removeToken();
        await _cacheManager.deleteAuthToken();
      }
    } catch (_) {}
  }

  void _updateToken(String token) {
    _appInfo.token = token;
    _cacheManager.upsertAuthToken(token);
    _tokenValidStreamController.sink.add(MyTokenStatus.valid);
  }

  Future<String> _getOAuthId() async {
    String? deviceId;
    if (!kIsWeb) {
      if (Platform.isAndroid) {
        const androidIdPlugin = AndroidId();
        final androidId = await androidIdPlugin.getId();
        deviceId = androidId;
      } else if (Platform.isIOS) {
        final deviceInfo = DeviceInfoPlugin();
        final iosInfo = await deviceInfo.iosInfo;
        deviceId = iosInfo.identifierForVendor;
      }
    }

    deviceId ??= await _cacheManager.readOauthId();

    if (deviceId == null) {
      deviceId =
          '${RepoUtils.randomId(16)}_${DateTime.now().millisecondsSinceEpoch}';
      await _cacheManager.upsertOauthId(deviceId);
    }
    return RepoUtils.gvMD5(deviceId);
  }

  @override
  String getOAuthId() => _appInfo['oauth_id'] ?? '';

  @override
  String getOAuthType() {
    if (kIsWeb) {
      return 'web';
    }
    if (Platform.isAndroid) {
      return 'android';
    }
    if (Platform.isIOS) {
      return 'ios';
    }
    return 'web';
  }

  Future<Json> _getAppInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();

    final info = kIsWeb
        ? {
            'bundleId': BuildConfig.webBundleId,
            'version': packageInfo.version,
            'language': 'zh',
            'via': 'pwa',
          }
        : {
            'bundleId': packageInfo.packageName,
            'version': packageInfo.version,
            // "build_affcode": "cweZ2",
          };

    info.addAll({
      'oauth_id': await _getOAuthId(),
      'oauth_type': getOAuthType(),
    });

    final token = await _cacheManager.readAuthToken();

    if (token != null) {
      info.token = token;
      _tokenValidStreamController.sink.add(MyTokenStatus.valid);
    } else {
      _tokenValidStreamController.sink.add(null);
    }

    return info;
  }

  @override
  void setBaseURL(String url) async {
    // TODO: 手动设置线路
    if (!kIsWeb) {
      final fdsKey = await _getFdsKey();
      final secretValue = PlatformAwareCrypto.secretValue(fdsKey: fdsKey);
      _apiDio.options.headers = {'Cf-Ray-Xf': secretValue};
    }
    _apiDio.options.baseUrl = url;
  }

  @override
  void initLine({
    Function? success,
    Function? failed,
    Function(List<String>)? lines,
  }) async {
    // List<String> unChecklines =
    //     (await _cacheManager.readLinesUrl()) ?? BuildConfig.apiLines;

    // 测试服
    List<String> unChecklines = ['https://91gfapi.dyclub.co/api.php'];
    List<String> linesTemp = [...unChecklines];

    if (!kIsWeb) {
      final fdsKey = await _getFdsKey();
      final secretValue = PlatformAwareCrypto.secretValue(fdsKey: fdsKey);
      _apiDio.options.headers = {'Cf-Ray-Xf': secretValue};
    }

    // 检查网络
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi)) {
      //返回所有线路 让用户直链
      var gitLine = await _backupLine();
      if (gitLine.isNotEmpty) linesTemp.add(gitLine);
      lines?.call(linesTemp);

      //逻辑思路 1、异步检测所有线路 2、看是否有成功线路，有则结束检测，否则继续 3、检测GIT备用线路，成功则结束检测，否则失败
      Future.wait(unChecklines.map((x) async {
        return _checkLine(x);
      })).then((result) async {
        var first =
            result.firstWhere((p) => p["code"] == 200, orElse: () => {});
        if (first.isNotEmpty) {
          _apiDio.options.baseUrl = first["url"].toString();
          success?.call();
          _reportLine(result);
        } else {
          var p = await _checkLine(gitLine);
          if (p["code"] == 200) {
            _apiDio.options.baseUrl = p["url"].toString();
            success?.call();
            _reportLine(result);
          } else {
            //没有任何可用线路 失败回调
            failed?.call();
          }
        }
      });
    } else {
      failed?.call();
    }
  }

  Future<String> _getFdsKey() async {
    const duration = Duration(seconds: 5);
    for (String fdsApi in BuildConfig.fdsKeyApi) {
      try {
        final resp = await Dio(
                BaseOptions(connectTimeout: duration, receiveTimeout: duration))
            .get(fdsApi);
        if (resp.statusCode == 200) {
          final fdsKey = resp.data.toString().replaceAll('\n', '');
          _cacheManager.upsertFdsKey(fdsKey);
          return fdsKey;
        }
      } catch (_) {}
    }

    final fdsKey = await _cacheManager.readFdsKey();
    return fdsKey ?? '';
  }

  /// check line
  Future<Map<String, Object>> _checkLine(String line) async {
    int code = 0;
    String xt = line.trim();
    try {
      if (kIsWeb) {
        code = await html.HttpRequest.request('$xt/api/callback/checkLine',
                method: "POST")
            .then((value) => value.status ?? 0)
            .timeout(const Duration(milliseconds: 5 * 1000));
      } else {
        code = await _apiDio
            .post('$xt/api/callback/checkLine')
            .then((value) => value.statusCode ?? 0);
      }
    } catch (_) {
      code = 0;
    }
    return {"url": xt, "code": code};
  }

  /// 启用备用线路
  Future<String> _backupLine() async {
    final github =
        (await _cacheManager.readGithubUrl()) ?? BuildConfig.githubLine;
    dynamic line;
    try {
      if (kIsWeb) {
        line = await html.HttpRequest.request(github, method: "GET")
            .then((value) => value.response)
            .timeout(const Duration(milliseconds: 5 * 1000));
      } else {
        line = await Dio(BaseOptions(
                connectTimeout: const Duration(seconds: 5),
                receiveTimeout: const Duration(seconds: 5)))
            .get(github);
      }
    } catch (_) {
      line = "";
    }
    return line.toString().trim().replaceAll('\n', '');
  }

  /// 上报线路
  void _reportLine(List<Map<String, Object>> lines) {
    if (lines.isEmpty) return;
    _apiDio.post('/api/home/domainCheckReport2', data: {'list': lines});
  }

  @override
  AsyncJson uploadImageBytes({
    required String baseUrl,
    required String key,
    required Uint8List bytes,
    String position = 'head',
    String? id,
    CancelToken? cancelToken,
    ProgressCallback? progressCallback,
  }) async {
    final id0 = id ?? '${DateTime.now().millisecondsSinceEpoch}';
    final newKey = 'id=$id0&position=$position${key.replaceFirst('head', '')}';
    final tmpSha256 = _gvSha256(newKey);
    final sign = _gvMD5(tmpSha256);
    final imageName = _gvMD5(id0);

    final formData = FormData.fromMap({
      'id': id0,
      'position': position,
      'sign': sign,
      'cover': MultipartFile.fromBytes(
        bytes,
        filename: '$imageName.png',
        contentType: MediaType.parse('image/png'),
      ),
    });

    final response = await _dio.post(
      baseUrl,
      data: formData,
      cancelToken: cancelToken,
      onSendProgress: progressCallback,
      options: Options(contentType: Headers.multipartFormDataContentType),
    );
    return jsonDecode(response.data);
  }

  @override
  AsyncJson uploadImage({
    required XFile xFile,
    required String baseUrl,
    required String key,
    String position = 'head',
    String? id,
    CancelToken? cancelToken,
    ProgressCallback? progressCallback,
  }) async {
    final id0 = id ?? '${DateTime.now().millisecondsSinceEpoch}';
    final newKey = 'id=$id0&position=$position${key.replaceFirst('head', '')}';
    final tmpSha256 = _gvSha256(newKey);
    final sign = _gvMD5(tmpSha256);
    final imageName = _gvMD5(id0);
    final ext = xFile.name.split('.').last;

    final formData = FormData.fromMap({
      'id': id0,
      'position': position,
      'sign': sign,
      'cover': MultipartFile.fromBytes(
        await xFile.readAsBytes(),
        filename: '$imageName.$ext',
        contentType: MediaType.parse('image/$ext'),
      ),
    });

    final response = await _dio.post(
      baseUrl,
      data: formData,
      cancelToken: cancelToken,
      onSendProgress: progressCallback,
      options: Options(contentType: Headers.multipartFormDataContentType),
    );
    return jsonDecode(response.data);
  }

  @override
  AsyncJson uploadVideo({
    required BuildContext context,
    required XFile xFile,
    CancelToken? cancelToken,
    ProgressCallback? progressCallback,
  }) async {
    final result =
        await R2UploaderUtil(context: context, cancelToken: cancelToken).upload(
      xFile: xFile,
      progressCallback: progressCallback,
    );
    return result;
  }

  @override
  Future<Response> downloadApk(
          {required String urlPath,
          required String savePath,
          ProgressCallback? onReceiveProgress}) =>
      _dio.download(urlPath, savePath, onReceiveProgress: onReceiveProgress);
}

extension _MapHelper on Map {
  String get _tokenKey => 'token';

  void removeToken() => remove(_tokenKey);

  String? get token => this[_tokenKey];
  set token(String? value) {
    if (value == null) {
      remove(_tokenKey);
    } else {
      this[_tokenKey] = value;
    }
  }
}

extension _Guard<T> on AsyncResult<T> {
  AsyncResult<T> get guard async {
    try {
      return await this;
    } catch (err, stack) {
      logger.e(err);
      logger.e(stack);
      return Result(msg: err.toString() + stack.toString());
    }
  }
}

String _gvMD5(String data) {
  var content = const Utf8Encoder().convert(data);
  var digest = md5.convert(content);
  var text = hex.encode(digest.bytes);
  return text;
}

String _gvSha256(String data) {
  var content = const Utf8Encoder().convert(data);
  var digest = sha256.convert(content);
  var text = hex.encode(digest.bytes);
  return text;
}
