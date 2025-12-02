import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../domain/model/proxy_detail_model.dart';
import '../../../theme.dart';

class MineShareToUserTips extends StatelessWidget {
  const MineShareToUserTips({super.key, required this.proxyDetail});

  final ProxyDetail? proxyDetail;

  List textsWithMiddleKey({required String text, required String key}) {
    var results = text.split(key);
    final list = [];
    for (var i = 0; i < results.length; i++) {
      list.add({'type': 0, 'word': results[i]});
      if (i != results.length - 1) {
        list.add({'type': 1, 'word': key});
      }
    }
    return list;
  }

  List textsWithList(List inputList, String key) {
    final list = [];
    for (var item in inputList) {
      if (item['type'] == 1) {
        list.add(item);
      } else {
        list.addAll(textsWithMiddleKey(text: item['word'], key: key));
      }
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    if (proxyDetail == null) return const SizedBox.shrink();
    final highlightStyle = TextStyle(
        color: const Color.fromRGBO(253, 160, 9, 1),
        fontSize: 13.sp,
        fontWeight: FontWeight.normal,
        overflow: TextOverflow.ellipsis,
        decoration: TextDecoration.none);
    final text = proxyDetail!.tips;
    final keys = proxyDetail!.colorKey;
    var list = textsWithMiddleKey(text: text, key: keys.first);
    for (var i = 1; i < keys.length; i++) {
      list = textsWithList(list, keys[i]);
    }
    return Column(
      children: [
        Container(
          height: 40.w,
          alignment: Alignment.centerLeft,
          child: Text(
            'gzsm'.tr(context: context),
            style: MyTheme.white255_18_M,
          ),
        ),
        RichText(
          text: TextSpan(
            children: list
                .map(
                  (e) => TextSpan(
                      text: e['word'],
                      style: e['type'] == 1
                          ? highlightStyle
                          : MyTheme.white255_13),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
