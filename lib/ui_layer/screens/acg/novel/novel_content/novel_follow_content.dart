import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:jygf/domain/api_validator.dart';
import 'package:jygf/domain/model/novel_model.dart';
import 'package:jygf/domain/remote_domain/domains/novel.dart';
import 'package:jygf/ui_layer/const.dart';
import 'package:jygf/ui_layer/screens/acg/novel/card/novel_item_card.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_list_view.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/report/ui_layer/report_gesture_detector.dart';

class NovelFollowContent extends StatefulWidget {
  const NovelFollowContent({super.key});

  @override
  State<NovelFollowContent> createState() => _NovelFollowContentState();
}

class _NovelFollowContentState extends State<NovelFollowContent> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: cofigContentView());
  }

  Widget cofigContentView() {

    return const _FollowNovelView();

    // TabBarWithView.fillColor(
    //   tabBarHeight: 32.w,
    //   labelStyle: MyTheme.white15_M,
    //   tabBarPadding: EdgeInsets.only(bottom: 5.w),
    //   unselectedLabelStyle: MyTheme.white07_15,
    //   isCenter: true,
    //   titles: [
    //     'xs'.tr(context: context),
    //     'zht'.tr(context: context)
    //   ],
    //   views: const [
    //     KeepAliveWrapper(
    //       child: _FollowNovelView(),
    //     ),
    //     KeepAliveWrapper(
    //       child: _FollowNovelSubjectView(),
    //     ),
    //   ]);
  }
}

///关注的小说
class _FollowNovelView extends StatefulWidget {
  const _FollowNovelView();

  @override
  State<_FollowNovelView> createState() => _FollowNovelViewState();
}

class _FollowNovelViewState extends State<_FollowNovelView> {
  late final _domain = context.read<NovelDomain>();
  List<NovelItemsModel> array = [];

  Future<List<NovelItemsModel>?> _getData({
    required int page,
    required int pageSize,
  }) async {
    final result =
    await _domain.novelFavoriteList(page: page, limit: pageSize);
    if (result.isValid) {
      List<NovelItemsModel> tp = List.from(result.data ?? []);
      if (page == 1) {
        array = tp;
      } else {
        array.addAll(tp);
      }
      return tp;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MyListView.grid(
      padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
      childAspectRatio: UILayerConst.pictureRatio,
      crossAxisSpacing: 10.w,
      crossAxisCount: 3,
      itemBuilder: (_, item, index) => NovelItemCard(data: item),
      onFetchingMore: (currentPage, pageSize) => _getData(
        page: currentPage,
        pageSize: pageSize,
      ),
    );
  }
}

///关注的小说专题
// class _FollowNovelSubjectView extends StatefulWidget {
//   const _FollowNovelSubjectView();
//
//   @override
//   State<_FollowNovelSubjectView> createState() =>
//       _FollowNovelSubjectViewState();
// }

// class _FollowNovelSubjectViewState extends State<_FollowNovelSubjectView> {
//   late final _domain = context.read<NovelDomain>();
//   List<NovelSubjectListItemModel> array = [];
//
//   Future<List<NovelSubjectListItemModel>?> _getData({
//     required int page,
//     required int pageSize,
//   }) async {
//     final result =
//         await _domain.novelFollowSubjectList(page: page, limit: pageSize);
//     if (result.isValid) {
//       List<NovelSubjectListItemModel>? tp = List.from(result.data?.list ?? []);
//       if (page == 1) {
//         array = tp;
//       } else {
//         array.addAll(tp);
//       }
//       return tp;
//     } else {
//       return null;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MyListView.list(
//       padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
//       contentPadding: 10.w,
//       itemBuilder: (_, item, index) => NovelSubjectListCard(data: item),
//       onFetchingMore: (currentPage, pageSize) => _getData(
//         page: currentPage,
//         pageSize: pageSize,
//       ),
//     );
//   }
// }

// class NovelSubjectListCard extends StatefulWidget {
//   const NovelSubjectListCard({super.key, required this.data});
//
//   final NovelSubjectListItemModel data;
//
//   @override
//   State<NovelSubjectListCard> createState() => _NovelSubjectListCardState();
// }

// class _NovelSubjectListCardState extends State<NovelSubjectListCard> {
//   late final _domain = context.read<NovelDomain>();
//
//   @override
//   Widget build(BuildContext context) {
//     return ReportGestureDetector(
//       behavior: HitTestBehavior.translucent,
//       onTap: () {
//         // final data = RecNovelModel(
//         //     title: widget.data.title ?? '',
//         //     value: widget.data.value);
//         // MoreNovelRoute(data).push(context);
//       },
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.only(
//                     topRight: Radius.circular(5.w),
//                     bottomRight: Radius.circular(5.w)),
//               ),
//               clipBehavior: Clip.antiAlias,
//               width: 160.w,
//               height: 90.w,
//               child:
//                   MyImage.network(widget.data.thumb ?? '', borderRadius: 5.w)),
//           Expanded(
//             child: Container(
//               height: 90.w,
//               padding: EdgeInsets.all(6.w),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(widget.data.name ?? '',
//                       style: MyTheme.white14, maxLines: 1),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text('${widget.data.followNum}关注',
//                           style: MyTheme.white04_11),
//                       ReportGestureDetector(
//                         onTap: () async {
//                           //关注--取消关注小说专题
//                           final result = await _domain.novelFollowSubject(
//                               id: widget.data.id ?? 0);
//                           if (result.status == 1) {
//                             final int isFollow = result.data['is_follow'];
//                             widget.data.isFollow = isFollow;
//                             setState(() {});
//                           } else {
//                             MyToast.showText(text: result.msg ?? '');
//                           }
//                         },
//                         child: Container(
//                             padding: EdgeInsets.symmetric(
//                                 horizontal: 10.w, vertical: 5.w),
//                             decoration: BoxDecoration(
//                               color: widget.data.isFollow == 1
//                                   ? MyTheme.white008Color
//                                   : MyTheme.jellyCyanColor,
//                               borderRadius:
//                                   BorderRadius.all(Radius.circular(5.w)),
//                             ),
//                             child: Text(
//                                 widget.data.isFollow == 1
//                                     ? 'qxgz'.tr(context: context)
//                                     : 'gz'.tr(context: context),
//                                 style: MyTheme.white04_11)),
//                       ),
//                     ],
//                   ),
//                   Text(
//                     '${CommonUtils.renderFixedNumber(widget.data.worksNum ?? 0)}${'zp'.tr(context: context)}',
//                     style: MyTheme.white04_12,
//                     // textAlign: ,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
