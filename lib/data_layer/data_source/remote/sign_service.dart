import '../../../domain/type_def.dart';
import 'base_service.dart';

class SignService extends BaseService {
  SignService(super._dio);

  @override
  final service = 'sign';

  /// 获取积分列表
  AsyncJson getExpOfVIP() => post(
        '/list_exp_vip',
        data: {'type': 1},
      );

  /// VIP积分兑换
  AsyncJson expConvertVIP({required int id}) => post(
        '/convert_vip',
        data: {'id': id},
      );

  /// 新人福利
  AsyncJson signListTask({required String type}) =>
      post('/list_task', data: {'type': type});

  /// 新人福利 领取
  AsyncJson signListTaskAccept(Map reqData) =>
      post('/accept_task', data: reqData);

  /// 签到
  AsyncJson signUp() => post('/sign_up');
}
