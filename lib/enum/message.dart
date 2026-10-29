import 'package:fl_clash/ui/ui.dart';
import 'package:fl_clash/ui/icons/icons.dart';
import 'package:material_ui/material_ui.dart';

enum MessageLevel { info, success, warning, error }

extension MessageLevelExt on MessageLevel {
  Glyph? get glyph {
    return switch (this) {
      MessageLevel.info => null,
      MessageLevel.success => AppGlyphs.checkCircle,
      MessageLevel.warning => AppGlyphs.warning,
      MessageLevel.error => AppGlyphs.error,
    };
  }

  Color containerColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return switch (this) {
      MessageLevel.error => colorScheme.errorContainer,
      _ => SurfaceLevel.floatingOf(colorScheme).colorOf(colorScheme),
    };
  }

  Color contentColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return switch (this) {
      MessageLevel.error => colorScheme.onErrorContainer,
      _ => colorScheme.onSurfaceVariant,
    };
  }

  Color iconColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return switch (this) {
      MessageLevel.info => colorScheme.onSurfaceVariant,
      MessageLevel.success => colorScheme.success,
      MessageLevel.warning => colorScheme.warning,
      MessageLevel.error => colorScheme.onErrorContainer,
    };
  }

  Duration get duration {
    return switch (this) {
      MessageLevel.info || MessageLevel.success => const Duration(seconds: 3),
      MessageLevel.warning => const Duration(seconds: 5),
      MessageLevel.error => const Duration(seconds: 6),
    };
  }
}
