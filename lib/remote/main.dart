import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:collection/collection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fl_clash/l10n/l10n.dart';
import 'package:fl_clash/l10n/ui.dart';
import 'package:fl_clash/ui/icons/icons.dart';
import 'package:fl_clash/ui/form_row.dart';
import 'package:fl_clash/ui/ui.dart';
import 'package:fl_clash/ui/navigation_frame.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, listEquals;
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'client.dart';
import 'proxies.dart';
import 'dashboard_page.dart';
import 'table_widths.dart';
import 'package:fl_clash/widgets/table_widths_source.dart';
import 'package:fl_clash/manager/status_manager.dart';
import 'package:fl_clash/widgets/feedback.dart';
import 'package:fl_clash/widgets/home_navigation_shell.dart';
import 'setting_labels.dart';

part 'views.dart';
part 'settings.dart';
part 'settings_section.dart';
part 'profile_form.dart';
part 'form_guard.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const RemoteApplication());
}

class RemoteApplication extends StatefulWidget {
  const RemoteApplication({super.key, this.client});

  final RemoteControlClient? client;

  @override
  State<RemoteApplication> createState() => _RemoteApplicationState();
}

class _RemoteApplicationState extends State<RemoteApplication> {
  late final _client = widget.client ?? RemoteControlClient();
  Timer? _timer;
  final _navigatorKey = GlobalKey<NavigatorState>();
  late final _widths = RemoteTableWidths(_client, (_) {
    final context = _navigatorKey.currentContext;
    if (context != null) showAppFeedback(context, AppLocalizations.of(context).remoteOperationFailed, level: MessageLevel.error);
  });

