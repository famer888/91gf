
part of '../repo.dart';

mixin _Rank on _BaseAppRepo implements RankDomain {
  @override
  AsyncResult<List<FeedVideoModel>?>rankMVList({
    required String type,
    required String cycle,
}) =>
      _rankService
          .rankMVList(type: type, cycle: cycle)
          .deserializeJsonListBy((e) => e.map(FeedVideoModel.fromJson).toList())
          .guard;
}
