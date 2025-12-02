
part of '../repo.dart';

mixin _Asmr on _BaseAppRepo implements ASMRDomain {

  @override
  AsyncResult<VoiceWithBannersModel> voiceIndexList({
    required String sort,
    required int id,
    required int page,
    required int limit,
  }) =>
      _asmrService.voiceIndexList(
        sort: sort,
        id: id,
        page: page,
        limit: limit,
      ).deserializeJsonBy(VoiceWithBannersModel.fromJson).guard;

  @override
  AsyncResult<List<VoiceModel>?> voiceListQueue({
    required int page,
    required int limit,
  }) => _asmrService.voiceListQueue(
    page: page,
    limit: limit,
  ).deserializeJsonListBy((e) => e.map(VoiceModel.fromJson).toList()).guard;

  @override
  AsyncResult<List<VoiceModel>?> voiceFavoriteList({
    required int page,
    required int limit,
  }) => _asmrService.voiceFavoriteList(
    page: page,
    limit: limit,
  ).deserializeJsonListBy((e) => e.map(VoiceModel.fromJson).toList()).guard;

  @override
  AsyncResult<List<VoiceModel>?> voiceBuyList({
    required int page,
    required int limit,
  }) => _asmrService.voiceBuyList(
    page: page,
    limit: limit,
  ).deserializeJsonListBy((e) => e.map(VoiceModel.fromJson).toList()).guard;

  @override
  AsyncResult<List<VoiceModel>?> voiceSearch({
    required String word,
    required int page,
    required int limit,
  }) => _asmrService.voiceSearch(
    word: word,
    page: page,
    limit: limit,
  ).deserializeJsonListBy((e) => e.map(VoiceModel.fromJson).toList()).guard;

  @override
  AsyncResult addVoiceQueue({required int id}) =>
      _asmrService.addVoiceQueue(id: id).deserialize().guard;

  @override
  AsyncResult delVoiceQueue({required int id}) =>
      _asmrService.delVoiceQueue(id: id).deserialize().guard;

  @override
  AsyncResult reportVoicePlay({required int id}) =>
      _asmrService.reportVoicePlay(id: id).deserialize().guard;

  @override
  AsyncResult favoriteVoice({required int id}) =>
      _asmrService.favoriteVoice(id: id).deserialize().guard;

  @override
  AsyncResult buyVoice({required int id}) =>
      _asmrService.buyVoice(id: id).deserialize().guard;

  @override
  AsyncResult downloadVoice({required int id}) =>
      _asmrService.downloadVoice(id: id).deserialize().guard;

}
