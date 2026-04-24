import 'package:analytics_sdk/analytics_sdk.dart';
import 'package:analytics_sdk/entity/ad_click_event.dart';
import 'package:analytics_sdk/entity/advertising_event.dart';
import 'package:analytics_sdk/entity/app_install_event.dart';
import 'package:analytics_sdk/entity/keyword_click_event.dart';
import 'package:analytics_sdk/entity/keyword_search_event.dart';
import 'package:analytics_sdk/entity/video_event.dart';
import 'package:analytics_sdk/enum/click_item_type_enum.dart';
import 'package:analytics_sdk/enum/user_type_enum.dart';
import 'package:analytics_sdk/enum/video_content_type_enum.dart';
import 'package:analytics_sdk/enum/video_event_enum.dart';
import 'package:analytics_sdk/manager/page_name_manager.dart';
import 'package:analytics_sdk/observer/page_lifecycle_observer.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jygf/app_global.dart';
import 'package:jygf/domain/model/feed/feed_model.dart';
import 'package:jygf/domain/model/home_data_model.dart';
import 'package:jygf/domain/model/live_model.dart';
import 'package:jygf/domain/model/video_detail_model.dart';
import 'package:jygf/domain/model/vlog_model.dart';
import 'package:jygf/report/analytics/analytics_page_sync.dart';
import 'package:jygf/report/analytics/report_search_event.dart';
import 'package:jygf/ui_layer/utils/common_utils.dart';

/// 将服务端埋点用的 behavior key 映射为 SDK 枚举
VideoEventEnum videoBehaviorFromHttpKey(String key) {
  switch (key) {
    case 'video_play':
      return VideoEventEnum.VIDEO_PLAY;
    case 'video_pause':
      return VideoEventEnum.VIDEO_PAUSE;
    case 'video_complete':
      return VideoEventEnum.VIDEO_COMPLETE;
    case 'video_forward':
      return VideoEventEnum.VIDEO_FORWARD;
    case 'video_rewind':
      return VideoEventEnum.VIDEO_REWIND;
    default:
      return VideoEventEnum.VIDEO_PLAY;
  }
}

/// 拉取加密配置并下发给 SDK（接入 ReportDomain 后可在此实现）
Future<void> fetchAndApplyConfig() async {
  try {
    // jygf 暂无 ReportDomain#getEncryptedConfig，与 a_hjsq 对齐预留入口
    CommonUtils.log('fetchAndApplyConfig: 未配置 ReportDomain，跳过');
  } catch (e) {
    CommonUtils.log('获取加密 config 失败: $e');
  }
}

Future<void> initAnalyticsSdk(
  BuildContext? context, {
  String oauthId = '',
  String appVersion = '',
}) async {
  final appId =
      AppGlobal.reportAppId.isNotEmpty ? AppGlobal.reportAppId : 'DX-002';
  await AnalyticsSdk.instance.init(
    appId: appId,
    encryptedConfig: null,
    deviceId: oauthId,
    enableDebugBanner: kDebugMode,
    appVersion: appVersion.isNotEmpty ? appVersion : '1.0.0',
  );
}

bool _appInstallEventSent = false;

void analyticsReportInstall(BuildContext context, String traceID) {
  if (_appInstallEventSent) return;
  _appInstallEventSent = true;
  AnalyticsSdk.instance.track(AppInstallEvent(traceId: traceID));
}

void analyticsUserLogin(int vipLevel) {
  AnalyticsSdk.setUserIdAndType(
    userId: (AppGlobal.aff > 0) ? AppGlobal.aff.toString() : '',
    userTypeEnum: vipLevel > 0 ? UserTypeEnum.vip : UserTypeEnum.normal,
  );
}

void analyticsSetUid(String uid) {
  AnalyticsSdk.setUid(uid);
}

void analyticsSetChannel(String channel) {
  AnalyticsSdk.setChannel(
    channel == 'self' ? '' : channel,
  );
}

void analyticsLogout() {
  AnalyticsSdk.logoutUser();
}

void analyticsNavigationChange() {
  final key = PageLifecycleObserver.currentPageKey;
  final pageName = PageNameMapper.getPageName(key);
  AnalyticsSdk.instance.updateCurrentPage(pageKey: key, pageName: pageName);
  AnalyticsSdk.instance.trackNavigation(
    pageKey: key,
    pageName: pageName,
  );
}

