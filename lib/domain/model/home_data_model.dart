import 'package:jygf/domain/model/ai_nav_model.dart';
import 'package:jygf/domain/model/banner_model.dart';
import 'package:jygf/domain/model/bit_nav_model.dart';
import 'package:jygf/domain/model/chat_nav_model.dart';
import 'package:jygf/domain/model/chat_select_nav_model.dart';
import 'package:jygf/domain/model/live_model.dart';

import 'community_nav_model.dart';
import 'navigator_model.dart';

class HomeData {
  HomeData({
    required this.versionMsg,
    this.timestamp,
    required this.config,
    this.notice,
    this.ads,
    this.startScreenAds,
    this.popAds,
    this.help,
    this.noticeApps,
  });

  final VersionMsg? versionMsg;
  final int? timestamp;
  final Notice? notice;
  final List<Notice>? popAds;
  final Config config;
  final AdModel? ads;
  final List<AdModel>? startScreenAds;
  final List<Help>? help;
  final List<Notice>? noticeApps;

  factory HomeData.fromJson(Map<String, dynamic> json) => HomeData(
        versionMsg: json['versionMsg'] == null
            ? null
            : VersionMsg.fromJson(json['versionMsg']),
        notice: json['notice'] == null ? null : Notice.fromJson(json['notice']),
        timestamp: json['timestamp'],
        config: Config.fromJson(json['config']),
        ads: json['ads'] == null ? null : AdModel.fromJson(json['ads']),
        popAds: List<Notice>.from(
            json['pop_ads']?.map((x) => Notice.fromJson(x)) ?? []),
        help: List<Help>.from(json['help']?.map((e) => Help.fromJson(e))),
        noticeApps: List<Notice>.from(
            json['notice_app']?.map((x) => Notice.fromJson(x)) ?? []),
        startScreenAds: List<AdModel>.from(
            json['start_screen_ads']?.map((x) => AdModel.fromJson(x)) ?? []),
      );
}

class AdModel {
  AdModel(
      {this.id,
      this.title,
      this.description,
      this.imgUrl,
      this.url,
      this.position,
      this.androidDownUrl,
      this.iosDownUrl,
      this.type,
      this.status,
      this.oauthType,
      this.mvM3U8,
      this.channel,
      this.createdAt,
      this.subTitle});

  final int? id;
  final String? title;
  final String? description;
  final String? imgUrl;
  final String? url;
  final int? position;
  final String? androidDownUrl;
  final String? iosDownUrl;
  final int? type;
  final int? status;
  final int? oauthType;
  final String? mvM3U8;
  final String? channel;
  final String? createdAt;
  final String? subTitle;

  factory AdModel.fromJson(Map<String, dynamic> json) => AdModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      imgUrl: json['img_url'],
      url: json['url'],
      position: json['position'],
      androidDownUrl: json['android_down_url'],
      iosDownUrl: json['ios_down_url'],
      type: json['type'],
      status: json['status'],
      oauthType: json['oauth_type'],
      mvM3U8: json['mv_m3u8'],
      channel: json['channel'],
      createdAt: json['created_at'].toString(),
      subTitle: json['sub_title']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'img_url': imgUrl,
        'url': url,
        'position': position,
        'android_down_url': androidDownUrl,
        'ios_down_url': iosDownUrl,
        'type': type,
        'status': status,
        'oauth_type': oauthType,
        'mv_m3u8': mvM3U8,
        'channel': channel,
        'created_at': createdAt,
        'sub_title': subTitle
      };
}

