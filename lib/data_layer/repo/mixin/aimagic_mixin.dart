part of '../repo.dart';

mixin _AIMagic on _BaseAppRepo implements AIMagicDomain {
  @override
  AsyncResult<AIMagicListModel> aiMagicList({
    required int page,
    int limit = 15,
  }) =>
      _aiMagicService
          .aiMagicList(page: page, limit: limit)
          .deserializeJsonBy(AIMagicListModel.fromJson)
          .guard;

  @override
  AsyncResult<AIMagicModel> aiMagicGenerate(
          {required String materialId,
          required String thumb,
          required String thumbW,
          required String thumbH}) =>
      _aiMagicService
          .aiMagicGenerate(
            materialId: materialId,
            thumb: thumb,
            thumbW: thumbW,
            thumbH: thumbH,
          )
          .deserializeJsonBy(AIMagicModel.fromJson)
          .guard;

  @override
  AsyncResult<List<AIMagicRecordModel>> aiMagicRecord({
    required int status,
    required int page,
    required int limit,
  }) =>
      _aiMagicService
          .aiMagicRecord(status: status, page: page, limit: limit)
         .deserializeJsonListBy((e) => e.map(AIMagicRecordModel.fromJson).toList())
          .guard;

  @override
  AsyncResult delAIMagicRecord({
    required int ids,
  }) =>
      _aiMagicService
          .delAIMagicRecord(ids: ids)
          .deserializeJsonBy((e) => e)
          .guard;
}
