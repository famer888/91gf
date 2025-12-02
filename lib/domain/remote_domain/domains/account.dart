import '../../type_def.dart';

abstract class AccountDomain {
  /// 用户名帐号登登录
  AsyncJson loginByAccount({
    required String username,
    required String password,
  });

  /// 用户名注册登录
  AsyncJson loginByReg({
    required String userName,
    required String password,
  });

  /// 验证用户名
  AsyncResult validateUsername({
    required String username,
  });

  Future logout();

  /// 发送验证码
  AsyncResult sendCode({
    required String email,
  });

  /// 绑定邮箱
  AsyncResult bindEmail({
    required String email,
    required String code,
  });
}
