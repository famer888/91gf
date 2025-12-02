import 'package:jygf/domain/model/creator_info_model.dart';

import '../../enum.dart';
import '../../model/bank_card_model.dart';
import '../../model/coin_detail_model.dart';
import '../../model/follow_user_model.dart';
import '../../model/income_detail_data_model.dart';
import '../../model/member_model.dart';
import '../../model/tiezt_model.dart';
import '../../type_def.dart';

abstract class UserDomain {
  /// 获取用户接口
  AsyncResult<Member> getUserInfo();

  /// 关注用户/取消关注
  AsyncJson communityFollowUser({required String aff});

  /// 修改用户头像、昵称、签名
  AsyncResult updateUserInfo({
    String? nickName,
    String? thumb,
    String? intro,
  });

  /// 填写邀请码
  AsyncResult toInvitation({required String affCode});

  /// 金币明细
  AsyncResult<List<CoinDetail>> getListMoneyDetail({
    required int page,
    required MyCoinFilterType type,
    required int limit,
  });

  /// 提现  银行卡列表
  AsyncResult<BankList> cashBankCardList({
    required int page,
    required int limit,
  });

  /// 提现  添加银行卡
  AsyncJson cashAddBankCard({
    required String card,
    required String name,
  });

  /// 提现  删除银行卡
  AsyncJson cashDeleteBankCard({required int cardId});

  /// 收益汇总
  AsyncResult<MineIncomeDetailData> earnTotalInfo({
    String source = '',
    required int page,
    required int limit,
    required String lastIx,
  });

  /// 我的帖子
  AsyncResult<List<TieztModel>> userMyPosts({
    String cate = 'release',
    required int page,
    required int limit,
  });

  /// 我收藏的
  AsyncResult getUserFavor({
    required int page,
    required int limit,
    required int type,
    required String lastIx,
  });

  /// 用户收藏   type: 1 mv  2 book 3 story 4 link 5 soundBook 6pic
  AsyncResult userFavorites({required int type, required int id});

  /// 我购买的
  AsyncResult getUserBuy({
    required int page,
    required int limit,
    required int type,
  });

  /// 我的关注
  AsyncResult<FollowingUser> userListFollow({
    required int page,
    required int limit,
    required String lastIx,
  });

  /// 填写邀请码
  AsyncResult sendInvitation({required String affCode});

  AsyncResult imSend({required String type});

  /// 点赞/取消点赞
  AsyncResult userLike({required int type, required int id});

  /// 评论点赞/取消点赞
  AsyncResult userCommentLike({required int type, required int id});

  /// 收藏/取消收藏,type 1 - 长视频 2 - 短视频 3 - 漫画 4 - 帖子 5 - 种子 6 - 语音 7 - 直播 8 - '动漫   9-黄游   10-小说   11-色图
  AsyncResult userFavorite({required int type, required int id});

  /// 可升级列表
  AsyncResult getUserUpgradeGoods();

  /// 金币升级VIP
  AsyncResult userUpgrade({
    required int goodsId,
  });

  /// 他人中心
  AsyncResult<CreatorInfo> userCenterInfo({required String aff});

  ///解锁他人联系方式
  AsyncResult userContactBuy({required int aff});

  /// 获取客服url
  AsyncResult customerConf();

  /// 清除缓存
  AsyncJson clearCached();
}
