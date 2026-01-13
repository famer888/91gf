import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../domain/api_validator.dart';
import '../../../domain/model/search_model.dart';
import '../../../domain/remote_domain/domains/search.dart';
import '../../notifiers/home_config_notifier.dart';
import '../../router/routes.dart';
import '../../utils/common_utils.dart';
import '../../utils/my_toast.dart';
import '../common_widgets/my_image.dart';
import '../common_widgets/screen_background.dart';
import '../common_widgets/status/empty_data.dart';
import '../image_paths.dart';
import '../theme.dart';
import 'package:jygf/report/ui_layer/report_gesture_detector.dart';import 'package:jygf/report/ui_layer/report_general_banner.dart';




class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final searchTextEditController = TextEditingController();
  late final _homeConfigNotifier = context.read<HomeConfigNotifier>();

  void onSubmitted(String keyword) {
    if (keyword.trim().isEmpty) {
      MyToast.showText(text: 'qsrgjz'.tr());
      return;
    }
    final searchHistory = _homeConfigNotifier.searchHistory;

    final title = keyword.replaceAll('/', '|');
    if (!searchHistory.contains(keyword)) {
      _homeConfigNotifier.upsertSearchHistory(searchHistory: searchHistory..add(keyword));
    }
    SearchResultRoute(title).push(context);
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      child: Scaffold(
        appBar: _SearchBar(
          textEditingController: searchTextEditController,
          onSubmitted: onSubmitted,
        ),
        body: ListView(
          padding: EdgeInsets.only(
            left: MyTheme.pagePadding,
            right: MyTheme.pagePadding,
            bottom: 50.w,
          ),
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15.w),
              child: Row(
                children: [
                  Text(
                    'ssjl'.tr(context: context),
                    style: MyTheme.white16medium,
                  ),
                  const Spacer(),
                  ReportGestureDetector(
                    onTap: _homeConfigNotifier.clearSearchHistory,
                    child: Text(tr('qcjl'), style: MyTheme.jellyCyan_13),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Selector<HomeConfigNotifier, List<String>>(
                selector: (_, config) => config.searchHistory,
                builder: (context, searchHistory, child) =>
                    searchHistory.isNotEmpty
                        ? Wrap(
                            spacing: 10.w,
                            runSpacing: 10.w,
                            children: [
                              for (final text in searchHistory)
                                _KeywordTile(
                                  text: text,
                                  onTap: () {
                                    searchTextEditController.text = text;
                                    onSubmitted(text);
                                  },
                                  onDelete: () {
                                    final history =
                                        _homeConfigNotifier.searchHistory;
                                    _homeConfigNotifier.upsertSearchHistory(
                                        searchHistory: history..remove(text));
                                  },
                                )
                            ],
                          )
                        : PageEmptyDataView(
                            text: 'myss'.tr(context: context),
                          ),
              ),
            ),
            _SearchContentView(
              onSubmitted: (text) {
                searchTextEditController.text = text;
                onSubmitted(text);
              },
            )
          ],
        ),
      ),
    );
  }
}

class _SearchBar extends StatefulWidget implements PreferredSizeWidget {
  const _SearchBar({
    required this.textEditingController,
    required this.onSubmitted,
  });
  final TextEditingController textEditingController;
  final ValueChanged<String> onSubmitted;

  @override
  State<_SearchBar> createState() => _SearchBarState();

  @override
  final preferredSize = const Size.fromHeight(44);
}

class _SearchBarState extends State<_SearchBar> {
  TextEditingController get textEditingController =>
      widget.textEditingController;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: MyTheme.navbarHegiht,
        padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
        child: Row(
          children: [
            ReportGestureDetector(
              child: MyImage.asset(
                MyImagePaths.appBackIcon,
                width: 20.w,
                height: 20.w,
              ),
              onTap: () => context.pop(),
            ),
            Expanded(
              child: Container(
                height: 36.w,
                margin: EdgeInsets.symmetric(horizontal: 8.w),
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.w),
                  ),
                  color: Colors.white.withOpacity(0.1),
                ),
                alignment: Alignment.center,
                child: _SearchTextField(
                  textEditingController: textEditingController,
                  onSubmitted: widget.onSubmitted,
                ),
              ),
            ),
            SizedBox(width: 5.w),
            ReportGestureDetector(
              onTap: () {
                widget.onSubmitted.call(textEditingController.text);
              },
              child: Text(
                'ss'.tr(context: context),
                style: MyTheme.white255_14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _KeywordTile extends StatelessWidget {
  const _KeywordTile({
    required this.text,
    required this.onTap,
    required this.onDelete,
  });
  final String text;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 22.w,
      decoration: BoxDecoration(
        gradient: MyTheme.gradient_90_114_15,
        borderRadius: BorderRadius.circular(4.w),
      ),
      padding: EdgeInsets.symmetric(horizontal: 13.w),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ReportGestureDetector(
            onTap: onTap,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 100.w),
              child: Text(
                text,
                style: MyTheme.white15,
              ),
            ),
          ),
          Container(
            color: const Color(0xffffffff),
            height: 13.w,
            width: 1.w,
            margin: EdgeInsets.symmetric(horizontal: 10.w),
          ),
          ReportGestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: onDelete,
            child: MyImage.asset(
              MyImagePaths.appRecordDeleteIcon,
              width: 8.w,
              height: 8.w,
              fit: BoxFit.fitWidth,
            ),
          )
        ],
      ),
    );
  }
}

