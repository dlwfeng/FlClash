import 'package:fl_clash/ui/ui.dart';
import 'package:material_ui/material_ui.dart';

const mobileNavigationMaxWidth = 600.0;
const compactNavigationMaxWidth = 840.0;

class NavigationFrame extends StatelessWidget {
  const NavigationFrame({
    super.key,
    required this.hasSidebar,
    required this.sidebar,
    this.backdropOpacity,
    this.onContentWidth,
    required this.child,
  });

  final bool hasSidebar;
  final Widget sidebar;
  final double? backdropOpacity;
  final ValueChanged<double>? onContentWidth;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isLtr = Directionality.of(context) == TextDirection.ltr;
    final chrome = context.colorScheme.chromeSurface;
    return Container(
      color: backdropOpacity != null
          ? Colors.transparent
          : SurfaceLevel.page.colorOf(context.colorScheme),
      child: Row(
        children: [
          AnimatedVisibility.sidebar(
            visible: hasSidebar,
            child: Material(
              color: backdropOpacity != null
                  ? chrome.withValues(alpha: backdropOpacity)
                  : chrome,
              shape: BorderDirectional(end: Divider.createBorderSide(context)),
              child: MediaQuery.removePadding(
                context: context,
                removeLeft: !isLtr,
                removeRight: isLtr,
                child: sidebar,
              ),
            ),
          ),
          Expanded(
            child: ClipRect(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  onContentWidth?.call(constraints.maxWidth);
                  return MediaQuery.removePadding(
                    context: context,
                    removeLeft: hasSidebar && isLtr,
                    removeRight: hasSidebar && !isLtr,
                    child: child,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
