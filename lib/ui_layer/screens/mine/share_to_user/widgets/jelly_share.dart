import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../../domain/model/proxy_detail_model.dart';
import '../../../../notifiers/user_notifier.dart';
import '../../../common_widgets/my_image.dart';
import '../../../image_paths.dart';
import '../../../theme.dart';

class JellyShareCard extends StatelessWidget {
  const JellyShareCard({super.key, required this.proxyDetail});

  final ProxyDetail? proxyDetail;

  @override
  Widget build(BuildContext context) {
    late final member = context.read<UserNotifier>().member;
    final height = 426.w;
    final width = 325.w;
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          MyImage.asset(
            MyImagePaths.appMineJellyShareQrBg,
            fit: BoxFit.fill,
            width: width,
            height: height,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              proxyDetail?.directProxyNum == null
                  ? const SizedBox.shrink()
                  : RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '${'ljyq'.tr(context: context)} ',
                            style: MyTheme.white9255_15,
                          ),
                          TextSpan(
                            text:
                                '${proxyDetail?.directProxyNum}${'ren'.tr(context: context)}',
                            style: MyTheme.jellyCyan_15,
                          )
                        ],
                      ),
                    ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 13.w),
                child: ColoredBox(
                  color: Colors.white,
                  child: QrImageView(
                    data: '${member.share?.affUrl}',
                    version: 3,
                    size: 134.w,
                  ),
                ),
              ),
              RichText(
                text: TextSpan(
                  text: 'wdggm'.tr(context: context),
                  style: MyTheme.white9255_15,
                  children: <TextSpan>[
                    TextSpan(
                        text: '${member.share?.affCode}',
                        style: MyTheme.jellyCyan_25_semi)
                  ],
                ),
              ),
              // SizedBox(height: 15.w),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 16.w),
                child: Text('fxtips'.tr(context: context),
                    style: MyTheme.gray12,
                    maxLines: 5,
                    textAlign: TextAlign.center),
              )
            ],
          )
        ],
      ),
    );
  }
}
