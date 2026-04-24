/// 预定义页面路由枚举，提供标准 [key]（页面唯一标识）和 [name]（展示名称）。
///
/// **用法示例**
///
/// ```dart
/// // 上报导航事件
/// AnalyticsSdk.instance.trackNavigation(
///   pageKey: AppPageEnum.video.key,
///   pageName: AppPageEnum.video.name,
/// );
///
/// // 配置底部/顶部 Tab
/// BottomNavigationBar(...).withAnalytics(tabs: [
///   AnalyticsTab(AppPageEnum.home.key,  AppPageEnum.home.name),
///   AnalyticsTab(AppPageEnum.video.key, AppPageEnum.video.name),
///   AnalyticsTab(AppPageEnum.mine.key,  AppPageEnum.mine.name),
/// ]);
///
/// // PageView 子页面同步
/// AnalyticsSdk.instance.updateCurrentPage(
///   pageKey: AppPageEnum.videoList.key,
///   pageName: AppPageEnum.videoList.name,
/// );
/// ```
///
/// **自定义页面**：直接传入字符串即可，无需扩展枚举：
/// ```dart
/// AnalyticsSdk.instance.trackNavigation(
///   pageKey: 'live_room',
///   pageName: '直播间',
/// );
/// ```
enum AppPageEnum {
  // ── 公共类 ──────────────────────────────────────────────────

  /// 启动页
  launch('launch', '启动页'),

  /// 引导页（新用户首次打开时展示）
  guide('guide', '引导页'),

  /// 首页（底部导航第一 Tab 常用值）
  home('home', '首页'),

  /// 主页
  mainPage('main_page', '主页'),

  /// 发现页
  discover('discover', '发现页'),

  /// 搜索页（搜索入口页，含搜索框和热搜）
  search('search', '搜索页'),

  /// 搜索结果页
  searchResult('search_result', '搜索结果页'),

  /// 应用中心
  appCenter('app_center', '应用中心'),

  /// 社区页
  community('community', '社区页'),

  /// 广场页
  square('square', '广场页'),

  /// 我的（底部导航"我的"Tab）
  mine('mine', '我的'),

  /// 个人中心（登录用户的详情页）
  userCenter('user_center', '个人中心'),

  /// 用户主页（查看他人主页）
  userHome('user_home', '用户主页'),

  /// 作者主页
  authorHome('author_home', '作者主页'),

  /// 登录页
  login('login', '登录页'),

  /// 注册页
  register('register', '注册页'),

  /// 消息中心
  messageCenter('message_center', '消息中心'),

  /// 设置页
  setting('setting', '设置页'),

  /// 充值页
  recharge('recharge', '充值页'),

  /// 充值记录页
  rechargeRecord('recharge_record', '充值记录页'),

  /// 我的收藏
  mineCollect('mine_collect', '我的收藏'),

  /// 我的历史
  mineHistory('mine_history', '我的历史'),

  /// 会员中心页
  mineVip('mine_vip', '会员中心页'),

  // ── 视频类 ──────────────────────────────────────────────────

  /// 视频列表页
  videoList('video_list', '视频列表页'),

  /// 视频分类页
  videoCategory('video_category', '视频分类页'),

  /// 视频榜单页
  videoRank('video_rank', '视频榜单页'),

  /// 视频搜索页
  videoSearch('video_search', '视频搜索页'),

  /// 视频详情页
  videoDetail('video_detail', '视频详情页'),

  /// 视频播放页
  videoPlay('video_play', '视频播放页'),

  // ── 小说类 ──────────────────────────────────────────────────

  /// 小说列表页
  novelList('novel_list', '小说列表页'),

  /// 小说分类页
  novelCategory('novel_category', '小说分类页'),

  /// 小说榜单页
  novelRank('novel_rank', '小说榜单页'),

  /// 小说详情页
  novelDetail('novel_detail', '小说详情页'),

  /// 小说阅读页
  novelRead('novel_read', '小说阅读页'),

  /// 小说章节页
  novelChapterList('novel_chapter_list', '小说章节页'),

  // ── 漫画类 ──────────────────────────────────────────────────

  /// 漫画列表页
  comicList('comic_list', '漫画列表页'),

  /// 漫画分类页
  comicCategory('comic_category', '漫画分类页'),

  /// 漫画榜单页
  comicRank('comic_rank', '漫画榜单页'),

  /// 漫画详情页
  comicDetail('comic_detail', '漫画详情页'),

  /// 漫画阅读页
  comicRead('comic_read', '漫画阅读页'),

  /// 漫画章节页
  comicChapterList('comic_chapter_list', '漫画章节页');

  // ─────────────────────────────────────────────────────────────

  const AppPageEnum(this.key, this.name);

  /// 页面唯一标识，用于 `page_key` 字段。
  final String key;

  /// 页面展示名称，用于 `page_name` 字段。
  final String name;
}
