# Manual de Operación y Configuración — Finanzas Personales

Este documento reúne las instrucciones de configuración, secretos de CI/CD, mantenimiento de la plataforma, operación visual y tareas pendientes requeridas por los agentes de desarrollo.

---

## 1. Configuración de Repositorio GitHub para Actualizaciones

La aplicación incluye un cliente para comprobar y descargar nuevas versiones publicadas en GitHub Releases (`features/updates`).

Por requerimiento de seguridad y desacoplamiento, el repositorio utiliza valores temporales tipo placeholder:
- **Archivo:** [`lib/features/updates/data/repositories/update_repository_impl.dart`](file:///c:/Users/elpeo/OneDrive/Documentos/App%20Finanzas/lib/features/updates/data/repositories/update_repository_impl.dart)
- **Constantes:**
  ```dart
  static const defaultOwner = 'TODO_OWNER';
  static const defaultRepo = 'TODO_REPO';
  ```

### Instrucción para el usuario / desarrollador:
Antes de generar la primera versión en producción:
1. Reemplazar `'TODO_OWNER'` por el nombre de usuario u organización en GitHub (ej. `'mi-usuario'`).
2. Reemplazar `'TODO_REPO'` por el nombre del repositorio (ej. `'finanzas-personales'`).
3. Alternativamente, inyectar estos valores al inicializar el provider `updateRepositoryProvider` o mediante variables de entorno en compilación (`--dart-define`).

---

## 2. Generación de Keystore y Secretos para CI/CD

El flujo de trabajo en [`.github/workflows/release.yml`](file:///c:/Users/elpeo/OneDrive/Documentos/App%20Finanzas/.github/workflows/release.yml) automatiza la compilación del APK de release, cálculo de hash SHA-256 y creación del Release en GitHub ante cada tag que comience por `v*` (por ejemplo `v1.0.0`).

### 2.1 Generar el Keystore de firmado Android
En tu terminal local:
```bash
keytool -genkey -v -keystore finanzas-release.jks -keyalg RSA -keysize 2048 -validity 10000 -alias finanzas_key
```

### 2.2 Obtener la versión en Base64
En Linux / macOS:
```bash
base64 -w 0 finanzas-release.jks > keystore_base64.txt
```
En Windows PowerShell:
```powershell
[Convert]::ToBase64String([IO.File]::ReadAllBytes("finanzas-release.jks")) | Set-Content keystore_base64.txt
```

### 2.3 Cargar los Secretos en GitHub Actions
En el repositorio de GitHub, navegar a **Settings** → **Secrets and variables** → **Actions** y agregar los siguientes secretos:
- `SIGNING_KEYSTORE_BASE64`: Contenido completo del archivo `keystore_base64.txt`.
- `KEY_STORE_PASSWORD`: Contraseña maestra del almacén de claves.
- `KEY_ALIAS`: Alias asignado (ej. `finanzas_key`).
- `KEY_PASSWORD`: Contraseña asignada a la clave particular.

---

## 3. Arquitectura y Providers Disponibles

Toda la lógica de negocio y datos ha sido construida bajo Clean Architecture y Riverpod:
- Cada feature en `lib/features/<nombre_feature>/` contiene un archivo `README.md` detallando:
  - Propósito de la característica.
  - Lista exhaustiva de **Providers públicos** (nombre, tipo y qué retorna).
  - Casos de uso disponibles con sus parámetros y códigos de error `FailureCode`.
  - Ejemplos de uso directo para el Agente Visual.
- Ningún valor monetario utiliza `double`. Todas las transacciones, saldos y cuotas se operan en unidades menores enteras a través de `Money` y `Currency`.
- El parser del deep link `finanzas://quick-add` valida formato, monto positivo y categoría, permitiendo prellenar transacciones desde widgets de escritorio.

---

## 4. Guía de Operación y Pruebas Visuales / Widgets Nativos

### 4.1 Comprobación de Widgets de Escritorio en Android
La app expone 3 widgets nativos (AppWidgets) para la pantalla de inicio de Android:
1. **Widget de Gasto Rápido (`QuickExpenseWidgetProvider`)**: 
   - Botón de acceso directo con icono rojo (-) que lanza el deep link `finanzas://quick-add?kind=expense`.
2. **Widget de Ingreso Rápido (`QuickIncomeWidgetProvider`)**: 
   - Botón de acceso directo con icono verde (+) que lanza el deep link `finanzas://quick-add?kind=income`.
3. **Widget de Resumen Financiero (`SummaryWidgetProvider`)**: 
   - Tarjeta informativa que lee de `SharedPreferences` (`FlutterSharedPreferences`) los valores `widget_safe_available` y `widget_monthly_balance` actualizados automáticamente en cada movimiento, y botones rápidos para registrar ingresos o gastos.

### 4.2 Probar Deep Links desde la terminal (ADB)
Con un emulador o dispositivo conectado vía USB:
```bash
# Registrar un gasto rápido con categoría
adb shell am start -a android.intent.action.VIEW -d "finanzas://quick-add?kind=expense&amount=25000&category=food"

# Registrar un ingreso rápido
adb shell am start -a android.intent.action.VIEW -d "finanzas://quick-add?kind=income&amount=150000"

# Abrir diálogo rápido sin monto predeterminado
adb shell am start -a android.intent.action.VIEW -d "finanzas://quick-add?kind=expense"
```

### 4.3 Ejecución de Pruebas de Presentación
```bash
# Ejecutar todas las pruebas del Agente Visual
flutter test test/presentation/

# Ejecutar la suite completa del proyecto (131 pruebas)
flutter test
```

---

## 5. Pendientes generados por agentes

Esta sección consolida las tareas delegadas al siguiente agente o que requieren intervención manual del usuario:

### Para el Agente Visual (`docs/13_agente_visual.md`):
- [x] Implementar la interfaz gráfica y pantallas completas: Inicio, Registrar movimiento, Historial de movimientos, Deudas, Por cobrar, Metas de ahorro, Reportes y Ajustes.
- [x] Implementar el sistema de diseño (`FinanceColors`, tipografía Inter tabular, componentes reutilizables en `lib/core/widgets`).
- [x] Definir los archivos de localización ARB en español e inglés (`lib/l10n/`) asignando un mensaje amigable a cada código de `FailureCode`.
- [x] Implementar los layouts y código nativo Kotlin de los widgets de escritorio en Android (`android/app/src/main/kotlin/`) que consumen `WidgetDataService` y abren `finanzas://quick-add`.
- [x] Diseñar el splash nativo y temas Material 3 sin retrasar el arranque.
- [x] Pruebas visuales de widgets y componentes de presentación (`test/presentation/`).

### Para el Agente QA (`docs/14_agente_qa.md`):
- [ ] Ejecutar la matriz de trazabilidad Q-001 y auditoría estática Q-002.
- [ ] Ejecutar los 12 flujos de integración punta a punta (E2E) descritos en `docs/14_agente_qa.md`.
- [ ] Verificar pruebas de robustez (modo sin conexión, rotación, límites de almacenamiento).
- [ ] Generar el reporte `docs/QA_REPORTE.md` y checklist `docs/QA_CHECKLIST_RELEASE.md`.

### Para el Usuario / Administrador del Sistema:
- [ ] Reemplazar `TODO_OWNER` y `TODO_REPO` en `lib/features/updates/data/repositories/update_repository_impl.dart` con los datos reales del repositorio de GitHub.
- [ ] Generar el keystore de producción y registrar los secretos en GitHub Actions para habilitar el pipeline de release.
- [ ] Probar la adición física de los widgets en el escritorio de un dispositivo Android real tras instalar el APK debug o release.
