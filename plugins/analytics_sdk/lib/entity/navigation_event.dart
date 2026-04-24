import 'package:analytics_sdk/const/event_type.dart';
import 'package:analytics_sdk/manager/sdk_context.dart';

/// 导航菜单点击事件（纯手动上报）。
///
/// 仅在用户主动点击导航菜单时触发：底部 Tab、顶部 Tab、侧边抽屉等。
/// SDK 不会在路由跳转时自动发送此事件；触发方式：
///   - [AnalyticsSdk.trackNavigation] 手动调用
///   - [BottomNavigationBar.withAnalytics] / [TabBar.withAnalytics] 包装器内部自动处理
///
/// **page_key / page_name 填写规范**
///
/// 建议使用 [AppPageEnum] 预定义值，也可直接传入自定义字符串：
/// ```dart
/// NavigationEvent(
///   navigationKey: AppPageEnum.video.key,   // 'video'
///   navigationName: AppPageEnum.video.name, // '影视'
/// )
/// ```
///
/// **上报时序**：应在同次导航的 [AppPageViewEvent] 之前发出。
class NavigationEvent {
  final String event = EventType.navigation.event;
  late final String eventId;

  /// 导航目标的唯一标识，与对应页面的 [AppPageViewEvent.pageKey] 保持一致。
  ///
  /// 示例：`home`（首页）、`video`（影视）、`video_hot`（影视·热门子 Tab）
  final String navigationKey;

  /// 导航目标的展示名称。
  ///
  /// 示例：`首页`、`影视`、`影视·热门`
  final String navigationName;

  late final Map<String, dynamic> _commonFields;

  NavigationEvent({
    required this.navigationKey,
    required this.navigationName,
  }) {
    _commonFields = SdkContext.generateCommonFields(event);

    eventId = SdkContext.generateEventIdFromCommonFields(_commonFields, [
      navigationKey,
      navigationName,
    ]);
  }

  /// 序列化为上报 JSON；payload 包含 `navigation_key` 和 `navigation_name`。
  Map<String, dynamic> toJson() {
    Map<String, dynamic> payload = {
      'navigation_key': navigationKey,
      'navigation_name': navigationName,
    };
    return {
      ..._commonFields,
      'event_id': eventId,
      "payload": payload
    };
  }

  /// 从 JSON 反序列化（通常用于缓存恢复场景）。
  factory NavigationEvent.fromJson(Map<String, dynamic> json) {
    return NavigationEvent(
      navigationKey: json['navigation_key'] as String,
      navigationName: json['navigation_name'] as String,
    );
  }
}
