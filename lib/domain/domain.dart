import 'package:jygf/domain/type_def.dart';

import 'remote_domain/domain.dart';
import 'model/home_data_model.dart';
export 'remote_domain/domains/account.dart';
export 'remote_domain/domains/community.dart';
export 'remote_domain/domains/dynamic.dart';
export 'remote_domain/domains/element.dart';
export 'remote_domain/domains/home.dart';
export 'remote_domain/domains/order.dart';
export 'remote_domain/domains/proxy.dart';
export 'remote_domain/domains/seed.dart';
export 'remote_domain/domains/sign.dart';
export 'remote_domain/domains/user.dart';
export 'remote_domain/domains/withdraw.dart';
export 'remote_domain/domains/message.dart';
export 'remote_domain/domains/mv.dart';
export 'remote_domain/domains/vlog.dart';
export 'remote_domain/domains/privilege.dart';
export 'remote_domain/domains/search.dart';

abstract class AppDomain implements LocaleDomain, RemoteDomain {}

abstract class LocaleDomain {
  CacheDomain get cache;
  Json get info;
}

abstract class CacheDomain
    implements VideoDownloadCacheDomain, ChatCacheDomain {
  /// 大于500M清理磁盘
  Future<void> clearImageCacheIfNeed({bool force = false});

  /// 获取广告缓存
  Future<AdModel?> readAds();

  /// 获取广告缓存
  Future<List<AdModel>?> readStartScreenAds();

  Future<bool> readIsBarrage();

  ///获取直播弹幕开关，默认true：开
  Future<void> upsertIsBarrage(bool isBarrage);

  /// 获取官网链结缓存
  Future<String?> readOfficeWeb();

  /// 取得搜索记录
  Future<List<String>> readSearchHistory();

  /// 更新搜索记录
  Future<void> upsertSearchHistory({required List<String> searchHistory});

    /// 取得漫画阅读到第几章节
  Future<int> readComicReaderChapterIndex({required String comicIdkey});

  ///记录漫画阅读章节
  Future<void> upsertComicReaderChapterIndex({required String comicIdkey, required int chapterIndex});

  /// 取得小说阅读到第几章节
  Future<int> readNovelReaderChapterIndex({required String novelIdkey});

  ///记录小说阅读章节
  Future<void> upsertNovelReaderChapterIndex({required String novelIdkey, required int chapterIndex});

  /// 取得小说字体设置大小
  Future<double> readNovelReaderFontSize();

  ///记录小说字体设置大小
  Future<void> upsertNovelFontSize({required double fontSize});

  /// 取得小说阅读设置背景颜色
  Future<int> readNovelReaderBgColorIndex();

  ///记录小说背景颜色设置值
  Future<void> upsertNovelBgColorIndex({required int index});

  /// 清除搜索记录
  Future<void> clearSearchHistory();
}

abstract class VideoDownloadCacheDomain {
  Future<List> readDownloadVideoTasks();

  Future<void> upsertDownloadVideoTasks({required List tasks});
}

abstract class ChatCacheDomain {
  Future<String> readChats();

  Future<void> upsertChats({required String chats});
}
