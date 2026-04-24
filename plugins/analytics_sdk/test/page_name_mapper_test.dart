import 'package:analytics_sdk/manager/page_name_manager.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PageNameMapper.normalizeKey', () {
    test('普通字符串不变', () {
      expect(PageNameMapper.normalizeKey('home'), 'home');
    });

    test('去掉单个前导斜杠', () {
      expect(PageNameMapper.normalizeKey('/home'), 'home');
    });

    test('去掉前导斜杠后剩余部分保留', () {
      expect(PageNameMapper.normalizeKey('/video_detail'), 'video_detail');
    });

    test('纯 / 保留原值（避免 pageKey 变空字符串）', () {
      expect(PageNameMapper.normalizeKey('/'), '/');
    });

    test('空字符串不变', () {
      expect(PageNameMapper.normalizeKey(''), '');
    });

    test('双斜杠开头只去掉第一个', () {
      expect(PageNameMapper.normalizeKey('//home'), '/home');
    });

    test('斜杠在中间不受影响', () {
      expect(PageNameMapper.normalizeKey('a/b'), 'a/b');
    });

    test('斜杠在结尾不受影响', () {
      expect(PageNameMapper.normalizeKey('home/'), 'home/');
    });
  });

  group('PageNameMapper.getPageName', () {
    setUp(() {
      PageNameMapper.clearCustom();
    });

    tearDown(() {
      PageNameMapper.clearCustom();
    });

    test('无映射时返回归一化后的 key', () {
      expect(PageNameMapper.getPageName('/home'), 'home');
    });

    test('有映射时返回映射名称（带斜杠注册）', () {
      PageNameMapper.addMapping('/home', '首页');
      expect(PageNameMapper.getPageName('/home'), '首页');
      expect(PageNameMapper.getPageName('home'), '首页');
    });

    test('有映射时返回映射名称（不带斜杠注册）', () {
      PageNameMapper.addMapping('home', '首页');
      expect(PageNameMapper.getPageName('/home'), '首页');
      expect(PageNameMapper.getPageName('home'), '首页');
    });

    test('纯 / 时 getPageName 返回 /', () {
      expect(PageNameMapper.getPageName('/'), '/');
    });
  });

  group('PageNameMapper 新格式（Map 值）', () {
    setUp(() {
      PageNameMapper.clearCustom();
    });

    tearDown(() {
      PageNameMapper.clearCustom();
    });

    test('新格式注册后 resolvePageInfo 精确匹配返回稳定 key 和 name', () {
      PageNameMapper.addMappings({
        '/video/:id': {'key': 'video_detail', 'name': '视频详情'},
      });
      final info = PageNameMapper.resolvePageInfo('/video/123');
      expect(info.key, 'video_detail');
      expect(info.name, '视频详情');
    });

    test('新格式注册后不同 id 均能命中同一模式', () {
      PageNameMapper.addMappings({
        '/video/:id': {'key': 'video_detail', 'name': '视频详情'},
      });
      expect(PageNameMapper.resolvePageInfo('video/abc').key, 'video_detail');
      expect(PageNameMapper.resolvePageInfo('video/999').key, 'video_detail');
    });

    test('新格式注册后 getPageName 用稳定 key 仍能取到 name', () {
      PageNameMapper.addMappings({
        '/video/:id': {'key': 'video_detail', 'name': '视频详情'},
      });
      expect(PageNameMapper.getPageName('video_detail'), '视频详情');
    });

    test('老格式与新格式混传，互不干扰', () {
      PageNameMapper.addMappings({
        'home': '首页',
        '/video/:id': {'key': 'video_detail', 'name': '视频详情'},
      });
      expect(PageNameMapper.getPageName('home'), '首页');
      expect(PageNameMapper.resolvePageInfo('video/42').name, '视频详情');
    });

    test('无匹配时 resolvePageInfo fallback 返回归一化 key', () {
      final info = PageNameMapper.resolvePageInfo('/unknown/page');
      expect(info.key, 'unknown/page');
      expect(info.name, 'unknown/page');
    });

    test('老格式路由走 resolvePageInfo 仍返回正确结果', () {
      PageNameMapper.addMappings({'home': '首页'});
      final info = PageNameMapper.resolvePageInfo('/home');
      expect(info.key, 'home');
      expect(info.name, '首页');
    });
  });

  group('PageNameMapper 老格式回归（兼容性保障）', () {
    setUp(() {
      PageNameMapper.clearCustom();
    });

    tearDown(() {
      PageNameMapper.clearCustom();
    });

    test('addMapping 单条老格式，getPageName 正常', () {
      PageNameMapper.addMapping('discover', '发现页');
      expect(PageNameMapper.getPageName('discover'), '发现页');
      expect(PageNameMapper.getPageName('/discover'), '发现页');
    });

    test('addMappings 批量老格式，所有 key 均可查到', () {
      PageNameMapper.addMappings({
        'home': '首页',
        'discover': '发现页',
        'profile': '我的',
      });
      expect(PageNameMapper.getPageName('home'), '首页');
      expect(PageNameMapper.getPageName('discover'), '发现页');
      expect(PageNameMapper.getPageName('profile'), '我的');
    });

    test('老格式覆盖：重复 addMapping 后取最新值', () {
      PageNameMapper.addMapping('home', '首页');
      PageNameMapper.addMapping('home', '主页');
      expect(PageNameMapper.getPageName('home'), '主页');
    });

    test('无映射路由 getPageName 返回归一化 key（老行为不变）', () {
      expect(PageNameMapper.getPageName('/unknown'), 'unknown');
      expect(PageNameMapper.getPageName('unknown'), 'unknown');
    });

    test('clearCustom 后老格式映射全部清除', () {
      PageNameMapper.addMappings({'home': '首页', 'discover': '发现页'});
      PageNameMapper.clearCustom();
      expect(PageNameMapper.getPageName('home'), 'home');
      expect(PageNameMapper.getPageName('discover'), 'discover');
    });

    test('新格式注册不影响已有老格式条目', () {
      PageNameMapper.addMappings({'home': '首页'});
      PageNameMapper.addMappings({
        'video/:id': {'key': 'video_detail', 'name': '视频详情'},
      });
      // 老格式仍然正常
      expect(PageNameMapper.getPageName('home'), '首页');
      // 新格式不干扰 getPageName 的老路由查询
      expect(PageNameMapper.getPageName('home'), '首页');
    });

    test('resolvePageInfo 对老格式路由 key 不发生变化', () {
      PageNameMapper.addMappings({'discover': '发现页'});
      final info = PageNameMapper.resolvePageInfo('discover');
      // 老格式：key 保持原路由名，不被替换
      expect(info.key, 'discover');
      expect(info.name, '发现页');
    });
  });

  group('PageNameMapper 风险修复验证', () {
    setUp(() {
      PageNameMapper.clearCustom();
    });

    tearDown(() {
      PageNameMapper.clearCustom();
    });

    // 风险 1：字段校验 — 无效入参不 crash，静默忽略
    test('key 字段为 null 时静默忽略，不 crash', () {
      expect(
        () => PageNameMapper.addMapping('video/:id', {'key': null, 'name': '视频'}),
        returnsNormally,
      );
      expect(PageNameMapper.resolvePageInfo('video/1').key, 'video/1');
    });

    test('key 字段缺失时静默忽略，不 crash', () {
      expect(
        () => PageNameMapper.addMapping('video/:id', {'name': '视频'}),
        returnsNormally,
      );
      expect(PageNameMapper.resolvePageInfo('video/1').key, 'video/1');
    });

    test('name 字段为空字符串时静默忽略，不 crash', () {
      expect(
        () => PageNameMapper.addMapping('video/:id', {'key': 'video_detail', 'name': ''}),
        returnsNormally,
      );
      expect(PageNameMapper.resolvePageInfo('video/1').key, 'video/1');
    });

    // 风险 2：_customMap 与 _resolvedKeyMap 隔离 — 老格式不被新格式覆盖
    test('老格式 resolvedKey 同名条目不被新格式污染', () {
      PageNameMapper.addMappings({'video_detail': '旧名称'});
      PageNameMapper.addMappings({
        'video/:id': {'key': 'video_detail', 'name': '新名称'},
      });
      // 老格式路由 video_detail 走精确匹配，name 应保持老格式语义
      final info = PageNameMapper.resolvePageInfo('video_detail');
      expect(info.key, 'video_detail');
      expect(info.name, '旧名称');
    });

    test('新格式 resolvedKey 可被 getPageName 正常反查', () {
      PageNameMapper.addMappings({
        'video/:id': {'key': 'video_detail', 'name': '视频详情'},
      });
      expect(PageNameMapper.getPageName('video_detail'), '视频详情');
    });
  });
}
