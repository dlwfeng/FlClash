export 'package:fl_clash/enum/proxies.dart';
export 'package:fl_clash/enum/proxies_labels.dart';
export 'package:fl_clash/models/proxies.dart';
export 'package:fl_clash/common/iterable.dart';
export 'package:fl_clash/common/optional_string.dart';
export 'package:fl_clash/common/search.dart';
export 'package:fl_clash/l10n/context.dart';
export 'package:fl_clash/ui/ui.dart';
export 'package:fl_clash/ui/icons/icons.dart';
export 'package:fl_clash/widgets/icon.dart';
export 'package:fl_clash/common/proxy_layout.dart';
export 'bindings.dart';

import 'package:collection/collection.dart';
import 'package:fl_clash/l10n/l10n.dart';
import 'package:fl_clash/models/proxies.dart';
import 'package:flutter/widgets.dart';

const stringListEquality = ListEquality<String>();
const proxiesListStoreKey = PageStorageKey<String>('proxies_list');
String delayFailureText(int delay, AppLocalizations l) =>
    delay == delayTimedOutValue ? l.timeout : l.delayFailed;

const reservedCustomProxyNames = {
  'DIRECT',
  'REJECT',
  'REJECT-DROP',
  'COMPATIBLE',
  'PASS',
  'PASS-RULE',
  'GLOBAL',
};
