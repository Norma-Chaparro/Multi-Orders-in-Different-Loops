WITH order_locations AS (
SELECT p.order_id, t.location, p.du_id,t.tm_id
FROM x_pick p
LEFT JOIN x_tm t ON p.stock_tm_id = t.tm_id
WHERE t.location LIKE 'ob0_%'
),

orders_with_two_locations AS (
SELECT order_id, du_id
FROM order_locations
GROUP BY order_id, du_id
HAVING COUNT(DISTINCT location) = 2
)

SELECT distinct p.order_id, p.du_id,t.tm_id
FROM x_pick p
LEFT JOIN x_tm t ON p.stock_tm_id = t.tm_id
WHERE p.order_id IN (
SELECT order_id 
FROM orders_with_two_locations 
WHERE du_id = p.du_id
)
AND pick_state IN ('reserved')
AND p.stock_tm_id LIKE 'phe%'
AND t.location LIKE 'ob0_%' 
AND t.pss_status = 'GE(TUEX)'
ORDER BY 1;