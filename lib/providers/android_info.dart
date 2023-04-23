import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utilities/android_info.dart';

final androidInfoProvider = FutureProvider((ref) => getAndroidInfo());
