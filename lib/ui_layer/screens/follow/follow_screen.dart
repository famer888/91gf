import 'package:flutter/material.dart';
import 'package:jygf/domain/remote_domain/domains/community.dart';
import 'package:jygf/ui_layer/utils/common_utils.dart';
import 'package:provider/provider.dart';

class FollowScreen extends StatefulWidget {
  const FollowScreen({super.key});

  @override
  State<FollowScreen> createState() => _FollowScreenState();
}

class _FollowScreenState extends State<FollowScreen> {
  late final _appDomain = context.read<CommunityDomain>();

  Future<void> _initData() async {
    final noticeRes = _appDomain.getNoticeList();
    final followTopicResult = _appDomain.getFollowTopicList();
    final followUserResult = _appDomain.getFollowUserList();
    CommonUtils.log('请求的结果:$noticeRes - $followUserResult - $followTopicResult');
  }

  @override
  void initState() {
    _initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('关注的也买呢'),);
  }
}
