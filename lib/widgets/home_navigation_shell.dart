import 'package:fl_clash/ui/ui.dart';
import 'package:fl_clash/ui/icons/icons.dart';
import 'package:material_ui/material_ui.dart';

class HomeNavigationShell extends StatelessWidget {
  const HomeNavigationShell({
    super.key,
    required this.isMobile,
    required this.floating,
    required this.destinations,
    required this.selectedIndex,
    required this.onSelected,
    required this.child,
  });
  final bool isMobile, floating;
  final List<NavigationDockDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: SurfaceLevel.page.colorOf(context.colorScheme),
      child: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: FocusTraversalGroup(
                    policy: PageTraversalPolicy(),
                    child: BottomInsetScope(
                      inset: isMobile && floating
                          ? NavigationDock.insetOf(context)
                          : 0,
                      child: _BodyPadding(isMobile: isMobile, child: child),
                    ),
                  ),
                ),
                PositionedDirectional(
                  start: 0,
                  end: 0,
                  bottom: 0,
                  child: AnimatedVisibility.bottomNavigation(
                    visible: isMobile && floating,
                    child: _NavigationPadding(
                      child: NavigationDock(
                        destinations: [
                          for (final item in destinations)
                            NavigationDockDestination(
                              glyph: item.glyph,
                              label: item.label,
                            ),
                        ],
                        selectedIndex: selectedIndex,
                        onSelected: onSelected,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          AnimatedVisibility.bottomNavigation(
            visible: isMobile && !floating,
            child: _NavigationPadding(
              child: NavigationBar(
                destinations: [
                  for (final (index, item) in destinations.indexed)
                    NavigationDestination(
                      icon: AnimatedGlyph(
                        glyph: item.glyph,
                        filled: index == selectedIndex,
                      ),
                      label: item.label,
                    ),
                ],
                selectedIndex: selectedIndex,
                onDestinationSelected: onSelected,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BodyPadding extends StatelessWidget {
  const _BodyPadding({required this.isMobile, required this.child});

  final bool isMobile;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      removeTop: false,
      removeBottom: isMobile,
      removeLeft: isMobile,
      removeRight: isMobile,
      context: context,
      child: child,
    );
  }
}

class _NavigationPadding extends StatelessWidget {
  const _NavigationPadding({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      removeTop: true,
      removeBottom: false,
      removeLeft: true,
      removeRight: true,
      context: context,
      child: child,
    );
  }
}
