part of '../repo.dart';

mixin _AIDraw on _BaseAppRepo implements AIDrawDomain {
  @override
  AsyncResult<AIDrawListModel> aiDrawList() => _aidrawService
      .aiDrawList()
      .deserializeJsonBy(AIDrawListModel.fromJson)
      .guard;

  @override
  AsyncResult aiDrawGenerate(
          {required String prompt,
          required String negativeprompt,
          required String size,
          required String image}) =>
      _aidrawService
          .aiDrawGenerate(
              prompt: prompt,
              negativeprompt: negativeprompt,
              size: size,
              image: image)
          .deserializeJsonBy((e) => e)
          .guard;

  @override
  AsyncResult<List<AIDrawRecordModel>> aiDrawRecord({
    required int status,
    required int page,
    required int limit,
  }) =>
      _aidrawService
          .aiDrawRecord(status: status, page: page, limit: limit)
         .deserializeJsonListBy((e) => e.map(AIDrawRecordModel.fromJson).toList())
          .guard;

  @override
  AsyncResult delAIDrawRecord({
    required int ids,
  }) =>
      _aidrawService
          .delAIDrawRecord(ids: ids)
          .deserializeJsonBy((e) => e)
          .guard;
}
