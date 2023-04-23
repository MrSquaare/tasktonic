import 'package:device_info_plus/device_info_plus.dart';

bool hasPerAppLocale(AndroidDeviceInfo? info) {
  if (info == null) return false;

  return info.version.sdkInt >= 33;
}

Future<AndroidDeviceInfo?> getAndroidInfo() async {
  try {
    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;

    return androidInfo;
  } catch (e) {
    return null;
  }
}