class Config {
  Config({
    required this.imgBase,
    required this.imgUploadUrl,
    this.mp4UploadUrl,
    this.mobileMp4UploadUrl,
    required this.uploadImgKey,
    this.uploadMp4Key,
    this.uuid,
    this.github,
    this.officeSite,
    this.officialGroup,
    this.line,
    this.m3u8Encrypt,
    this.videoEncryptApi,
    this.videoEncryptReferer,
    this.videoEncryptM3u8,
    required this.vipLevelStr,
    required this.vipNameStr,
    required this.navId,
    this.lqNavid,
    this.dmNavid,
    this.mhNavid,
    this.awNavid,
    this.githubUrl,
    this.linesUrl,
    this.tipsShareText,
    this.girlCommentOption,
    this.shortSite,
    this.proxyJoinNum,
    this.solution,
    this.personAds,
    this.dayPrice,
    this.coverIds,
    this.coverVipStr,
    this.coverTips,
    this.voiceNav,
    this.voiceSortNav,
    this.sortNav,
    this.forumNav,
    this.seedSortNav,
    this.vlogNav,
    this.vlogTagSortNav,
    this.vlogSortNav,
    this.vlogDiscoverSortNav,
    this.cartoonTopNav,
    this.cartoonSortNav,
    this.comicTopNav,
    this.comicSortNav,
    this.gameTopNav,
    this.gameSortNav,
    this.gameTagSortNav,
    this.acgNav,
    this.comicTypeNav,
    this.novelNav,
    this.novelSort,
    this.novelTypeNav,
    required this.chatNav,
    required this.chatSelectNav,
    required this.circleNav,
    required this.vipNameCircleStrImg,
    this.albumNav,
    this.albumSortNav,
    this.albumTagSort,
    this.postDetailAds,
    this.buoy,
    this.forumTips,
    required this.liveTopNav,
    required this.communityNav,
    this.faceTopNav,
    this.faceSortNav,
    required this.seedTopNav,
    this.showApp,
    required this.potatoGroup,
    required this.tgGroup,
    required this.payAi,
    required this.seedVipTip,
    required this.seedCoinsTip,
    required this.wdaiStr,
    required this.vipLevelAwqStr,
    required this.vipNameAwqStr,
    required this.originalSortNav,
    required this.originalBloggerNav,
    required this.originalTopNav,
    required this.faceCoins,
    required this.stripCoins,
    required this.payAiMagic,
    required this.payAiDraw,
    this.openLive,
    this.rankTopNav,
    this.rankCycleNav,
    this.imCoins,
    this.imTip,
    this.bindEmailTip,
    this.joinChatGroupCoins,
    this.pwaDownloadUrl,
    this.r2URL,
    this.r2Key,
    this.r2CompleteURL,
    this.pwa_apk,
    this.keywords,
    this.description,
    this.title,
    this.adVersion,
    this.nav_prepend,
    this.nav_default,
    required this.aiNav,
    required this.payAiAudio,
    required this.payAiNovel,
    required this.payAiKiss,
    this.videoFaceTopNav,
    this.videoFaceSortNav,
    required this.aiAudioFontCt,
  });

  final int? imCoins;
  final String? imTip;
  final String? bindEmailTip;
  final String? dayPrice;
  final dynamic personAds;
  final String imgUploadUrl;
  final String? solution;
  final String? mp4UploadUrl;
  final String? mobileMp4UploadUrl;
  final String uploadImgKey;
  final String? uploadMp4Key;
  final String? uuid;
  final String? tipsShareText;
  final String? github;
  final String? officeSite;
  final String? officialGroup;
  final String? shortSite;
  final String imgBase;
  final List<String>? line;
  final int? m3u8Encrypt;
  final String? videoEncryptApi;
  final String? videoEncryptReferer;
  final String? videoEncryptM3u8;
  final List<String> vipLevelStr;
  final String vipNameStr;
  final int? navId;
  final int? lqNavid;
  final int? dmNavid;
  final int? mhNavid;
  final int? awNavid;
  final String? githubUrl;
  final List<String>? linesUrl;
  final String? girlCommentOption;
  final String? proxyJoinNum;
  final List<String>? coverIds;
  final List<String>? coverVipStr;
  final String? coverTips;
  final List<FaceNavigatorModel>? voiceNav;
  final List<NavigatorModel>? voiceSortNav;
  final List<NavigatorModel>? sortNav;
  final List<NavigatorModel>? forumNav;
  final List<NavigatorModel>? seedSortNav;
  final List<VlogNavigatorModel>? vlogNav;
  final List<NavigatorModel>? vlogTagSortNav;
  final List<NavigatorModel>? vlogSortNav; //短视频-下拉排序
  final List<NavigatorModel>? vlogDiscoverSortNav;

