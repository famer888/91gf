import 'package:analytics_sdk/manager/sdk_context.dart';
import 'package:analytics_sdk/utils/logger.dart';
import 'package:flutter_test/flutter_test.dart';

/// appVersion 格式校验测试。
///
/// `flutter test` 默认运行在 Debug 模式（kDebugMode=true），
/// 因此这里只能直接验证 Debug 分支行为。Release 分支的外部可观察效果
/// 与 Debug 分支最终一致：都让 `generateCommonFields()['app_version']`
/// 退回到 [SdkContext.kDefaultAppVersion]。
void main() {
  group('AnalyticsUtils appVersion 格式校验', () {
    setUp(() {
      SdkContext.reset();
    });

    tearDown(() {
      Logger.onLog = null;
      SdkContext.reset();
    });

    test('合法 x.y.z 正常写入', () {
      SdkContext.configure(appVersion: '2.5.1');
      expect(SdkContext.appVersion, equals('2.5.1'));
      expect(
        SdkContext.generateCommonFields('test')['app_version'],
        equals('2.5.1'),
      );
    });

    test('未传 appVersion：上报字段默认填 kDefaultAppVersion', () {
      SdkContext.configure(appId: 'app');
      expect(SdkContext.appVersion, isNull);
      expect(
        SdkContext.generateCommonFields('test')['app_version'],
        equals(SdkContext.kDefaultAppVersion),
      );
    });

    test('非法 appVersion：Debug 下保留原值，发出 error 日志，上报字段退回默认值', () {
      final logs = <MapEntry<String, LogLevel>>[];
      Logger.onLog = (msg, level) => logs.add(MapEntry(msg, level));

      SdkContext.configure(appVersion: 'abc');

      expect(SdkContext.appVersion, isNull,
          reason: 'Debug 下非法值不应写入 _appVersion');
      expect(
        SdkContext.generateCommonFields('test')['app_version'],
        equals(SdkContext.kDefaultAppVersion),
      );
      expect(
        logs.any((e) =>
            e.value == LogLevel.error && e.key.contains('appVersion 格式不正确')),
        isTrue,
        reason: 'Debug 下应发出 error 级日志',
      );
    });

    test('先合法后非法：Debug 下保留先前合法值不被污染', () {
      SdkContext.configure(appVersion: '3.2.1');
      SdkContext.configure(appVersion: 'not-a-version');
      expect(SdkContext.appVersion, equals('3.2.1'));
    });
  });
}
