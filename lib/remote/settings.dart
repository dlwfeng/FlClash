part of 'main.dart';

extension _RemoteSettings on _RemoteHomeState {
  Widget _settings() {
    final sections = {
      'appSettingProps': l.general,
      'networkProps': l.network,
      'patchClashConfig': l.advancedConfig,
      'themeProps': l.theme,
      'proxiesStyleProps': l.proxies,
      'davProps': l.webDAVConfiguration,
    };
    return _pageView(l.settings, [
      for (final entry in sections.entries)
        CommonCard(
          onPressed: enabled
              ? () {
                  unawaited(
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => _RemoteSettingsSection(
                          client: client,
                          section: entry.key,
                          title: entry.value,
                        ),
                      ),
                    ),
                  );
                }
              : null,
          child: ListTile(
            title: Text(entry.value),
            trailing: const GlyphIcon(AppGlyphs.chevronForward),
          ),
        ),
    ]);
  }

  Future<void> _editText(
    String title,
    String value,
    Future<void> Function(String text)? onSave,
  ) {
    return Navigator.of(context).push(
      FormSheetRoute<void>(
        barrierLabel: l.close,
        barrierColor: Theme.of(context).colorScheme.modalScrim,
        builder: (context) =>
            _RemoteEditor(title: title, value: value, onSave: onSave),
      ),
    );
  }
}

class _RemoteEditor extends StatefulWidget {
  const _RemoteEditor({
    required this.title,
    required this.value,
    required this.onSave,
  });

  final String title;
  final String value;
  final Future<void> Function(String text)? onSave;

  @override
  State<_RemoteEditor> createState() => _RemoteEditorState();
}

class _RemoteEditorState extends State<_RemoteEditor> {
  late final _text = TextEditingController(text: widget.value);
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
      await widget.onSave!(_text.text);
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
      builder: (context, onClose) => CommonScaffold(
        backAction: onClose,
        title: widget.title,
        confirmationAction: widget.onSave == null
            ? null
            : IconButtonData(
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
                TextField(
                  controller: _text,
                  readOnly: widget.onSave == null || _saving,
                  maxLines: null,
                  autocorrect: false,
                  style: AppTextStyle.body
                      .of(context)
                      .copyWith(fontFamily: 'JetBrainsMono'),
                  decoration: InputDecoration(labelText: l.content),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