  @override
  void initState() {
    super.initState();
    unawaited(_client.refresh());
    _timer = Timer.periodic(const Duration(seconds: 2), (_) {
      unawaited(_client.refresh());
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _client.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [tableWidthsSourceProvider.overrideWithValue(_widths)],
      child: ListenableBuilder(
        listenable: _client,
        builder: (context, _) {
          final config = _map(_client.state?['config']);
          final theme = _map(config['themeProps']);
          final locale = _map(config['appSettingProps'])['locale'] as String?;
          final parts = locale?.split(RegExp('[-_]'));
          final seeds = _map(_client.state?['themeSeeds']);
          ThemeData appTheme(Brightness brightness) => buildAppTheme(
            colorScheme: seededColorScheme(
              seedColor: Color(
                (theme['primaryColor'] as num?)?.toInt() ??
                    (seeds[brightness.name] as num?)?.toInt() ??
                    0xff007aff,
              ),
              brightness: brightness,
              style:
                  ColorStyle.values.asNameMap()[theme['colorStyle']] ??
                  ColorStyle.vivid,
            ).toPureBlack(theme['pureBlack'] == true),
            platform: switch (_client.state?['platform']) { 'macos' => TargetPlatform.macOS, 'windows' => TargetPlatform.windows, 'linux' => TargetPlatform.linux, 'android' => TargetPlatform.android, _ => defaultTargetPlatform },
            locales: WidgetsBinding.instance.platformDispatcher.locales,
            fontFamily: theme['systemFontFamily'] as String?,
          );
          return MaterialApp(
            navigatorKey: _navigatorKey,
          title: 'FlClash',
            initialRoute: '/',
            onUnknownRoute: (_) => MaterialPageRoute<void>(
              settings: const RouteSettings(name: '/'),
              builder: (_) => _RemoteHome(client: _client),
            ),
            debugShowCheckedModeBanner: false,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              AppUiLocalizations.delegate,
              ...GlobalMaterialLocalizations.delegates,
            ],
            supportedLocales: AppLocalizations.delegate.supportedLocales,
            locale: parts == null || parts.first.isEmpty
                ? null
                : Locale(parts.first, parts.length > 1 ? parts[1] : null),
            theme: appTheme(Brightness.light),
            darkTheme: appTheme(Brightness.dark),
            themeMode: switch (theme['themeMode']) {
              'light' => ThemeMode.light,
              'dark' => ThemeMode.dark,
              _ => ThemeMode.system,
            },
            scrollBehavior: const BaseScrollBehavior(),
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.linear(
                  (_map(theme['textScale'])['enable'] == true
                          ? (_map(theme['textScale'])['scale'] as num?)
                                    ?.toDouble() ??
                                1
                          : MediaQuery.textScalerOf(context).scale(1))
                      .clamp(minTextScale, maxTextScale),
                ),
              ),
              child: Builder(
                builder: (context) => LayoutBuilder(
                  builder: (context, constraints) => ViewScope(
                    size: constraints.biggest,
                    isMobile: constraints.maxWidth <= 600,
                    child: MeasureScope(
                      measure: Measure.of(
                        context,
                        MediaQuery.textScalerOf(context).scale(1),
                      ),
                      child: SurfaceScope(
                        level: SurfaceLevel.page,
                        child: LiquidGlassScope(
                          enabled:
                              theme['liquidGlass'] != null &&
                              theme['liquidGlass'] != 'none',
                          quality: theme['liquidGlass'] == 'ultra'
                              ? LiquidGlassQuality.ultra
                              : LiquidGlassQuality.standard,
                          child: LiquidGlassHost(
                            enabled:
                                theme['liquidGlass'] != null &&
                                theme['liquidGlass'] != 'none',
                            child: StatusManager(
                              isMobile: constraints.maxWidth <= mobileNavigationMaxWidth,
                              topOffset: pageToolbarHeight,
                              child: child!,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            home: _RemoteHome(client: _client),
          );
        },
      ),
    );
  }
}

class _RemoteHome extends StatefulWidget {
  const _RemoteHome({required this.client});

  final RemoteControlClient client;

  @override
  State<_RemoteHome> createState() => _RemoteHomeState();
}

class _RemoteHomeState extends State<_RemoteHome> {
  final _secret = TextEditingController();
  int _page = 0;
  bool _expanded = true;

  RemoteControlClient get client => widget.client;
  AppLocalizations get l => AppLocalizations.of(context);
  Map<String, dynamic> get state => client.state ?? {};
  Map<String, dynamic> get config => _map(state['config']);
  bool get enabled =>
      !client.busy && client.error == null && state['ready'] == true;

  @override
  void dispose() {
    _secret.dispose();
    super.dispose();
  }

  Future<Object?> _run(Future<Object?> Function() action) async {
    try {
      final result = await action();
      if (result == false) throw StateError(l.remoteOperationFailed);
      return result;
    } catch (error) {
      if (mounted) {
        final message = error is DioException
            ? _map(error.response?.data)['error']?.toString() ??
                  l.remoteConnectionLost
            : error.toString();
        showAppFeedback(context, message, level: MessageLevel.error);
      }
      return null;
    }
  }

  Future<void> _command(
    String command, [
    Map<String, Object?> args = const {},
  ]) async {
    await _run(() => client.command(command, args));
  }

  @override
  Widget build(BuildContext context) {
    if (client.state == null) {
      return CommonScaffold(
        title: l.remoteControl,
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 16,
                children: [
                  Text(l.remoteConnectTip),
                  TextField(
                    controller: _secret,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: l.externalControllerSecret,
                    ),
                    onSubmitted: (_) => _connect(),
                  ),
                  if (client.error != null) Text(l.remoteConnectionLost),
                  FilledButton(onPressed: _connect, child: Text(l.connection)),
                ],
              ),
            ),
          ),
        ),
      );
    }
    final destinations = [
      SidebarDestination(glyph: AppGlyphs.dashboard, label: l.dashboard),
      SidebarDestination(glyph: AppGlyphs.proxies, label: l.proxies),
      SidebarDestination(glyph: AppGlyphs.profiles, label: l.profiles),
      SidebarDestination(glyph: AppGlyphs.connections, label: l.connections),
      SidebarDestination(glyph: AppGlyphs.requests, label: l.requests),
      const SidebarDestination(glyph: AppGlyphs.dns, label: 'DNS'),
      SidebarDestination(glyph: AppGlyphs.logs, label: l.logs),
      SidebarDestination(glyph: AppGlyphs.resources, label: l.resources),
      SidebarDestination(glyph: AppGlyphs.settings, label: l.settings),
    ];
    final mobile = MediaQuery.sizeOf(context).width <= mobileNavigationMaxWidth;
    final app = _map(config['appSettingProps']);
    final pages = mobile
        ? [0, 1, 2, 9]
        : [0, 1, 2, 3, if (app['openLogs'] == true) 6, 9];
    final allDestinations = [
      ...destinations,
      SidebarDestination(glyph: AppGlyphs.tools, label: l.tools),
    ];
    final shownDestinations = [
      for (final index in pages) allDestinations[index],
    ];
    final selected = pages.indexOf(_page);
    return Scaffold(
      body: SafeArea(
        child: NavigationFrame(
          hasSidebar: !mobile,
          sidebar: NavigationSidebar(
            destinations: shownDestinations,
            selectedIndex: selected < 0 ? pages.length - 1 : selected,
            expanded: MediaQuery.sizeOf(context).width > 840 && _expanded,
            onSelected: (index) => setState(() => _page = pages[index]),
            onToggle: MediaQuery.sizeOf(context).width > 840
                ? () => setState(() => _expanded = !_expanded)
                : null,
          ),
          child: HomeNavigationShell(
            isMobile: mobile,
            floating: app['floatingNavigationBar'] != false,
            destinations: [
              for (final item in shownDestinations)
                NavigationDockDestination(glyph: item.glyph, label: item.label),
            ],
            selectedIndex: selected < 0 ? pages.length - 1 : selected,
            onSelected: (index) => setState(() => _page = pages[index]),
            child: Column(
              children: [
                if (client.error != null)
                  MaterialBanner(
                    content: Text(l.remoteConnectionLost),
                    actions: [
                      TextButton(
                        onPressed: client.refresh,
                        child: Text(l.retry),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            client.state = null;
                            client.secret = '';
                          });
                        },
                        child: Text(l.externalControllerSecret),
                      ),
                    ],
                  ),
                if (client.busy && _page > 1) const LinearProgressIndicator(),
                Expanded(
                  child: switch (_page) {
                    0 => _dashboard(),
                    1 => _proxies(),
                    2 => _profiles(),
                    3 => _feed('/api/connections', l.connections),
                    4 => _feed('/api/requests', l.requests),
                    5 => _feed('/api/dns', 'DNS'),
                    6 => _feed('/api/logs', l.logs),
                    7 => _resources(),
                    8 => _settings(),
                    _ => _tools(),
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void selectPage(int page) => setState(() => _page = page);

  Future<void> _connect() async {
    if (_secret.text.isNotEmpty) client.secret = _secret.text.trim();
    await client.refresh();
  }

  Widget _pageView(
    String title,
    List<Widget> children, {
    List<IconButtonData> actions = const [],
  }) {
    return CommonScaffold(
      title: title,
      iconActions: actions,
      body: Builder(
        builder: (context) => ListView(
          padding: EdgeInsets.fromLTRB(
            16,
            context.contentTopPadding,
            16,
            16 + context.bottomInset,
          ),
          children: [
            for (final child in children)
              Padding(padding: const EdgeInsets.only(bottom: 12), child: child),
          ],
        ),
      ),
    );
  }
}

Map<String, dynamic> _map(Object? value) =>
    value is Map ? Map<String, dynamic>.from(value) : {};

List<Map<String, dynamic>> _maps(Object? value) => value is List
    ? value
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList()
    : [];
