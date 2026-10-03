ENREDADOS — PROYECTO MAESTRO ANDROID / WEBVIEW · R11 CONSOLIDADO · 2026-10-03

FUENTE ÚNICA DE LA APLICACIÓN
app/src/main/assets/index.html

BACKEND DEL PROYECTO
server.js · API canónica: /api/room/create · /api/room/join · /api/room/:code

REGLA
El código activo de juego se mantiene en index.html. Los demás archivos sostienen Android,
QA, build y backend. No mezclar HTML históricos ni backups dentro del proyecto activo.
La capa visual de los niveles tiene un único contenedor .screen: game() es el propietario; los renderers
de nivel no crean .screen anidados. El giroscopio de Nivel 5 se desmonta al salir del nivel.

CAMPAÑA DEFINITIVA
1. ¿Cuánto me conoces? — 20 preguntas
2. La Ruleta de la Química — 15 giros
3. Duelo de manos — 10 rondas (PIEDRA · PAPEL · TIJERAS)
4. Reto en cadena — 15 de racha
5. Ruta de decisiones — 100 casillas
6. Caos por ronda — 20 rondas
7. Parchís de la tentación — Meta 57
8. Memoria de pareja — 10 parejas / 20 cartas
9. Dados eróticos — 15 rondas + acciones / 3 dados
10. Kamasutra / Gran final — 10 rondas + 3 barajas de acciones

NAVEGACIÓN
HOME → PREPARAR PARTIDA → NIVEL 1 → ... → NIVEL 10 → FINAL.
No existe selector de niveles para la campaña.

MINIJUEGOS
HOME → MINIJUEGOS → elegir nivel → jugar → volver a MINIJUEGOS.
No avanzan la campaña.

PREPARAR PARTIDA
PARTIDA LOCAL: Jugador 1 + Jugador 2 → nombres → EMPEZAR → NIVEL 1.
CREAR PARTIDA: nombre → CREAR → código → espera al segundo jugador.
UNIRSE: código → nombre → UNIRSE.

VISUAL
Identidad premium 3D/neón. No se sustituyen las imágenes aprobadas para arreglar código.
El logo oficial pertenece a HOME; no se añade logo dentro de los niveles.

ANDROID
WebView local file:///android_asset/index.html.
Back Android moderno mediante OnBackInvokedCallback.
Pantalla vertical e inmersiva.

TERMUX
1) cd ~/Enredados-Mobile-Termux
2) chmod +x ./gradlew
3) bash scripts/QA_ENREDADOS_R11.sh
4) node scripts/test_master_runtime.js
5) node scripts/test_server_master.js
6) ./gradlew clean assembleDebug
7) verificar que el SHA del index.html fuente coincide con assets/index.html dentro de la APK.

AUDITORÍA PROFUNDA · 2026-10-03
Se mantiene este directorio como única base activa. Se eliminó código visual duplicado de media queries, se retiró
una etiqueta pseudo-elemento obsoleta de Nivel 4 que se inyectaba sobre el contenedor de Reto en cadena, y la limpieza
central de ciclo de vida elimina también el overlay de cambio de turno antes de navegar. El test de backend usa la ruta
del propio proyecto mediante __dirname y no una ubicación histórica externa.

VALIDACIÓN
NODE CHECK != BUILD != APK != FUNCIONAMIENTO REAL.
No se considera funcionamiento real hasta instalar y probar la APK en Android.