  final List<BitNavModel>? cartoonTopNav; //动漫分类
  final List<BitNavModel>? cartoonSortNav; //动漫排序
  final List<BitNavModel>? comicTopNav; //漫画分类
  final List<BitNavModel>? comicSortNav; //漫画排序
  final List<BitNavModel>? gameTopNav; //黄游分类
  final List<BitNavModel>? gameSortNav; //黄游排序
  final List<BitNavModel>? gameTagSortNav; //黄游tag排序
  final List<BitNavModel>? acgNav; //ACG - nav
  final List<ComicTypeNav>? comicTypeNav; //漫画分类  
  final List<BitNavModel>? novelNav; //小说分类
  final List<BitNavModel>? novelSort; //小说排序
  final List<ComicTypeNav>? novelTypeNav; //小说分类排序条件
  final List<ChatNavModel> chatNav;//裸聊分类
  final List<ChatSelectNavModel> chatSelectNav;
  final List<NavigatorModel> circleNav;//圈子
  final String vipNameCircleStrImg;
  final List<BitNavModel>? albumNav; //色图分类
  final List<BitNavModel>? albumTagSort; //色图标签界面分类
  final List<BitNavModel>? albumSortNav; //色图排序
  final List<FaceNavigatorModel> seedTopNav;
  final List<RankNavigatorModel>? rankTopNav;
  final List<RankNavigatorModel>? rankCycleNav;
  final List<BitNavModel> liveTopNav;
  final List<FaceNavigatorModel>? faceTopNav;
  final List<FaceSortModel>? faceSortNav;
  final List<FaceNavigatorModel>? videoFaceTopNav;
  final List<VideoFaceSortModel>? videoFaceSortNav;

  final List<NavigatorModel>? originalSortNav;
  final List<NavigatorModel>? originalBloggerNav;
  final List<OriginalCommunityNavModel> originalTopNav;
  final List<TipModel>? forumTips;
  final List<BitNavModel> communityNav;

  final List<BannerModel>? postDetailAds;
  final List<BannerModel>? buoy;
  final int payAi;
  final int? showApp;

  final String potatoGroup;
  final String tgGroup;

  final String seedVipTip;
  final String seedCoinsTip;
  final String wdaiStr;
  final List<String> vipLevelAwqStr;
  final String vipNameAwqStr;
  final int faceCoins;
  final int stripCoins;
  final int? openLive;
  final int? joinChatGroupCoins; //加入soul群聊所需金币数

  final String? pwaDownloadUrl;

  //R2分片上传
  final String? r2URL;
  final String? r2Key;
  final String? r2CompleteURL;

  //paw_apk下载
  final String? pwa_apk;

  //seo
  final String? keywords;
  final String? description;
  final String? title;

  final int? adVersion;

  List<NavPrependModel>? nav_prepend;
  int? nav_default;

  final int payAiMagic;
  final int payAiDraw;

  final AiNavModel aiNav;
  final int payAiAudio;
  final int payAiNovel;
  final int payAiKiss;
  final int aiAudioFontCt; //音频生成字数限制

