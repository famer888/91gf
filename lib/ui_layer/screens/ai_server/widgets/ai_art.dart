import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jygf/domain/model/ai/ai_draw_model.dart';
import 'package:jygf/domain/model/member_model.dart';
import 'package:jygf/domain/remote_domain/domains/aidraw.dart';
import 'package:jygf/ui_layer/notifiers/home_config_notifier.dart';
import 'package:jygf/ui_layer/notifiers/user_notifier.dart';
import 'package:jygf/ui_layer/router/routes.dart';
import 'package:jygf/ui_layer/screens/ai_server/widgets/dialog/ai_server_dialog.dart';
import 'package:jygf/ui_layer/screens/common_widgets/dialog/widgets/regular_dialog.dart';
import 'package:jygf/ui_layer/screens/common_widgets/keep_alive_wrapper.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_app_bar.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_image.dart';
import 'package:jygf/ui_layer/screens/common_widgets/my_tab_bar.dart';
import 'package:jygf/ui_layer/screens/common_widgets/screen_background.dart';
import 'package:jygf/ui_layer/screens/image_paths.dart';
import 'package:jygf/ui_layer/screens/theme.dart';
import 'package:jygf/ui_layer/utils/common_utils.dart';
import 'package:jygf/ui_layer/utils/my_toast.dart';
import 'package:provider/provider.dart';
import 'package:jygf/report/ui_layer/report_gesture_detector.dart';


class AIArtScreen extends StatefulWidget {
  const AIArtScreen({super.key});

  @override
  State<AIArtScreen> createState() => _AIArtScreenState();
}

