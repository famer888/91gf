// lib/utils/page_name_mapper.dart

import 'package:analytics_sdk/utils/logger.dart';

/// 统一的页面 pageKey → pageName 映射管理器
/// 支持静态默认映射 + 动态添加/覆盖（业务方可在初始化时自定义）
///
/// ## 两种注册格式
///
/// **老格式（精确匹配）**：值为字符串，pageKey 与路由名称完全一致时命中
/// ```dart
/// PageNameMapper.addMappings({'home': '首页'});
/// ```
///
/// **新格式（支持 `:param` 动态路由）**：值为 `{'key': ..., 'name': ...}`
/// - `key`：上报时使用的稳定 pageKey（替换掉含真实 ID 的原始路由名）
/// - `name`：页面展示名称
/// ```dart
/// PageNameMapper.addMappings({
///   '/video/:id': {'key': 'video_detail', 'name': '视频详情'},
/// });
/// ```
class PageNameMapper {
  // 默认映射表（SDK 内置，精确匹配）
  static const Map<String, String> _defaultMap = {};

  // 老格式：精确匹配映射表（路由名 → pageName）
  static final Map<String, String> _customMap = {};

  // 新格式：:param 模式映射表（pattern → ResolvedPageInfo）
  static final Map<String, ResolvedPageInfo> _patternMap = {};

  // 新格式 resolvedKey 缓存（resolvedKey → pageName），与 _customMap 隔离
  // 供 getPageName 在 currentPageKey 已被解析为稳定 key 时反查 pageName
  static final Map<String, String> _resolvedKeyMap = {};

  static const String _tag = 'PageNameMapper';

  /// 去除 pageKey 前导斜杠，结果为空时保留原值（如纯 "/" 保持为 "/"）
  static String normalizeKey(String pageKey) {
    if (!pageKey.startsWith('/')) return pageKey;
    final stripped = pageKey.substring(1);
    return stripped.isEmpty ? pageKey : stripped;
  }

  /// 获取页面名称（老格式精确匹配，行为与之前完全一致）
  ///
  /// 同时查 _resolvedKeyMap，确保新格式解析后的稳定 key 也能反查到 pageName
  static String getPageName(String pageKey) {
    final key = normalizeKey(pageKey);
    return _customMap[key] ?? _resolvedKeyMap[key] ?? _defaultMap[key] ?? key;
  }

  /// 解析路由名称，返回上报用的稳定 [ResolvedPageInfo]。
  ///
  /// 查找优先级：
  ///   1. 老格式精确匹配（_customMap / _defaultMap）
  ///   2. 新格式精确匹配（_patternMap）
  ///   3. 新格式 `:param` 通配匹配（_patternMap）
  ///   4. Fallback：key = name = 归一化后的路由名
  static ResolvedPageInfo resolvePageInfo(String routeName) {
    final normalized = normalizeKey(routeName);

    // 1. 老格式精确匹配（只查 _customMap / _defaultMap，不查 _resolvedKeyMap）
    final directName = _customMap[normalized] ?? _defaultMap[normalized];
    if (directName != null) return ResolvedPageInfo(normalized, directName);

    // 2. 新格式精确匹配
    final exactPattern = _patternMap[normalized];
    if (exactPattern != null) return exactPattern;

    // 3. 新格式 :param 通配匹配
    for (final entry in _patternMap.entries) {
      if (_matchesPattern(entry.key, normalized)) {
        return entry.value;
      }
    }

    // 4. Fallback
    return ResolvedPageInfo(normalized, normalized);
  }

  /// 动态添加或覆盖单个映射
  ///
  /// [value] 可为字符串（老格式）或 `{'key': String, 'name': String}`（新格式）
  static void addMapping(String routePattern, dynamic value) {
    final normalized = normalizeKey(routePattern);
    if (value is String) {
      _customMap[normalized] = value;
    } else if (value is Map) {
      // ── 风险 1 修复：严格校验 key / name 字段，避免运行时 crash ──
      final resolvedKey = value['key'];
      final name = value['name'];
      if (resolvedKey is! String || resolvedKey.isEmpty) {
        Logger.warn(_tag, 'addMapping("$routePattern") 的 key 字段无效或为空，已忽略');
        return;
      }
      if (name is! String || name.isEmpty) {
        Logger.warn(_tag, 'addMapping("$routePattern") 的 name 字段无效或为空，已忽略');
        return;
      }

      // ── 风险 3 修复：检测与已注册 pattern 的歧义冲突 ──
      if (_hasConflictingPattern(normalized)) {
        Logger.warn(
          _tag,
          'addMapping("$routePattern") 与已注册的某个 pattern 存在歧义，'
          '将按注册顺序匹配，请检查是否重复注册',
        );
      }

      _patternMap[normalized] = ResolvedPageInfo(resolvedKey, name);
      // ── 风险 2 修复：写入独立的 _resolvedKeyMap，不污染 _customMap ──
      _resolvedKeyMap[resolvedKey] = name;
    }
  }

  /// 批量动态添加或覆盖映射，兼容老格式与新格式混传
  static void addMappings(Map<String, dynamic> mappings) {
    for (final entry in mappings.entries) {
      addMapping(entry.key, entry.value);
    }
  }

  /// 清空自定义映射（测试或重置用）
  static void clearCustom() {
    _customMap.clear();
    _patternMap.clear();
    _resolvedKeyMap.clear();
  }

  /// 判断路由名称是否匹配某个 :param 模式
  static bool _matchesPattern(String pattern, String routeName) {
    final patternParts = pattern.split('/');
    final routeParts = routeName.split('/');
    if (patternParts.length != routeParts.length) return false;
    for (int i = 0; i < patternParts.length; i++) {
      if (patternParts[i].startsWith(':')) continue; // 通配符，跳过
      if (patternParts[i] != routeParts[i]) return false;
    }
    return true;
  }

  /// 检测新 pattern 是否与已注册的 pattern 存在歧义（可能命中同一路由）
  static bool _hasConflictingPattern(String newPattern) {
    for (final existing in _patternMap.keys) {
      if (existing == newPattern) continue; // 相同 pattern，属于覆盖，不是冲突
      if (_patternsConflict(existing, newPattern)) return true;
    }
    return false;
  }

  /// 判断两个 pattern 是否可能匹配同一条路由
  static bool _patternsConflict(String p1, String p2) {
    final parts1 = p1.split('/');
    final parts2 = p2.split('/');
    if (parts1.length != parts2.length) return false;
    for (int i = 0; i < parts1.length; i++) {
      final isParam1 = parts1[i].startsWith(':');
      final isParam2 = parts2[i].startsWith(':');
      // 两段都是固定字面量且不相等 → 不可能同时匹配
      if (!isParam1 && !isParam2 && parts1[i] != parts2[i]) return false;
    }
    return true;
  }
}

/// [PageNameMapper.resolvePageInfo] 的返回值：路由解析后的稳定标识
class ResolvedPageInfo {
  /// 上报用的稳定 pageKey（新格式下为业务方自定义 key，老格式下为归一化路由名）
  final String key;

  /// 页面展示名称
  final String name;

  const ResolvedPageInfo(this.key, this.name);
}
