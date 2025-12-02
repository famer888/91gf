part of '../repo.dart';

mixin _Original on _BaseAppRepo implements OriginalDomain {
  @override
  AsyncResult<List<TopicModel>> originalTopics({
    required int page,
    required int limit,
  }) =>
      _originalService
          .originalTopics(page: page, limit: limit)
          .deserializeJsonListBy((e) => e.map(TopicModel.fromJson).toList())
          .guard;
}
