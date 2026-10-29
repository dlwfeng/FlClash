import 'package:fl_clash/common/print.dart';
import 'package:fl_clash/enum/enum.dart';

void logPollingFailure(Type type, Object error) =>
    commonPrint.log('$type poll error: $error', logLevel: LogLevel.warning);
