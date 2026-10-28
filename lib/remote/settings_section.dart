part of 'main.dart';

class _RemoteSettingsSection extends StatelessWidget {
  const _RemoteSettingsSection({
    required this.client,
    required this.section,
    required this.title,
    this.path = const [],
  });

  final RemoteControlClient client;
  final String section;
  final String title;
  final List<String> path;

  Map<String, dynamic> _root() {
    final config = _map(client.state?['config']);
    if (section == 'davProps' && config[section] == null) {
      return {'uri': '', 'user': '', 'password': '', 'fileName': 'backup.zip'};
    }
    return _map(config[section]);
  }

  Map<String, dynamic> _values(Map<String, dynamic> root) {
    var values = root;
    for (final key in path) {
      values = _map(values[key]);
    }
    return values;
  }

  Future<void> _save(
    Map<String, dynamic> root,
    String key,
    Object? value,
  ) async {
    Map<String, dynamic> replace(Map<String, dynamic> values, int depth) => {
      ...values,
      if (depth == path.length)
        key: value
      else
        path[depth]: replace(_map(values[path[depth]]), depth + 1),
    };
    final next = replace(root, 0);
    final expected = _map(client.state?['config'])[section];
    if (expected != null &&
        !const DeepCollectionEquality().equals(root, expected)) {
      throw StateError(AppLocalizations.current.remoteSettingsConflict);
    }
    await client.patchSettings(section, next, expected);
  }

  Future<void> _edit(
    BuildContext context,
    Map<String, dynamic> root,
    String key,
    Object? value,
  ) async {
    final l = AppLocalizations.of(context);
    if (value is Map) {
      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => _RemoteSettingsSection(
            client: client,
            section: section,
            title: remoteSettingLabel(l, key),
            path: [...path, key],
          ),
        ),
      );
      return;
    }
    await Navigator.of(context).push(
      FormSheetRoute<void>(
        barrierLabel: l.close,
        barrierColor: Theme.of(context).colorScheme.modalScrim,
        builder: (_) => _RemoteValueForm(
          label: remoteSettingLabel(l, key),
          value: value,
          secret: const {'password', 'secret', 'ageSecretKey'}.contains(key),
          numeric:
              value is num ||
              const {'primaryColor', 'routing-mark'}.contains(key),
          choices: _choices(section, key),
          onSave: (value) => _save(root, key, value),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: client,
    builder: (context, _) {
      final l = AppLocalizations.of(context);
      final root = _root();
      final values = _values(root);
      final enabled = !client.busy && client.error == null;
      return CommonScaffold(
        title: title,
        body: Builder(
          builder: (context) => ListView(
            padding: EdgeInsets.fromLTRB(
              16,
              context.contentTopPadding,
              16,
              16 + context.bottomInset,
            ),
            children: [
              generateGroup([
                for (final entry in values.entries)
                  if (entry.key != 'acceptedDisclaimerVersion')
                    FormRow(
                      title: remoteSettingLabel(l, entry.key),
                      onPressed: entry.value is bool || !enabled
                          ? null
                          : () => _edit(context, root, entry.key, entry.value),
                      trailing: entry.value is bool
                          ? CommonSwitch(
                              value: entry.value as bool,
                              onChanged: !enabled
                                  ? null
                                  : (value) async {
                                      try {
                                        await _save(root, entry.key, value);
                                      } catch (error) {
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                l.remoteOperationFailed,
                                              ),
                                            ),
                                          );
                                        }
                                      }
                                    },
                            )
                          : Row(
                              mainAxisSize: MainAxisSize.min,
                              spacing: 8,
                              children: [
                                Flexible(
                                  child: Text(
                                    _summary(l, entry.key, entry.value),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const GlyphIcon(AppGlyphs.chevronForward),
                              ],
                            ),
                    ),
              ]),
            ],
          ),
        ),
      );
    },
  );

  static String _summary(AppLocalizations l, String key, Object? value) {
    if (const {'secret', 'password', 'ageSecretKey'}.contains(key)) {
      return '••••••';
    }
    if (value == null) return l.defaultText;
    if (value is Map) return '';
    if (value is List) return '${value.length}';
    return remoteSettingLabel(l, '$value');
  }

  static List<String>? _choices(String section, String key) => switch ((
    section,
    key,
  )) {
    ('themeProps', 'themeMode') => ['system', 'light', 'dark'],
    ('themeProps', 'colorStyle') => ['vivid', 'tinted', 'soft', 'monochrome'],
    ('themeProps', 'liquidGlass') => ['none', 'standard', 'ultra'],
    ('appSettingProps', 'tabAnimation') => ['fade', 'slide'],
    ('proxiesStyleProps', 'type') => ['list', 'tab'],
    ('proxiesStyleProps', 'sortType') => ['none', 'name', 'delay'],
    ('proxiesStyleProps', 'layout') => ['standard', 'loose', 'tight'],
    ('proxiesStyleProps', 'iconStyle') => ['filled', 'plain', 'hidden'],
    ('proxiesStyleProps', 'cardType') => ['standard', 'compact'],
    (_, 'mode') => ['rule', 'global', 'direct'],
    (_, 'log-level') => ['silent', 'error', 'warning', 'info', 'debug'],
    (_, 'stack') => ['system', 'gvisor', 'mixed'],
    (_, 'external-controller') => ['', '127.0.0.1:9090'],
    _ => null,
  };
}

