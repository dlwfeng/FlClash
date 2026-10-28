import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/ui/icons/icons.dart';
import 'package:fl_clash/widgets/widgets.dart';
import 'package:material_ui/material_ui.dart';

export 'package:fl_clash/ui/form_row.dart';

class InfoMessageButton extends StatelessWidget {
  final String message;

  const InfoMessageButton({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return CommonMinIconButtonTheme(
      child: IconButton(
        tooltip: context.appLocalizations.tip,
        onPressed: () {
          dialogs.showAlert(message: TextSpan(text: message));
        },
        icon: GlyphIcon(
          AppGlyphs.info,
          fill: 1,
          size: 20.ap(context),
          color: context.colorScheme.error,
        ),
      ),
    );
  }
}

class EntryButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool _add;

  const EntryButton.add({super.key, required this.onPressed}) : _add = true;

  const EntryButton.remove({super.key, required this.onPressed}) : _add = false;

  @override
  Widget build(BuildContext context) {
    final appLocalizations = context.appLocalizations;
    return CommonMinIconButtonTheme(
      child: ElasticButton(
        child: IconButton(
          tooltip: _add ? appLocalizations.add : appLocalizations.remove,
          onPressed: onPressed,
          icon: GlyphIcon(
            _add ? AppGlyphs.addCircle : AppGlyphs.removeCircle,
            size: 24,
          ),
          padding: EdgeInsets.zero,
        ),
      ),
    );
  }
}
