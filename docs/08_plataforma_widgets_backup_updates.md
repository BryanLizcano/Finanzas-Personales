# 08 — Widgets, copias de seguridad y actualizaciones

## 1. Widgets de pantalla de inicio (Android)

| Widget | Tamaño | Función |
|--------|--------|---------|
| Gasto rápido | 4x1 / 4x2 | Botones con las 4–8 categorías de gasto más usadas |
| Ingreso rápido | 4x1 | Botones con categorías de ingreso frecuentes |
| Resumen | 2x2 | Disponible seguro y balance del mes |

**Implementación:** `home_widget` + `AppWidgetProvider` en Kotlin.
- Cada botón dispara un deep link: `finanzas://quick-add?kind=expense&cat=<key>`.
- `go_router` abre `QuickAddPage`: teclado numérico, cuenta por defecto preseleccionada, confirmar y cerrar.
- Tras guardar, la app actualiza los datos del widget (`HomeWidget.saveWidgetData` + `updateWidget`).
- Las categorías que muestra el widget son las **activas** ordenadas por frecuencia de uso; configurables en Ajustes.
- Los widgets respetan tema claro/oscuro y se redimensionan.

Criterio: del toque al registro guardado en ≤ 5 s.

## 2. Copia de seguridad en el dispositivo

**Formato:** archivo JSON versionado `finanzas_backup_YYYYMMDD_HHmm.json`.
```json
{
  "schemaVersion": 1,
  "appVersion": "1.0.0",
  "createdAt": "2026-10-16T10:00:00Z",
  "checksum": "sha256:...",
  "data": { "accounts": [], "categories": [], "transactions": [], "debts": [], "receivables": [], "goals": [], "rules": [], "settings": {} }
}
```

**Dónde se guarda:** en una carpeta que el usuario elige con el selector del sistema (Storage Access Framework). Esa carpeta sobrevive a desinstalar la app. **No** usar solo el directorio privado de la app: se borra al desinstalar.

**Cuándo:**
- Manual: botón "Crear copia ahora".
- Automática: tarea con `workmanager` (diaria y tras N cambios), con retención de las últimas 10 copias.
- Antes de cada migración de base de datos y antes de restaurar.

**Restaurar:** elegir archivo → validar JSON, checksum y `schemaVersion` (si es mayor que el de la app, rechazar con mensaje) → vista previa (conteos) → crear copia de seguridad automática del estado actual → reemplazar datos en una transacción atómica.

**Cambio de teléfono:** copiar el archivo (cable, Drive, mensajería) → instalar app → Ajustes → Restaurar.

**Riesgo conocido:** si el teléfono se pierde y la carpeta de backup estaba solo en él, la copia también se pierde. Mitigaciones:
- Botón "Compartir copia" (`share_plus`) para enviarla a otro lugar.
- Recordatorio mensual: "Guarda una copia fuera del teléfono".
- Opción v2: cifrado con contraseña (AES-GCM).
- Android Auto Backup puede activarse como complemento, no como mecanismo principal.

## 3. Actualización dentro de la app

### Opciones evaluadas
| Opción | Ventajas | Desventajas |
|--------|----------|-------------|
| **A. GitHub Releases + APK** (recomendada) | Gratis, sin Play Store, control total, encaja con GitHub Actions | Android requiere permiso "instalar apps desconocidas"; el usuario confirma la instalación |
| B. Google Play (`in_app_update`) | Experiencia nativa, actualizaciones automáticas | Cuenta de desarrollador (pago único), revisión de Google |
| C. Firebase App Distribution | Distribución a testers | Depende de Firebase; pensado para pruebas |
| D. Obtainium / F-Droid | Sin código en la app | Depende de apps externas |

**Decisión:** opción A para v1; se puede migrar a B sin tocar el dominio.

### Flujo
1. Cada release se publica con tag semver `vMAJOR.MINOR.PATCH` y adjunta `app-release.apk` y `app-release.apk.sha256`.
2. La app consulta `GET https://api.github.com/repos/<owner>/<repo>/releases/latest`.
3. Compara `tag_name` con la versión instalada (`package_info_plus`).
4. Si hay nueva: muestra notas (cuerpo del release), descarga con progreso, verifica SHA-256 y abre el instalador con `open_filex`.
5. Comprobación automática como máximo una vez al día y manual desde Ajustes.

### Requisitos
- Repo o repo de releases **público** (un APK en un repo privado exige token, que no debe ir dentro de la app).
- Mismo **keystore** de firma siempre; guardarlo fuera del repo y respaldado; en CI como secreto de GitHub.
- `versionCode` creciente en cada release.
- Permiso `REQUEST_INSTALL_PACKAGES` en el manifiesto; si no está concedido, guiar al usuario a ajustes.
- Manejar sin red, límite de la API (60 solicitudes/h sin autenticar) y descarga interrumpida.
- Solo Android; en otras plataformas ocultar la opción.

### CI de releases (GitHub Actions)
Al empujar un tag `v*`: analizar, probar, `flutter build apk --release`, firmar con el keystore secreto, calcular SHA-256 y crear el release con los archivos.
