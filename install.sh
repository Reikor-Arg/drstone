#!/bin/sh
# Dr. Stone - macOS and Linux installer
# Usage:  curl -fsSL https://raw.githubusercontent.com/Reikor-Arg/drstone/master/install.sh | sh
set -e

DIR="$HOME/.claude"
FILE="$DIR/settings.json"
REC='echo DRSTONE: keep answers short. NEVER: filler, pleasantries, narrating tool calls, unrequested extras. Code and errors verbatim.'

mkdir -p "$DIR"
[ -f "$FILE" ] || echo '{}' > "$FILE"

# Back up before touching anything: this file usually holds the user own permissions and hooks.
BACKUP="$FILE.bak-$(date +%Y%m%d-%H%M%S)"
cp "$FILE" "$BACKUP"
echo "Backup: $BACKUP"

if ! command -v python3 >/dev/null 2>&1; then
  echo ""
  echo "No python3 found, which is the only thing here that can edit the JSON safely."
  echo "Paste this by hand into $FILE, inside \"hooks\":"
  echo ""
  echo '  "UserPromptSubmit": [ { "hooks": [ { "type": "command", "command": "'"$REC"'", "timeout": 5 } ] } ]'
  exit 1
fi

REC="$REC" FILE="$FILE" python3 - <<'PY'
import json, os

path = os.environ['FILE']
rec = os.environ['REC']

with open(path, encoding='utf-8') as f:
    data = json.load(f) or {}

hooks = data.setdefault('hooks', {})
# Keep whatever hooks were already there, except a previous install of this one.
previos = [h for h in hooks.get('UserPromptSubmit', []) if 'DRSTONE ON' not in json.dumps(h)]
previos.append({'hooks': [{'type': 'command', 'command': rec, 'timeout': 5}]})
hooks['UserPromptSubmit'] = previos

with open(path, 'w', encoding='utf-8') as f:
    json.dump(data, f, indent=2, ensure_ascii=False)
PY

echo ""
echo "Dr. Stone installed."
echo "Quit and reopen Claude Code (the app, not just the session) for it to take effect."
