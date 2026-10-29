import 'package:fl_clash/l10n/l10n.dart';
import 'proxies.dart';

extension ProxiesTypeL10n on ProxiesType {
  String get label {
    final appLocalizations = AppLocalizations.current;
    return switch (this) {
      ProxiesType.tab => appLocalizations.tab,
      ProxiesType.list => appLocalizations.list,
    };
  }
}

extension ProxyCardTypeL10n on ProxyCardType {
  String get label {
    final appLocalizations = AppLocalizations.current;
    return switch (this) {
      ProxyCardType.loose => appLocalizations.loose,
      ProxyCardType.standard => appLocalizations.standard,
      ProxyCardType.compact => appLocalizations.compact,
    };
  }
}
