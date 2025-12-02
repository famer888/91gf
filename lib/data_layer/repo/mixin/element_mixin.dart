part of '../repo.dart';

mixin _Element on _BaseAppRepo implements ElementDomain {
  @override
  AsyncResult<ElementModel> getFirstTopNavConfig({int? navId}) =>
      _elementService
          .getFirstTopNavConfig(navId: navId ?? 7)
          .deserializeJsonBy(ElementModel.fromJson)
          .guard;
}
