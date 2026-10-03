#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail
SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PROJECT="$(cd -- "$SCRIPT_DIR/.." && pwd)"
HTML="$PROJECT/app/src/main/assets/index.html"
JAVA="$PROJECT/app/src/main/java/com/enredados/app/MainActivity.java"
MANIFEST="$PROJECT/app/src/main/AndroidManifest.xml"
SERVER="$PROJECT/server.js"
TMP="${TMPDIR:-/tmp}/enredados-r11-js-check-$$.js"
cleanup(){ rm -f "$TMP"; }
trap cleanup EXIT
fail(){ echo "ERROR: $*" >&2; exit 1; }
cd "$PROJECT" || fail "no existe $PROJECT"
test -f "$HTML" || fail "falta index.html activo"
test -f "$JAVA" || fail "falta MainActivity.java"
test -f "$MANIFEST" || fail "falta AndroidManifest.xml"
test -f "$SERVER" || fail "falta server.js maestro"

echo '=== QA ENREDADOS R11 · MASTER ==='
python3 - "$HTML" "$TMP" <<'PY'
import re, sys
from pathlib import Path
from collections import Counter
p=Path(sys.argv[1]); out=Path(sys.argv[2]); s=p.read_text(encoding='utf-8')
scripts=re.findall(r'<script(?:\s[^>]*)?>(.*?)</script>', s, re.S|re.I)
styles=re.findall(r'<style(?:\s[^>]*)?>', s, re.I)
if len(scripts) != 2: raise SystemExit(f'ERROR: scripts activos != 2 ({len(scripts)})')
if len(styles) != 1: raise SystemExit(f'ERROR: bloques style activos != 1 ({len(styles)})')
js='\n'.join(scripts)
fns=re.findall(r'\bfunction\s+([A-Za-z_$][\w$]*)\s*\(', js)
c=Counter(fns)
dups=sorted(k for k,v in c.items() if v>1)
if dups: raise SystemExit('ERROR: funciones duplicadas: '+', '.join(dups))
legacy=['R9','R8','R7','V99','V91','V87','V82','V81','V73','V71','ENRE_BOARD_60','handsStart','handsHit','handsFinishTurn','optimizedSave','resetEntireCampaign','memoryRestart','levelSelector','selectorNivel']
hits=[x for x in legacy if x in s]
if hits: raise SystemExit('ERROR: referencias legacy activas: '+', '.join(hits))
required=[
'¿Cuánto me conoces?','La Ruleta de la Química','Duelo de manos','Reto en cadena',
'Ruta de decisiones','Caos por ronda','Parchís de la tentación','Memoria de pareja',
'Dados eróticos','Kamasutra / Gran final',
'ENREDADOS-FINAL-DEFINITIVO-R11-2026-10-02','enreDadosFINAL_DEFINITIVO_R11_20261002',
'{1:20,2:15,3:10,4:15,5:100,6:20,7:57,8:10,9:15,10:10}',
'PIEDRA · PAPEL · TIJERAS','100 casillas','10 parejas','3 dados','10 rondas'
]
missing=[x for x in required if x not in s]
if missing: raise SystemExit('ERROR: faltan elementos definitivos: '+' | '.join(missing))
if s.count('visibilitychange') != 1: raise SystemExit('ERROR: visibilitychange duplicado')
if s.count('pagehide') != 1: raise SystemExit('ERROR: pagehide duplicado')
# No conservar bloques móviles exactamente duplicados en la cascada CSS activa.
media=re.findall(r'@media\(max-width:520px\)\{([^{}]*)\}',s)
if len(media) != len(set(media)): raise SystemExit('ERROR: @media móvil duplicado')
if '.l5Wrap::before{content:"NIVEL 4"' in s: raise SystemExit('ERROR: etiqueta visual obsoleta NIVEL 4 en l5Wrap')
if "const turnTransition=document.getElementById('turn-transition')" not in s: raise SystemExit('ERROR: limpieza central de turn-transition ausente')
ids=re.findall(r'\bid=["\']([^"\']+)["\']',s,re.I)
if len(ids)!=len(set(ids)): raise SystemExit('ERROR: IDs HTML duplicados')
# Every onclick function call must resolve to an app function or browser/global helper.
fnset=set(fns); calls=[]
for expr in re.findall(r'onclick\s*=\s*["\']([^"\']+)["\']',s,re.I):
    calls += re.findall(r'\b([A-Za-z_$][\w$]*)\s*\(',expr)
allowed={'alert','confirm','prompt','setTimeout','setInterval','clearTimeout','clearInterval','getElementById'}
missing_calls=sorted(set(calls)-fnset-allowed)
if missing_calls: raise SystemExit('ERROR: onclick sin función: '+', '.join(missing_calls))

# Arquitectura visual: game() es el único propietario del contenedor .screen de niveles.
route_region = s[s.find('function route()'):s.find('function routeReset()')]
if '<div class="screen">' in route_region:
    raise SystemExit('ERROR: Route conserva contenedores .screen anidados')
for name in ['quiz','roulette','hands','chain','route','chaos','parchis','memory','dice','final']:
    m=re.search(r'function\s+'+re.escape(name)+r'\s*\([^)]*\)\s*\{', js)
    if not m: raise SystemExit('ERROR: renderer de nivel ausente: '+name)
