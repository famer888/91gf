import 'result.dart';
import 'type_def.dart';

extension ApiValidator on Json {
  bool get isValid => status == 1;
}

extension ResultValidator on Result {
  bool get isValid => status == 1;
}
