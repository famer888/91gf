import 'package:analytics_sdk/const/event_type.dart';
import 'package:analytics_sdk/manager/sdk_context.dart';

/// 关键词搜索事件
class KeywordSearchEvent {
  final String event = EventType.keywordSearch.event;
  late final String eventId;

  /// 搜索关键词
  final String keyword;

  /// 搜索结果数量
  final int searchResultCount;

  /// 搜索引擎 trace ID，未接搜索引擎时传空字符串
  final String searchTraceId;

  /// 搜索引擎 search ID，未接搜索引擎时传空字符串
  final String searchId;

  /// 搜索列表的内容类型：video / novel / comic
  /// 未接搜索推荐引擎时传空字符串
  final String searchContentType;

  late final Map<String, dynamic> _commonFields;

  KeywordSearchEvent({
    required this.keyword,
    required this.searchResultCount,
    this.searchTraceId = '',
    this.searchId = '',
    this.searchContentType = '',
  }) {
    _commonFields = SdkContext.generateCommonFields(event);

    eventId = SdkContext.generateEventIdFromCommonFields(_commonFields, [
      keyword,
      searchResultCount.toString(),
      searchTraceId,
      searchId,
      searchContentType,
    ]);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> payload = {
      'keyword': keyword,
      'search_result_count': searchResultCount,
      'search_trace_id': searchTraceId,
      'search_id': searchId,
      'search_content_type': searchContentType,
    };
    return {..._commonFields, 'event_id': eventId, "payload": payload};
  }

  factory KeywordSearchEvent.fromJson(Map<String, dynamic> json) {
    return KeywordSearchEvent(
      keyword: json['keyword'] as String,
      searchResultCount: json['search_result_count'] as int,
      searchTraceId: json['search_trace_id'] as String? ?? '',
      searchId: json['search_id'] as String? ?? '',
      searchContentType: json['search_content_type'] as String? ?? '',
    );
  }
}
