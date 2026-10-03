# 🎲 ENREDADOS — INSTRUCCIONES MAESTRAS DEL PROYECTO

## 1. IDENTIDAD DEL PROYECTO

EnreDados es un juego Android interactivo de estilo premium basado en una experiencia de tablero virtual con personajes 3D, animaciones, minijuegos, dados, cartas, retos y diferentes mecánicas.

El proyecto debe evolucionar manteniendo siempre una identidad visual y técnica coherente.

EnreDados NO debe convertirse en una aplicación genérica de interfaz plana.

La experiencia debe sentirse como un videojuego de tablero virtual 3D premium, dinámico, visual, inmersivo y cuidado.

---

## 2. REGLA PRINCIPAL DE TRABAJO

Cada modificación debe seguir este orden:

EXAMINAR → AUDITAR → CORREGIR → MEJORAR → LIMPIAR → PROBAR → COMPILAR → VERIFICAR → GUARDAR

Nunca modificar una parte importante del proyecto sin comprobar primero:

- qué existe actualmente;
- qué funciona;
- qué está roto;
- qué código ha quedado obsoleto;
- qué funcionalidades dependen de ese código;
- qué archivos son realmente necesarios;
- qué cambios anteriores deben conservarse.

REGLA FUNDAMENTAL:

No sustituir algo que funciona por algo nuevo simplemente porque parece más bonito.

Primero se conserva la funcionalidad y después se mejora visualmente.

---

## 3. ESTRUCTURA DE TRABAJO

Proyecto local:

EnreDados-GITHUB

Repositorio oficial:

allerim94/EnreDados

Rama principal:

main

Flujo oficial:

TRABAJO LOCAL
↓
TERMUX
↓
GIT
↓
GITHUB
↓
REPOSITORIO ENREDADOS

GitHub es el repositorio oficial y sistema de respaldo y control de versiones del proyecto.

---

## 4. HERRAMIENTAS PRINCIPALES

### TERMUX

Termux es el entorno principal de trabajo en Android.

Se utilizará para:

- ejecutar scripts;
- ejecutar Git;
- ejecutar Gradle;
- compilar APK;
- realizar auditorías;
- ejecutar pruebas;
- crear copias de seguridad;
- comprobar la estructura del proyecto;
- instalar y verificar APK.

### GIT

Todo cambio importante debe quedar registrado mediante Git.

Antes de cambios importantes:

git status

Después de una modificación:

git status

Los commits deben utilizar mensajes claros y descriptivos.

### GITHUB

GitHub es el repositorio oficial.

Después de cambios importantes:

COMPROBAR → COMMIT → PUSH

No subir:

- build/
- .gradle/
- local.properties
- claves privadas;
- contraseñas;
- tokens;
- API keys;
- archivos temporales;
- logs innecesarios.

---

## 5. ANDROID Y GRADLE

La aplicación debe poder compilarse desde Termux.

Antes de considerar terminada una modificación importante:

COMPILAR
↓
COMPROBAR BUILD
↓
INSTALAR/PROBAR APK
↓
VERIFICAR FUNCIONAMIENTO

Un cambio NO se considera terminado solamente porque el código compile.

Debe comprobarse también el comportamiento real de la aplicación.

---

## 6. HTML / CSS / JAVASCRIPT

El núcleo visual y jugable de EnreDados se encuentra principalmente en:

app/src/main/assets/

Especialmente:

index.html

Antes de crear una función nueva:

1. Buscar si ya existe.
2. Comprobar si puede reutilizarse.
3. Comprobar dependencias.
4. Eliminar versiones antiguas si ya no sirven.

El código debe mantenerse limpio, organizado y coherente.

No duplicar funciones innecesariamente.

---

## 7. SERVER.JS

server.js forma parte del proyecto y debe conservarse cuando sea necesario para las funcionalidades correspondientes.

Antes de modificarlo:

- revisar qué funciones proporciona;
- comprobar dependencias;
- no romper las comunicaciones existentes;
- probar después del cambio.

No sustituir server.js sin una razón técnica clara.

---

## 8. IDENTIDAD VISUAL DEFINITIVA

La identidad visual de EnreDados debe mantenerse en todos los niveles.

ESTILO PRINCIPAL:

