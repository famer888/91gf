part of '../repo.dart';

mixin _Privilege on _BaseAppRepo implements PrivilegeDomain {
  @override
  AsyncResult downNum({required String id}) =>
      _privilegeService.downNum(id: id).deserialize().guard;
}
