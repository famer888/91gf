import 'package:analytics_sdk/manager/page_name_manager.dart';
import 'package:analytics_sdk/const/event_type.dart';
import 'package:analytics_sdk/manager/sdk_context.dart';

/// 广告点击日志 （手动上报）
class AdClickEvent {
  /// 事件类型（固定）
  final String event = EventType.adClick.event;

  /// 去重 ID（动态计算）
  late final String eventId;

  /// 页面唯一标识，建议使用 [AppPageEnum]（如 `AppPageEnum.videoPlay.key`），
  /// 也可传入自定义字符串。
  final String pageKey;

  /// 页面展示名称，建议与 [pageKey] 保持对应（如 `AppPageEnum.videoPlay.name`）。
  final String pageName;

  /// 广告位标识：与展示事件一致，如 home_banner_1
  final String adSlotKey;

  /// 广告位名称：与展示事件一致
  final String adSlotName;

  /// 被点击的广告ID
  final String adId;

  /// 素材ID（可选）
  final String creativeId;

  /// 广告类型字符串，由广告中心定义，如 banner, feed 等
  final String adType;

  /// 公共字段（通过工具类生成）
  late final Map<String, dynamic> _commonFields;

  AdClickEvent({
    required String pageKey,
    required this.pageName,
    required this.adSlotKey,
    required this.adSlotName,
    required this.adId,
    this.creativeId = '',
    this.adType = '',
  }) : pageKey = PageNameMapper.normalizeKey(pageKey) {
    _commonFields = SdkContext.generateCommonFields(event);

    eventId = SdkContext.generateEventIdFromCommonFields(_commonFields, [
      pageKey,
      pageName,
      adSlotKey,
      adSlotName,
      adId,
      adType,
      creativeId,
    ]);
  }

  /// 转换为 JSON Map，用于上报和缓存
  Map<String, dynamic> toJson() {
    Map<String, dynamic> payload = {
      'page_key': pageKey,
      'page_name': pageName,
      'ad_slot_key': adSlotKey,
      'ad_slot_name': adSlotName,
      'ad_id': adId,
      'ad_type': adType,
      'creative_id': creativeId,
    };
    return {..._commonFields, 'event_id': eventId, "payload": payload};
  }

  /// 从 JSON 恢复实例（用于缓存恢复）
  factory AdClickEvent.fromJson(Map<String, dynamic> json) {
    return AdClickEvent(
      pageKey: json['page_key'] as String,
      pageName: json['page_name'] as String,
      adSlotKey: json['ad_slot_key'] as String,
      adSlotName: json['ad_slot_name'] as String,
      adId: json['ad_id'] as String,
      creativeId: json['creative_id'] as String? ?? '',
      adType: json['ad_type'] as String? ?? '',
    );
  }
}
