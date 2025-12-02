import 'package:jygf/domain/model/ai_model.dart';
import 'package:jygf/domain/model/ai_server_face_model.dart';
import 'package:jygf/domain/type_def.dart';

abstract class AIDomain {
  /// 换脸列表排序
  AsyncResult<AIServerFaceModel> faceMaterialList({
    required int id,
    required int page,
    required int limit,
    required String sort,
    required String type,
  });

  AsyncResult changeFace({
    required int id,
    required String thumb,
    required int thumbW,
    required int thumbH,
  });

  AsyncResult customizeFace({
    required String ground,
    required int groundW,
    required int groundH,
    required String thumb,
    required int thumbW,
    required int thumbH,
  });

  AsyncResult strip({
    required String thumb,
    required int thumbW,
    required int thumbH,
  });

  ///我的换脸记录
  AsyncResult<List<AIModel>?> aIMyFace({
    required int status, // 0-待处理 1-处理中 2-已成功 3-已失败
    required int page,
    required int limit,
  });

  ///我的脱衣记录
  AsyncResult<List<AIModel>?> aIMyStrip({
    required int status, // 0-待处理 1-处理中 2-已成功 3-已失败
    required int page,
    required int limit,
  });

  /// 删除我的脱衣记录
  AsyncResult delStrip({required String ids});

  /// 删除我的换脸记录
  AsyncResult delFace({required String ids});

  /// 视频换脸素材列表
  AsyncResult<VideoFaceModel> videoFaceMaterialList({
    required int id,
    required int page,
    required int limit,
    required String sort,
    required String type,
  });

  /// 视频换脸
  AsyncResult changeVideoFace({
    required String materialId,
    required String thumb,
    required String thumbW,
    required String thumbH,
  });

  /// 我的视频换脸记录
  AsyncResult<List<AIModel>?> myVideoFace({
    required int status, // 0-待处理 1-处理中 2-已成功 3-已失败
    int? page,
    int? limit,
  });

  /// 删除我的视频换脸记录
  AsyncResult delVideoFace({required String ids});
}
