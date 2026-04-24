import 'package:analytics_sdk/entity/keyword_search_event.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('KeywordSearchEvent', () {
    test('默认值：searchContentType 为空字符串', () {
      final e = KeywordSearchEvent(
        keyword: '斗破苍穹',
        searchResultCount: 100,
      );
      expect(e.searchContentType, '');
      final json = e.toJson()['payload'] as Map<String, dynamic>;
      expect(json['search_content_type'], '');
    });

    test('传入 video 时正确序列化', () {
      final e = KeywordSearchEvent(
        keyword: '斗破苍穹',
        searchResultCount: 100,
        searchContentType: 'video',
      );
      final json = e.toJson()['payload'] as Map<String, dynamic>;
      expect(json['search_content_type'], 'video');
    });

    test('fromJson 反序列化包含 searchContentType', () {
      final e = KeywordSearchEvent.fromJson({
        'keyword': '火影忍者',
        'search_result_count': 50,
        'search_trace_id': 'trace_001',
        'search_id': 'sid_001',
        'search_content_type': 'comic',
      });
      expect(e.keyword, '火影忍者');
      expect(e.searchContentType, 'comic');
    });

    test('fromJson 缺少 search_content_type 时 fallback 为空字符串', () {
      final e = KeywordSearchEvent.fromJson({
        'keyword': '火影忍者',
        'search_result_count': 50,
        'search_trace_id': '',
        'search_id': '',
      });
      expect(e.searchContentType, '');
    });
  });
}
