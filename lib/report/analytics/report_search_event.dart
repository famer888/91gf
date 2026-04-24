import 'package:analytics_sdk/analytics_sdk.dart';
import 'package:analytics_sdk/entity/keyword_click_event.dart';
import 'package:analytics_sdk/enum/click_item_type_enum.dart';

enum SearchTypeEvent {
  video(name: '视频', key: 'video'),
  novel(name: '小说', key: 'novel'),
  comic(name: '漫画', key: 'comic'),
  vlog(name: '短视频', key: 'vlog'),
  news(name: '新闻', key: 'news'),
  voice(name: '有事', key: 'voice'),
  album(name: '色图', key: 'alubm'),
  game(name: '游戏', key: 'game'),
  post(name: '帖子', key: 'post'),
  live(name: '直播', key: 'live'),
  bit(name: '种子', key: 'bit'),
  cartoon(name: '动漫', key: 'cartoon'),
  ;

  final String key;
  final String name;

  const SearchTypeEvent({
    required this.key,
    required this.name,
  });
}

void reportSearchClickEvent({
  required String keyword,
  required String contentId,
  required SearchTypeEvent contentType,
  required int clickPosition,
  required String searchTraceId,
}) {
  ClickItemTypeEnum cType = ClickItemTypeEnum(
    contentType.key,
    contentType.name,
  );

  AnalyticsSdk.instance.track(KeywordClickEvent(
    keyword: keyword,
    clickItemId: contentId,
    clickItemType: cType,
    clickPosition: clickPosition,
    searchTraceId: searchTraceId,
  ));
}