  factory Config.fromJson(Map<String, dynamic> json) => Config(
        nav_default: json['nav_default'],
        nav_prepend: List<NavPrependModel>.from(
            json['nav_prepend']?.map((x) => NavPrependModel.fromJson(x)) ?? []),
        dayPrice: json['day_price'],
        personAds: json['person_ads'],
        imgUploadUrl: json['img_upload_url'],
        solution: json['solution'] ?? '',
        mp4UploadUrl: json['mp4_upload_url'],
        mobileMp4UploadUrl: json['mobile_mp4_upload_url'],
        uploadImgKey: json['upload_img_key'] ?? '',
        uploadMp4Key: json['upload_mp4_key'],
        uuid: json['uuid'],
        github: json['github'],
        officeSite: json['office_site'],
        officialGroup: json['official_group'],
        imgBase: json['img_base'],
        line: json['line']?.map((x) => x).toList(),
        m3u8Encrypt: json['m3u8_encrypt'],
        videoEncryptApi: json['video_encrypt_api'],
        videoEncryptReferer: json['video_encrypt_referer'],
        videoEncryptM3u8: json['video_encrypt_m3u8'],
        vipLevelStr:
            List<String>.from(json['vip_level_str']?.map((x) => x) ?? []),
        vipNameStr: json['vip_name_str'] ?? '',
        navId: json['nav_id'],
        lqNavid: json['lq_navid'],
        dmNavid: json['dm_navid'],
        mhNavid: json['mh_navid'],
        awNavid: json['aw_id'] ?? 0,
        shortSite: json['short_site'],
        githubUrl: json['github_url'],
        linesUrl: List<String>.from(json['lines_url']?.map((x) => x) ?? []),
        tipsShareText: json['tips_share_text'],
        girlCommentOption: json['girl_comment_option'] ??
            json['girl_comment_option'].toString(),
        proxyJoinNum: json['proxy_join_num']?.toString(),
        coverIds: List<String>.from(json['cover_ids']?.map((x) => x) ?? []),
        coverVipStr: json['cover_vip_str']?.map((x) => x).toList(),
        coverTips: json['cover_tips'],
        voiceNav: List<FaceNavigatorModel>.from(
            json['voice_nav']?.map((x) => FaceNavigatorModel.fromJson(x)) ??
                []),
        voiceSortNav: List<NavigatorModel>.from(
            json['voice_sort_nav']?.map((x) => NavigatorModel.fromJson(x)) ??
                []),
        sortNav: List<NavigatorModel>.from(
            json['sort_nav']?.map((x) => NavigatorModel.fromJson(x)) ?? []),
        forumNav: List<NavigatorModel>.from(
            json['forum_nav']?.map((x) => NavigatorModel.fromJson(x)) ?? []),
        seedSortNav: List<NavigatorModel>.from(
            json['seed_sort_nav']?.map((x) => NavigatorModel.fromJson(x)) ??
                []),
        vlogNav: List<VlogNavigatorModel>.from(
            json['vlog_nav']?.map((x) => VlogNavigatorModel.fromJson(x)) ?? []),
        vlogTagSortNav: List<NavigatorModel>.from(
            json['vlog_tag_sort_nav']?.map((x) => NavigatorModel.fromJson(x)) ??
                []),
        vlogSortNav: List<NavigatorModel>.from(
            json['vlog_sort_nav']?.map((x) => NavigatorModel.fromJson(x)) ??
                []),
        vlogDiscoverSortNav: List<NavigatorModel>.from(
            json['vlog_discover_sort_nav']
                    ?.map((x) => NavigatorModel.fromJson(x)) ??
                []),
        cartoonTopNav: List<BitNavModel>.from(
            json['cartoon_top_nav']?.map((x) => BitNavModel.fromJson(x)) ?? []),
        cartoonSortNav: List<BitNavModel>.from(
            json['cartoon_sort_nav']?.map((x) => BitNavModel.fromJson(x)) ??
                []),
        comicTopNav: List<BitNavModel>.from(
            json['comic_top_nav']?.map((x) => BitNavModel.fromJson(x)) ?? []),
        comicSortNav: List<BitNavModel>.from(
            json['comic_sort_nav']?.map((x) => BitNavModel.fromJson(x)) ?? []),
        gameTopNav: List<BitNavModel>.from(
            json['game_top_nav']?.map((x) => BitNavModel.fromJson(x)) ?? []),
        gameSortNav: List<BitNavModel>.from(
            json['game_sort_nav']?.map((x) => BitNavModel.fromJson(x)) ?? []),
        gameTagSortNav: List<BitNavModel>.from(
            json['game_tag_sort_nav']?.map((x) => BitNavModel.fromJson(x)) ??
                []),
        liveTopNav: List<BitNavModel>.from(
            json['live_top_nav']?.map((x) => BitNavModel.fromJson(x)) ?? []),
        communityNav: List<BitNavModel>.from(
            json['community_nav']?.map((x) => BitNavModel.fromJson(x)) ?? []),
        faceTopNav: List<FaceNavigatorModel>.from(
            json['face_top_nav']?.map((x) => FaceNavigatorModel.fromJson(x)) ??
                []),
        seedTopNav: List<FaceNavigatorModel>.from(
            json['seed_top_nav']?.map((x) => FaceNavigatorModel.fromJson(x)) ??
                []),
        faceSortNav: List<FaceSortModel>.from(
            json['face_sort_nav']?.map((x) => FaceSortModel.fromJson(x)) ?? []),
        postDetailAds: List<BannerModel>.from(
            json['post_detail_ads']?.map((x) => BannerModel.fromJson(x)) ?? []),
        buoy: List<BannerModel>.from(
            json['buoy']?.map((x) => BannerModel.fromJson(x)) ?? []),
        forumTips: List<TipModel>.from(
            json['forum_tips']?.map((x) => TipModel.fromJson(x)) ?? []),
        rankTopNav: List<RankNavigatorModel>.from(
            json['rank_top_nav']?.map((x) => RankNavigatorModel.fromJson(x))),
        rankCycleNav: List<RankNavigatorModel>.from(
            json['rank_cycle_nav']?.map((x) => RankNavigatorModel.fromJson(x))),
        payAi: json['pay_ai'] ?? 0,
        showApp: json['show_app'],
        potatoGroup: json['potato_group'] ?? '',
        tgGroup: json['tg_group'] ?? '',
        seedVipTip: json['seed_vip_tip'] ?? '',
        seedCoinsTip: json['seed_coins_tip'] ?? '',
        wdaiStr: json['wdai_str'] ?? '',
        vipLevelAwqStr:
            List<String>.from(json['vip_level_awq_str']?.map((x) => x) ?? []),
        vipNameAwqStr: json['vip_name_awq_str'] ?? '',
        originalSortNav: List<NavigatorModel>.from(
            json['original_sort_nav']?.map((x) => NavigatorModel.fromJson(x)) ??
                []),
        originalBloggerNav: List<NavigatorModel>.from(
            json['original_blogger_nav']
                    ?.map((x) => NavigatorModel.fromJson(x)) ??
                []),
        originalTopNav: List<OriginalCommunityNavModel>.from(
            json['original_top_nav']
                    ?.map((x) => OriginalCommunityNavModel.fromJson(x)) ??
                []),
        faceCoins: json['face_coins'],
        stripCoins: json['strip_coins'],
        openLive: json['open_live'],
        imCoins: json['im_coins'],
        imTip: json['im_tip'],
        bindEmailTip: json['bind_email_tip'],
        joinChatGroupCoins: json['join_chat_group_coins'] ?? 0,
        pwaDownloadUrl: json['pwa_download_url'] ?? '',
        r2URL: json['r2URL'] ?? '',
        r2Key: json['r2Key'] ?? '',
        r2CompleteURL: json['r2CompleteURL'] ?? '',
        pwa_apk: json['pwa_apk'] ?? '',
        keywords: json['keywords'] ?? '',
        description: json['description'] ?? '',
        title: json['title'] ?? '',
        adVersion: json['ad_version'] ?? 0,
        payAiMagic: json['pay_ai_magic'] ?? 0,
        payAiDraw: json['pay_ai_draw'] ?? 0,
        aiNav: AiNavModel.fromJson(json['ai_nav'] ?? {}),
        payAiAudio: json['pay_ai_audio'] ?? 0,
        payAiNovel: json['pay_ai_novel'] ?? 0,
        payAiKiss: json['pay_ai_kiss'] ?? 0,
        aiAudioFontCt: json['ai_audio_font_ct'] ?? 0,
        videoFaceTopNav: List<FaceNavigatorModel>.from(
            json['video_face_top_nav']
                    ?.map((x) => FaceNavigatorModel.fromJson(x)) ??
                []),
        videoFaceSortNav: List<VideoFaceSortModel>.from(
            json['video_face_sort_nav']
                    ?.map((x) => VideoFaceSortModel.fromJson(x)) ??
                []),
        acgNav: List<BitNavModel>.from(
            json['acg_nav']?.map((x) => BitNavModel.fromJson(x)) ?? []),
       comicTypeNav: List<ComicTypeNav>.from(
            json['comic_type_nav']?.map((x) => ComicTypeNav.fromJson(x)) ?? []),
        novelNav: List<BitNavModel>.from(
            json['novel_nav']?.map((x) => BitNavModel.fromJson(x)) ?? []),
        novelSort: List<BitNavModel>.from(
            json['novel_sort']?.map((x) => BitNavModel.fromJson(x)) ?? []),
        novelTypeNav: List<ComicTypeNav>.from(
            json['novel_type_nav']?.map((x) => ComicTypeNav.fromJson(x)) ?? []),
        chatNav: List<ChatNavModel>.from(
            json['chat_nav']?.map((x) => ChatNavModel.fromJson(x)) ?? []),
        chatSelectNav: List<ChatSelectNavModel>.from(
            json['chat_select_nav']?.map((x) => ChatSelectNavModel.fromJson(x)) ?? []),
        circleNav: List<NavigatorModel>.from(
            json['circle_nav']?.map((x) => NavigatorModel.fromJson(x)) ?? []),
        vipNameCircleStrImg: json['vip_name_circle_str_img'] ?? '',
        albumNav: List<BitNavModel>.from(
            json['album_nav']?.map((x) => BitNavModel.fromJson(x)) ?? []),
        albumTagSort: List<BitNavModel>.from(
            json['album_tag_sort_nav']?.map((x) => BitNavModel.fromJson(x)) ?? []),
        albumSortNav: List<BitNavModel>.from(
            json['album_sort_nav']?.map((x) => BitNavModel.fromJson(x)) ?? []),
      );