class _SearchTextField extends StatelessWidget {
  const _SearchTextField({
    required this.textEditingController,
    required this.onSubmitted,
  });

  final TextEditingController textEditingController;
  final ValueChanged<String> onSubmitted;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textEditingController,
      cursorColor: Colors.white,
      onSubmitted: onSubmitted,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: 'pmnyfh'.tr(context: context),
        hintStyle: MyTheme.gray8f8e90_13,
        contentPadding: EdgeInsets.zero,
        prefixIcon: Row(
          children: [
            SizedBox(width: 12.w),
            MyImage.asset(
              MyImagePaths.appSearchIcon,
              width: 12.w,
              height: 12.w,
            ),
            SizedBox(width: 2.w),
          ],
        ),
        prefixIconConstraints: BoxConstraints(
          maxHeight: 35.w,
          maxWidth: 35.w,
        ),
      ),
      style: TextStyle(
        color: Colors.white,
        fontSize: 13.sp,
      ),
    );
  }
}

class _SearchContentView extends StatefulWidget {
  const _SearchContentView({
    required this.onSubmitted,
  });
  final ValueChanged<String> onSubmitted;

  @override
  State<_SearchContentView> createState() => _SearchContentViewState();
}

class _SearchContentViewState extends State<_SearchContentView> {
  late final searchDomain = context.read<SearchDomain>();
  SearchModel? _data;
  @override
  void initState() {
    _initData();
    super.initState();
  }

  Future _initData() async {
    final res = await searchDomain.searchHotList();
    if (res.isValid && mounted) {
      setState(() {
        _data = res.data;
      });
    } else if (res.msg case final msg?) {
      MyToast.showText(text: msg);
    }
  }

  /// 热搜文字颜色
  final Map<int, int> colorMap = {
    0: 0xFFE83125,
    1: 0xFFFFD93B,
    2: 0xFF00D1FF,
  };

  @override
  Widget build(BuildContext context) {
    if (_data == null) return const SizedBox.shrink();
    final banner = _data!.banner;
    final hotTags = _data!.top.all;

    return Column(
      children: [
        SizedBox(height: 16.w),
        banner.isNotEmpty
            ? ReportGeneralAppsListVidget(
                aspectRatio: 7 / 2,
                data: banner,
                radius: 5.0,
              )
            : const SizedBox.shrink(),
        hotTags.isNotEmpty
            ? Column(
                children: [
                  SizedBox(height: 30.w),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(width: 4.w),
                      Text(
                        'rszb'.tr(context: context),
                        style: MyTheme.white16medium,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(width: 10.w)
                    ],
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      addRepaintBoundaries: false,
                      addAutomaticKeepAlives: false,
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => ReportGestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              widget.onSubmitted(hotTags[index].work);
                            },
                            child: SizedBox(
                              height: 35.w,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(width: 5.w),
                                  Container(
                                    height: ScreenUtil().setWidth(20),
                                    width: ScreenUtil().setWidth(20),
                                    alignment: Alignment.center,
                                    child: Text(
                                      '${index + 1}',
                                      style: MyTheme.white255_13_B.copyWith(
                                        color: colorMap[index] != null
                                            ? Color(colorMap[index]!)
                                            : MyTheme.white08Color,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  Expanded(
                                    child: Text(
                                      hotTags[index].work,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15.sp,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      maxLines: 1,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      MyImage.asset(
                                        MyImagePaths.appSearHotkeyN,
                                        width: 11.w,
                                        height: 11.w,
                                      ),
                                      SizedBox(width: 5.w),
                                      Text(
                                        '${CommonUtils.renderFixedNumber(hotTags[index].num)}${'rd'.tr(context: context)}',
                                        style: TextStyle(
                                          fontSize: 13.sp,
                                          color: MyTheme.white08Color,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                      itemCount: hotTags.length),
                ],
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}
