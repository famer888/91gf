import 'package:analytics_sdk/analytics_sdk.dart';
import 'package:analytics_sdk/entity/ad_click_event.dart';
import 'package:analytics_sdk/entity/advertising_event.dart';
import 'package:analytics_sdk/entity/app_install_event.dart';
import 'package:analytics_sdk/entity/comic_event.dart';
import 'package:analytics_sdk/entity/keyword_click_event.dart';
import 'package:analytics_sdk/entity/keyword_search_event.dart';
import 'package:analytics_sdk/entity/novel_event.dart';
import 'package:analytics_sdk/entity/video_event.dart';
import 'package:analytics_sdk/enum/click_item_type_enum.dart';
import 'package:analytics_sdk/enum/read_behavior_enum.dart';
import 'package:analytics_sdk/enum/user_type_enum.dart';
import 'package:analytics_sdk/enum/video_content_type_enum.dart';
import 'package:analytics_sdk/enum/video_event_enum.dart';
import 'package:analytics_sdk/manager/page_name_manager.dart';
import 'package:analytics_sdk/observer/page_lifecycle_observer.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jygf/report/analytics/report_search_event.dart';
import 'package:provider/provider.dart';

import '../../app_global.dart';
import '../../data_layer/repo/repo.dart';
import '../../domain/model/comic_model.dart';
import '../../domain/model/novel_model.dart';
import '../../domain/remote_domain/domains/report.dart';
import '../../domain/model/feed/feed_model.dart';
import '../../domain/model/home_data_model.dart';
import '../../domain/model/video_detail_model.dart';
import '../../domain/model/vlog_model.dart';
import '../../ui_layer/utils/common_utils.dart';
import 'analytics_page_sync.dart';

Future<void> fetchAndApplyConfig() async {
  try {
    final reportDomain = AppGlobal.context?.read<ReportDomain>();
    final res = await reportDomain?.getEncryptedConfig();
    // 根据实际的API响应格式提取config
    if (res != null && res.status == 1) {
      if (res.data case final encryptedConfig) {
        CommonUtils.log('encryptedConfig:$encryptedConfig');
        await AnalyticsSdk.instance.refreshDomainConfig(
          encryptedConfig: encryptedConfig,
        );
      }
    }
  } catch (e) {
    CommonUtils.log('获取加密config失败: $e');
  }
}

Future<void> initAnalyticsSdk(BuildContext? context, {String oauthId = ''}) async {
  final appId = AppGlobal.reportAppId.isNotEmpty ? AppGlobal.reportAppId : 'DX-106';
  await AnalyticsSdk.instance.init(
    appId: appId,
    encryptedConfig: null,
    deviceId: oauthId,
    enableDebugBanner: kDebugMode,
    appVersion: '26.0511.1038',
  );
}

// 安装事件
void analyticsReportInstall(BuildContext context, String traceID) {
  if (AppGlobal.installFlag.isEmpty) {
    AnalyticsSdk.instance.track(AppInstallEvent(traceId: traceID));
    context.read<AppRepo>().setInstallFlag('1');
  }
}

// 用户登陆
void analyticsUserLogin(int vipLevel) {
  AnalyticsSdk.setUserIdAndType(
    userId: (AppGlobal.aff > 0) ? AppGlobal.aff.toString() : '',
    userTypeEnum: vipLevel > 0 ? UserTypeEnum.vip : UserTypeEnum.normal,
  );
}

// 设置UID
void analyticsSetUid(String uid) {
  AnalyticsSdk.setUid(uid);
}

// 设置Channel
void analyticsSetChannel(String channel) {
  AnalyticsSdk.setChannel(
    channel == 'self' ? '' : channel,
  );
}

// 登出
void analyticsLogout() {
  AnalyticsSdk.logoutUser();
}

// 页面导航切换
void analyticsNavigationChange() {
  final key = PageLifecycleObserver.currentPageKey;
  final pageName = PageNameMapper.getPageName(key);
  AnalyticsSdk.instance.updateCurrentPage(pageKey: key, pageName: pageName);
  AnalyticsSdk.instance.trackNavigation(
    pageKey: key,
    pageName: pageName,
  );
}

// 视频行为上报
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
    mediaId = data.mediaId;
  }

  if (data is VlogModel) {
    videoId = data.id?.toString() ?? '';
    videoTitle = data.title ?? '';
    videoTypeId = data.videoTypeId?.toString() ?? '';
    videoTypeName = data.videoTypeName ?? '';
    videoTagKey = data.videoTagKey ?? 'video_detail';
    videoTagName = data.videoTagName ?? (data.tags ?? '');
    recommendTraceId = data.recommendTraceId ?? '';
    mediaId = data.mediaId;
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
      // 未接推荐引擎传 ''
      recommendTraceId: recommendTraceId,
      mediaId: mediaId,
    ),
  );
}

//漫画行为 展示, 下一页, 上一页,读完
void analyticsComicEvent(
  ReadBehaviorEnum eventType, //行为
  ChaptersModel? chapterInfo, {
  ComicDetailModel? model,
  int? readProgress = 0, //章节百分比
  int? pageNo = 1,
}) async {
  AnalyticsSdk.instance.track(ComicEvent(
    comicId: model?.id.toString() ?? '',
    comicTitle: model?.title ?? '',
    comicTypeId: model?.reportInfo?.typeId ?? '',
    comicTypeName: model?.reportInfo?.typeName ?? '',
    comicTagKey: model?.comicTagKey ?? "default",
    comicTagName: model?.comicTagName ?? "默认标签",
    readProgress: readProgress ?? 0,
    pageNo: pageNo ?? 1,
    comicBehavior: eventType,
    mediaId: model?.lsjId ?? '',
    recommendTraceId: '',
    chapterId: chapterInfo?.id.toString() ?? '1',
    chapterName: chapterInfo?.title ?? '第一章',
  ));
}

//小说行为 展示, 下一页, 上一页,读完
void analyticsNovelEvent(
  ReadBehaviorEnum eventType, //行为
  NovelChaptersModel? chapterInfo, {
  NovelDetailModel? model, //小说模型
  int? readProgress = 0, //章节百分比
  int? pageNo = 1, //
}) async {
  AnalyticsSdk.instance.track(NovelEvent(
    novelId: model?.id.toString() ?? "",
    novelTitle: model?.title ?? "",
    novelTypeId: model?.reportInfo?.typeId ?? '',
    novelTypeName: model?.reportInfo?.typeName ?? '',
    novelTagKey: model?.novelTagKey ?? "default",
    novelTagName: model?.novelTagName ?? "默认标签",
    readProgress: readProgress ?? 0,
    pageNo: pageNo ?? 1,
    novelBehavior: eventType,
    mediaId: model?.lsjId ?? '',
    recommendTraceId: '',
    chapterId: chapterInfo?.id.toString()?.isNotEmpty == true ? chapterInfo!.id!.toString() : '1',
    chapterName: chapterInfo?.title?.isNotEmpty == true ? chapterInfo!.title! : '第一章',
  ));
}

// 点击广告上报
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
    adType = "${data.adType}" ?? '';
  }

  if (data is AdModel) {
    adSlotKey = data.advertiseLocationCode ?? '';
    adSlotName = data.adSlotName ?? '';
    adId = data.advertiseCode ?? '';
    adType = "${data.adType}" ?? '';
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

// 广告行为上报
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

// 搜索关键词上报
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

// 关键词搜索
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
