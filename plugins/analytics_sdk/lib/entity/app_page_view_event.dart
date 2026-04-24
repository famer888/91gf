import 'package:analytics_sdk/const/event_type.dart';
import 'package:analytics_sdk/manager/sdk_context.dart';
import 'package:analytics_sdk/manager/page_name_manager.dart';

/// 应用页面展示日志（由 [PageLifecycleObserver] 和 Tab 包装器自动上报）。
///
/// **page_key / page_name 填写规范**
///
/// 建议使用 [AppPageEnum] 预定义值，也可直接传入自定义字符串：
/// ```dart
/// AppPageViewEvent(
///   pageKey:  AppPageEnum.videoDetail.key,   // 'video_detail'
///   pageName: AppPageEnum.videoDetail.name,  // '视频详情页'
///   ...
/// )
/// ```
class AppPageViewEvent {
  final String event = EventType.appPageView.event;
  late final String eventId;

  final String userType;

  /// 当前页面标识，建议使用 [AppPageEnum]（如 `AppPageEnum.videoDetail.key`），
  /// 也可传入自定义字符串。
  final String pageKey;

  /// 当前页面展示名称，建议与 [pageKey] 保持对应（如 `AppPageEnum.videoDetail.name`）。
  final String pageName;

  /// 来路页面标识，填写跳转前所在页面的 pageKey，规范同 [pageKey]。
  final String referrerPageKey;

  /// 来路页面展示名称，规范同 [pageName]。
  final String referrerPageName;

  /// 当前页面标识（与 [pageKey] 通常保持一致，保留用于扩展场景）。
  final String currentPageKey;

  /// 当前页面展示名称（与 [pageName] 通常保持一致）。
  final String currentPageName;

  /// 页面加载耗时（毫秒）
  final int pageLoadTime;

  /// 推荐引擎的trace_id，有多个推荐列表时用英文逗号分隔，未接推荐引擎传空字符串
  final String recommendTraceId;

  late final Map<String, dynamic> _commonFields;

  AppPageViewEvent({
    required this.userType,
    required String pageKey,
    required this.pageName,
    required String referrerPageKey,
    required this.referrerPageName,
    required String currentPageKey,
    required this.currentPageName,
    required this.pageLoadTime,
    this.recommendTraceId = '',
  })  : pageKey = PageNameMapper.normalizeKey(pageKey),
        referrerPageKey = PageNameMapper.normalizeKey(referrerPageKey),
        currentPageKey = PageNameMapper.normalizeKey(currentPageKey) {
    _commonFields = SdkContext.generateCommonFields(event);

    eventId = SdkContext.generateEventIdFromCommonFields(_commonFields, [
      userType,
      pageKey,
      pageName,
      referrerPageKey,
      referrerPageName,
      currentPageKey,
      currentPageName,
      pageLoadTime.toString(),
      recommendTraceId,
    ]);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> payload = {
      'user_type': userType,
      'page_key': pageKey,
      'page_name': pageName,
      'referrer_page_key': referrerPageKey,
      'referrer_page_name': referrerPageName,
      'current_page_key': currentPageKey,
      'current_page_name': currentPageName,
      'page_load_time': pageLoadTime,
      'recommend_trace_id': recommendTraceId,
    };
    return {
      ..._commonFields,
      'event_id': eventId,
      "payload": payload
    };
  }

  factory AppPageViewEvent.fromJson(Map<String, dynamic> json) {
    return AppPageViewEvent(
      userType: json['user_type'] as String,
      pageKey: json['page_key'] as String,
      pageName: json['page_name'] as String,
      referrerPageKey: json['referrer_page_key'] as String,
      referrerPageName: json['referrer_page_name'] as String,
      currentPageKey: json['current_page_key'] as String,
      currentPageName: json['current_page_name'] as String,
      pageLoadTime: json['page_load_time'] as int,
      recommendTraceId: json['recommend_trace_id'] as String? ?? '',
    );
  }
}