- negro;
- rojo;
- neón;
- iluminación cinematográfica;
- estética premium;
- profundidad;
- brillos;
- sombras;
- materiales realistas;
- elementos 3D;
- personajes 3D;
- tablero virtual;
- efectos de luz;
- sensación de videojuego.

NO utilizar una interfaz plana convencional como sustituto del estilo EnreDados.

Los botones, paneles, cartas, dados, casillas, personajes y elementos interactivos deben integrarse visualmente en el mundo del juego.

---

## 9. TABLERO VIRTUAL + PERSONAJES 3D

La referencia visual principal del proyecto es:

TABLERO VIRTUAL + PERSONAJES 3D + ILUMINACIÓN PREMIUM + INTERACCIÓN VISUAL

Cada nuevo nivel debe parecer perteneciente al mismo videojuego.

Aunque la mecánica de cada nivel sea diferente, la identidad visual debe permanecer.

No hacer:

Nivel 1 → estilo videojuego
Nivel 2 → web plana
Nivel 3 → diseño completamente diferente
Nivel 4 → interfaz genérica

Sí hacer:

Los 10 niveles deben compartir el mismo lenguaje visual de EnreDados.

---

## 10. REFERENCIAS VISUALES

Cuando se proporcione una imagen de referencia, no copiar solamente el color.

Analizar:

- composición;
- profundidad;
- iluminación;
- materiales;
- perspectiva;
- posición de elementos;
- proporciones;
- personajes;
- tablero;
- botones;
- sombras;
- texturas;
- animaciones;
- jerarquía visual.

La referencia sirve para adaptar el lenguaje visual sin destruir la mecánica del nivel.

---

## 11. IMÁGENES Y RECURSOS

Los recursos visuales deben mantenerse organizados.

No crear múltiples versiones casi idénticas sin necesidad.

Cuando un recurso sea sustituido:

1. comprobar dónde se utiliza;
2. sustituir referencias;
3. probar;
4. eliminar el recurso obsoleto si ya no se necesita.

El proyecto debe evitar acumular archivos innecesarios.

---

## 12. HERRAMIENTAS DE CONTENIDO Y VÍDEO

Cuando sea necesario crear o mejorar material audiovisual se pueden utilizar:

- Runway;
- Renderforest;
- CapCut;
- herramientas de generación de imágenes;
- herramientas de edición y animación.

Todos los recursos generados deben adaptarse posteriormente a la identidad de EnreDados.

No introducir un vídeo, imagen o animación solamente porque sea llamativo.

Debe encajar con:

ENREDADOS + NEGRO + ROJO + NEÓN + PREMIUM + 3D + TABLERO VIRTUAL

---

# 13. LOS 10 NIVELES DEFINITIVOS

Esta es la lista oficial actual y no debe sustituirse por versiones antiguas.

| Nivel | Juego | Objetivo |
|---|---|---|
| 1 | ¿Cuánto me conoces? | 20 preguntas |
| 2 | La Ruleta de la Química | 15 giros |
| 3 | Duelo de manos | 10 rondas |
| 4 | Reto en cadena | 15 de racha |
| 5 | Ruta de decisiones | 100 casillas |
| 6 | Caos por ronda | 20 rondas |
| 7 | Parchís de la tentación | Meta 57 |
| 8 | Memoria de pareja | 10 parejas |
| 9 | Dados eróticos | 15 rondas + acciones |
| 10 | Kamasutra / Gran final | 10 rondas + 3 barajas de acciones |

IMPORTANTE:

Las versiones antiguas de los niveles NO deben utilizarse para sustituir esta lista.

Esta es la lista definitiva del proyecto actual.

---

## 14. REGLA PARA MODIFICAR UN NIVEL

Antes de modificar cualquier nivel:

1. Abrir la versión actual.
2. Auditar el funcionamiento.
3. Identificar errores.
4. Identificar código duplicado.
5. Identificar elementos obsoletos.
6. Corregir.
7. Mejorar visualmente.
8. Añadir las funcionalidades necesarias.
9. Eliminar lo que ya no sirve.
10. Probar la mecánica completa.
11. Probar en móvil.
12. Compilar.
13. Verificar el APK.
14. Guardar los cambios en Git.

