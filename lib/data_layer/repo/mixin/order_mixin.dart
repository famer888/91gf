part of '../repo.dart';

mixin _Order on _BaseAppRepo implements OrderDomain {
  @override
  AsyncResult<ProductOfVipOrCoin> getProduct({
    required MyProductType type,
  }) =>
      _orderService
          .getGoodsList(type: type.id)
          .deserializeJsonBy(ProductOfVipOrCoin.fromJson)
          .guard;

  @override
  AsyncJson onOrderExchange({required int productId}) =>
      _orderService.onOrderExchange(productId: productId);

  @override
  AsyncJson onCreatePaying({
    required String payWay,
    required String payType,
    required int productId,
  }) =>
      _orderService.onCreatePaying(
        payWay: payWay,
        payType: payType,
        productId: productId,
      );

  @override
  AsyncResult<List<Order>> getOrderList({
    required int page,
    required String type,
    required int limit,
  }) =>
      _orderService
          .getOrderList(page: page, limit: limit, type: type)
          .deserializeJsonListBy((e) => e.map(Order.fromJson).toList())
          .guard;

  @override
  AsyncJson incomeApplyWithdraw({
    required int cardId,
    required int amount,
    required int type,
  }) =>
      _orderService.incomeApplyWithdraw(
          cardId: cardId, amount: amount, type: type);

  @override
  AsyncResult<List<MineWithdrawalRecord>> cashWithdrawList({
    required int page,
    required int limit,
  }) =>
      _orderService
          .cashWithdrawList(page: page, limit: limit)
          .deserializeJsonListBy(
              (e) => e.map(MineWithdrawalRecord.fromJson).toList())
          .guard;
}
