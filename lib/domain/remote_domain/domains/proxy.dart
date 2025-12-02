import '../../model/proxy_detail_model.dart';
import '../../model/proxy_invite_record_model.dart';
import '../../model/proxy_profit_model.dart';
import '../../type_def.dart';

abstract class ProxyDomain {
  /// 代理 推广数据 | 等级信息
  AsyncResult<ProxyDetail> getProxyDetail();

  /// 代理 邀请记录
  AsyncResult<ProxyInviteRecordData> getProxyInviteRecord({
    required int currentPage,
    required int limit,
  });

  /// 代理 收益明细
  AsyncResult<List<ProxyProfit>> getProxyProfitList({
    required int page,
    required int limit,
  });

  AsyncResult proxyApply({required String contact});

}