  Map<String, dynamic> toJson() => {
        'nav_default': nav_default,
        'nav_prepend': nav_prepend?.map((e) => e).toList() ?? [],
        'day_price': dayPrice,
        'person_ads': personAds,
        'img_upload_url': imgUploadUrl,
        'solution': solution ?? '',
        'mp4_upload_url': mp4UploadUrl,
        'mobile_mp4_upload_url': mobileMp4UploadUrl,
        'upload_img_key': uploadImgKey,
        'upload_mp4_key': uploadMp4Key,
        'uuid': uuid,
        'github': github,
        'office_site': officeSite,
        'official_group': officialGroup,
        'img_base': imgBase,
        'line': line?.map((e) => e).toList(),
        'm3u8_encrypt': m3u8Encrypt,
        'video_encrypt_api': videoEncryptApi,
        'video_encrypt_referer': videoEncryptReferer,
        'video_encrypt_m3u8': videoEncryptM3u8,
        'vip_level_str': vipLevelStr.map((e) => e).toList(),
        'vip_name_str': vipNameStr,
        'nav_id': navId,
        'lq_navid': lqNavid,
        'dm_navid': dmNavid,
        'mh_navid': mhNavid,
        'aw_navid': awNavid,
        'short_site': shortSite,
        'github_url': githubUrl,
        'tips_share_text': tipsShareText,
        'lines_url': linesUrl?.map((e) => e).toList(),
        'girl_comment_option': girlCommentOption,
        'proxy_join_num': proxyJoinNum,
        'cover_ids': coverIds?.map((e) => e).toList(),
        'cover_vip_str': coverVipStr?.map((e) => e).toList(),
        'cover_tips': coverTips,
        'voice_sort_nav': voiceSortNav?.map((x) => x).toList() ?? [],
        'sort_nav': sortNav?.map((x) => x).toList() ?? [],
        'forum_nav': forumNav?.map((e) => e).toList() ?? [],
        'seed_top_nav': seedTopNav.map((e) => e).toList(),
        'seed_sort_nav': seedSortNav?.map((e) => e).toList() ?? [],
        'vlog_nav': vlogNav?.map((e) => e).toList() ?? [],
        'vlog_tag_sort_nav': vlogTagSortNav?.map((e) => e).toList() ?? [],
        'vlog_sort_nav': vlogSortNav?.map((e) => e).toList() ?? [],
        'vlog_discover_sort_nav':
            vlogDiscoverSortNav?.map((e) => e).toList() ?? [],
        'cartoon_top_nav': cartoonTopNav?.map((e) => e).toList() ?? [],
        'cartoon_sort_nav': cartoonSortNav?.map((e) => e).toList() ?? [],
        'comic_top_nav': comicTopNav?.map((e) => e).toList() ?? [],
        'comic_sort_nav': comicSortNav?.map((e) => e).toList() ?? [],
        'game_top_nav': gameTopNav?.map((e) => e).toList() ?? [],
        'game_sort_nav': gameSortNav?.map((e) => e).toList() ?? [],
        'game_tag_sort_nav': gameTagSortNav?.map((e) => e).toList() ?? [],
        'comic_type_nav': comicTypeNav?.map((e) => e).toList() ?? [],
        'live_top_nav': liveTopNav.map((e) => e).toList(),
        'community_nav': communityNav.map((e) => e).toList(),
        'face_top_nav': faceTopNav?.map((e) => e).toList() ?? [],
        'face_sort_nav': faceSortNav?.map((e) => e).toList() ?? [],
        'original_sort_nav': originalSortNav?.map((e) => e).toList() ?? [],
        'original_blogger_nav':
            originalBloggerNav?.map((e) => e).toList() ?? [],
        'post_detail_ads': postDetailAds?.map((e) => e).toList() ?? [],
        'buoy': buoy?.map((e) => e).toList() ?? [],
        'forum_tips': forumTips?.map((e) => e).toList() ?? [],
        'original_top_nav': originalTopNav.map((e) => e).toList(),
        'rank_top_nav': rankTopNav?.map((e) => e).toList(),
        'rank_cycle_nav': rankCycleNav?.map((e) => e).toList(),
        'pay_ai': payAi,
        'show_app': showApp,
        'potato_group': potatoGroup,
        'tg_group': tgGroup,
        'seed_vip_tip': seedVipTip,
        'seed_coins_tip': seedCoinsTip,
        'face_coins': faceCoins,
        'strip_coins': stripCoins,
        'open_live': openLive,
        'im_coins': imCoins,
        'im_tip': imTip,
        'bind_email_tip': bindEmailTip,
        'join_chat_group_coins': joinChatGroupCoins,
        'pwa_download_url': pwaDownloadUrl,
        'r2URL': r2URL,
        'r2Key': r2Key,
        'r2CompleteURL': r2CompleteURL,
        'pwa_apk': pwa_apk,
        'keywords': keywords,
        'description': description,
        'title': title,
        'ad_version': adVersion,
        'pay_ai_magic': payAiMagic,
        'pay_ai_draw': payAiDraw,
        'ai_audio_font_ct': aiAudioFontCt,
        'video_face_top_nav': videoFaceTopNav?.map((e) => e).toList() ?? [],
        'video_face_sort_nav': videoFaceSortNav?.map((e) => e).toList() ?? [],
        'acg_nav': acgNav?.map((e) => e).toList() ?? [],
        'novel_nav': novelNav?.map((e) => e).toList() ?? [],
        'novel_sort': novelSort?.map((e) => e).toList() ?? [],
        'novel_type_nav': novelTypeNav?.map((e) => e).toList() ?? [],
        'chat_nav': chatNav.map((e) => e).toList(),
        'chat_select_nav': chatSelectNav.map((e) => e).toList(),
        'circle_nav': circleNav.map((e) => e).toList(),
        'vip_name_circle_str_img': vipNameCircleStrImg,
        'album_nav': albumNav?.map((e) => e).toList() ?? [],
        'album_tag_sort_nav': albumTagSort?.map((e) => e).toList() ?? [],
        'album_sort_nav': albumSortNav?.map((e) => e).toList() ?? [],
      };
}

