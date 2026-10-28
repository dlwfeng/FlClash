# AI 执行手册：远程切换 mac-mini 的 FlClash（全命令行）

执行对象是接手部署的 AI。通过 Tailscale / SSH 在 `mac-mini` 上完成构建、机场数据备份、安装切换、验收和回退；不要求用户点击托盘、Finder、设置页或授权弹窗。

本次编写文档不等于执行安装。收到用户明确的部署或切换指令后再执行停机、替换和正常模式启动；已有授权不重复询问。项目默认的安全模式验证规则继续适用于普通开发验证。

## 目标与权限

| 项目 | 必须保留 / 达到的状态 |
| --- | --- |
| 代理 | 原来的 `127.0.0.1:7890`，原代理认证设置不变 |
| Core 控制 | 原来的 `127.0.0.1:9090`，原密钥不变 |
| Web 与应用 API | 新增 `0.0.0.0:9091`，远程地址 `http://mac-mini:9091/` |
| 机场数据 | 原订阅、订阅文件、规则、脚本、当前配置和节点选择保留 |
| 系统代理 / TUN | 沿用原设置；原来关闭就保持关闭 |
| 安装方式 | Release 替换 `/Applications/FlClash.app`，复用原数据目录 |

7890 是 HTTP / SOCKS 混合代理；9090 是内核控制接口；9091 不承载代理流量。
Web 与桌面操作同一个 Core。`0.0.0.0` 覆盖 Tailscale 及局域网 IPv4 网卡，API 仍要求密钥认证。
默认允许 Host `mac-mini`、`localhost`、`127.0.0.1`，同源访问无需 CORS 配置。

**不要预先要求 sudo。** 复制应用、启动普通代理和监听这三个端口不需要以 root 运行。
只需当前账号能写目标目录，并有已登录的 macOS 图形会话供 LaunchServices 启动应用。
TUN 授权、被防火墙拦截后的规则修改、目标目录不可写属于按需处理的权限问题，见末尾；不要为了安装而启用系统代理或 TUN。
当前读取到旧版自动运行为开启、系统代理和 TUN 为关闭；部署时必须重新检查，不能把本次检查结果当作永久状态。

Release 的 Bundle ID 是 `com.follow.clash`，数据目录是 `~/Library/Application Support/com.follow.clash`。
Debug 的 Bundle ID 和数据目录不同，不用于本次替换。安全模式不启动 Core 和 9091，也不能作为实际安装产物。
只允许一个普通版本占用原端口；切换期间旧 TCP 连接会中断，新版就绪后客户端重连即可，不改客户端地址。

## 1. 连接：所有后续安装命令都在 mac-mini 执行

AI 若已在 `/Users/dingliwei/workspace/FlClash` 所在的 Mac 上工作，直接开启 Bash，不要 SSH 到自己：

```bash
/bin/bash
```

AI 若在另一台机器，使用现有 SSH 凭据连接，不通过 7890 转发 SSH：

```bash
ssh -o ConnectTimeout=10 -t dingliwei@mac-mini /bin/bash
```

