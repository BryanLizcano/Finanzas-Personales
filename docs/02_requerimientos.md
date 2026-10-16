# 02 — Requerimientos

Prioridad: **M** = Must (MVP), **S** = Should, **C** = Could (post-MVP).

## Funcionales
| ID | Requerimiento | Prio |
|----|---------------|------|
| RF-01 | Crear, editar, archivar cuentas (efectivo, banco, ahorro) con saldo inicial | M |
| RF-02 | Registrar ingreso, gasto y transferencia con monto, fecha, categoría, cuenta y nota opcional | M |
| RF-03 | Editar y eliminar transacciones (eliminación lógica, deshacer) | M |
| RF-04 | Categorías por defecto de ingreso y gasto; crear nuevas; inhabilitar/habilitar; editar nombre, ícono y color | M |
| RF-05 | Las categorías por defecto se muestran traducidas según idioma; las personalizadas conservan su nombre | M |
| RF-06 | Registrar deudas (acreedor, monto inicial, saldo, interés mensual, cuota mínima, día de pago, prioridad) | M |
| RF-07 | Abonar a una deuda: crea un gasto vinculado y reduce el saldo | M |
| RF-08 | Sugerir a qué deuda abonar (estrategia bola de nieve o avalancha, configurable) | S |
| RF-09 | Registrar préstamos por cobrar (persona, monto, saldo, fecha) | M |
| RF-10 | Registrar abono recibido de un préstamo: crea un ingreso vinculado y reduce el saldo pendiente | M |
| RF-11 | Metas de ahorro con monto objetivo, fecha opcional y progreso | M |
| RF-12 | Configurar ingreso base seguro mensual | M |
| RF-13 | Configurar reglas de reparto de ingresos extra por porcentaje (deudas, ahorro, gastos libres) | S |
| RF-14 | Resumen mensual: ingresos, gastos, balance, gasto por categoría, deuda total, por cobrar total, ahorro | M |
| RF-15 | Disponible seguro del mes = ingreso base − gastos fijos − cuotas de deuda − aporte a ahorro | S |
| RF-16 | Gastos de moto: categorías dedicadas y recordatorios (SOAT, tecnomecánica, mantenimiento) | S |
| RF-17 | Widgets Android: gasto rápido, ingreso rápido, resumen | M |
| RF-18 | Selector de moneda de la app: COP, USD, EUR | M |
| RF-19 | Selector de idioma: sistema, español, inglés | M |
| RF-20 | Selector de tema: sistema, claro, oscuro | M |
| RF-21 | Copia de seguridad manual y automática en una carpeta del dispositivo elegida por el usuario | M |
| RF-22 | Restaurar copia con validación de versión y copia previa automática | M |
| RF-23 | Buscar y filtrar transacciones por fecha, categoría, cuenta y texto | S |
| RF-24 | Transacciones recurrentes (suscripciones, cuotas fijas) | C |
| RF-25 | Comprobar e instalar actualizaciones desde GitHub Releases | M |
| RF-26 | Bloqueo opcional de la app con biometría/PIN | C |
| RF-27 | Exportar transacciones a CSV | C |

## No funcionales
| ID | Requerimiento |
|----|---------------|
| RNF-01 | Funciona 100 % offline; no requiere cuenta ni internet salvo para buscar actualizaciones |
| RNF-02 | Montos almacenados como enteros en unidad menor; prohibido usar `double` para dinero |
| RNF-03 | Arranque en frío < 2 s en gama media; listas fluidas a 60 fps con 10 000 transacciones |
| RNF-04 | Diseño adaptativo para pantallas pequeñas (<360 dp), medianas (360–411 dp) y grandes (≥412 dp); soporta escala de texto del sistema hasta 1.3× sin desbordes |
| RNF-05 | Contraste mínimo WCAG AA (4.5:1 texto) en ambos temas |
| RNF-06 | Sin textos fijos en código: todo vía localización (es/en) |
| RNF-07 | Migraciones de base de datos versionadas y probadas |
| RNF-08 | Cobertura de pruebas ≥ 80 % en dominio y casos de uso |
| RNF-09 | Sin telemetría ni envío de datos a terceros |
| RNF-10 | Las copias de seguridad incluyen `schemaVersion` y se validan antes de restaurar |
| RNF-11 | Android mínimo: API 24 (Android 7.0) |
| RNF-12 | APK firmado con el mismo keystore en todas las versiones (requisito para actualizar in-app) |
