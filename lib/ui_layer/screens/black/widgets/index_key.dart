enum UsePosition {
  item, // list item
  detail,
  bottom,
}

enum ResType {
  free,
  vip,
  coin,
  original,
  boutique,
}

enum IndexKey {
  video, // 通用视频(瀑布流)
  long, // 长视频(也称:视频)
  short, // 短视频
  darkMv, // 暗网-长视频
  black, // 黑料
  celebrity, // 明星
  user, // 用户
  movie, // 电影
  skits, // 短剧
  drama, // 剧集
  stage, // 综艺
  cartoon, // 动漫
  comic, // 漫画
  date, // 约炮
  chat, // 裸聊
  post, // 帖子
  darkPt, // 禁区 ---
  trade, // 交易 ---
  seed, // 种子
  game, // 黄游
  graph, // 色图
  novel, // 小说
  audio, // 有声
  live, // 直播
  strip, // 脱衣 ---
  aiGirl, // ai女友
  imChat, // 私信
  imageFacial, // 图片换脸 ---
  videoFacial, // 视频换脸 ---
  aiDrawImage, // AI绘图
  aiNovel, // AI小说
  aiVoice, // AI语音
  aiImageVideo, // 图生视频
}

const Map<IndexKey, String> indexMap = {
  IndexKey.video: '视频',
  IndexKey.long: '视频',
  IndexKey.short: '短视频',
  IndexKey.black: '黑料',
  IndexKey.celebrity: '明星',
  IndexKey.user: '用户',
  IndexKey.movie: '电影',
  IndexKey.skits: '短剧',
  IndexKey.drama: '剧集',
  IndexKey.stage: '综艺',
  IndexKey.cartoon: '动漫',
  IndexKey.comic: '漫画',
  IndexKey.date: '约炮',
  IndexKey.chat: '裸聊',
  IndexKey.post: '帖子',
  IndexKey.seed: '种子',
  IndexKey.game: '黄游',
  IndexKey.graph: '色图', // 注意：P站-艳照，其它-色图
  IndexKey.novel: '小说',
  IndexKey.audio: '有声',
  IndexKey.live: '直播',
  IndexKey.strip: 'AI脱衣',
  IndexKey.imageFacial: '图片换脸',
  IndexKey.videoFacial: '视频换脸',
  IndexKey.aiImageVideo: '图生视频',
  IndexKey.aiDrawImage: 'AI绘图',
  IndexKey.aiNovel: 'AI小说',
  IndexKey.aiVoice: 'AI语音',
};

String indexValue(IndexKey? key) => indexMap[key] ?? '*';
