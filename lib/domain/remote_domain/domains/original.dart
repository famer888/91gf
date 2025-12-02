import '../../model/topic_model.dart';
import '../../type_def.dart';

abstract class OriginalDomain {
  AsyncResult<List<TopicModel>> originalTopics({
    required int page,
    required int limit,
  });
}
