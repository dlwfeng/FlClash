import 'dart:js_interop';

@JS('window.sessionStorage.getItem')
external JSString? _getItem(JSString key);

@JS('window.sessionStorage.setItem')
external void _setItem(JSString key, JSString value);

@JS('window.history.replaceState')
external void _replaceState(JSAny? data, JSString title, JSString url);

@JS('window.history.state')
external JSAny? get _historyState;

String? readRemoteSecret() {
  final fragment = Uri.splitQueryString(Uri.base.fragment);
  final secret = fragment['secret'];
  if (secret != null) {
    storeRemoteSecret(secret);
    _replaceState(
      _historyState,
      ''.toJS,
      Uri.base.replace(fragment: '').toString().toJS,
    );
    return secret;
  }
  return _getItem('flclash.remote.secret'.toJS)?.toDart;
}

void storeRemoteSecret(String secret) {
  _setItem('flclash.remote.secret'.toJS, secret.toJS);
}
