import '../../type_def.dart';

abstract class DynamicDomain {
  AsyncJson getConstructByApiLink({
    required String apiLink,
    required Map params,
  });
}