class _AIArtScreenState extends State<AIArtScreen>
    with TickerProviderStateMixin {
  late final _appDomain = context.read<AIDrawDomain>();

  final List<Map<String, dynamic>> _tabs = [
    {'title': '标签模式', 'data': <AIDrawModeModel>[]},
    {'title': '专家模式', 'data': <AIDrawModeModel>[]},
  ];

  late final tabController = TabController(length: _tabs.length, vsync: this);

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final result = await _appDomain.aiDrawList();
    if (result.status == 1) {
      AIDrawListModel? widgetData = result.data;
      setState(() {
        _tabs[0]['data'] = widgetData!.labelModeForm;
        _tabs[1]['data'] = widgetData.expertModeForm;
      });
    } else {
      MyToast.showText(text: result.msg ?? '');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      child: Scaffold(
        appBar: MyAppBar(
          title: 'AI绘画',
          rightWidget: Align(
            alignment: Alignment.centerRight,
            child: ReportGestureDetector(
              onTap: () {
                const MineAIRecordRoute(index: 7).push(context);
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Text(
                  'wdai'.tr(),
                  style: MyTheme.white255_13.copyWith(height: 1.0),
                ),
              ),
            ),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TabBarWithView.line(
                indicatorType: IndicatorType.curve,
                isCenter: true,
                tabController: tabController,
                titles: _tabs.map((tab) => tab['title'] as String).toList(),
                views: [
                  KeepAliveWrapper(
                    child: SelectOptionsList(
                      current: 'label_mode_form',
                      data: _tabs[0]['data'] as List<AIDrawModeModel>,
                    ),
                  ),
                  KeepAliveWrapper(
                    child: SelectOptionsList(
                      current: 'expert_mode_form',
                      data: _tabs[1]['data'] as List<AIDrawModeModel>,
                    ),
                  ),
                ],
                // labelStyle: MyTheme.blue80_16,
                unselectedLabelStyle: MyTheme.white16medium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SelectOptionsList extends StatefulWidget {
  const SelectOptionsList(
      {super.key, required this.current, required this.data});
  final String current;
  final List<AIDrawModeModel> data;

  @override
  State<SelectOptionsList> createState() => _SelectOptionsListState();
}

class _SelectOptionsListState extends State<SelectOptionsList> {
  late final _appDomain = context.read<AIDrawDomain>();
  late final homeConfig = context.read<HomeConfigNotifier>();
  late final userNotifier = context.read<UserNotifier>();
  late Member member = userNotifier.member;
  late int payAiDraws = homeConfig.config.payAiDraw;
  int get freeNumber => userNotifier.member.aiDrawValue;
  int get coins => userNotifier.member.money;

  Map<String, List<Map<String, String>>> selectedMap = {};
  List<Map<String, String>> get selectedList {
    return selectedMap.values.expand((list) => list).toList();
  }

  void onChanged(Map<String, String>? option) {
    if (option == null) return;

    final title = option['title']!;
    final key = option['key']!;
    final value = option['value']!;

    setState(() {
      selectedMap[title] ??= [];
      final existingIndex =
          selectedMap[title]!.indexWhere((item) => item['key'] == key);
      if (existingIndex >= 0) {
        if (value.isEmpty) {
          selectedMap[title]!.removeAt(existingIndex);
        } else {
          selectedMap[title]![existingIndex] = option;
        }
      } else {
        selectedMap[title]!.add(option);
      }

      selectedMap[title] = selectedMap[title]!
          .where((e) => e['value'] != null && e['value']!.isNotEmpty)
          .toList();
    });

    print('当前选中 list: $selectedList');
  }

  Future<void> _checkPerm() async {
    if (freeNumber > 0) {
      MyToast.showText(text: '已使用免费次数，剩余 ${freeNumber - 1} 次');
      onSubmit();
    } else if (coins < payAiDraws) {
      AiServerDialog.showBalanceNotEnough(context, coins);
    } else {
      AiServerDialog.showConfirmDialog(context, payAiDraws, onSubmit);
    }
  }

  Future<void> onSubmit() async {
    final Map<String, List<String>> grouped = {};
    for (var item in selectedList) {
      final key = item['key'];
      final value = item['value'];
      if (key == null || value == null) continue;

      grouped.putIfAbsent(key, () => []).add(value);
    }

    final prompt = grouped['prompt']?.join(',') ?? '';
    final negativePrompt = grouped['negative_prompt']?.join(',') ?? '';
    final size = grouped['size']?.join(',') ?? '';
    final image = grouped['image']?.firstOrNull ?? '';

    MyToast.showLoading(text: '正在生成中...');

    final result = await _appDomain.aiDrawGenerate(
      prompt: prompt,
      negativeprompt: negativePrompt,
      size: size,
      image: image,
    );
    MyToast.closeAllLoading();

    if (result.status == 1) {
      AiServerDialog.showSubmitSuccess(context);
      final drawValue = freeNumber - 1;
      if (drawValue >= 0) {
        userNotifier.setDrawValue(num: drawValue);
      } else {
        userNotifier.setMoney(money: coins - payAiDraws);
      }
    } else {
      MyToast.showText(text: result.msg ?? '提交失败');
    }
  }

  @override
  Widget build(BuildContext context) {
    final String buttonText = freeNumber > 0
        ? '免费生成（剩余 $freeNumber 次）'
        : '需消耗 $payAiDraws 金币【余额 $coins】生成';
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(16.w),
            itemCount: widget.data.length,
            itemBuilder: (context, index) {
              final item = widget.data[index];
              return Padding(
                padding: EdgeInsets.only(bottom: 16.h),
                child: OptionsWidget(
                  model: item,
                  selectedMap: selectedMap,
                  onChanged: onChanged,
                  tabValue: widget.current,
                ),
              );
            },
          ),
        ),
        ReportGestureDetector(
          onTap: () {
            if (selectedList.isEmpty) {
              MyToast.showText(text: '请至少选择一项');
              return;
            }
            _checkPerm();
          },
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.all(15.w),
            padding: EdgeInsets.symmetric(vertical: 12.w),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(35.r),
                gradient: MyTheme.gradient_90_114),
            child: Text(buttonText, style: MyTheme.white16medium),
          ),
        ),
      ],
    );
  }
}

class OptionsWidget extends StatelessWidget {
  const OptionsWidget({
    super.key,
    required this.model,
    required this.selectedMap,
    required this.onChanged,
    required this.tabValue,
  });

  final AIDrawModeModel model;
  final Map<String, List<Map<String, String>>> selectedMap;
  final void Function(Map<String, String>? option) onChanged;
  final String tabValue;

