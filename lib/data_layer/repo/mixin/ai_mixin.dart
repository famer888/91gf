part of '../repo.dart';

mixin _AI on _BaseAppRepo implements AIDomain {
  @override
  AsyncResult<AIServerFaceModel> faceMaterialList({
    required int id,
    required int page,
    required int limit,
    required String sort,
    required String type,
  }) =>
      _aiService
          .faceMaterialList(
              id: id, page: page, limit: limit, sort: sort, type: type)
          .deserializeJsonBy(AIServerFaceModel.fromJson)
          .guard;

  @override
  AsyncResult changeFace({
    required int id,
    required String thumb,
    required int thumbW,
    required int thumbH,
  }) =>
      _aiService
          .changeFace(id: id, thumb: thumb, thumbW: thumbW, thumbH: thumbH)
          .deserialize()
          .guard;

  @override
  AsyncResult customizeFace({
    required String ground,
    required int groundW,
    required int groundH,
    required String thumb,
    required int thumbW,
    required int thumbH,
  }) =>
      _aiService
          .customizeFace(
              ground: ground,
              groundW: groundW,
              groundH: groundH,
              thumb: thumb,
              thumbW: thumbW,
              thumbH: thumbH)
          .deserialize()
          .guard;

  @override
  AsyncResult strip({
    required String thumb,
    required int thumbW,
    required int thumbH,
  }) =>
      _aiService
          .strip(thumb: thumb, thumbW: thumbW, thumbH: thumbH)
          .deserialize()
          .guard;

  @override
  AsyncResult<List<AIModel>?> aIMyFace({
    required int status,
    required int page,
    required int limit,
  }) =>
      _aiService
          .aIMyFace(
            status: status,
            page: page,
            limit: limit,
          )
          .deserializeJsonListBy((e) => e.map(AIModel.fromJson).toList())
          .guard;

  @override
  AsyncResult<List<AIModel>?> aIMyStrip({
    required int status,
    required int page,
    required int limit,
  }) =>
      _aiService
          .aIMyStrip(
            status: status,
            page: page,
            limit: limit,
          )
          .deserializeJsonListBy((e) => e.map(AIModel.fromJson).toList())
          .guard;

  @override
  AsyncResult delStrip({required String ids}) =>
      _aiService.delStrip(ids: ids).deserialize().guard;

  @override
  AsyncResult delFace({required String ids}) =>
      _aiService.delFace(ids: ids).deserialize().guard;

  @override
  AsyncResult<VideoFaceModel> videoFaceMaterialList({
    required int id,
    required int page,
    required int limit,
    required String sort,
    required String type,
  }) =>
      _aiService
          .videoFaceMaterialList(
              id: id, page: page, limit: limit, sort: sort, type: type)
          .deserializeJsonBy(VideoFaceModel.fromJson)
          .guard;

  @override
  AsyncResult changeVideoFace({
    required String materialId,
    required String thumb,
    required String thumbW,
    required String thumbH,
  }) =>
      _aiService
          .changeVideoFace(
              materialId: materialId,
              thumb: thumb,
              thumbW: thumbW,
              thumbH: thumbH)
          .deserialize()
          .guard;

  @override
  AsyncResult<List<AIModel>?> myVideoFace({
    required int status,
    int? page,
    int? limit,
  }) =>
      _aiService
          .myVideoFace(
            status: status,
            page: page,
            limit: limit,
          )
          .deserializeJsonListBy((e) => e.map(AIModel.fromJson).toList())
          .guard;

  @override
  AsyncResult delVideoFace({required String ids}) =>
      _aiService.delVideoFace(ids: ids).deserialize().guard;
}
