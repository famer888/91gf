part of '../repo.dart';

mixin _Proxy on _BaseAppRepo implements ProxyDomain {
  @override
  AsyncResult<ProxyDetail> getProxyDetail() => _proxyService
      .getProxyDetail()
      .deserializeJsonBy(ProxyDetail.fromJson)
      .guard;

  @override
  AsyncResult<ProxyInviteRecordData> getProxyInviteRecord({
    required int currentPage,
    required int limit,
  }) =>
      _proxyService
          .getProxyInviteRecord(page: currentPage, limit: limit)
          .deserializeJsonBy(ProxyInviteRecordData.fromJson)
          .guard;

  @override
  AsyncResult<List<ProxyProfit>> getProxyProfitList({
    required int page,
    required int limit,
  }) =>
      _proxyService
          .getProxyProfitList(page: page, limit: limit)
          .deserializeJsonListBy((e) => e.map(ProxyProfit.fromJson).toList())
          .guard;

  @override
  AsyncResult proxyApply({required String contact}) =>
      _proxyService.proxyApply(contact: contact).deserialize().guard;

}
