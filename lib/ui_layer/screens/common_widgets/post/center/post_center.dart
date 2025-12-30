import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../domain/domain.dart';
import '../../../../../domain/model/tiezt_model.dart';
import '../../../../utils/my_toast.dart';
import '../../my_list_view.dart';
import '../../screen_background.dart';
import 'card/card.dart';

class PostCenter extends StatefulWidget {
  const PostCenter({super.key, this.aff, this.header,required this.type});
  final String? aff;
  final Widget? header;
  final int type; // 0-待审核 1-已通过 2-已拒绝
  @override
  State<PostCenter> createState() => _PostCenterState();
}

class _PostCenterState extends State<PostCenter> {
  /// 个人帖子/他人帖子
  bool get isSelf => widget.aff == null;

  late final communityDomain = context.read<CommunityDomain>();

  Future<List<TieztModel>> getData(
      {required int currentPage, required int limit}) async {
    final res = await (isSelf
        ? communityDomain.myPosts(page: currentPage, limit: limit, status: widget.type)
        : communityDomain.peerCenterPost(
            page: currentPage, aff: widget.aff ?? '', limit: limit));

    if (res.msg case final msg? when msg.isNotEmpty) {
      MyToast.showText(text: msg);
    }

    return res.data!;
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      needBgImg: false,
      child: Scaffold(
        body: MyListView.list(
          padding: EdgeInsets.zero,
          header: widget.header,
          itemBuilder: (context, item, index) => PostCenterCard(data: item),
          onFetchingMore: (currentPage, pageSize) =>
              getData(currentPage: currentPage, limit: pageSize),
        ),
      ),
    );
  }
}
