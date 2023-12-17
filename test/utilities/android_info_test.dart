import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tasktonic/utilities/android_info.dart';

class MockAndroidBuildVersion extends Fake implements AndroidBuildVersion {
  late int _sdkInt;

  MockAndroidBuildVersion({int sdkInt = 33}) {
    _sdkInt = sdkInt;
  }

  @override
  int get sdkInt => _sdkInt;
}

class MockAndroidDeviceInfo extends Fake implements AndroidDeviceInfo {
  late int _sdkInt;

  MockAndroidDeviceInfo({int sdkInt = 33}) {
    _sdkInt = sdkInt;
  }

  @override
  AndroidBuildVersion get version => MockAndroidBuildVersion(sdkInt: _sdkInt);
}

class MockDeviceInfoPlugin extends Mock implements DeviceInfoPlugin {
  @override
  Future<AndroidDeviceInfo> get androidInfo async {
    return super.noSuchMethod(
      Invocation.getter(#androidInfo),
      returnValue: Future.value(MockAndroidDeviceInfo()),
    );
  }
}

void main() {
  group('hasPerAppLocale', () {
    test('should return false if info is null', () {
      final result = hasPerAppLocale(null);

      expect(result, false);
    });

    test('should return false if sdkInt is less than 33', () {
      final result = hasPerAppLocale(MockAndroidDeviceInfo(sdkInt: 32));

      expect(result, false);
    });

    test('should return true if sdkInt is equal to 33', () {
      final result = hasPerAppLocale(MockAndroidDeviceInfo(sdkInt: 33));

      expect(result, true);
    });

    test('should return true if sdkInt is greater than 33', () {
      final result = hasPerAppLocale(MockAndroidDeviceInfo(sdkInt: 34));

      expect(result, true);
    });
  });

  group('getAndroidInfo', () {
    test('should return AndroidDeviceInfo when device info is available',
        () async {
      final deviceInfo = MockDeviceInfoPlugin();
      final androidDeviceInfo = MockAndroidDeviceInfo();

      when(deviceInfo.androidInfo).thenAnswer((_) async => androidDeviceInfo);

      final result = await getAndroidInfo(deviceInfo);

      expect(result, equals(androidDeviceInfo));
    });

    test('should return null when device info is not available', () async {
      final deviceInfo = MockDeviceInfoPlugin();

      when(deviceInfo.androidInfo).thenThrow(Exception());

      final result = await getAndroidInfo(deviceInfo);

      expect(result, isNull);
    });
  });
}