---

## 15. NO DEJAR CÓDIGO OBSOLETO

Mientras se corrige y mejora una parte del proyecto, también se debe eliminar aquello que haya dejado de utilizarse.

No queremos:

función vieja
+
función nueva
+
función duplicada
+
HTML antiguo
+
CSS antiguo
+
mecánica antigua

Queremos:

UNA IMPLEMENTACIÓN
+
LIMPIA
+
FUNCIONAL
+
PROBADA

---

## 16. AUDITORÍA

Las auditorías deben ser profundas.

### FUNCIONALIDAD

Comprobar:

- botones;
- navegación;
- turnos;
- puntuaciones;
- dados;
- cartas;
- rondas;
- objetivos;
- finales;
- reinicios;
- guardado.

### INTERFAZ

Comprobar:

- adaptación móvil;
- orientación;
- tamaños;
- textos;
- botones;
- desbordamientos;
- desplazamiento;
- elementos fuera de pantalla;
- centrado;
- escalado.

### CÓDIGO

Comprobar:

- errores JavaScript;
- funciones duplicadas;
- referencias inexistentes;
- IDs incorrectos;
- eventos rotos;
- variables inexistentes;
- código muerto.

### ANDROID

Comprobar:

- carga;
- pantalla blanca;
- centrado;
- adaptación;
- rendimiento;
- compilación;
-instalación;
- ejecución del APK.

---

## 17. PRUEBAS

No basta con comprobar que la aplicación abre.

Hay que realizar pruebas reales de juego.

Cuando sea posible utilizar:

test_campaign.js

para comprobar automáticamente las mecánicas.

Después realizar también pruebas manuales.

---

## 18. VERSIONADO

Cada versión importante debe poder identificarse claramente.

Ejemplos:

R11
R12
R13

Nunca perder una versión estable por modificar directamente sin respaldo.

Antes de una modificación grande:

VERSIÓN ESTABLE
↓
COMMIT / COPIA
↓
MODIFICACIÓN
↓
PRUEBAS
↓
NUEVA VERSIÓN

---

## 19. APK FINAL

Un APK solamente puede considerarse FINAL cuando:

- los 10 niveles funcionan;
- las mecánicas principales están probadas;
- no existen errores críticos conocidos;
- la interfaz se adapta correctamente;
- no hay pantallas blancas;
- no hay elementos cortados;
- el proyecto compila;
- el APK instala correctamente;
- se ha probado en dispositivo;
- el código está guardado en Git;
- GitHub contiene la versión correspondiente.

---

## 20. REGLA DE ORO

NO HACER CAMBIOS POR CAMBIAR.

Cada modificación debe responder a una de estas razones:

CORREGIR
MEJORAR
OPTIMIZAR
COMPLETAR
SIMPLIFICAR
LIMPIAR
PROTEGER
PROBAR

Si una modificación no aporta ninguna de esas cosas, no debe hacerse.

---

## 21. OBJETIVO FINAL

El objetivo no es simplemente conseguir un APK que funcione.

El objetivo es conseguir:

UN JUEGO COMPLETO, ESTABLE, VISUALMENTE PREMIUM, COHERENTE, MANTENIBLE Y LISTO PARA EVOLUCIONAR.

Cada nueva versión debe ser mejor que la anterior sin perder lo que ya funciona.

---

# FRASE MAESTRA DEL PROYECTO

ENREDADOS SE CONSTRUYE PASO A PASO:

SE EXAMINA ANTES DE TOCAR,
SE CORRIGE ANTES DE AÑADIR,
SE ELIMINA LO OBSOLETO,
SE PRUEBA TODO
Y SOLO DESPUÉS SE DA POR TERMINADO.

---

# ESTADO BASE ACTUAL

Proyecto: EnreDados

Repositorio: allerim94/EnreDados

Rama: main

Versión base: R11-final

Commit base:
0a18b32

Sistema de trabajo:
Termux + Git + GitHub + Gradle

Conexión GitHub:
SSH

Objetivo:
Continuar desarrollando EnreDados sin perder funcionalidades existentes, manteniendo la identidad visual premium 3D y mejorando progresivamente estabilidad, jugabilidad, diseño y calidad técnica.
