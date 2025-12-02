import 'package:jygf/domain/model/voice_model.dart';
import 'package:jygf/domain/type_def.dart';

abstract class ASMRDomain {

  AsyncResult<VoiceWithBannersModel> voiceIndexList({
    required String sort,
    required int id,
    required int page,
    required int limit,
  });

  AsyncResult<List<VoiceModel>?> voiceListQueue({
    required int page,
    required int limit,
  });

  AsyncResult<List<VoiceModel>?> voiceFavoriteList({
    required int page,
    required int limit,
  });

  AsyncResult<List<VoiceModel>?> voiceBuyList({
    required int page,
    required int limit});


  AsyncResult<List<VoiceModel>?> voiceSearch({
    required String word,
    required int page,
    required int limit,
  });

  AsyncResult addVoiceQueue({required int id});

  AsyncResult delVoiceQueue({required int id});

  AsyncResult reportVoicePlay({required int id});

  AsyncResult favoriteVoice({required int id});

  AsyncResult buyVoice({required int id});

  AsyncResult downloadVoice({required int id});



}