import 'package:jygf/data_layer/data_source/remote/base_service.dart';
import 'package:jygf/domain/type_def.dart';

class ASMRService extends BaseService {
  ASMRService(super._dio);

  @override
  final service = 'voice';

  /// 首页分类列表
  AsyncJson voiceIndexList({
    required String sort,
    required int id,
    required int page,
    required int limit}) =>
      post('/index', data: {'sort': sort, 'id': id, 'page': page, 'limit': limit});

  /// 队列列表
  AsyncJson voiceListQueue({
    required int page,
    required int limit}) =>
      post('/list_queue', data: {'page': page, 'limit': limit});

  /// 收藏列表
  AsyncJson voiceFavoriteList({
    required int page,
    required int limit}) =>
      post('/list_favorite', data: {'page': page, 'limit': limit});

  /// 已购买列表
  AsyncJson voiceBuyList({
    required int page,
    required int limit}) =>
      post('/list_buy', data: {'page': page, 'limit': limit});

  /// 搜索列表
  AsyncJson voiceSearch({
    required String word,
    required int page,
    required int limit}) =>
      post('/search', data: {'word': word, 'page': page, 'limit': limit});

  /// 加入队列
  AsyncJson addVoiceQueue({required int id}) =>
      post('/add_queue', data: {'id': id});

  /// 从队列中删除
  AsyncJson delVoiceQueue({required int id}) =>
      post('/del_queue', data: {'id': id});

  /// 播放上报
  AsyncJson reportVoicePlay({required int id}) =>
      post('/play', data: {'id': id});

  /// 收藏/取消收藏
  AsyncJson favoriteVoice({required int id}) =>
      post('/favorite', data: {'id': id});

  /// 购买
  AsyncJson buyVoice({required int id}) =>
      post('/buy', data: {'id': id});

  /// 语音下载
  AsyncJson downloadVoice({required int id}) =>
      post('/download', data: {'id': id});

}
