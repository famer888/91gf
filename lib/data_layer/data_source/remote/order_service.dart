import '../../../domain/type_def.dart';
import 'base_service.dart';

class OrderService extends BaseService {
  OrderService(super._dio);

  @override
  final service = 'order';

  /// 获取商品
  AsyncJson getGoodsList({required int type}) => post('/goodsList', data: {
        'type': type,
      });

  /// 扣币兑换
  AsyncJson onOrderExchange({required int productId}) =>
      post('/exchange', data: {'product_id': productId});

  /// 在线支付
  AsyncJson onCreatePaying({
    required String payWay,
    required String payType,
    required int productId,
  }) =>
      post('/createPaying', data: {
        'pay_way': payWay,
        'pay_type': payType,
        'product_id': productId
      });

  /// 充值记录
  AsyncJson getOrderList({
    required page,
    required String type,
    required int limit,
  }) =>
      post('/orderList', data: {
        'limit': limit,
        'page': page,
        'type': type,
      });

  /// 提现  收益 申请提现
  AsyncJson incomeApplyWithdraw({
    required int cardId,
    required int amount,
    required int type,
  }) =>
      post('/withdraw', data: {
        'card_id': cardId,
        'amount': amount,
        'withdraw_from': type,
      });

  /// 提现  提现列表
  AsyncJson cashWithdrawList({
    required int page,
    required int limit,
  }) =>
      post('/listWithdraw', data: {
        'page': page,
        'limit': limit,
        'status': 1,
      });
}
