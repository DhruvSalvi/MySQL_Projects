-- 1. Top Selling Products by Quantity and Revenue

SELECT 
    p.product_id,
    p.product_name,
    SUM(oi.quantity) as total_quantity_sold,
    ROUND(SUM(oi.quantity * oi.list_price * (1 - oi.discount)), 2) as total_revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_revenue DESC
LIMIT 10;

-- 2. Sales by Category

SELECT 
    c.category_name,
    COUNT(DISTINCT o.order_id) as total_orders,
    SUM(oi.quantity) as total_items_sold,
    ROUND(SUM(oi.quantity * oi.list_price * (1 - oi.discount)), 2) as total_revenue
FROM categories c
JOIN products p ON c.category_id = p.category_id
JOIN order_items oi ON p.product_id = oi.product_id
JOIN orders o ON oi.order_id = o.order_id
GROUP BY c.category_name
ORDER BY total_revenue DESC;

-- 3. Store Performance Analysis

SELECT 
    s.store_name,
    COUNT(DISTINCT o.order_id) as total_orders,
    COUNT(DISTINCT o.customer_id) as unique_customers,
    ROUND(SUM(oi.quantity * oi.list_price * (1 - oi.discount)), 2) as total_revenue,
    ROUND(SUM(oi.quantity * oi.list_price * (1 - oi.discount))/COUNT(DISTINCT o.order_id), 2) as avg_order_value
FROM stores s
JOIN orders o ON s.store_id = o.store_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY s.store_id, s.store_name
ORDER BY total_revenue DESC;

-- 4. Top Performing Staff Members

SELECT 
    CONCAT(st.first_name, ' ', st.last_name) as staff_name,
    s.store_name,
    COUNT(DISTINCT o.order_id) as total_orders,
    ROUND(SUM(oi.quantity * oi.list_price * (1 - oi.discount)), 2) as total_sales
FROM staffs st
JOIN stores s ON st.store_id = s.store_id
JOIN orders o ON st.staff_id = o.staff_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY st.staff_id, staff_name, s.store_name
ORDER BY total_sales DESC;

-- 5. Low Stock Alert Report

SELECT 
    p.product_id,
    p.product_name,
    b.brand_name,
    c.category_name,
    SUM(s.quantity) as current_stock,
    COUNT(oi.order_id) as times_ordered
FROM products p
JOIN brands b ON p.brand_id = b.brand_id
JOIN categories c ON p.category_id = c.category_id
LEFT JOIN stocks s ON p.product_id = s.product_id
LEFT JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name, b.brand_name, c.category_name
HAVING current_stock < 5
ORDER BY current_stock ASC;

-- 6. Customer Purchase Analysis

SELECT 
    CONCAT(c.first_name, ' ', c.last_name) as customer_name,
    c.city,
    c.state,
    COUNT(DISTINCT o.order_id) as total_orders,
    ROUND(SUM(oi.quantity * oi.list_price * (1 - oi.discount)), 2) as total_spent,
    ROUND(AVG(oi.quantity * oi.list_price * (1 - oi.discount)), 2) as avg_order_value
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_id, customer_name, c.city, c.state
ORDER BY total_spent DESC
LIMIT 10;

-- 7. Discount Impact Analysis

SELECT 
    CASE 
        WHEN discount = 0 THEN 'No Discount'
        WHEN discount <= 0.1 THEN '1-10%'
        WHEN discount <= 0.2 THEN '11-20%'
        ELSE 'Over 20%'
    END as discount_range,
    COUNT(DISTINCT order_id) as number_of_orders,
    ROUND(AVG(quantity), 2) as avg_quantity_per_order,
    ROUND(SUM(quantity * list_price * (1 - discount)), 2) as total_revenue
FROM order_items
GROUP BY discount_range
ORDER BY 
    CASE discount_range
        WHEN 'No Discount' THEN 1
        WHEN '1-10%' THEN 2
        WHEN '11-20%' THEN 3
        ELSE 4
    END;
    
-- 8. Order Processing Time Analysis

SELECT 
    store_name,
    AVG(DATEDIFF(shipped_date, order_date)) as avg_processing_days,
    COUNT(CASE WHEN shipped_date > required_date THEN 1 END) as late_shipments,
    COUNT(*) as total_orders,
    ROUND(COUNT(CASE WHEN shipped_date > required_date THEN 1 END) * 100.0 / COUNT(*), 2) as late_shipment_percentage
FROM orders o
JOIN stores s ON o.store_id = s.store_id
WHERE shipped_date IS NOT NULL
GROUP BY store_name
ORDER BY avg_processing_days;

-- 9. Product Return or Cancellation Rate

SELECT 
    p.product_name,
    COUNT(*) AS cancelled_orders
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE o.order_status IN ('Cancelled', 'Returned', '3') -- adjust status codes as per your data
GROUP BY p.product_id, p.product_name
ORDER BY cancelled_orders DESC
LIMIT 10;

-- 10. Average Basket Size (Items per Order)

SELECT 
    ROUND(AVG(item_count), 2) AS avg_items_per_order
FROM (
    SELECT order_id, SUM(quantity) AS item_count
    FROM order_items
    GROUP BY order_id
) t;

-- 11. Repeat Customer Rate

SELECT 
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM customers), 2) AS repeat_customer_percentage
FROM (
    SELECT customer_id
    FROM orders
    GROUP BY customer_id
    HAVING COUNT(order_id) > 1
) t;

-- 12. Most Popular Product by Region

SELECT 
    c.state,
    p.product_name,
    SUM(oi.quantity) AS total_sold
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY c.state, p.product_id
ORDER BY c.state, total_sold DESC;

-- 13. Inventory Turnover Rate

SELECT 
    p.product_name,
    SUM(oi.quantity) AS total_sold,
    SUM(s.quantity) AS current_stock,
    ROUND(SUM(oi.quantity) / NULLIF(SUM(s.quantity) + SUM(oi.quantity), 0), 2) AS turnover_rate
FROM products p
LEFT JOIN order_items oi ON p.product_id = oi.product_id
LEFT JOIN stocks s ON p.product_id = s.product_id
GROUP BY p.product_id, p.product_name
ORDER BY turnover_rate DESC;

-- 14. Customer Lifetime Value (CLV) Estimate

SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    ROUND(SUM(oi.quantity * oi.list_price * (1 - oi.discount)), 2) AS lifetime_value
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_id, customer_name
ORDER BY lifetime_value DESC
LIMIT 10;