class _RemoteValueForm extends StatefulWidget {
  const _RemoteValueForm({
    required this.label,
    required this.value,
    required this.onSave,
    this.secret = false,
    this.numeric = false,
    this.choices,
  });

  final String label;
  final Object? value;
  final bool secret;
  final bool numeric;
  final List<String>? choices;
  final Future<void> Function(Object? value) onSave;

  @override
  State<_RemoteValueForm> createState() => _RemoteValueFormState();
}

class _RemoteValueFormState extends State<_RemoteValueForm> {
  late final _strings =
      widget.value is List &&
      (widget.value as List).every((item) => item is String);
  late final _text = TextEditingController(
    text: widget.value == null
        ? ''
        : _strings
        ? (widget.value as List).join('\n')
        : widget.value is List
        ? const JsonEncoder.withIndent('  ').convert(widget.value)
        : '${widget.value}',
  );
  String? _choice;
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_saving) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final Object? value;
      if (widget.choices != null) {
        value = _choice ?? widget.value;
      } else if (_strings) {
        value = _text.text
            .split('\n')
            .where((line) => line.trim().isNotEmpty)
            .toList();
      } else if (widget.value is List) {
        value = jsonDecode(_text.text);
      } else if (widget.numeric) {
        value = _text.text.isEmpty && widget.value == null
            ? null
            : num.parse(_text.text);
      } else {
        value = _text.text.isEmpty && widget.value == null ? null : _text.text;
      }
      await widget.onSave(value);
      if (mounted) Navigator.pop(context);
    } catch (error) {
      if (mounted) {
        setState(
          () => _error = error is DioException
              ? _map(error.response?.data)['error']?.toString() ??
                    AppLocalizations.of(context).remoteOperationFailed
              : error.toString(),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return _RemoteFormGuard(
      controllers: [_text],
      saving: _saving,
      hasChanges: () => _choice != null && _choice != widget.value,
      builder: (context, onClose) => CommonScaffold(
        backAction: onClose,
        title: widget.label,
        confirmationAction: IconButtonData(
          glyph: AppGlyphs.check,
          tooltip: l.save,
          isLoading: _saving,
          onPressed: _saving ? null : _save,
        ),
        body: Builder(
          builder: (context) => SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              16,
              context.contentTopPadding,
              16,
              16 + context.bottomInset,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_error != null)
                  Text(
                    _error!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                generateGroup([
                  if (widget.choices case final choices?)
                    FormRow(
                      title: widget.label,
                      trailing: DropdownButton<String>(
                        isExpanded: true,
                        value: _choice ?? widget.value as String?,
                        items: [
                          for (final choice in choices)
                            DropdownMenuItem(
                              value: choice,
                              child: Text(
                                choice.isEmpty
                                    ? l.none
                                    : remoteSettingLabel(l, choice),
                              ),
                            ),
                        ],
                        onChanged: _saving
                            ? null
                            : (value) => setState(() => _choice = value),
                      ),
                    )
                  else if (widget.value is List)
                    TextField(
                      controller: _text,
                      maxLines: null,
                      autocorrect: false,
                      readOnly: _saving,
                      decoration: InputDecoration(labelText: widget.label),
                    )
                  else
                    FormRow(
                      title: widget.label,
                      trailing: widget.secret
                          ? FormRowSecretTextField(
                              controller: _text,
                              readOnly: _saving,
                            )
                          : FormRowTextField(
                              controller: _text,
                              readOnly: _saving,
                              autocorrect: false,
                              keyboardType: widget.numeric
                                  ? TextInputType.number
                                  : null,
                            ),
                    ),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
