import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../../domain/model/proxy_detail_model.dart';
import '../../../../notifiers/user_notifier.dart';
import '../../../common_widgets/my_image.dart';
import '../../../image_paths.dart';

class JellyShareCard extends StatelessWidget {
  const JellyShareCard({super.key, required this.proxyDetail});

  final ProxyDetail? proxyDetail;

  @override
  Widget build(BuildContext context) {
    late final member = context.read<UserNotifier>().member;

    return AspectRatio(
      aspectRatio: 325 / 426,
      child: LayoutBuilder(builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;
        final scale = width / 325.0;

        return Stack(
          alignment: Alignment.topCenter,
          children: [
            MyImage.asset(
              MyImagePaths.appMineJellyShareQrBgNew,
              fit: BoxFit.fill,
              width: width,
              height: height,
            ),
            // proxyDetail?.directProxyNum == null
            //     ? const SizedBox.shrink()
            //     : RichText(
            //         text: TextSpan(
            //           children: [
            //             TextSpan(
            //               text: '${'ljyq'.tr(context: context)} ',
            //               style: MyTheme.white9255_15,
            //             ),
            //             TextSpan(
            //               text:
            //                   '${proxyDetail?.directProxyNum}${'ren'.tr(context: context)}',
            //               style: MyTheme.jellyCyan_15,
            //             )
            //           ],
            //         ),
            //       ),
            Positioned(
              bottom: 15 * scale,
              left: 12.5 * scale,

              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10 * scale),
                ),
                // color: Colors.white,
                child: QrImageView(
                  data: '${member.share?.affUrl}',
                  version: 3,
                  size: 98 * scale,
                ),
              ),
            ),
            Positioned(
              bottom: 68 * scale,
              right: 50 * scale,
              child: Text(
                '${member.share?.affCode}',
                style: TextStyle(
                    color: const Color.fromRGBO(255, 57, 57, 1),
                    fontSize: 25 * scale,
                    fontWeight: FontWeight.w600),
              ),
            ),
            // SizedBox(height: 15.w),
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 16.w),
            //   child: Text('fxtips'.tr(context: context),
            //       style: MyTheme.gray12,
            //       maxLines: 5,
            //       textAlign: TextAlign.center),
            // )
          ],
        );
      }),
    );
  }
}