class Notice {
  Notice({
    this.id,
    this.imgUrl,
    this.router,
    this.type,
    this.height,
    this.width,
    this.urlStr,
    this.reportId,
    this.reportType,
    this.linkUrl,
    this.title,
    this.redirect_type,
  });

  final int? id;
  final String? imgUrl;
  final String? router;
  final String? type;
  final int? height;
  final int? width;
  final String? urlStr;
  final int? reportId;
  final int? reportType;

  final String? linkUrl;
  final String? title;
  final int? redirect_type;

  factory Notice.fromJson(Map<String, dynamic> json) => Notice(
        id: json['id'] ?? 0,
        imgUrl: json['img_url'] ?? '',
        router: json['router'] ?? '',
        type: '${json['type']}' ?? '',
        height: json['height'] ?? 100,
        width: json['width'] ?? 100,
        urlStr: json['url_str'] ?? '',
        reportId: json['report_id'] ?? 0,
        reportType: json['report_type'] ?? 0,
        linkUrl: json['link_url'] ?? '',
        title: json['title'] ?? '',
        redirect_type: json['redirect_type'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'img_url': imgUrl,
        'router': router,
        'type': type,
        'height': height,
        'width': width,
        'url_str': urlStr,
        'report_id': reportId,
        'report_type': reportType,
        'link_url': linkUrl,
        'title': title,
        'redirect_type': redirect_type,
      };
}

class VersionMsg {
  VersionMsg({
    this.version,
    this.type,
    this.apk,
    this.tips,
    this.must,
    this.status,
    this.message,
    this.mstatus,
    this.channel,
  });

