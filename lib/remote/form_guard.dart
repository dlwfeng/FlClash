part of 'main.dart';

class _RemoteFormGuard extends StatefulWidget {
  const _RemoteFormGuard({
    required this.controllers,
    required this.saving,
    required this.builder,
    this.hasChanges,
  });

  final List<TextEditingController> controllers;
  final bool saving;
  final bool Function()? hasChanges;
  final Widget Function(BuildContext context, VoidCallback onClose) builder;

  @override
  State<_RemoteFormGuard> createState() => _RemoteFormGuardState();
}

class _RemoteFormGuardState extends State<_RemoteFormGuard> {
  final _initial = <TextEditingController, String>{};
  ValueNotifier<SheetDismissHandler?>? _dismissHandler;
  Future<bool>? _confirmation;

  bool get _dirty =>
      widget.controllers.any(
        (controller) => controller.text != _initial[controller],
      ) ||
      (widget.hasChanges?.call() ?? false);

  @override
  void initState() {
    super.initState();
    _attach(widget.controllers);
  }

  void _attach(List<TextEditingController> controllers) {
    for (final controller in controllers) {
      _initial.putIfAbsent(controller, () => controller.text);
      controller.addListener(_changed);
    }
  }

  void _changed() {
    if (mounted) setState(() {});
  }

  @override
  void didUpdateWidget(covariant _RemoteFormGuard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!listEquals(oldWidget.controllers, widget.controllers)) {
      for (final controller in oldWidget.controllers) {
        controller.removeListener(_changed);
      }
      _attach(widget.controllers);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final handler = SheetDismissScope.of(context);
    if (!identical(handler, _dismissHandler)) {
      _releaseDismiss();
      _dismissHandler = handler?..value = _close;
    }
  }

  void _releaseDismiss() {
    if (_dismissHandler?.value == _close) _dismissHandler?.value = null;
  }

  Future<void> _close() async {
    await Navigator.of(context).maybePop();
  }

  Future<bool> _canClose(BuildContext context) async {
    if (widget.saving) return false;
    if (!_dirty) return true;
    final pending = _confirmation;
    if (pending != null) return pending;
    final l = AppLocalizations.of(context);
    final confirmation = showFloatingDialog<bool>(
      context: context,
      child: CommonDialog(
        title: l.discardChanges,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l.confirm),
          ),
        ],
      ),
    ).then((value) => value == true);
    _confirmation = confirmation;
    try {
      return await confirmation;
    } finally {
      _confirmation = null;
    }
  }

  @override
  void dispose() {
    _releaseDismiss();
    for (final controller in widget.controllers) {
      controller.removeListener(_changed);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final child = CommonPopScope(
      onPop: widget.saving || _dirty ? _canClose : null,
      child: Builder(
        builder: (context) =>
            widget.builder(context, () => unawaited(_close())),
      ),
    );
    return SheetProvider.of(
          context,
        )?.copyWith(onClose: () => unawaited(_close()), child: child) ??
        child;
  }
}
