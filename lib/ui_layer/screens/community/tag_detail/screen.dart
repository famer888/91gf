import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../domain/api_validator.dart';
import '../../../../domain/async_value.dart';
import '../../../../domain/domain.dart';
import '../../../../domain/model/navigator_model.dart';
import '../../../../domain/model/post_model.dart';
import '../../../../domain/model/topic_model.dart';
import '../../../../domain/type_def.dart';
import '../../../notifiers/home_config_notifier.dart';
import '../../../utils/common_utils.dart';
import '../../../utils/my_toast.dart';
import '../../common_widgets/follow_button.dart';
import '../../common_widgets/my_app_bar.dart';
import '../../common_widgets/my_image.dart';
import '../../common_widgets/my_list_view.dart';
import '../../common_widgets/my_tab_bar.dart';
import '../../common_widgets/post/card/card.dart';
import '../../common_widgets/screen_background.dart';
import '../../common_widgets/status/loading.dart';
import '../../common_widgets/status/network_error.dart';
import '../../theme.dart';

class CommunityTagDetailScreen extends StatefulWidget {
  const CommunityTagDetailScreen({super.key, required this.id});
  final String id;
  @override
  State<CommunityTagDetailScreen> createState() =>
      _CommunityTagDetailScreenState();
}

class _CommunityTagDetailScreenState extends State<CommunityTagDetailScreen> {
  late final _homeConfig = context.read<HomeConfigNotifier>();
  late final _communityDomain = context.read<CommunityDomain>();

  late final List<NavigatorModel> _titles = _homeConfig.config.forumNav ?? [];

  AsyncValue<TopicModel> _asyncValue = const AsyncInit();

  @override
  void initState() {
    _init();
    super.initState();
  }

  Future _init() async {
    if (_asyncValue.isLoading) return;
    setState(() {
      _asyncValue = const AsyncLoading();
    });

    final res =
        await _communityDomain.communityTopicsDetail(topicId: widget.id);
    if (res.data case final data?) {
      _asyncValue = AsyncData(data);
    } else {
      if (res.msg case final msg? when msg.isNotEmpty) {
        MyToast.showText(text: msg);
      }
      _asyncValue = const AsyncError();
    }

    if (mounted) {
      setState(() {});
    }
  }

  Future<List<PostModel>> _getData({
    required String cate,
    required int page,
    required int pageSize,
  }) async {
    final res = await _communityDomain.communityListTopicPost(
      topicId: widget.id,
      cate: cate,
      page: page,
      limit: pageSize,
    );

    if (res.msg case final msg? when msg.isNotEmpty) {
      MyToast.showText(text: msg);
    }
    return res.data!;
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      child: _asyncValue.maybeWhen(
        orElse: () => const Scaffold(
          appBar: MyAppBar(),
          body: LoadingView(),
        ),
        error: (_, __) => Scaffold(
          appBar: const MyAppBar(),
          body: NetworkErrorView(onTap: _init),
        ),
        data: (data) => Scaffold(
          appBar: MyAppBar(
            title: data.name,
          ),
          body: NestedScrollView(
            headerSliverBuilder: (_, __) => [
              SliverToBoxAdapter(
                child: _Header(data: data),
              ),
            ],
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
              child: TabBarWithView.fillColor(
                tabBarPadding: EdgeInsets.symmetric(vertical: 6.w),
                tabBarHeight: 32.w,
                titles: [for (final title in _titles) title.title],
                views: [
                  for (final NavigatorModel nav in _titles)
                    MyListView.list(
                      contentPadding: 15.w,
                      padding:
                      EdgeInsets.only(top: 5.w, bottom: MyTheme.pagePadding),
                      itemBuilder: (context, item, index) => PostCard.community(
                        data: item,
                      ),
                      onFetchingMore: (currentPage, pageSize) => _getData(
                        page: currentPage,
                        pageSize: pageSize,
                        cate: nav.type,
                      ),
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.data});
  final TopicModel data;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
      child: Column(
        children: [
          SizedBox(height: 15.w),
          Row(
            children: [
              SizedBox(
                width: 90.w,
                height: 90.w,
                child: MyImage.network(
                  data.thumb,
                  borderRadius: 5.w,
                  fit: BoxFit.cover,
                  backgroundColor: MyTheme.imageBgColor,
                ),
              ),
              SizedBox(width: 6.5.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.intro,
                      style: MyTheme.gray234_14,
                      maxLines: 3,
                    ),
                    SizedBox(height: 10.w),
                    Text(
                      '${CommonUtils.renderFixedNumber(data.postNum)}${'tiez'.tr(context: context)}    ${CommonUtils.renderFixedNumber(data.viewNum)}${'llan'.tr(context: context)}',
                      style: MyTheme.gray208_13,
                    )
                  ],
                ),
              ),
              SizedBox(width: 6.5.w),
              StatefulBuilder(builder: (_, setState) {
                final isFollowed = data.isFollow == 1;
                bool isLoading = false;

                return FollowButton(
                  isFollowed: isFollowed,
                  onTap: () async {
                    if (isLoading) return;
                    isLoading = true;

                    final communityDomain = context.read<CommunityDomain>();
                    final res = await communityDomain.communityFollowTopic(
                        topicId: '${data.id}');
                    if (res.isValid) {
                      setState(() {
                        data.isFollow = isFollowed ? 0 : 1;
                      });
                    } else if (res.msg case final msg? when msg.isNotEmpty) {
                      MyToast.showText(text: msg);
                    }

                    isLoading = false;
                  },
                );
              }),
            ],
          ),
          SizedBox(height: 10.w),
        ],
      ),
    );
  }
}