  /// 版本号
  final String? version;
  final String? type;

  /// 更新app用下载网址
  final String? apk;

  /// 更新描述
  final String? tips;

  /// 更新开关 0 不更新  1 强制更新 2 非强制更新
  final int? must;
  final int? status;

  /// 公告描述
  final String? message;

  /// 系统公告状态 0 没有 1通知 2禁用
  final int? mstatus;
  final String? channel;

  factory VersionMsg.fromJson(Map<String, dynamic> json) => VersionMsg(
        version: json['version'],
        type: json['type'],
        apk: json['apk'],
        tips: json['tips'],
        must: json['must'],
        status: json['status'],
        message: json['message'],
        mstatus: json['mstatus'],
        channel: json['channel'],
      );

  Map<String, dynamic> toJson() => {
        'version': version,
        'type': type,
        'apk': apk,
        'tips': tips,
        'must': must,
        'status': status,
        'message': message,
        'mstatus': mstatus,
        'channel': channel,
      };
}

class Help {
  Help({
    required this.items,
    required this.type,
    required this.name,
  });

  final List<HelpItem> items;
  final int type;
  final String name;

  factory Help.fromJson(Map<String, dynamic> json) => Help(
        items: List.from(json['items'].map((x) => HelpItem.fromJson(x))),
        type: json['type'],
        name: json['name'],
      );
}

class HelpItem {
  HelpItem(
      {required this.id,
      required this.question,
      required this.answer,
      required this.status,
      required this.type,
      required this.views,
      required this.createdAt,
      required this.updatedAt});