这要求 SSH 已可用；连接失败先报告具体原因，不假定 Tailscale 在线就代表 SSH 已启用。
Tailscale 客户端需能解析 `mac-mini`，并允许 SSH 和 TCP 9091；不用开启 Funnel 或公网端口转发。
参考：[MagicDNS](https://tailscale.com/docs/features/magicdns)、[设备间连接](https://tailscale.com/docs/how-to/connect-to-devices)。

## 2. 预检与准备：此时旧版继续运行

以下代码块按顺序在同一 Bash 会话执行。失败即停止，不继续执行下一块。

```bash
set -euo pipefail
umask 077
test "$(uname -s)" = Darwin
test "$(id -un)" = dingliwei
test "$(stat -f '%Su' /dev/console)" = dingliwei
export flclash_repo=/Users/dingliwei/workspace/FlClash
export flclash_target=/Applications/FlClash.app
export flclash_data="$HOME/Library/Application Support/com.follow.clash"
export flclash_source="$flclash_repo/build/macos/Build/Products/Release/FlClash.app"
export flclash_run="$HOME/FlClash-deployments/$(date +%Y%m%d-%H%M%S)"
mkdir -p "$flclash_run"
cd "$flclash_repo"
test -w /Applications
test -d "$flclash_target"
test -d "$flclash_data"
command -v python3
command -v sqlite3
/usr/libexec/ApplicationFirewall/socketfilterfw --getglobalstate
ps -axo pid,ppid,comm | awk '$3 ~ /FlClash/ {print}'
lsof -nP -iTCP:7890 -sTCP:LISTEN || true
lsof -nP -iTCP:9090 -sTCP:LISTEN || true
lsof -nP -iTCP:9091 -sTCP:LISTEN || true
scutil --proxy > "$flclash_run/proxy-before.txt"
defaults export com.follow.clash "$flclash_run/preferences-before.plist"
python3 - <<'PY'
import json, os, pathlib, plistlib
p = plistlib.loads((pathlib.Path(os.environ['flclash_run']) / 'preferences-before.plist').read_bytes())
raw = p.get('flutter.config', p.get('config'))
c = json.loads(raw) if isinstance(raw, str) else raw
assert isinstance(c, dict), '原配置无法读取，停止部署'
assert c['appSettingProps']['autoRun'], '原版未开启自动运行，需先制定无 GUI 的代理恢复方案'
assert not c['networkProps']['systemProxy'], '系统代理状态与本手册场景不同，停止部署'
assert not c['patchClashConfig']['tun']['enable'], 'TUN 状态与本手册场景不同，停止部署'
print('PASS：原版自动运行开启，系统代理和 TUN 关闭，无需 TUN 提权')
PY
```

`/dev/console` 不是 `dingliwei` 时，不以 root 启动应用，不在其他用户目录初始化空机场配置。
目录不可写时，在停旧版之前处理权限；不要先退出再发现无法安装。

若需要从当前源码重建，在旧版仍运行时执行；已有对应源码的合格 Release 包可跳过构建：

```bash
cd "$flclash_repo"
export PATH="/Users/dingliwei/flutter/bin:$PATH"
export PUB_HOSTED_URL=https://pub.dev
export FLUTTER_STORAGE_BASE_URL=https://storage.googleapis.com
flutter --version
bash tool/flutter_locked.sh pub get
bash tool/flutter_locked.sh analyze --no-fatal-infos
bash tool/flutter_locked.sh test test/remote test/lint
bash tool/build_remote_web.sh
bash tool/flutter_locked.sh build macos --release
```

依赖为 Flutter 3.47.x、本机 Xcode、Go 工具链、rustup / Cargo；`pubspec.yaml` 的两个 `build_assets` 都必须为 `true`。
不要执行 `flutter pub upgrade`，不要在安装构建中设置 `SAFE_MODE=true`。
远程安装直接使用 `.app`，无需 DMG。如果另需分发包，命令是 `dart setup.dart macos --env stable --targets dmg`，输出到 `dist/`。

先复制并校验待安装包，再停旧版，避免网络下载或构建失败占用停机时间：

```bash
test -x "$flclash_source/Contents/MacOS/FlClash"
test -x "$flclash_source/Contents/MacOS/FlClashCore"
test -f "$flclash_source/Contents/Resources/remote-web/index.html"
codesign --verify --deep --strict "$flclash_source"
ditto "$flclash_source" "$flclash_run/new.app"
codesign --verify --deep --strict "$flclash_run/new.app"
cmp "$flclash_repo/build/remote-web/main.dart.js" \
  "$flclash_run/new.app/Contents/Resources/remote-web/main.dart.js"
test "$(/usr/libexec/PlistBuddy -c 'Print :CFBundleIdentifier' "$flclash_run/new.app/Contents/Info.plist")" = com.follow.clash
printf 'export flclash_run=%q\n' "$flclash_run" > "$HOME/FlClash-deployments/current.env"
declare -p flclash_repo flclash_target flclash_data flclash_source >> "$HOME/FlClash-deployments/current.env"
```

后续断线或换终端，重连后先运行以下命令恢复路径，检查部署目录已有文件，**不要重跑新建部署目录或重复覆盖备份**：

```bash
source "$HOME/FlClash-deployments/current.env"
ls -l "$flclash_run"
```

## 3. 记录目标 PID 和端口归属，再优雅退出

只记录并操作准确路径对应的 PID。禁止 `killall FlClash`、`pkill -f FlClash` 或按名称关闭所有同名实例。

```bash
export flclash_old_pid="$(ps -axo pid=,comm= | awk '$2=="/Applications/FlClash.app/Contents/MacOS/FlClash" {print $1}')"
[[ "$flclash_old_pid" =~ ^[0-9]+$ ]]
ps -p "$flclash_old_pid" -o pid=,ppid=,comm= > "$flclash_run/old-process.txt"
ps -axo pid=,ppid=,comm= | awk -v p="$flclash_old_pid" \
  '$2==p && $3=="/Applications/FlClash.app/Contents/MacOS/FlClashCore" {print $1}' \
  > "$flclash_run/old-core-pid.txt"
[[ "$(cat "$flclash_run/old-core-pid.txt")" =~ ^[0-9]+$ ]]
printf '%s\n' "$flclash_old_pid" > "$flclash_run/old-pid.txt"
for flclash_port in 7890 9090; do
  lsof -t -nP -iTCP:"$flclash_port" -sTCP:LISTEN | sort -u > "$flclash_run/port-$flclash_port-owner.txt"
  cmp "$flclash_run/old-core-pid.txt" "$flclash_run/port-$flclash_port-owner.txt"
done
if lsof -t -nP -iTCP:9091 -sTCP:LISTEN >/dev/null; then
  echo '9091 已被占用，停止部署并调查归属' >&2
  exit 1
fi
test "$(ps -p "$flclash_old_pid" -o comm= | xargs)" = /Applications/FlClash.app/Contents/MacOS/FlClash
kill -TERM "$flclash_old_pid"
for flclash_wait in {1..30}; do
  if ! kill -0 "$flclash_old_pid" 2>/dev/null; then break; fi
  sleep 1
done
if kill -0 "$flclash_old_pid" 2>/dev/null; then
  echo '旧进程未退出，停止部署' >&2
  exit 1
fi
for flclash_port in 7890 9090 9091; do
  if lsof -t -nP -iTCP:"$flclash_port" -sTCP:LISTEN >/dev/null; then
    echo "端口 $flclash_port 未释放，停止安装" >&2
    exit 1
  fi
done
```

项目接收 SIGTERM 并进入与退出菜单相同的清理路径，保存设置、关闭 Core，并撤销自身网络状态。
旧包来源不明或未实现该行为时，必须以 PID 消失及端口释放的实测结果为准；超时不改用 `kill -9`，不手动杀残留 Core 后继续安装。
上面的归属检查针对当前旧版已运行且使用 7890、9090 的场景；若实际状态不同，AI 应先记录并解释差异，再调整检查，不能直接删除失败断言。

## 4. 离线备份完整机场数据和偏好设置

旧版退出后再复制数据库目录；不在应用运行时复制 SQLite 主文件冒充一致性备份。
机场信息不只在 YAML 中，还在数据库和 macOS 偏好设置里。全部保存在用户私有部署目录，不提交仓库，不输出订阅 URL、密码或密钥。

```bash
ditto "$flclash_target" "$flclash_run/old.app"
ditto "$flclash_data" "$flclash_run/data"
defaults export com.follow.clash "$flclash_run/preferences.plist"
sqlite3 -readonly "$flclash_run/data/database.sqlite" 'PRAGMA integrity_check;'
test "$(sqlite3 -readonly "$flclash_run/data/database.sqlite" 'PRAGMA integrity_check;')" = ok
codesign --verify --deep --strict "$flclash_run/old.app"
```

记录可供验收的基线，只输出数量，不泄露机场链接：

```bash
python3 - <<'PY'
import json, os, pathlib, plistlib, sqlite3
run = pathlib.Path(os.environ['flclash_run'])
prefs = plistlib.loads((run / 'preferences.plist').read_bytes())
raw = prefs.get('flutter.config', prefs.get('config'))
config = json.loads(raw) if isinstance(raw, str) else raw
assert isinstance(config, dict), '找不到旧版应用配置，停止安装'
assert config['patchClashConfig']['mixed-port'] == 7890
assert config['patchClashConfig'].get('secret'), '缺少原控制器密钥，停止安装'
with sqlite3.connect(f'file:{run / "data/database.sqlite"}?mode=ro', uri=True) as db:
    rows = db.execute('SELECT id, type, label, url, age_secret_key, selected_map FROM profiles ORDER BY id').fetchall()
assert rows, '旧版机场基线为空，停止安装并核查用户及数据目录'
(run / 'expected-config.json').write_text(json.dumps(config))
(run / 'expected-profiles.json').write_text(json.dumps(rows))
print('机场记录基线数量：', len(rows))
PY
```

Release 复用原目录就是迁移方式：**保留原数据原位，不重新创建机场、不下载一份空配置覆盖它**。
这份离线副本还保留本地规则、脚本、订阅缓存等，用于完整回退。

## 5. 安装与启动：保留原配置，命令启动应用

```bash
test -d "$flclash_run/old.app"
test -f "$flclash_run/expected-config.json"
test ! -e "$flclash_run/replaced.app"
mv "$flclash_target" "$flclash_run/replaced.app"
ditto "$flclash_run/new.app" "$flclash_target"
codesign --verify --deep --strict "$flclash_target"
open "$flclash_target"
```

`open` 是命令行调用 LaunchServices，不要求用户打开 Finder。不以 root 运行桌面应用。
先移走旧包再复制，避免新旧 `.app` 文件合并；数据目录保持原位，机场、原密钥和设置由新版读取。
如果此步失败，直接执行第 8 节回退，不在半安装状态继续启动。

立即记录新 PID，后续只能用它停止本次部署启动的进程：

```bash
for flclash_wait in {1..30}; do
  flclash_new_pid="$(ps -axo pid=,comm= | awk '$2=="/Applications/FlClash.app/Contents/MacOS/FlClash" {print $1}')"
  if [[ "$flclash_new_pid" =~ ^[0-9]+$ ]]; then break; fi
  sleep 1
done
[[ "$flclash_new_pid" =~ ^[0-9]+$ ]]
printf '%s\n' "$flclash_new_pid" > "$flclash_run/new-pid.txt"
ps -p "$flclash_new_pid" -o pid=,ppid=,comm=
```

## 6. 本机自动验收：不打开设置页，不手动输入密钥

从离线备份在内存中读取原密钥，直接调用新 API；密钥不进入 shell 参数、日志或聊天。
如果旧版正在提供 7890 而新版未自动恢复运行，只请求恢复代理运行，不修改系统代理、TUN 或端口设置。

```bash
python3 - <<'PY'
import json, os, pathlib, sqlite3, time, urllib.request
run = pathlib.Path(os.environ['flclash_run'])
expected = json.loads((run / 'expected-config.json').read_text())
secret = expected['patchClashConfig']['secret']
opener = urllib.request.build_opener(urllib.request.ProxyHandler({}))
def api(path, payload=None):
    req = urllib.request.Request(
        'http://127.0.0.1:9091' + path,
        data=None if payload is None else json.dumps(payload).encode(),
        headers={'Authorization': 'Bearer ' + secret, 'Content-Type': 'application/json'},
    )
    with opener.open(req, timeout=10) as response:
        return json.load(response)['data']
state = None
for _ in range(60):
    try:
        state = api('/api/state')
        if state.get('ready'): break
    except (OSError, ValueError):
        pass
    time.sleep(1)
assert state and state.get('ready'), '9091 未就绪，执行回退'
assert not state.get('safeMode'), '安装了安全模式包，执行回退'
if not state.get('running'):
    api('/api/command', {'command': 'running', 'value': True})
    state = api('/api/state')
assert state.get('running'), '未恢复代理运行，执行回退'
config = state['config']
assert config['patchClashConfig']['mixed-port'] == 7890
assert config['patchClashConfig']['secret'] == secret
assert config['patchClashConfig']['external-controller'] == expected['patchClashConfig']['external-controller']
assert config['networkProps'] == expected['networkProps'], '原网络设置被改变'
assert config['patchClashConfig']['tun'] == expected['patchClashConfig']['tun'], '原 TUN 设置被改变'
assert str(config['currentProfileId']) == str(expected['currentProfileId'])
rows = json.loads((run / 'expected-profiles.json').read_text())
assert {str(row[0]) for row in rows} == {str(p['id']) for p in state['profiles']}
with sqlite3.connect(f'file:{os.environ["flclash_data"]}/database.sqlite?mode=ro', uri=True) as db:
    current = db.execute('SELECT id, type, label, url, age_secret_key, selected_map FROM profiles ORDER BY id').fetchall()
assert [list(row) for row in current] == rows, '机场订阅或节点选择不一致，检查后回退'
print('PASS：原机场、节点选择、端口、密钥及网络设置保留；代理已恢复运行')
PY
lsof -nP -iTCP:7890 -sTCP:LISTEN
lsof -nP -iTCP:9090 -sTCP:LISTEN
lsof -nP -iTCP:9091 -sTCP:LISTEN
test "$(curl --noproxy '*' -s -o /dev/null -w '%{http_code}' http://127.0.0.1:9091/)" = 200
test "$(curl --noproxy '*' -s -o /dev/null -w '%{http_code}' http://127.0.0.1:9091/api/state)" = 401
```

核对 lsof：7890、9090 的持有者为同一个新 Core；9091 的持有者是记录的新桌面 PID，监听地址显示 `*:9091`。
不要仅凭“进程存在”宣布部署成功。不要测试时自动换节点或更新订阅，避免改变用户状态。

## 7. Tailscale 验收与交付

AI 在**另一台已接入 tailnet 的机器**执行以下命令；在 mac-mini 上自连不能代替跨设备验收：

```bash
curl --noproxy '*' --connect-timeout 10 -s -o /dev/null -w '%{http_code}\n' http://mac-mini:9091/
curl --noproxy '*' --connect-timeout 10 -s -o /dev/null -w '%{http_code}\n' http://mac-mini:9091/api/state
```

预期依次为 200、401。`--noproxy '*'` 只让本次请求直连，避免终端代理变量把 Tailscale 请求绕回 7890。
若 AI 没有第二台机器的执行权限，明确报告“本机验收通过，跨设备未验证”，不能虚报远程验收通过。
成功后在 Mac 上记录结果：

```bash
printf 'local verification passed\n' > "$flclash_run/local-verified.txt"
```

交付用户：`http://mac-mini:9091/`、验证范围、机场数量、备份目录、安装路径和当前 PID；不发送原密钥或机场链接。
本次只默认放行短主机名。若用户另需完整域名 / IP，使用 `FLCLASH_WEB_HOSTS` 精确配置，不放开任意 Host，不用 `*` CORS。
此环境变量需在真正启动应用的进程环境中生效，不能假定给 SSH 的 `open` 设置变量就会传入 LaunchServices 启动的应用。

Web 仍未达到全部页面/功能同码；不要将“安装成功”表述为“所有 Web 功能均已与桌面一致”。

## 8. 命令行回退：失败后由 AI 执行，不让用户点旧应用

重连后先恢复 `current.env`。若本次新版已启动，仅停止 `new-pid.txt` 记录且路径仍匹配的 PID：

```bash
source "$HOME/FlClash-deployments/current.env"
if test -f "$flclash_run/new-pid.txt"; then
  flclash_failed_pid="$(cat "$flclash_run/new-pid.txt")"
  if kill -0 "$flclash_failed_pid" 2>/dev/null; then
    test "$(ps -p "$flclash_failed_pid" -o comm= | xargs)" = /Applications/FlClash.app/Contents/MacOS/FlClash
    kill -TERM "$flclash_failed_pid"
    for flclash_wait in {1..30}; do
      if ! kill -0 "$flclash_failed_pid" 2>/dev/null; then break; fi
      sleep 1
    done
    if kill -0 "$flclash_failed_pid" 2>/dev/null; then
      echo '新版进程未退出，停止回退并报告' >&2
      exit 1
    fi
  fi
fi
for flclash_port in 7890 9090 9091; do
  if lsof -t -nP -iTCP:"$flclash_port" -sTCP:LISTEN >/dev/null; then
    echo "端口 $flclash_port 未释放，停止回退并核对进程归属" >&2
    exit 1
  fi
done
test -d "$flclash_run/old.app"
test -d "$flclash_run/data"
test -f "$flclash_run/preferences.plist"
if test -e "$flclash_target"; then
  mv "$flclash_target" "$flclash_run/failed.app"
fi
ditto "$flclash_run/old.app" "$flclash_target"
if test -e "$flclash_data"; then
  mv "$flclash_data" "$flclash_run/data-after-failure"
fi
ditto "$flclash_run/data" "$flclash_data"
defaults import com.follow.clash "$flclash_run/preferences.plist"
open "$flclash_target"
```

第 2 节已验证原版自动运行开启，因此恢复偏好设置并命令启动后应自行恢复 7890、9090。用以下命令验收，不改原设置：

```bash
for flclash_wait in {1..60}; do
  if lsof -t -nP -iTCP:7890 -sTCP:LISTEN >/dev/null && \
     lsof -t -nP -iTCP:9090 -sTCP:LISTEN >/dev/null; then break; fi
  sleep 1
done
lsof -nP -iTCP:7890 -sTCP:LISTEN
lsof -nP -iTCP:9090 -sTCP:LISTEN
ps -axo pid,ppid,comm | awk '$3 ~ /FlClash/ {print}'
```

若未恢复，报告具体进程和端口状态，不宣布回退成功，不以修改内核端口或开启系统代理冒充恢复。
旧版没有本项目新增 9091，不能用 9091 成功作为回退验收条件。
如果中断发生在完整备份之前，不执行缺少备份的回退代码；先保留现状，明确报告当前停在哪一步。
同一部署目录的回退只执行一次，已有 `failed.app` / `data-after-failure` 时先核对状态，不能覆盖它们。

## 9. 按需权限处理，全部使用命令

### 应用目录不可写

只有第 2 节 `test -w /Applications` 失败时才涉及安装权限。AI 先检查现有非交互 sudo 权限：

```bash
sudo -n true
```

失败就报告“当前账号无目标目录写权限且无可用的管理员授权”，在停止旧版前结束；不要求用户点 GUI，也不向聊天索取密码。
已有管理员授权时，可把应用包移动和复制命令按需改为 `sudo -n mv` / `sudo -n ditto`；备份数据和 `defaults` 仍以 `dingliwei` 执行。
不要 `sudo open`，不要把用户数据目录改成 root 所有。

### macOS 防火墙确实拦截 9091

先用第 2 节读到的防火墙状态判断，不默认修改规则。仅在本机 200 / 401 正常、远程连通已检查且确需放行应用时，使用已有管理员授权执行：

```bash
sudo -n /usr/libexec/ApplicationFirewall/socketfilterfw --add /Applications/FlClash.app/Contents/MacOS/FlClash
sudo -n /usr/libexec/ApplicationFirewall/socketfilterfw --unblockapp /Applications/FlClash.app/Contents/MacOS/FlClash
```

不关闭整个防火墙，不修改 tailnet ACL 来绕过权限；没有授权就报告该阻塞项。

### TUN 原本已开启

普通端口代理不需要此步骤。仅原设置已使用 TUN、需要按现有机制授权新 Core 且具备相应管理员授权时，项目对应的命令为：

```bash
sudo -n chown root:admin /Applications/FlClash.app/Contents/MacOS/FlClashCore
sudo -n chmod 4750 /Applications/FlClash.app/Contents/MacOS/FlClashCore
```

应在首次启动新版之前处理，避免弹出交互授权框；不为了通过检查而改动原 TUN 开关。
原来未开系统代理 / TUN 时不执行本节，也不把提权设为本次部署前提。
