/// Tab 页面的 analytics 配置。
///
/// - [key]：pageKey（必填），建议使用 [AppPageEnum]（如 `AppPageEnum.home.key`），
///   也可传入自定义字符串。
/// - [name]：pageName（可选），省略时由 [PageNameMapper] 自动解析；
///   传入时建议与 [AppPageEnum] 保持一致（如 `AppPageEnum.home.name`）。
///
/// ```dart
/// // 使用枚举
/// AnalyticsTab(AppPageEnum.home.key,  AppPageEnum.home.name)
/// AnalyticsTab(AppPageEnum.video.key, AppPageEnum.video.name)
///
/// // 使用自定义值
/// AnalyticsTab('live_room', '直播间')
///
/// // 省略 name（由 PageNameMapper 解析）
/// AnalyticsTab('home')
/// ```
class AnalyticsTab {
  final String key;
  final String? name;

  const AnalyticsTab(this.key, [this.name]);
}
