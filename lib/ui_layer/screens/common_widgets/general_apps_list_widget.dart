import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../domain/model/home_data_model.dart';
import '../../notifiers/home_config_notifier.dart';
import '../../utils/common_utils.dart';
import 'my_image.dart';

class GeneralAppsListVidget extends StatefulWidget {
  const GeneralAppsListVidget({super.key, this.apps});

  final List<Notice>? apps;

  @override
  State<GeneralAppsListVidget> createState() => _GeneralAppsListVidgetState();
}

class _GeneralAppsListVidgetState extends State<GeneralAppsListVidget> {
  late final homeConfigNotifier = context.read<HomeConfigNotifier>();
  List<Notice> apps = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.apps != null) {
      apps = widget.apps ?? [];
    } else {
      // apps = homeConfigNotifier.homeData.adsDetailBlock ?? [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return apps.isEmpty
        ? Container()
        : GridView.builder(
            shrinkWrap: true,
            addRepaintBoundaries: false,
            addAutomaticKeepAlives: false,
            physics: const BouncingScrollPhysics(),
            itemCount: apps.length,
            padding: EdgeInsets.symmetric(vertical: 5.w),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6,
              mainAxisSpacing: 10.w,
              crossAxisSpacing: 20.w,
              childAspectRatio: 57 / 86,
            ),
            itemBuilder: (context, index) {
              Notice? model = apps[index];
              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  final json = model.toJson() ?? {};
                  CommonUtils.openRoute(context, json);
                },
                child: Column(
                  children: [
                    AspectRatio(
                      aspectRatio: 1,
                      child: MyImage.network(
                        model.imgUrl ?? '',
                        fit: BoxFit.fill,
                        borderRadius: 6.w,
                      ),
                    ),
                    SizedBox(height: 5.w),
                    Text(
                      model.title ?? '',
                      style: TextStyle(
                          color: Colors.white,
                          overflow: TextOverflow.ellipsis,
                          decoration: TextDecoration.none,
                          height: 1,
                          // fontWeight: FontWeight.w600,
                          fontSize: 10.sp),
                      maxLines: 1,
                    ),
                  ],
                ),
              );
            });
  }
}
