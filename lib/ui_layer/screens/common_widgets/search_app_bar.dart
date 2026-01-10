import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../router/routes.dart';
import '../theme.dart';

import '../image_paths.dart';

class SearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SearchAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding, vertical: 5.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => const SearchRoute().push(context),
                child: Container(
                  height: 35.w,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17.5.w)),
                    color: Colors.white.withOpacity(0.1),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(width: 12.w),
                      Image.asset(MyImagePaths.appSearchIcon, width: 12.w, height: 12.w),
                      SizedBox(width: 2.w),
                      Container(
                        width: 1.w,
                        height: 16.w,
                        color: const Color.fromRGBO(255, 255, 255, 0.04),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text('stzdmmhbt'.tr(context: context), style: MyTheme.gray172_14),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: 10.w),
            GestureDetector(
              onTap: () {
                // const MineWelfareRoute(index: 1).push(context);

                const RankRoute().push(context);
              },
              child: SizedBox(
                height: 35.w,
                width: 35.w,
                child: OverflowBox(
                  maxHeight: 40.w,
                  maxWidth: 40.w,
                  child: Image.asset(
                    MyImagePaths.appRankList,
                    // MyImagePaths.appSearchLogo,
                    // height: 65.w,
                    // fit: BoxFit.fitHeight,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  final Size preferredSize = const Size.fromHeight(60);
}
