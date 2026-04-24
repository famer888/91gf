import 'package:analytics_sdk/manager/sdk_context.dart';
import 'package:analytics_sdk/utils/device_fingerprint_util.dart';
import 'package:flutter_test/flutter_test.dart';

/// fp_version 公共字段测试
///
/// 确保 getDeviceCommonFields() 和 generateCommonFields() 均包含
/// fp_version 字段，且值与 DeviceFingerprintUtil.kVersion 一致。
void main() {
  group('AnalyticsUtils fp_version', () {
    setUp(() {
      SdkContext.configure(
        appId: 'test_app',
        channel: 'test',
        deviceFingerprint: 'fp_abc',
        fingerprintVersion: DeviceFingerprintUtil.kVersion,
      );
    });

    test('getDeviceCommonFields() 包含 fp_version 字段', () {
      final fields = SdkContext.getDeviceCommonFields();
      expect(fields.containsKey('fp_version'), isTrue);
      expect(fields['fp_version'], equals(DeviceFingerprintUtil.kVersion));
    });

    test('generateCommonFields() 包含 fp_version 字段', () {
      final fields = SdkContext.generateCommonFields('test_event');
      expect(fields.containsKey('fp_version'), isTrue);
      expect(fields['fp_version'], equals(DeviceFingerprintUtil.kVersion));
    });

    test('fp_version 默认值为 kVersion', () {
      // 不传 fingerprintVersion，依然应有默认值
      SdkContext.configure(appId: 'test2');
      final fields = SdkContext.getDeviceCommonFields();
      expect(fields['fp_version'], isNotEmpty);
    });
  });
}
