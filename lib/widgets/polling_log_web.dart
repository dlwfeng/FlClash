import 'package:flutter/foundation.dart';

void logPollingFailure(Type type, Object error) =>
    debugPrint('$type poll error: $error');
