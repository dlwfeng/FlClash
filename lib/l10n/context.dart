import 'package:flutter/widgets.dart';
import 'l10n.dart';

extension AppLocalizationsContext on BuildContext {
  AppLocalizations get appLocalizations => AppLocalizations.of(this);
}
