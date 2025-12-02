import '../../../domain/type_def.dart';
import 'base_service.dart';

class ProxyService extends BaseService {
  ProxyService(super._dio);

  @override
  final service = 'proxy';

  /// 代理 推广数据 | 等级信息
  AsyncJson getProxyDetail() => post('/detail');

  /// 代理 邀请记录
  AsyncJson getProxyInviteRecord({required int page, required int limit}) =>
      post('/list_log', data: {'page': page, 'limit': limit});

  /// 代理 收益明细
  AsyncJson getProxyProfitList({required int page, required int limit}) =>
      post('/list', data: {
        'type': 1,
        'page': page,
        'limit': limit,
        'status': 1,
      });

  AsyncJson proxyApply({required String contact}) =>
      post('/apply', data: {'contact': contact});

}
