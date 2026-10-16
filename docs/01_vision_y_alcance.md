# 01 — Visión y alcance

## Problema
El usuario tiene ingresos variables (sueldo base más recargos dominicales y festivos, que cambian si se enferma o pide días no remunerados), ingresos extra irregulares (domicilios, alquiler de moto, servicios, ayudas familiares, ganancias de un negocio aparte), varias deudas, dinero prestado a terceros y gastos de moto, personales y de pareja. Hoy no tiene una vista única que responda: **¿cuánto puedo gastar con seguridad, cuánto debo a deudas y cuánto ahorro?**

## Objetivo
Una app móvil rápida de usar (registrar un gasto en menos de 5 segundos, incluso desde un widget) que consolide todo el flujo de dinero, priorice el pago de deudas y proteja al usuario de la variabilidad de sus ingresos.

## Usuario objetivo
Un único usuario (propietario del dispositivo). Sin cuentas, sin login, sin servidor.

## Principios de producto
1. **Registro rápido primero.** Todo lo demás es secundario.
2. **Presupuestar sobre el ingreso seguro**, no sobre el promedio.
3. **Los datos son del usuario:** locales, exportables, restaurables.
4. **Simple antes que completo.** Cada pantalla responde una pregunta.

## Alcance MVP (v1.0)
- Cuentas/bolsillos (efectivo, banco, ahorro).
- Ingresos y gastos con categorías (por defecto, personalizables, inhabilitables).
- Transferencias entre cuentas.
- Deudas con saldo, cuota, interés y abonos.
- Préstamos por cobrar con abonos que se suman a ingresos.
- Ahorro con metas.
- Ingreso base seguro y reparto configurable de ingresos extra.
- Resumen mensual y gráficas básicas.
- Widgets Android de gasto e ingreso rápido.
- Copia de seguridad y restauración local.
- Actualización dentro de la app (GitHub Releases).
- Tema claro/oscuro, español/inglés, COP/USD/EUR.

## Fuera de alcance (v1)
Sincronización en la nube, multiusuario, iOS, conversión automática de divisas, importación de extractos bancarios, integración con la app de inventario del negocio (solo se registra la ganancia retirada como ingreso).

## Métricas de éxito
- Registrar un gasto desde el widget en ≤ 5 s.
- Restaurar una copia en un teléfono nuevo en ≤ 2 min.
- Cero pérdida de datos en actualizaciones de la app (migraciones probadas).
