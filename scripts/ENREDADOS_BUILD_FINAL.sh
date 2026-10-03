#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
DEFAULT_PROJECT="$(cd -- "$SCRIPT_DIR/.." && pwd)"
PROJECT="${PROJECT:-$DEFAULT_PROJECT}"
HTML="$PROJECT/app/src/main/assets/index.html"
OUT="${OUT:-/storage/emulated/0/Download/EnReDados-R11-MASTER-FINAL.apk}"
CHECK_JS="$PROJECT/.enredados-r11-js-check.js"

fail(){ echo "ERROR: $*" >&2; exit 1; }

cd "$PROJECT" || fail "no existe $PROJECT"
test -x ./gradlew || { chmod +x ./gradlew; test -x ./gradlew || fail "./gradlew no es ejecutable"; }
test -f "$HTML" || fail "falta $HTML"

echo '=== ENREDADOS R11 · LIMPIEZA PROFUNDA · BUILD ==='
echo 'INSPECCIONAR → CHECK → TEST → BUILD → VERIFICAR APK'

bash "$PROJECT/scripts/QA_ENREDADOS_R11.sh"

echo '== COMPILANDO APK =='
./gradlew clean assembleDebug

APK="$PROJECT/app/build/outputs/apk/debug/app-debug.apk"
test -f "$APK" || fail "no se generó la APK"

mkdir -p "$(dirname "$OUT")"
SRC_HASH="$(sha256sum "$HTML" | awk '{print $1}')"
APK_HASH="$(unzip -p "$APK" assets/index.html | sha256sum | awk '{print $1}')"
echo "HTML SHA-256: $SRC_HASH"
echo "APK  SHA-256: $APK_HASH"
[ "$SRC_HASH" = "$APK_HASH" ] || fail "HTML fuente y APK no coinciden"

ACTIVE_HTML_COUNT="$(unzip -l "$APK" | awk '/assets\/[^ ]+\.html$/ {n++} END {print n+0}')"
[ "$ACTIVE_HTML_COUNT" -eq 1 ] || fail "assets HTML activos != 1 ($ACTIVE_HTML_COUNT)"

cp -f "$APK" "$OUT"
echo '========================================'
echo 'BUILD SUCCESSFUL · R11 MASTER FINAL'
echo "APK FINAL: $OUT"
ls -lh "$OUT"
echo '========================================'
