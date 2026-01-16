part of '../repo.dart';

mixin _User on _BaseAppRepo implements UserDomain {
  @override
  AsyncResult<Member> getUserInfo() =>
      _userService.getUserInfo().deserializeJsonBy(Member.fromJson).guard;

  @override
  AsyncResult toInvitation({required String affCode}) =>
      _userService.toInvitation(affCode: affCode).deserialize().guard;

  @override
  AsyncJson communityFollowUser({
    required String aff,
  }) =>
      _userService.communityFollowUser(aff: aff);

  @override
  AsyncResult favorites({
    required int id,
    required int type,
  })  =>
      _userService.favorites(id: id, type: type).deserialize().guard;

  @override
  AsyncResult updateUserInfo({
    String? nickName,
    String? thumb,
    String? intro,
  }) =>
      _userService
          .updateUserInfo(nickName: nickName, thumb: thumb, intro: intro)
          .deserialize()
          .guard;

  @override
  AsyncResult<List<CoinDetail>> getListMoneyDetail({
    required int page,
    required MyCoinFilterType type,
    required int limit,
  }) =>
      _userService
          .getListMoneyDetail(page: page, type: type.stringType, limit: limit)
          .deserializeJsonListBy((e) => e.map(CoinDetail.fromJson).toList())
          .guard;

  @override
  AsyncResult<BankList> cashBankCardList({
    required int page,
    required int limit,
  }) =>
      _userService
          .cashBankCardList(page: page, limit: limit)
          .deserializeJsonBy(BankList.fromJson)
          .guard;

  @override
  AsyncJson cashAddBankCard({
    required String card,
    required String name,
  }) =>
      _userService.cashAddBankCard(card: card, name: name);

  @override
  AsyncJson cashDeleteBankCard({required int cardId}) =>
      _userService.cashDeleteBankCard(cardId: cardId);

  @override
  AsyncResult<MineIncomeDetailData> earnTotalInfo({
    String source = '',
    required int page,
    required int limit,
    required String lastIx,
  }) =>
      _userService
          .earnTotalInfo(
              page: page, lastIx: lastIx, limit: limit, source: source)
          .deserializeJsonBy(MineIncomeDetailData.fromJson)
          .guard;

  @override
  AsyncResult<List<TieztModel>> userMyPosts({
    String cate = 'release',
    required int page,
    required int limit,
  }) =>
      _userService
          .userMyPosts(page: page, limit: limit, cate: cate)
          .deserializeJsonListBy((e) => e.map(TieztModel.fromJson).toList())
          .guard;

  @override
  AsyncResult getUserFavor({
    required int page,
    required int limit,
    required int type,
    required String lastIx,
  }) =>
      type == 1
          ? _userService
              .getUserFavor(
                  page: page, type: type, lastIx: lastIx, limit: limit)
              .deserializeJsonBy(MineVideoListModel.fromJson)
              .guard
          : _userService
              .getUserFavor(
                  page: page, type: type, lastIx: lastIx, limit: limit)
              .deserializeJsonBy(MineTieztListModel.fromJson)
              .guard;

  @override
  AsyncResult userFavorites({required int type, required int id}) =>
      _userService.userFavorites(type: type, id: id).deserialize().guard;

  @override
  AsyncResult getUserBuy({
    required int page,
    required int limit,
    required int type,
  }) =>
      type == 1
          ? _userService
              .getUserBuy(page: page, type: type, limit: limit)
              .deserializeJsonBy(MineVideoListModel.fromJson)
              .guard
          : _userService
              .getUserBuy(page: page, type: type, limit: limit)
              .deserializeJsonBy(MineTieztListModel.fromJson)
              .guard;

  @override
  AsyncResult<FollowingUser> userListFollow(
          {required int page, required int limit, required String lastIx}) =>
      _userService
          .userListFollow(page: page, lastIx: lastIx, limit: limit)
          .deserializeJsonBy(FollowingUser.fromJson)
          .guard;

  @override
  AsyncResult sendInvitation({required String affCode}) =>
      _userService.sendInvitation(affCode: affCode).deserialize().guard;

  @override
  AsyncResult imSend({required String type}) =>
      _userService.imSend(type: type).deserialize().guard;

  @override
  AsyncResult userLike({required int type, required int id}) =>
      _userService.userLike(type: type, id: id).deserialize().guard;

  @override
  AsyncResult userCommentLike({required int type, required int id}) =>
      _userService.userCommentLike(type: type, id: id).deserialize().guard;

  @override
  AsyncResult userFavorite({required int type, required int id}) =>
      _userService.userFavorite(type: type, id: id).deserialize().guard;

  @override
  AsyncResult getUserUpgradeGoods() =>
      _userService.getUserUpgradeGoods().deserialize().guard;

  @override
  AsyncResult userUpgrade({
    required int goodsId,
  }) =>
      _userService.userUpgrade(goodsId: goodsId).deserialize().guard;

  @override
  AsyncResult<CreatorInfo> userCenterInfo({required String aff}) => _userService
      .userCenterInfo(aff: aff)
      .deserializeJsonBy(CreatorInfo.fromJson)
      .guard;

  @override
  AsyncResult userContactBuy({required int aff}) => _userService
      .userContactBuy(aff: aff)
      .deserializeJsonBy(CreatorInfo.fromJson)
      .guard;

  @override
  AsyncResult customerConf() => _userService.customerConf().deserialize().guard;

  @override
  AsyncJson clearCached() => _userService.clearCached();
}