  final int id;
  final String question;
  final String answer;
  final int status;
  final int type;
  final int? views;
  final String createdAt;
  final String updatedAt;

  factory HelpItem.fromJson(Map<String, dynamic> json) => HelpItem(
      id: json['id'],
      question: json['question'],
      answer: json['answer'],
      status: json['status'],
      type: json['type'],
      views: json['views'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at']);
}

class NavPrependModel {
  NavPrependModel({
    this.label,
    this.type,
    this.sort,
    this.value,
  });

  final String? label;
  final int? type;
  final int? sort;
  final String? value;

  factory NavPrependModel.fromJson(Map<String, dynamic> json) =>
      NavPrependModel(
        label: json['label'],
        type: json['type'],
        sort: json['sort'],
        value: json['value'],
      );

  Map<String, dynamic> toJson() => {
        'label': label,
        'type': type,
        'sort': sort,
        'value': value,
      };
}


//漫画排序条件
class ComicTypeNav {
  ComicTypeNav({
    required this.items,
    required this.value,
    required this.title,
  });

  final List<BitNavModel> items;
  final String value;
  final String title;

  factory ComicTypeNav.fromJson(Map<String, dynamic> json) => ComicTypeNav(
        items: List.from(json['items'].map((x) => BitNavModel.fromJson(x))),
        value: json['value'],
        title: json['title'],
      );
}
