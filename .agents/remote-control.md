# Desktop Web Control

## Mandatory UI/UX Parity

User requirement confirmed on 2026-10-28; this is an implementation and acceptance constraint.

- Web and desktop use the same Flutter UI source: complete pages, navigation, responsive layouts, cards, forms,
  dialogs, sheets, menus, and feedback. Reusing colors, typography and a few base components alone is insufficient.
- Preserve the existing desktop UI/UX. At equal logical viewport dimensions, locale, text scale, theme, settings and
  equivalent data, both clients must render the same content, geometry, ordering and visual states. Both use the same
  responsive breakpoints; a narrow browser follows the existing narrow-window layout.
- Interaction and animation must also be identical: navigation transitions, gestures, hover and focus behavior,
  selection, scrolling, modal presentation, loading/error feedback, curves, durations and reduced-motion behavior.
  Share their implementations; do not maintain Web-specific approximations.
- Platform differences belong behind data and action interfaces. The desktop adapter owns local providers, files,
  database and plugins; the Web adapter uses authenticated remote APIs. Native dependencies are a reason to extract
  the shared UI, never a reason to create a separate simplified page.
- A function genuinely blocked on Web may remain unimplemented temporarily. Keep its original UI and allow the
  original interaction to reach an explicit localized error explaining that the function is unavailable on Web.
  Do not hide or disable the control, replace the page with a placeholder/JSON editor, or silently do nothing to avoid
  implementing the backend. Authentication and actual domain-state restrictions still apply consistently to both clients.
- Compare both clients at matching viewports and states, including intermediate animation frames and opened overlays.
  Exercise shared controls against both adapters and verify unavailable actions produce the promised error.
- A migration may proceed page by page, but unmigrated pages remain outstanding work. Do not report full parity
  while separate Web page implementations or unmatched interactions/animations remain.
- Changing this requirement requires an explicit user instruction; implementation convenience, platform limitations
  and time estimates do not authorize weakening it.

The desktop application owns the authenticated HTTP server on `0.0.0.0:9091`.
It accepts `mac-mini`, `localhost` and `127.0.0.1` by default;
`FLCLASH_WEB_HOSTS` adds exact hostnames or IPv4 addresses (comma-separated, no
scheme or port). Same-origin HTTP requests for these hosts are accepted.
The install, subscription migration and rollback guide is
[`docs/macos-web-install.md`](../docs/macos-web-install.md).
It starts after application initialization and closes through `SystemAction`'s
exit cleanup. Safe mode never binds it. Port conflicts leave the other listener
alone and disable the Web-control entry in General settings.

The existing optional mihomo controller remains on `127.0.0.1:9090`. The Web
client uses only 9091. Application operations reach the existing action
providers and `CoreController`, preserving desktop lifecycle ownership, config
application and selection persistence. There is no second Core process.

## Development

```bash
bash tool/flutter_locked.sh pub get
dart run intl_utils:generate
bash tool/build_remote_web.sh
```

After starting the desktop application, open General → Web control. The link
carries the existing controller secret in its fragment. The browser removes
that fragment and remembers the secret only in session storage. Opening
`http://127.0.0.1:9091` directly asks for the same secret. A changed controller
secret also changes 9091 authentication. It works with the 9090 controller off.

For a separate Flutter Web development server:

```bash
FLCLASH_WEB_ORIGINS=http://localhost:7357 flutter run -d macos
flutter run -d chrome --web-port 7357 --target lib/remote/main.dart \
  --dart-define=REMOTE_ENDPOINT=http://127.0.0.1:9091
```

Only the user may run that normal desktop command. Agents must use safe mode,
which leaves both controller ports free and does not start the Web server.
For a remote development server, explicitly allow its exact browser origin via
`FLCLASH_WEB_ORIGINS` on the Mac. The browser must be able to reach the Mac's
service. Tailscale clients can use `http://mac-mini:9091/` directly with
MagicDNS and network access to TCP 9091. Browser local-network permission and
HTTPS mixed-content rules also apply. No wildcard CORS is enabled. Binding all
IPv4 interfaces also exposes the listener to LAN interfaces; retain authentication
and control access through the host firewall and tailnet policy.

Static files are read from `FLCLASH_WEB_ROOT`, `remote-web` beside the executable,
`Contents/Resources/remote-web` in a macOS bundle, or `build/remote-web` in the
working directory. Only files resolved within those directories are served.
To include a built client in an existing macOS bundle:

```bash
bash tool/build_remote_web.sh /path/to/FlClash.app
```

Copy before signing the bundle. The script uses `tool/flutter_locked.sh` to enforce the existing dependency lock before building,
then builds with `--no-pub`. A lock mismatch prevents copying deployment assets. The script does not launch or stop any app.
`dart setup.dart macos` builds the Web client before packaging; the Xcode embed
phase includes `build/remote-web` in the app resources before signing. A direct
`flutter build macos` includes the Web assets when that directory exists.

## Boundaries

The Web entry point imports the shared `lib/ui` components and pure localization
adapter, rather than the native app bootstrap. Existing native page classes
still depend on filesystem, database and plugin access. The legacy Web feature views are
currently separate: dashboard, proxy selection/probes, profiles and YAML editing,
connection management, request/DNS/log inspection, resource inspection/update,
and settings-section editing. This is an outstanding violation of the parity requirement above, not an approved
architecture or acceptance exception. This is not full page-level or feature parity:
settings reuse desktop FormRow inputs, with nested sections, switches and choice
fields; structured lists still use JSON. Individual resource editors, backup/restore, QR flows,
and desktop integrations have not been adapted to the browser.

All `/api/` paths require the controller secret as a bearer token. The server
checks Host and Origin, limits JSON bodies, and never exposes arbitrary paths,
raw IPC dispatch, shell commands, or general filesystem deletion. Profile file
operations resolve an existing profile ID. Large JSON responses are encoded in
an isolate; integers outside JavaScript's safe range, including Snowflake IDs,
travel as strings. Settings writes carry the previous section value and reject
a stale write with HTTP 409.
