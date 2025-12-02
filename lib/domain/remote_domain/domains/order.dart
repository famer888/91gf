import '../../enum.dart';
import '../../model/mine_withdrawal_record_model.dart';
import '../../model/order_model.dart';
import '../../model/product_vip_coin_model.dart';
import '../../type_def.dart';

abstract class OrderDomain {
  /// 获取商品
  AsyncResult<ProductOfVipOrCoin> getProduct({required MyProductType type});

  /// 扣币兑换
  AsyncJson onOrderExchange({required int productId});

  /// 在线支付
  AsyncJson onCreatePaying({
    required String payWay,
    required String payType,
    required int productId,
  });

  /// 充值记录
  AsyncResult<List<Order>> getOrderList({
    required int page,
    required String type,
    required int limit,
  });

  ///提现  收益 申请提现
  AsyncJson incomeApplyWithdraw({
    required int cardId,
    required int amount,
    required int type,
  });

  ///提现  提现列表
  AsyncResult<List<MineWithdrawalRecord>> cashWithdrawList({
    required int page,
    required int limit,
  });
}