void analyticsVideo({
  FlickManager? flickManager,
  dynamic data,
  required VideoEventEnum videoEvent,
  required VideoContentTypeEnum videoContentType,
}) {
  if (data == null) return;
  if (data is! VideoData && data is! VlogModel) return;

  final value = flickManager?.flickVideoManager?.videoPlayerValue;
  if (value == null || !value.isInitialized) return;

  int playDuration = value.position.inSeconds;
  int videoDuration = value.duration.inSeconds;

  double percent = videoDuration > 0 ? playDuration / videoDuration : 0;
  if (percent.isNaN || percent.isInfinite) {
    percent = 0;
  }

  String videoId = '';
  String videoTitle = '';
  String videoTypeId = '';
  String videoTypeName = '';
  String videoTagKey = '';
  String videoTagName = '';
  String recommendTraceId = '';
  String mediaId = '';
  if (data is VideoData) {
    videoId = data.id?.toString() ?? '';
    videoTitle = data.title ?? '';
    videoTypeId = data.videoTypeId?.toString() ?? '';
    videoTypeName = data.videoTypeName ?? '';
    videoTagKey = data.videoTagKey ?? 'video_detail';
    videoTagName = data.videoTagName ?? (data.tags ?? '');
    recommendTraceId = data.recommendTraceId ?? '';
    mediaId = '';
  }

  if (data is VlogModel) {
    videoId = data.id?.toString() ?? '';
    videoTitle = data.title ?? '';
    videoTypeId = data.videoTypeId?.toString() ?? '';
    videoTypeName = data.videoTypeName ?? '';
    videoTagKey = data.videoTagKey ?? 'video_detail';
    videoTagName = data.videoTagName ?? (data.tags ?? '');
    recommendTraceId = data.recommendTraceId ?? '';
    mediaId = '';
  }

  int progress = (percent * 100).clamp(0, 100).round();
  AnalyticsSdk.instance.track(
    VideoEvent(
      videoId: videoId,
      videoTitle: videoTitle,
      videoTypeId: videoTypeId,
      videoTypeName: videoTypeName,
      videoTagKey: videoTagKey,
      videoTagName: videoTagName,
      videoDuration: videoDuration,
      playDuration: playDuration,
      playProgress: progress,
      videoBehavior: videoEvent,
      videoContentType: videoContentType,
      recommendTraceId: recommendTraceId,
      mediaId: mediaId,
    ),
  );
}

/// 直播流（LiveModel）视频行为，字段对齐 [VideoEvent]
void analyticsLiveVideo({
  FlickManager? flickManager,
  required LiveModel data,
  required VideoEventEnum videoEvent,
}) {
  final value = flickManager?.flickVideoManager?.videoPlayerValue;
  if (value == null || !value.isInitialized) return;

  int playDuration = value.position.inSeconds;
  int videoDuration = value.duration.inSeconds;
  double percent = videoDuration > 0 ? playDuration / videoDuration : 0;
  if (percent.isNaN || percent.isInfinite) percent = 0;
  int progress = (percent * 100).clamp(0, 100).round();

  AnalyticsSdk.instance.track(
    VideoEvent(
      videoId: data.id?.toString() ?? '',
      videoTitle: data.username ?? '',
      videoTypeId: data.videoTypeId?.toString() ?? '',
      videoTypeName: data.videoTypeName ?? '',
      videoTagKey: data.videoTagKey ?? 'live',
      videoTagName: data.videoTagName ?? '',
      videoDuration: videoDuration,
      playDuration: playDuration,
      playProgress: progress,
      videoBehavior: videoEvent,
      videoContentType: VideoContentTypeEnum('live'),
      recommendTraceId: data.recommendTraceId ?? '',
      mediaId: '',
    ),
  );
}

void analyticsAdClick(BuildContext context, dynamic data) {
  if (data is! FeedAdModel && data is! AdModel) return;

  String adSlotKey = '';
  String adSlotName = '';
  String adId = '';
  String adType = '';
  if (data is FeedAdModel) {
    adSlotKey = data.advertiseLocationCode ?? '';
    adSlotName = data.adSlotName ?? '';
    adId = data.advertiseCode ?? '';
    adType = data.adType ?? '';
  }

  if (data is AdModel) {
    adSlotKey = data.advertiseLocationCode ?? '';
    adSlotName = data.adSlotName ?? '';
    adId = data.advertiseCode ?? '';
    adType = data.adType ?? '';
  }

  final pageInfo = syncAnalyticsPageFromContext(context);
  final pageKey = pageInfo.pageKey;
  final pageName = pageInfo.pageName;
  AnalyticsSdk.instance.track(
    AdClickEvent(
      pageKey: pageKey,
      pageName: pageName,
      adSlotKey: adSlotKey,
      adSlotName: adSlotName,
      adId: adId,
      creativeId: '',
      adType: adType,
    ),
  );
}

void analyticsAdvertising({required dynamic data, required String action}) {
  if (data is! FeedAdModel && data is! AdModel) return;

  String adSlotKey = '';
  String adSlotName = '';
  String adId = '';
  if (data is FeedAdModel) {
    adSlotKey = data.advertiseLocationCode ?? '';
    adSlotName = data.adSlotName ?? '';
    adId = data.advertiseCode ?? '';
  }

  if (data is AdModel) {
    adSlotKey = data.advertiseLocationCode ?? '';
    adSlotName = data.adSlotName ?? '';
    adId = data.advertiseCode ?? '';
  }

  AnalyticsSdk.instance.track(
    AdvertisingEvent(
      eventType: action,
      advertisingKey: adSlotKey,
      advertisingName: adSlotName,
      advertisingId: adId,
    ),
  );
}

void analyticsKeywordClick({
  required String keyword,
  required String clickItemId,
  required SearchTypeEvent contentType,
  required int clickPosition,
  required String searchTraceId,
}) {
  ClickItemTypeEnum cType = ClickItemTypeEnum(
    contentType.key,
    contentType.name,
  );

  AnalyticsSdk.instance.track(
    KeywordClickEvent(
      keyword: keyword,
      clickItemId: clickItemId,
      clickItemType: cType,
      clickPosition: clickPosition,
      searchTraceId: searchTraceId,
    ),
  );
}

void analyticsKeywordSearch({
  required String keyword,
  required int searchResultCount,
  required String searchId,
  required String searchTraceId,
  required String searchContentType,
}) {
  AnalyticsSdk.instance.track(
    KeywordSearchEvent(
      keyword: keyword,
      searchResultCount: searchResultCount,
      searchTraceId: searchTraceId,
      searchId: searchId,
      searchContentType: searchContentType,
    ),
  );
}
