part of '../repo.dart';

mixin _AINovel on _BaseAppRepo implements AINovelDomain {
  @override
  AsyncResult aiNovelGenerate({
    required String description,
    required String characterSetting,
    required String locationScene,
    required String details,
    required String count,
  }) =>
      _ainovelService
          .aiNovelGenerate(
            description: description,
            characterSetting: characterSetting,
            locationScene: locationScene,
            details: details,
            count: count,
          )
          .deserializeJsonBy((e) => e)
          .guard;

  @override
  AsyncResult<List<dynamic>> aiNovelRecord({
    required int status,
    required int page,
    required int limit,
  }) =>
      _ainovelService
          .aiNovelRecord(status: status, page: page, limit: limit)
          .deserializeJsonListBy((e) => e.toList())
          .guard;

  @override
  AsyncResult<Json> aiNovelDetail({
    required String id,
  }) =>
      _ainovelService.aiNovelDetail(id: id).deserializeJsonBy((e) => e).guard;

  @override
  AsyncResult delAINovelRecord({
    required String ids,
  }) =>
      _ainovelService
          .delAINovelRecord(ids: ids)
          .deserializeJsonBy((e) => e)
          .guard;
}
