import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jygf/domain/remote_domain/domains/ainovel.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_app_bar.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/ui_layer/utils/my_toast.dart';
import 'package:provider/provider.dart';

class AiNovelDetailPage extends StatefulWidget {
  const AiNovelDetailPage(
      {super.key, required this.id, required this.generateTime});
  final String id;
  final String generateTime;

  @override
  State<AiNovelDetailPage> createState() => _AiNovelDetailPageState();
}

class _AiNovelDetailPageState extends State<AiNovelDetailPage> {
  String _content = '';
  late final _appDomain = context.read<AINovelDomain>();
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    MyToast.showLoading();
    final result = await _appDomain.aiNovelDetail(id: widget.id);
    MyToast.closeAllLoading();
    if (result.status == 1) {
      setState(() {
        _content = result.data?['txt'] ?? '';
      });
    } else {
      MyToast.showText(text: result.msg ?? '加载失败');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'xsxq'.tr()),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10.w),
            Row(
              children: [
                Text('${'生成时间:'} ${widget.generateTime}',
                    style: MyTheme.white255_15),
                const Spacer(),
                GestureDetector(
                  onTap: () async {
                    await Clipboard.setData(ClipboardData(text: _content));
                    MyToast.showText(text: '复制成功~');
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 18.w, vertical: 3.w),
                    decoration: BoxDecoration(
                      gradient: MyTheme.gradient_84_55,
                      borderRadius: BorderRadius.circular(20.w),
                    ),
                    child: Text('复制', style: MyTheme.white14),
                  ),
                )
              ],
            ),
            SizedBox(height: 10.w),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 20.w),
                child: Text(_content, style: MyTheme.white14, maxLines: 3000),
              ),
            )
          ],
        ),
      ),
    );
  }
}
