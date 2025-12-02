part of '../repo.dart';

mixin _Account on _BaseAppRepo implements AccountDomain {
  @override
  AsyncJson loginByAccount(
      {required String username, required String password}) async {
    final result = await _accountService.loginByAccount(
      username: username,
      password: password,
    );
    if (result.data case final String token when token.isNotEmpty) {
      _updateToken(token);
    }
    return result;
  }

  @override
  AsyncJson loginByReg({
    required String userName,
    required String password,
  }) async {
    final result = await _accountService.loginByReg(
      username: userName,
      password: password,
    );
    if (result.data case final String token when token.isNotEmpty) {
      _updateToken(token);
    }
    return result;
  }

  @override
  AsyncResult validateUsername({
    required String username,
  }) =>
      _accountService.validateUsername(username: username).deserialize().guard;

  @override
  Future logout() async {
    await _cleanToken();
    _tokenValidStreamController.sink.add(null);
  }

  @override
  AsyncResult sendCode({
    required String email,
  }) =>
      _accountService.sendCode(email: email).deserialize().guard;

  @override
  AsyncResult bindEmail({
    required String email,
    required String code,
  }) =>
      _accountService.bindEmail(email: email, code: code).deserialize().guard;
}
