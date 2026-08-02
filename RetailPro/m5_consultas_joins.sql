-- Ejercicio Pre entrega 5
-- Autor: Milagros Lucía Morales
-- Fecha: 01-08-2026

-- Consulta 1 — Vista base del proyecto (INNER JOIN) 
-- Combiná ventas, clientes, productos y territorios para obtener en una sola fila: 
-- fecha, nombre del cliente, segmento, región, nombre del producto, categoría, cantidad, precio unitario, total de venta y canal. 
-- Esta consulta será la fuente de datos principal en Power BI.

SELECT 
    v.fecha_venta AS fecha,
    c.nombre_cliente,
    c.segmento,
    t.region,
    p.nombre_producto,
    cat.nombre_categoria AS categoria,
    v.cantidad,
    v.precio_unitario,
    v.total_venta,
    v.canal
FROM ventas AS v
INNER JOIN clientes AS c 
    ON v.id_cliente = c.id_cliente
INNER JOIN territorios AS t 
    ON c.id_territorios = t.id_territorios
INNER JOIN productos AS p 
    ON v.id_producto = p.id_producto
INNER JOIN categorias AS cat 
    ON p.categoria = cat.nombre_categoria;

-- Consulta 2 — Clientes sin ventas (LEFT JOIN) 
-- Identificá clientes registrados que aún no han realizado ninguna compra. 
-- Mostrá su nombre, email y fecha de registro. Usá WHERE ... IS NULL para aislar los casos.

SELECT
    c.nombre_cliente,
    c.email,
    c.fecha_registro
FROM clientes AS c
LEFT JOIN ventas AS v
    ON v.id_cliente = c.id_cliente
WHERE v.id_venta IS NULL;

-- Consulta 3 — Productos sin ventas (LEFT JOIN) 
-- Identificá productos del catálogo que no tienen ninguna venta registrada. 
-- Mostrá nombre del producto, categoría y precio. Usá WHERE ... IS NULL.

SELECT
    p.nombre_producto,
    p.categoria,
    p.precio
FROM productos AS p
LEFT JOIN ventas AS v
    ON v.id_producto = p.id_producto
WHERE v.id_venta IS NULL;

-- Consulta 4 — Consolidado por canal (UNION ALL) 
-- Usá UNION ALL para combinar en un solo resultado las ventas Online y Presencial, 
-- agregando una columna canal que identifique el origen de cada fila. 
-- Al final calculá el total por canal con un GROUP BY.

WITH VentasConsolidadas AS (
    -- Ventas del canal Online
    SELECT 
        id_venta,
        canal,
        total_venta
    FROM ventas
    WHERE canal = 'Online'

    UNION ALL

    -- Ventas del canal Presencial
    SELECT 
        id_venta,
        canal,
        total_venta
    FROM ventas
    WHERE canal = 'Presencial'
)
SELECT 
    canal,
    COUNT(*) AS cantidad_transacciones,
    SUM(total_venta) AS total_ventas_canal
FROM VentasConsolidadas
GROUP BY canal;
