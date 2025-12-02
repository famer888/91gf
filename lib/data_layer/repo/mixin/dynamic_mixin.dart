part of '../repo.dart';

mixin _Dynamic on _BaseAppRepo implements DynamicDomain {
  @override
  AsyncJson getConstructByApiLink(
          {required String apiLink, required Map params}) =>
      _dynamicService.getConstructByApiLink(apiLink: apiLink, params: params);
}
