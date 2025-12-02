import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../common_widgets/my_app_bar.dart';
import '../../common_widgets/screen_background.dart';
import 'widgets/income_detail_view.dart';

class MineIncomeDetailScreen extends StatefulWidget {
  const MineIncomeDetailScreen({super.key});

  @override
  State<MineIncomeDetailScreen> createState() => _MineIncomeDetailScreenState();
}

class _MineIncomeDetailScreenState extends State<MineIncomeDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      child: Scaffold(
        appBar: MyAppBar(
          title: 'symx'.tr(context: context),
        ),
        body: const IncomeDetailView(source: 'post'),
      ),
    );
  }
}
