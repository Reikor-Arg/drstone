#!/bin/sh
# Dr. Stone - instalador para macOS y Linux
# Uso:  curl -fsSL https://raw.githubusercontent.com/Reikor-Arg/drstone/master/install.sh | sh
set -e

DIR="$HOME/.claude"
FILE="$DIR/settings.json"
REC='echo DRSTONE: cavernicola. Cero relleno, cortesias ni hedging. Fragmentos OK. Sin narrar tools, sin tablas, sin recapitular, sin pendientes no pedidos. Largo el justo. Codigo y errores literales.'

mkdir -p "$DIR"
[ -f "$FILE" ] || echo '{}' > "$FILE"

# Copia antes de tocar nada: este archivo suele tener permisos y hooks propios.
BACKUP="$FILE.bak-$(date +%Y%m%d-%H%M%S)"
cp "$FILE" "$BACKUP"
echo "Copia de seguridad: $BACKUP"

if ! command -v python3 >/dev/null 2>&1; then
  echo ""
  echo "No hay python3, que es lo unico que puede editar el JSON sin romperlo."
  echo "Pega esto a mano en $FILE, dentro de \"hooks\":"
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
# Se conservan los hooks que ya tenia, salvo una instalacion anterior de este mismo.
previos = [h for h in hooks.get('UserPromptSubmit', []) if 'DRSTONE ON' not in json.dumps(h)]
previos.append({'hooks': [{'type': 'command', 'command': rec, 'timeout': 5}]})
hooks['UserPromptSubmit'] = previos

with open(path, 'w', encoding='utf-8') as f:
    json.dump(data, f, indent=2, ensure_ascii=False)
PY

echo ""
echo "Dr. Stone instalado."
echo "Cerra y abri Claude Code (la app, no solo la sesion) para que tome el cambio."
