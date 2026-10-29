import 'feedback.dart';
import 'package:fl_clash/l10n/context.dart';
import 'package:material_ui/material_ui.dart';

void showCopySuccess(BuildContext context) =>
    showAppFeedback(context, context.appLocalizations.copySuccess);
