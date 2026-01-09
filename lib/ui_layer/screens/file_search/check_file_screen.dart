import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/domain/async_value.dart';
import 'package:jygf/domain/model/banner_model.dart';
import 'package:jygf/domain/model/live_model.dart';
import 'package:jygf/domain/remote_domain/domains/community.dart';
import 'package:jygf/ui_layer/screens/black/model/black_model.dart';
import 'package:jygf/ui_layer/utils/common_utils.dart';
import 'package:provider/provider.dart';

class CheckFileScreen extends StatefulWidget {
  const CheckFileScreen({super.key});

  @override
  State<CheckFileScreen> createState() => _CheckFileScreenState();
}

class _CheckFileScreenState extends State<CheckFileScreen> {
  late final _domain = context.read<CommunityDomain>();
  late final _screenUtils = ScreenUtil();
  AsyncValue<List<BlackModel>> _asyncValue = const AsyncInit();
  final ValueNotifier<List<TipModel>> _blackListNoticeNotifier = ValueNotifier([]);
  final ValueNotifier<List<BannerModel>> _bannersNotifier = ValueNotifier([]);

  late final TabController? tabController;
  int _initialIndex = 0;
  bool isInit = false;

  Future<void> _init() async {
    final res = await _domain.getCheckFileList();
    CommonUtils.log('结果 res:$res');
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
