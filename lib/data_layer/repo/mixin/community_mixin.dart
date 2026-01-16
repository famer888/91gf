part of '../repo.dart';

mixin _Community on _BaseAppRepo implements CommunityDomain {

  @override
  AsyncResult<List<TipModel>> getNoticeList()
    => _communityService
        .getNoticeList()
        .deserializeJsonListBy((e) => e.map(TipModel.fromJson).toList())
        .guard;

  @override
  AsyncResult<FollowMemberModel> getFollowUserList() {
    return _communityService
        .getFollowUserList()
        .deserializeJsonBy(FollowMemberModel.fromJson)
        .guard;
  }

  @override
  AsyncResult<FollowTopicModel> getFollowTopicList() {
    return _communityService
        .getFollowTopicList()
        .deserializeJsonBy(FollowTopicModel.fromJson)
        .guard;
  }

  @override
  AsyncResult<List<CommunityCategoryTabModel>> getCategoryTabList() =>
      _communityService
          .getCategoryTabList()
          .deserializeJsonListBy((e) => e.map(CommunityCategoryTabModel.fromJson).toList())
          .guard;

  @override
  AsyncResult<CommunityWithBannerModel> communitySortList({
    required int id,
    required String sort,
    required int page,
    required int limit,
  }) =>
      _communityService
          .communitySortList(id: id, sort: sort, page: page, limit: limit)
          .deserializeJsonBy(CommunityWithBannerModel.fromJson)
          .guard;

  @override
  AsyncResult<CheckFileModel> getCheckFileList({required int page, required int limit, required String sort})
    => _communityService
        .getCheckFileList(page: page, limit: limit, sort: sort)
        .deserializeJsonBy(CheckFileModel.fromJson)
        .guard;

  @override
  AsyncResult<TopicsWithBannersModel> postList(
          {required int page, int limit = 15}) =>
      _communityService
          .postList(page: page, limit: limit)
          .deserializeJsonBy(TopicsWithBannersModel.fromJson)
          .guard;

  @override
  AsyncResult buyPostTutorials({required int id}) =>
      _communityService.buyPostTutorials(id: id).deserialize().guard;

  @override
  AsyncResult<List<CommunityNavModel>> reqGetPostNav({String type = ''}) =>
      _communityService
          .reqGetPostNav(type: type)
          .deserializeJsonListBy(
              (e) => e.map(CommunityNavModel.fromJson).toList())
          .guard;

  @override
  AsyncResult<CommunityWithBannerModel> communityAiList({
    required int page,
    required int limit,
  }) =>
      _communityService
          .communityAiList(page: page, limit: limit)
          .deserializeJsonBy(CommunityWithBannerModel.fromJson)
          .guard;

  @override
  AsyncResult<TopicDetail> communityTopicDetail({required String id}) =>
      _communityService
          .communityTopicDetail(id: id)
          .deserializeJsonBy(TopicDetail.fromJson)
          .guard;

  @override
  AsyncResult<List<PostModel>> communityTopicAsk({
    required String aff,
    required int page,
    required int limit,
  }) =>
      _communityService
          .communityTopicAsk(aff: aff, page: page, limit: limit)
          .deserializeJsonListBy((e) => e.map(PostModel.fromJson).toList())
          .guard;

  @override
  AsyncResult<CheckDetailModel> checkFileDetail({required String id}) =>
      _communityService
          .checkFileDetail(id: id)
          .deserializeJsonBy(CheckDetailModel.fromJson)
          .guard;

  @override
  AsyncResult<List<ReviewData>> communityPostComments(
          {required String id, required int page, required int limit}) =>
      _communityService
          .communityPostComments(id: id, page: page, limit: limit)
          .deserializeJsonListBy((e) => e.map(ReviewData.fromJson).toList())
          .guard;

  @override
  AsyncJson communityPostComment(
          {required String postId,
          required String commentId,
          required String content}) =>
      _communityService.communityPostComment(
          postId: postId, commentId: commentId, content: content);

  @override
  AsyncResult communityTopicLike(
          {required MyLikeType type, required String id}) =>
      _communityService
          .communityTopicLike(id: id, type: type.name)
          .deserialize()
          .guard;

  @override
  AsyncJson reqGetPostURL({required int id}) =>
      _communityService.reqGetPostURL(id: id);

  @override
  AsyncResult communityTopicFavorite({required String id, required int type, required int requestType}) =>
      _communityService.communityTopicFavorite(id: id, type: type, requestType: requestType).deserialize().guard;

  @override
  AsyncResult<List<ReviewData>> communityPostCommentsSecond({
    required String commentId,
    required int page,
    required int limit,
  }) =>
      _communityService
          .communityPostCommentsSecond(
              commentId: commentId, page: page, limit: limit)
          .deserializeJsonListBy((e) => e.map(ReviewData.fromJson).toList())
          .guard;

  @override
  AsyncJson communityPost({
    required String topicId,
    required String title,
    String content = '',
    required String medias,
    required String coins,
    String type = '',
    String contact = '',
    int isPublic = 0,
  }) =>
      _communityService.communityPost(
          topicId: topicId,
          title: title,
          content: content,
          medias: medias,
          coins: coins,
          type: type,
          contact: contact,
          isPublic: isPublic);

  @override
  AsyncResult<List<TopicModel>> communityTopics({
    required int page,
    required int limit,
    required int type,
  }) =>
      _communityService
          .communityTopics(page: page, limit: limit, type: type)
          .deserializeJsonListBy((e) => e.map(TopicModel.fromJson).toList())
          .guard;

  @override
  AsyncResult<List<TieztModel>> peerCenterPost({
    required String aff,
    required int page,
    required int limit,
    String lastIx = '',
  }) =>
      _communityService
          .peerCenterPost(aff: aff, page: page, limit: limit, lastIx: lastIx)
          .deserializeJsonListBy((e) => e.map(TieztModel.fromJson).toList())
          .guard;

  @override
  AsyncResult<CreatorInfo> peerCenterInfo({required String aff}) =>
      _communityService
          .peerCenterInfo(aff: aff)
          .deserializeJsonBy(CreatorInfo.fromJson)
          .guard;

  @override
  AsyncResult<List<TopicModel>> focusTops({
    required int page,
    required int limit,
  }) =>
      _communityService
          .focusTops(page: page, limit: limit)
          .deserializeJsonBy((data) => (data['topics'] as List? ?? [])
              .map((e) => TopicModel.fromJson(e))
              .toList())
          .guard;

  @override
  AsyncJson communityFollowTopic({required String topicId}) =>
      _communityService.communityFollowTopic(topicId: topicId);

  @override
  AsyncResult<TopicModel> communityTopicsDetail({
    required String topicId,
    String type = '',
  }) =>
      _communityService
          .communityTopicsDetail(topicId: topicId, type: type)
          .deserializeJsonBy(TopicModel.fromJson)
          .guard;

  @override
  AsyncResult<List<PostModel>> communityListTopicPost({
    required String topicId,
    required String cate,
    required int page,
    required int limit,
    String type = '',
  }) =>
      _communityService
          .communityListTopicPost(
              topicId: topicId, cate: cate, page: page, limit: limit)
          .deserializeJsonListBy((e) => e.map(PostModel.fromJson).toList())
          .guard;

  @override
  AsyncResult<List<PostModel>> searchCommunity({
    required int page,
    required int limit,
    required String word,
    required String type,
  }) =>
      _communityService
          .searchCommunity(page: page, limit: limit, word: word, type: type)
          .deserializeJsonListBy((e) => e.map(PostModel.fromJson).toList())
          .guard;

 @override
  AsyncResult<PostsWithBannersModel> circleSortList({
    required int id,
    required String sort,
    required int page,
    required int limit,
  }) =>
      _communityService
          .circleSortList(id: id, sort: sort, page: page, limit: limit)
          .deserializeJsonBy(PostsWithBannersModel.fromJson)
          .guard;

          @override
  AsyncResult<List<CirclePostNavModel>> reqGetCircleNav({String type = ''}) =>
      _communityService
          .reqGetCircleNav(type: type)
          .deserializeJsonListBy(
              (e) => e.map(CirclePostNavModel.fromJson).toList())
          .guard;

  @override
  AsyncResult<List<TieztModel>> myPosts({
    required int page,
    required int limit,
    required int status,
  }) =>
      _communityService.myPosts(page: page, limit: limit, status: status).deserializeJsonListBy((e) => e.map(TieztModel.fromJson).toList()).guard;
}
