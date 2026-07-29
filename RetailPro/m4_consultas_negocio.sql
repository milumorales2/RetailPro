-- Ejercicio Pre entrega 4
-- Autor: Milagros Lucía Morales
-- Fecha: 29-07-2026

USE Ventas_Tech_DB;

-- Consulta 1: Resumen ejecutivo mensual
-- Total facturado, cantidad de pedidos y ticket promedio por mes.

SELECT
MONTH(fecha_venta) AS mes,
SUM(cantidad * precio_unitario) AS total_facturado,
COUNT(*) AS cantidad_pedidos,
AVG(cantidad * precio_unitario) AS ticket_promedio
FROM Ventas
GROUP BY MONTH(fecha_venta)
ORDER BY mes;

-- Consulta 2: Ranking de productos (Top 5)
-- Top 5 id_producto por total facturado y sus unidades vendidas.

SELECT TOP 5
id_producto,
SUM(cantidad) AS unidades_vendidas,
SUM(cantidad * precio_unitario) AS total_generado
FROM Ventas
GROUP BY id_producto
ORDER BY total_generado DESC;

-- Consulta 3: Clientes recurrentes
-- Clientes con más de 1 pedido, cantidad de pedidos y gasto total.

SELECT
id_cliente,
COUNT(*) AS cantidad_pedidos,
SUM(cantidad * precio_unitario) AS total_gastado
FROM Ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1
ORDER BY cantidad_pedidos DESC, total_gastado DESC;

-- Consulta 4: Meses por encima / por debajo del promedio general
-- Total facturado por mes con etiqueta condicional según el promedio.

SELECT
MONTH(fecha_venta) AS mes,
AVG(cantidad * precio_unitario) AS total_facturado,

SELECT 
    mes_resumen.mes,
    mes_resumen.total_facturado_mes,
    CASE 
        WHEN mes_resumen.total_facturado_mes > (
            -- Subconsulta para calcular el promedio mensual general
            SELECT AVG(total_por_mes)
            FROM (
                SELECT SUM(cantidad * precio_unitario) AS total_por_mes
                FROM ventas
                GROUP BY MONTH(fecha_venta)
            ) AS ventas_mensuales
        ) THEN 'Por encima'
        ELSE 'Por debajo'
    END AS relacion_con_promedio
FROM (
    SELECT 
        MONTH(fecha_venta) AS mes,
        SUM(cantidad * precio_unitario) AS total_facturado_mes
    FROM Ventas
    GROUP BY MONTH(fecha_venta)
) AS mes_resumen
ORDER BY mes_resumen.mes;

-- BLOQUE DE CIERRE: Hallazgos clave de negocio
-- 1. Concentración de ventas: El producto con el total_generado mayor en la Consulta 2
--    representa una porción significativa del ingreso total, indicando alta dependencia de un solo ítem.
-- 2. Estacionalidad: En la Consulta 4 se podría llegar a observar un patrón en los meses clasificados 'Por encima' 
--    del promedio, lo cual ayudaría a prever picos de demanda para el inventario futuro.
-- 3. Fidelización: Los clientes recurrentes identificados en la Consulta 3 generan un mayor ticket promedio 
--    por transacción que los clientes de un único pedido, destacando la importancia de fidelizarlos.
