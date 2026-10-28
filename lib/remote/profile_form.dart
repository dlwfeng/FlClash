part of 'main.dart';

class _RemoteProfileForm extends StatefulWidget {
  const _RemoteProfileForm({required this.client});

  final RemoteControlClient client;

  @override
  State<_RemoteProfileForm> createState() => _RemoteProfileFormState();
}

class _RemoteProfileFormState extends State<_RemoteProfileForm> {
  final _name = TextEditingController();
  final _url = TextEditingController();
  final _secret = TextEditingController();
  final _content = TextEditingController();
  bool _fromFile = false;
  bool _saving = false;
  String? _error;
  String? _fileName;
  Uint8List? _pickedBytes;

  @override
  void dispose() {
    _name.dispose();
    _url.dispose();
    _secret.dispose();
    _content.dispose();
    super.dispose();
  }

  Future<void> _pick() async {
    final file = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: ['yaml', 'yml', 'txt', 'conf', 'age'],
    );
    if (!mounted || file == null) return;
    try {
      final bytes = await file.readAsBytes();
      if (!mounted) return;
      try {
        _content.text = utf8.decode(bytes);
      } on FormatException {
        _content.clear();
      }
      if (_name.text.trim().isEmpty) _name.text = file.name;
      setState(() {
        _pickedBytes = bytes;
        _fileName = file.name;
        _error = null;
      });
    } catch (error) {
      if (mounted) setState(() => _error = error.toString());
    }
  }

  Future<void> _save() async {
    if (_saving) return;
    final l = AppLocalizations.of(context);
    if ((_fromFile ? _content.text : _url.text).trim().isEmpty &&
        (!_fromFile || _pickedBytes == null)) {
      setState(() => _error = _fromFile ? l.contentNotEmpty : l.invalidLinkTip);
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await widget.client.command('addProfile', {
        'label': _name.text.trim(),
        'ageSecretKey': _secret.text.trim(),
        if (_fromFile && _pickedBytes != null)
          'data': base64Encode(_pickedBytes!)
        else if (_fromFile)
          'content': _content.text
        else
          'url': _url.text.trim(),
      });
      if (mounted) Navigator.pop(context);
    } catch (error) {
      if (mounted) {
        setState(
          () => _error = error is DioException
              ? _map(error.response?.data)['error']?.toString() ??
                    l.remoteOperationFailed
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
      controllers: [_name, _url, _secret, _content],
      saving: _saving,
      builder: (context, onClose) => CommonScaffold(
        backAction: onClose,
        title: l.addProfile,
        confirmationAction: IconButtonData(
          glyph: AppGlyphs.check,
          tooltip: l.save,
          isLoading: _saving,
          onPressed: _saving ? null : _save,
        ),
        body: Builder(
          builder: (context) => ListView(
            padding: EdgeInsets.fromLTRB(
              16,
              context.contentTopPadding,
              16,
              16 + context.bottomInset,
            ),
            children: [
              if (_error != null)
                Text(
                  _error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              generateGroup([
                FormRow(
                  title: l.import,
                  trailing: DropdownButton<bool>(
                    value: _fromFile,
                    items: [
                      DropdownMenuItem(
                        value: false,
                        child: Text(l.importFromLink),
                      ),
                      DropdownMenuItem(value: true, child: Text(l.importFile)),
                    ],
                    onChanged: _saving
                        ? null
                        : (value) => setState(() => _fromFile = value!),
                  ),
                ),
                FormRow(
                  title: l.name,
                  trailing: FormRowTextField(
                    controller: _name,
                    autocorrect: false,
                    readOnly: _saving,
                  ),
                ),
                if (!_fromFile)
                  FormRow(
                    title: l.url,
                    trailing: FormRowTextField(
                      readOnly: _saving,
                      controller: _url,
                      autocorrect: false,
                    ),
                  ),
                FormRow(
                  title: l.ageSecretKey,
                  trailing: FormRowSecretTextField(
                    controller: _secret,
                    readOnly: _saving,
                  ),
                ),
                if (_fromFile)
                  FormRow(
                    title: l.file,
                    onPressed: _saving ? null : _pick,
                    trailing: Text(_fileName ?? l.importFile),
                  ),
              ]),
              if (_fromFile)
                TextField(
                  controller: _content,
                  onChanged: (_) => _pickedBytes = null,
                  maxLines: null,
                  readOnly: _saving,
                  autocorrect: false,
                  decoration: InputDecoration(labelText: l.content),
                  style: AppTextStyle.body
                      .of(context)
                      .copyWith(fontFamily: 'JetBrainsMono'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
