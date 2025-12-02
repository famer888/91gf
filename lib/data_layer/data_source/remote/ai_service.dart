import '../../../domain/type_def.dart';
import 'base_service.dart';

class AIService extends BaseService {
  AIService(super._dio);

  @override
  final service = 'ai';

  /// 换脸素材列表
  AsyncJson faceMaterialList({
    required int id,
    required int page,
    required int limit,
    required String sort,
    required String type,
  }) =>
      post('/list_face_material', data: {
        'id': id,
        'page': page,
        'limit': limit,
        'sort': sort,
        'type': type
      });

  /// 素材换脸
  AsyncJson changeFace({
    required int id,
    required String thumb,
    required int thumbW,
    required int thumbH,
  }) =>
      post('/change_face', data: {
        'id': id,
        'thumb': thumb,
        'thumb_w': thumbW,
        'thumb_h': thumbH
      });

  /// 自定义换脸
  AsyncJson customizeFace({
    required String ground,
    required int groundW,
    required int groundH,
    required String thumb,
    required int thumbW,
    required int thumbH,
  }) =>
      post('/customize_face', data: {
        'ground': ground,
        'ground_w': groundW,
        'ground_h': groundH,
        'thumb': thumb,
        'thumb_w': thumbW,
        'thumb_h': thumbH
      });

  /// 去衣
  AsyncJson strip({
    required String thumb,
    required int thumbW,
    required int thumbH,
  }) =>
      post('/strip',
          data: {'thumb': thumb, 'thumb_w': thumbW, 'thumb_h': thumbH});

  AsyncJson aIMyFace({
    required int status, // 0-待处理 1-处理中 2-已成功 3-已失败
    required int page,
    required int limit,
  }) =>
      post('/my_face', data: {'status': status, 'page': page, 'limit': limit});

  AsyncJson aIMyStrip({
    required int status, // 0-待处理 1-处理中 2-已成功 3-已失败
    required int page,
    required int limit,
  }) =>
      post('/my_strip', data: {'status': status, 'page': page, 'limit': limit});

  /// 删除我的脱衣记录
  AsyncJson delStrip({required String ids}) =>
      post('/del_strip', data: {'ids': ids});

  /// 删除我的换脸记录
  AsyncJson delFace({required String ids}) =>
      post('/del_face', data: {'ids': ids});

  AsyncJson videoFaceMaterialList({
    required int id,
    required int page,
    required int limit,
    required String sort,
    required String type,
  }) =>
      post('/list_video_face_material', data: {
        'cate_id': 1,
        'page': page,
        'limit': limit,
        'sort': sort,
        'type': 'used'
      });

  /// 视频换脸
  AsyncJson changeVideoFace({
    required String materialId,
    required String thumb,
    required String thumbW,
    required String thumbH,
  }) =>
      post('/change_video_face', data: {
        'material_id': materialId,
        'thumb': thumb,
        'thumb_w': thumbW,
        'thumb_h': thumbH
      });

  /// 我的视频换脸记录
  AsyncJson myVideoFace({
    required int status,
    int? page,
    int? limit,
  }) {
    final data = <String, dynamic>{'status': status};
    if (page != null) data['page'] = page;
    if (limit != null) data['limit'] = limit;
    return post('/my_video_face', data: data);
  }

  /// 删除我的视频换脸记录
  AsyncJson delVideoFace({required String ids}) =>
      post('/del_video_face', data: {'ids': ids});
}
