# 06 — Reglas de negocio

## Dinero
- RN-01: Todo monto es un entero en unidad menor. COP usa 0 decimales; USD y EUR usan 2.
- RN-02: La moneda es un ajuste global de la app. **Cambiarla no convierte montos**; solo cambia el formato. Mostrar advertencia clara al cambiarla.
- RN-03: No existe conversión automática de divisas en v1.

## Ingresos variables
- RN-04: El usuario define un **ingreso base seguro** mensual (el mínimo que recibe con certeza).
- RN-05: Todo presupuesto y el "disponible seguro" se calculan sobre el ingreso base, no sobre el promedio ni sobre el mes anterior.
- RN-06: El **ingreso extra** del mes = ingresos del mes − ingreso base (si es positivo). Es lo que se reparte.
- RN-07: Si el ingreso real del mes queda por debajo del base (enfermedad, día no remunerado), la app muestra aviso y no sugiere reparto.
- RN-08: Los ingresos por categoría `drinks_business` se registran como ganancia retirada, no como ventas brutas.

## Reparto de ingresos extra
- RN-09: Reglas por porcentaje con destinos `debts`, `savings`, `free`. La suma debe ser 100 %.
- RN-10: Valores por defecto sugeridos: 50 % deudas, 20 % ahorro, 30 % libre. Editables.
- RN-11: Mientras exista alguna deuda activa con interés, `debts` nunca puede ser menor a 0 % pero se advierte si se pone en 0 %.
- RN-12: El reparto es una **sugerencia**; ningún movimiento se crea sin confirmación.

## Deudas
- RN-13: Estrategia configurable: **avalancha** (mayor interés primero) o **bola de nieve** (menor saldo primero). Por defecto: avalancha.
- RN-14: Un abono crea un gasto con `debt_id` y categoría `debt_payment`.
- RN-15: Un abono no puede superar el saldo pendiente.
- RN-16: Interés mensual informativo en v1: la app lo muestra y lo usa para ordenar, pero no lo suma automáticamente al saldo; el usuario puede registrar ajustes.
- RN-17: Alerta de cuota próxima: 3 días antes de `due_day`.

## Préstamos por cobrar
- RN-18: Cada cobro crea un ingreso con `receivable_id`, categoría `loan_collection`.
- RN-19: Los cobros **no cuentan como ingreso extra repartible** por defecto (opción en ajustes).
- RN-20: Un cobro no puede superar el saldo pendiente.
- RN-21: El total por cobrar se muestra aparte y nunca se suma al saldo disponible.

## Gastos
- RN-22: Categorías de moto (`fuel`, `moto_maintenance`, `moto_documents`) se agrupan en el reporte "Moto".
- RN-23: Gastos de pareja (`partner`, `outings`) se agrupan en el reporte "Salidas y pareja".
- RN-24: Una categoría con transacciones solo puede inhabilitarse, no borrarse.

## Ahorro
- RN-25: Un aporte a una meta es una transferencia a una cuenta de tipo `savings` con `goal_id`.
- RN-26: El progreso de la meta = suma de aportes − retiros asociados.

## Disponible seguro
```
disponible_seguro = ingreso_base
                  − gastos_fijos_del_mes
                  − Σ cuotas_mínimas_de_deudas_activas
                  − aporte_mínimo_a_ahorro
```
Si el resultado es negativo se muestra en rojo con el déficit.

## Cuentas
- RN-27: Una cuenta con transacciones solo se archiva, no se elimina.
- RN-28: Eliminar una transacción es lógico y reversible durante la sesión (snackbar "Deshacer").
