part of '../repo.dart';

mixin _AIKiss on _BaseAppRepo implements AIKissDomain {
  @override
  AsyncResult aiKissGenerate({
    required String firstThumb,
    required String firstThumbW,
    required String firstThumbH,
    required String endThumb,
    required String endThumbW,
    required String endThumbH,
  }) =>
      _aikissService
          .aiKissGenerate(
            firstThumb: firstThumb,
            firstThumbW: firstThumbW,
            firstThumbH: firstThumbH,
            endThumb: endThumb,
            endThumbW: endThumbW,
            endThumbH: endThumbH,
          )
          .deserializeJsonBy((e) => e)
          .guard;

  @override
  AsyncResult<List<dynamic>> aiKissRecord({
    required int status,
    required int page,
    required int limit,
  }) =>
      _aikissService
          .aiKissRecord(status: status, page: page, limit: limit)
          .deserializeJsonListBy((e) => e.toList())
          .guard;

  @override
  AsyncResult delAIKissRecord({
    required String ids,
  }) =>
      _aikissService
          .delAIKissRecord(ids: ids)
          .deserializeJsonBy((e) => e)
          .guard;
}
