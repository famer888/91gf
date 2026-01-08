// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:jygf/domain/async_value.dart';
// import 'package:jygf/domain/remote_domain/domains/black_domain.dart';
// import 'package:jygf/ui_layer/screens/black/model/black_model.dart';
// import 'package:jygf/ui_layer/screens/common_widgets/my_image.dart';
// import 'package:jygf/ui_layer/screens/common_widgets/my_tab_bar.dart';
// import 'package:jygf/ui_layer/screens/common_widgets/screen_background.dart';
// import 'package:jygf/ui_layer/screens/common_widgets/status/loading.dart';
// import 'package:jygf/ui_layer/screens/common_widgets/status/network_error.dart';
// import 'package:jygf/ui_layer/screens/theme.dart';
// import 'package:jygf/ui_layer/utils/common_utils.dart';
// import 'package:provider/provider.dart';
//
// class BlackScreen extends StatefulWidget {
//   const BlackScreen({super.key});
//
//   @override
//   State<BlackScreen> createState() => _BlackIndexPageState();
// }
//
// class _BlackIndexPageState extends State<BlackScreen> with TickerProviderStateMixin {
//   late final _blockDomain = context.read<BlackDomain>();
//   AsyncValue<List<BlackModel>> _asyncValue = const AsyncInit();
//   late final TabController _tabController;
//   int initSelected = 0;
//   int _initialIndex = 0;
//
//   Future<void> _init() async {
//     if (_asyncValue.isLoading) return;
//
//     setState(() {
//       _asyncValue = const AsyncLoading();
//     });
//
//     final result = await _blockDomain.getCategoryList();
//     CommonUtils.log('获取黑料分类列表的结果 result:$result');
//     if (result.data case final data?) {
//       final blockModelList = data.list;
//       _initialIndex = blockModelList.indexWhere((model) => model.current);
//       _asyncValue = AsyncData(blockModelList);
//       _tabController = TabController(length: blockModelList.length, vsync: this, initialIndex: _initialIndex);
//     } else {
//       _asyncValue = const AsyncError();
//     }
//
//     if (mounted) {
//       setState(() {});
//     }
//   }
//
//   @override
//   void initState() {
//     _init();
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ScreenBackground(
//       child: _asyncValue.maybeWhen(
//         data: (data) => Container(
//           padding: EdgeInsets.only(top: 35.w),
//           child: TabBarWithView.line(
//             tabController: _tabController,
//             initialIndex: _initialIndex,
//             labelStyle: const TextStyle(color: MyTheme.blueColor64, fontSize: 18, fontWeight: FontWeight.w600),
//             unselectedLabelStyle: const TextStyle(color: MyTheme.whiteColor, fontSize: 17, fontWeight: FontWeight.w500),
//             titles: data.map((e) => e.name).toList(),
//             views: data.map((e) {
//               return BlackTagScreen(blockModel: e);
//             }).toList(),
//           ),
//         ),
//         error: (_, __) => NetworkErrorView(onTap: _init),
//         orElse: () => const LoadingView(),
//       ),
//     );
//   }
// }