# Un solo lifecycle listener por evento global sensible.
listener_patterns={
    'visibilitychange': r'addEventListener\(\s*[\"\']visibilitychange[\"\']',
    'pagehide': r'addEventListener\(\s*[\"\']pagehide[\"\']',
    'online': r'addEventListener\(\s*[\"\']online[\"\']',
    'offline': r'addEventListener\(\s*[\"\']offline[\"\']',
}
for evt,pat in listener_patterns.items():
    if len(re.findall(pat,s)) != 1: raise SystemExit(f'ERROR: listener {evt} duplicado')
if 'function n3GyroUnbind' not in s: raise SystemExit('ERROR: falta ciclo de vida del giroscopio')
# El flujo de sala debe guardar primero y comenzar polling después, evitando una carrera con el GET inicial.
for fn in ['function createRoom(){','function joinRoom(){']:
    i=s.find(fn)
    j=s.find('\nfunction ',i+1)
    body=s[i:j if j!=-1 else len(s)]
    if 'save();startSync();render()' not in body:
        raise SystemExit('ERROR: orden de sincronización incorrecto en '+fn[:-2])
open(out,'w',encoding='utf-8').write(js)
print(f'HTML: {len(s.encode("utf-8")):,} bytes')
print(f'Scripts: {len(scripts)} · Style: {len(styles)}')
print(f'Funciones: {len(fns)} · únicas: {len(c)}')
print(f'IDs: {len(ids)} · únicas: {len(set(ids))}')
print('Legacy: 0')
PY
python3 - "$SERVER" <<'PY2'
import sys
from pathlib import Path
server_text=Path(sys.argv[1]).read_text(encoding='utf-8')
for x in ['/api/create-room','/api/create"','/api/rooms"','/api/join-room','/api/join"','/api/rooms/join','/api/status','/status"','/message$','/state$']:
    if x in server_text: raise SystemExit('ERROR: rutas backend legacy activas: '+x)
for endpoint in ['"/api/room/create"','"/api/room/join"']:
    if endpoint not in server_text: raise SystemExit('ERROR: falta endpoint canónico: '+endpoint)
PY2
node --check "$TMP"
node --check "$SERVER"
if test -f "$PROJECT/scripts/test_master_runtime.js"; then node "$PROJECT/scripts/test_master_runtime.js" >/dev/null || fail 'fallo en test maestro de render/navegación'; fi
if test -f "$PROJECT/scripts/test_server_master.js"; then node "$PROJECT/scripts/test_server_master.js" >/dev/null || fail 'fallo en test maestro del backend local'; fi

# Tests del proyecto deben ejecutarse siempre sobre este master, nunca sobre rutas historicas externas.
if grep -qE '/mnt/data|master_audit|VIEJO|BACKUP|BEFORE' "$PROJECT/scripts/test_server_master.js"; then
  fail 'test_server_master.js contiene una ruta externa/historica';
fi

HTML_COUNT="$(find "$PROJECT/app/src/main/assets" -maxdepth 1 -type f -name '*.html' | wc -l | tr -d ' ')"
[ "$HTML_COUNT" -eq 1 ] || fail "HTML activos en assets != 1 ($HTML_COUNT)"

# Android navigation/lifecycle checks.
grep -q 'OnBackInvokedCallback' "$JAVA" || fail 'falta OnBackInvokedCallback'
grep -q 'registerOnBackInvokedCallback' "$JAVA" || fail 'falta registro de Back moderno'
grep -q 'unregisterOnBackInvokedCallback' "$JAVA" || fail 'falta liberación de Back moderno'
if grep -q 'setDatabaseEnabled(true)' "$JAVA"; then fail 'queda DatabaseEnabled obsoleto'; fi
grep -q 'enableOnBackInvokedCallback="true"' "$MANIFEST" || fail 'Manifest sin enableOnBackInvokedCallback'

# Online mode compatibility checks.
grep -q '"/api/room/create"' "$SERVER" || fail 'server sin /api/room/create'
grep -q '"/api/room/join"' "$SERVER" || fail 'server sin /api/room/join'
grep -q 'pathname.match' "$SERVER" || fail 'server sin rutas de estado'
grep -q 'validateStateWrite' "$SERVER" || fail 'server sin validación de escritura'
grep -q "'/api/room/create'" "$HTML" || fail 'cliente sin endpoint de creación'
grep -q "'/api/room/join'" "$HTML" || fail 'cliente sin endpoint de unión'

# Definitive Prepare Game flow.
grep -q 'id="hostName"' "$HTML" || fail 'falta hostName'
grep -q "const n=\$('hostName')" "$HTML" || fail 'createRoom no usa hostName'
grep -q "S.p=\[n,'Jugador 2'\]" "$HTML" || fail 'createRoom conserva dependencia del segundo nombre local'

# Dead generic state removed.
if grep -qE 's\.(round|moves)=|s\.player=' "$HTML"; then fail 'queda estado genérico obsoleto'; fi

# Approved campaign navigation structure.
grep -q 'baseStart(1)' "$HTML" || fail 'campaña no arranca en Nivel 1'
grep -q 'if(S.level<10)' "$HTML" || fail 'campaña lineal incompleta'
grep -q 'function startMinigame' "$HTML" || fail 'minijuegos sin entrada'
grep -q 'function returnToMinigames' "$HTML" || fail 'minijuegos sin retorno'

echo 'QA PASS · MASTER R11 limpio, consolidado, corregido y con backend compatible'
