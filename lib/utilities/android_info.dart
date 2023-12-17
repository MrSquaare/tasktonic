import 'package:device_info_plus/device_info_plus.dart';

bool hasPerAppLocale(AndroidDeviceInfo? info) {
  if (info == null) return false;

  return info.version.sdkInt >= 33;
}

Future<AndroidDeviceInfo?> getAndroidInfo(
  DeviceInfoPlugin deviceInfoPlugin,
) async {
  try {
    final androidInfo = await deviceInfoPlugin.androidInfo;

    return androidInfo;
  } catch (e) {
    return null;
  }
}
