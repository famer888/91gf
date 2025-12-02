part of '../repo.dart';

mixin _AIAudio on _BaseAppRepo implements AIAudioDomain {
  @override
  AsyncResult aiAudioGenerate({
    required String text,
    required String spkId,
  }) =>
      _aiaudioService
          .aiAudioGenerate(text: text, spkId: spkId)
          .deserializeJsonBy((e) => e)
          .guard;

  @override
  AsyncResult<List<dynamic>> aiAudioRecord({
    required int status,
    required int page,
    required int limit,
  }) =>
      _aiaudioService
          .aiAudioRecord(status: status, page: page, limit: limit)
          .deserializeJsonListBy((e) => e.toList())
          .guard;

  @override
  AsyncResult delAIAudioRecord({
    required String ids,
  }) =>
      _aiaudioService
          .delAIAudioRecord(ids: ids)
          .deserializeJsonBy((e) => e)
          .guard;
}