  @override
  Widget build(BuildContext context) {
    Widget childWidget;
    switch (model.layoutType) {
      case 0:
        childWidget = SelectRadios(
          model: model,
          currentValue: selectedMap[model.title]?.firstWhere(
            (item) => item['key'] == model.element.first.key,
            orElse: () => {'value': ''},
          )['value'],
          onChanged: onChanged,
        );
        break;

      case 1:
        childWidget = SelectThumbs(
          model: model,
          currentValue: selectedMap[model.title]?.firstWhere(
            (item) => item['key'] == model.element.first.key,
            orElse: () => {'value': ''},
          )['value'],
          onChanged: onChanged,
        );
        break;

      case 2:
        childWidget = TextaresPrompt(
          model: model,
          currentValueMap: {
            for (var e in model.element)
              e.key: selectedMap[model.title]?.firstWhere(
                      (item) => item['key'] == e.key,
                      orElse: () => {'value': ''})['value'] ??
                  ''
          },
          onChanged: onChanged,
        );
        break;
      case 3:
        childWidget = UploadImages(
          model: model,
          onChanged: onChanged,
        );
        break;
      default:
        childWidget = const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(model.title, style: MyTheme.white16medium),
        SizedBox(height: 8.w),
        childWidget,
      ],
    );
  }
}

class TextaresPrompt extends StatefulWidget {
  const TextaresPrompt({
    super.key,
    required this.model,
    required this.currentValueMap,
    required this.onChanged,
  });

  final AIDrawModeModel model;

  final Map<String, String?> currentValueMap;

  final void Function(Map<String, String>? option) onChanged;

  @override
  State<TextaresPrompt> createState() => _TextaresPromptState();
}

class _TextaresPromptState extends State<TextaresPrompt> {
  final Map<String, TextEditingController> controllerMap = {};

  @override
  void initState() {
    super.initState();
    for (var option in widget.model.element) {
      controllerMap[option.key] = TextEditingController(
        text: widget.currentValueMap[option.key] ?? '',
      );
    }
  }

  @override
  void didUpdateWidget(covariant TextaresPrompt oldWidget) {
    super.didUpdateWidget(oldWidget);
    for (var option in widget.model.element) {
      final newText = widget.currentValueMap[option.key] ?? '';
      if (controllerMap[option.key]?.text != newText) {
        controllerMap[option.key]?.text = newText;
      }
    }
  }

