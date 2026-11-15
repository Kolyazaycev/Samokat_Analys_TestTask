WITH UserFirstOrders AS (
    SELECT 
        o.user_id, 
        MIN(o.order_date) AS first_order_date
    FROM orders o
    JOIN warehouses w ON o.warehouse_id = w.warehouse_id
    WHERE w.city = 'Санкт-Петербург'
    GROUP BY o.user_id
),
TargetFirstOrders AS (
    SELECT o.order_id
    FROM orders o
    JOIN UserFirstOrders ufo 
        ON o.user_id = ufo.user_id 
        AND o.order_date = ufo.first_order_date
    WHERE o.order_date >= '2017-08-15' 
      AND o.order_date <= '2017-08-30'
)
SELECT 
    p.product, 
    COUNT(ol.order_id) AS frequency
FROM TargetFirstOrders tfo
JOIN order_lines ol ON tfo.order_id = ol.order_id
JOIN products p ON ol.product_id = p.product_id
WHERE p.product IS NOT NULL
GROUP BY p.product
ORDER BY frequency DESC
LIMIT 5;