part of 'main.dart';

extension _RemoteViews on _RemoteHomeState {
  Widget _dashboard() => RemoteDashboardPage(client: client);

  Widget _proxies() => RemoteProxiesPage(client: client);

  Widget _tools() => _pageView(l.tools, [
    for (final item in <(int, Glyph, String)>[
      (3, AppGlyphs.connections, l.liveConnections),
      (4, AppGlyphs.requests, l.recentRequests),
      (5, AppGlyphs.dns, l.dnsQueries),
      (6, AppGlyphs.logs, l.logs),
      (7, AppGlyphs.resources, l.resources),
      (8, AppGlyphs.settings, l.settings),
    ])
      DecorationListItem(
        leading: GlyphIcon(item.$2),
        title: Text(item.$3),
        onPressed: () => selectPage(item.$1),
      ),
  ]);

  Widget _profiles() => _pageView(
    l.profiles,
    [
      for (final profile in _maps(state['profiles']))
        CommonCard(
          isSelected: profile['id'] == config['currentProfileId'],
          onPressed: enabled
              ? () => _command('selectProfile', {'id': profile['id']})
              : null,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 8,
              children: [
                Row(
                  spacing: 8,
                  children: [
                    if (profile['id'] == config['currentProfileId'])
                      const GlyphIcon(AppGlyphs.check),
                    Expanded(
                      child: Text(
                        '${profile['label']}',
                        style: AppTextStyle.headline.of(context),
                      ),
                    ),
                  ],
                ),
                if ((profile['url'] as String?)?.isNotEmpty == true)
                  Text(
                    '${profile['url']}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    if (profile['type'] == 'url')
                      TextButton(
                        onPressed: enabled
                            ? () => _command('updateProfile', {
                                'id': profile['id'],
                              })
                            : null,
                        child: Text(l.update),
                      ),
                    TextButton(
                      onPressed: enabled ? () => _editProfile(profile) : null,
                      child: Text(l.edit),
                    ),
                    TextButton(
                      onPressed: enabled ? () => _deleteProfile(profile) : null,
                      child: Text(l.delete),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      FilledButton(
        onPressed: enabled ? _addProfile : null,
        child: Text(l.addProfile),
      ),
    ],
    actions: [
      IconButtonData(
        glyph: AppGlyphs.refresh,
        tooltip: l.update,
        onPressed: enabled ? () => _command('updateProfiles') : null,
      ),
    ],
  );

  Future<void> _deleteProfile(Map<String, dynamic> profile) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l.delete),
        content: Text('${profile['label']}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l.delete),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await _command('deleteProfile', {'id': profile['id']});
    }
  }

  Future<void> _editProfile(Map<String, dynamic> profile) async {
    final content = await _run(
      () => client.command('readProfile', {'id': profile['id']}),
    );
    if (!mounted || content is! String) return;
    await _editText('${profile['label']}', content, (text) async {
      await client.command('saveProfile', {
        'id': profile['id'],
        'content': text,
      });
    });
  }

  Future<void> _addProfile() async {
    await Navigator.of(context).push(
      FormSheetRoute<void>(
        barrierLabel: l.close,
        barrierColor: Theme.of(context).colorScheme.modalScrim,
        builder: (_) => _RemoteProfileForm(client: client),
      ),
    );
  }

  Widget _feed(String path, String title) => _RemoteFeed(
    key: ValueKey(path),
    client: client,
    path: path,
    title: title,
    onDetails: (value) => _editText(
      title,
      const JsonEncoder.withIndent('  ').convert(value),
      null,
    ),
    onClose: path == '/api/connections' && enabled
        ? (id) => _command('closeConnection', {'id': id})
        : null,
  );

  Widget _resources() => _RemoteFeed(
    key: const ValueKey('resources'),
    client: client,
    path: '/api/resources',
    title: l.resources,
    onDetails: (value) => _editText(
      l.resources,
      const JsonEncoder.withIndent('  ').convert(value),
      null,
    ),
    onRefresh: enabled ? () => _command('updateResources') : null,
  );
}

class _RemoteFeed extends StatefulWidget {
  const _RemoteFeed({
    super.key,
    required this.client,
    required this.path,
    required this.title,
    required this.onDetails,
    this.onClose,
    this.onRefresh,
  });

  final RemoteControlClient client;
  final String path;
  final String title;
  final ValueChanged<Map<String, dynamic>> onDetails;
  final ValueChanged<String>? onClose;
  final VoidCallback? onRefresh;

  @override
  State<_RemoteFeed> createState() => _RemoteFeedState();
}

class _RemoteFeedState extends State<_RemoteFeed> {
  Timer? _timer;
  List<Map<String, dynamic>>? _rows;
  Object? _error;
  bool _loading = false;
  String _search = '';

  @override
  void initState() {
    super.initState();
    unawaited(_refresh());
    _timer = Timer.periodic(
      Duration(seconds: widget.path == '/api/resources' ? 10 : 2),
      (_) => unawaited(_refresh()),
    );
  }

  Future<void> _refresh() async {
    if (_loading) return;
    _loading = true;
    try {
      final result = await widget.client.api('GET', widget.path);
      final rows = result is Map
          ? [
              for (final entry in result.entries)
                for (final row in _maps(entry.value))
                  {...row, 'category': entry.key},
            ]
          : _maps(result);
      if (mounted) {
        setState(() {
          _rows = rows;
          _error = null;
        });
      }
    } catch (error) {
      if (mounted) setState(() => _error = error);
    } finally {
      _loading = false;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final rows =
        _rows
            ?.where((row) => row.toString().toLowerCase().contains(_search))
            .toList() ??
        [];
    return CommonScaffold(
      title: widget.title,
      searchState: AppBarSearchState(
        onSearch: (value) => setState(() => _search = value.toLowerCase()),
      ),
      iconActions: [
        IconButtonData(
          glyph: AppGlyphs.refresh,
          tooltip: l.update,
          onPressed: widget.onRefresh ?? _refresh,
        ),
      ],
      isLoading: _rows == null && _error == null,
      body: Builder(
        builder: (context) => _error != null
            ? Center(
                child: TextButton(
                  onPressed: _refresh,
                  child: Text(l.remoteConnectionLost),
                ),
              )
            : ListView.builder(
                padding: EdgeInsets.fromLTRB(
                  16,
                  context.contentTopPadding,
                  16,
                  16 + context.bottomInset,
                ),
                itemCount: rows.length,
                itemBuilder: (context, index) {
                  final row = rows[index];
                  final metadata = _map(row['metadata']);
                  final title =
                      row['Payload'] ??
                      row['name'] ??
                      row['label'] ??
                      metadata['host'] ??
                      row['domain'] ??
                      row['id'] ??
                      row['category'] ??
                      '';
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: CommonCard(
                      onPressed: () => widget.onDetails(row),
                      child: ListTile(
                        title: Text(
                          '$title',
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          [
                            if (row['category'] != null) row['category'],
                            if (row['dateTime'] != null) row['dateTime'],
                            if (metadata['process'] != null)
                              metadata['process'],
                            if (row['chains'] is List)
                              (row['chains'] as List).join(' → '),
                          ].join(' · '),
                        ),
                        trailing: widget.onClose != null && row['id'] != null
                            ? IconButton(
                                tooltip: l.close,
                                onPressed: () =>
                                    widget.onClose!('${row['id']}'),
                                icon: const GlyphIcon(AppGlyphs.close),
                              )
                            : null,
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