  @override
  void dispose() {
    for (var controller in controllerMap.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.model.element.map((option) {
        final controller = controllerMap[option.key]!;

        return Padding(
          padding: EdgeInsets.only(bottom: 12.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(option.name, style: MyTheme.white14),
              SizedBox(height: 6.w),
              CommonUtils.dashedBorder(
                color: MyTheme.white03Color,
                borderRadius: BorderRadius.all(Radius.circular(8.r)),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10.w, horizontal: 5.w),
                  decoration: BoxDecoration(
                    color: MyTheme.white01Color,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: TextField(
                    controller: controller,
                    maxLines: 5,
                    style: MyTheme.white14,
                    onChanged: (val) {
                      final trimmed = val.trim();
                      if (trimmed.isEmpty) {
                        widget.onChanged(null);
                      } else {
                        widget.onChanged({
                          'title': widget.model.title,
                          'key': option.key,
                          'value': trimmed,
                        });
                      }
                    },
                    decoration: InputDecoration(
                      hintText: '请输入${option.name}',
                      hintStyle: MyTheme.white14.copyWith(color: Colors.white70),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class SelectRadios extends StatelessWidget {
  const SelectRadios({
    super.key,
    required this.model,
    required this.currentValue,
    required this.onChanged,
  });

  final AIDrawModeModel model;
  final String? currentValue;
  final void Function(Map<String, String>? option) onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.w,
      children: model.element.map((option) {
        final isSelected = option.val == currentValue;
        return ReportGestureDetector(
          onTap: () => onChanged(isSelected
              ? null
              : {
                  'title': model.title,
                  'value': option.val,
                  'key': option.key,
                }),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.w),
            decoration: BoxDecoration(
              gradient: isSelected ? MyTheme.gradient_90_114 : null,
              color: isSelected ? null : MyTheme.white01Color,
              borderRadius: BorderRadius.circular(5.r),
            ),
            child: Text(
              option.name,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class SelectThumbs extends StatelessWidget {
  const SelectThumbs({
    super.key,
    required this.model,
    required this.currentValue,
    required this.onChanged,
  });

  final AIDrawModeModel model;
  final String? currentValue;
  final void Function(Map<String, String>? option) onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
            children: model.element.map((option) {
          final isSelected = option.val == currentValue;
          return ReportGestureDetector(
            onTap: () => onChanged(
              isSelected
                  ? null
                  : {
                      'title': model.title,
                      'value': option.val,
                      'key': option.key
                    },
            ),
            child: Padding(
              padding: EdgeInsets.only(right: 10.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 65.w,
                    height: 65.w,
                    decoration: BoxDecoration(
                      color: const Color(0xff1b1c2b),
                      border: Border.all(
                        color:
                            isSelected ? MyTheme.primaryColor : const Color(0xff1b1c2b),
                        width: 1.w,
                      ),
                      borderRadius: BorderRadius.circular(3.r),
                    ),
                    child: MyImage.network(
                      option.cover,
                      fit: BoxFit.cover,
                      backgroundColor: MyTheme.imageBgColor,
                      borderRadius: 5.w,
                    ),
                  ),
                  SizedBox(height: 5.w),
                  Text(
                    option.name,
                    style: TextStyle(
                      color: isSelected ? MyTheme.primaryColor : Colors.white,
                      fontSize: 12.sp,
                    ),
                  )
                ],
              ),
            ),
          );
        }).toList()));
  }
}

class UploadImages extends StatefulWidget {
  const UploadImages({
    super.key,
    required this.model,
    required this.onChanged,
  });

  final AIDrawModeModel model;
  final void Function(Map<String, String>? option) onChanged;

  @override
  State<UploadImages> createState() => _UploadImagesState();
}

class _UploadImagesState extends State<UploadImages> {
  final List<Map> upList = [];

  Future<void> _handleImageUpload() async {
    final homeConfigNotifier = context.read<HomeConfigNotifier>();
    if (await CommonUtils.pickImage() case final xFile?) {
      MyToast.showLoading(text: 'scz'.tr());
      final result = await homeConfigNotifier.uploadImage(xFile);
      if (result != null && result['code'] == 1) {
        final url = "${result['msg']}";
        final image = await decodeImageFromList(await xFile.readAsBytes());
        final item = {
          'media_url': url,
          'url': homeConfigNotifier.config.imgBase + url,
          'thumb_width': image.width,
          'thumb_height': image.height,
        };
        upList.add(item);
        if (mounted) setState(() {});

        widget.onChanged({
          'title': widget.model.title,
          'key': widget.model.element.first.key,
          'value': url,
        });
      } else {
        MyToast.showText(text: result?['msg'] ?? '上传失败');
      }
      MyToast.closeAllLoading();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AIImagePickerGrid(
      upList: upList,
      picLimit: 1,
      onAddImage: _handleImageUpload,
      onRemoveImage: (item) {
        setState(() {
          upList.remove(item);
          widget.onChanged(null);
        });
      },
    );
  }
}

class AIImagePickerGrid extends StatelessWidget {
  const AIImagePickerGrid({
    super.key,
    required this.upList,
    required this.picLimit,
    required this.onAddImage,
    required this.onRemoveImage,
  });

  final List<Map> upList;
  final int picLimit;
  final VoidCallback onAddImage;
  final void Function(Map) onRemoveImage;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      mainAxisSpacing: 10.w,
      crossAxisSpacing: 10.w,
      children: [
        for (final item in upList)
          Stack(
            children: [
              MyImage.network(
                item['url'],
                fit: BoxFit.cover,
                borderRadius: 5.w,
              ),
              Positioned(
                top: 0,
                right: 0,
                child: ReportGestureDetector(
                  onTap: () => onRemoveImage(item),
                  child: MyImage.asset(
                    MyImagePaths.appIssueCancelIcon,
                    width: 18.w,
                    height: 18.w,
                  ),
                ),
              ),
            ],
          ),
        if (upList.length < picLimit)
          ReportGestureDetector(
            onTap: onAddImage,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xff1b1c2b),
                borderRadius: BorderRadius.circular(5.r),
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MyImage.asset(MyImagePaths.appAiUploadIcon,
                      width: 50.w, height: 50.w),
                  SizedBox(height: 5.w),
                  Text('点击上传', style: MyTheme.white14),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
