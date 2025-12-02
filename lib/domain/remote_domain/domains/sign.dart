import '../../model/exp_of_vip_model.dart';
import '../../model/welfare_task_model.dart';
import '../../type_def.dart';

abstract class SignDomain {
  /// 获取积分列表
  AsyncResult<ExpOfVIPData> getExpOfVIP();

  /// VIP积分兑换
  AsyncJson expConvertVIP({required int id});

  /// 新人福利：type为空则返回全部任务，type != ''只返回邀请任务
  AsyncResult<WelfareTaskModel?> signListTask({required String type});

  /// 新人福利 领取
  AsyncResult signListTaskAccept(Map request);

  /// 签到
  AsyncResult signUp();
}
