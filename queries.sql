-- Q1: Retrieve top 5 highest value completed orders
SELECT
    o.order_id,
    o.customer_id,
    SUM(oi.quantity * oi.unit_price) AS order_amount,
    o.order_date
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE o.status = 'Completed'
GROUP BY
    o.order_id,
    o.customer_id,
    o.order_date
ORDER BY order_amount DESC
LIMIT 5;



-- Q2: List customers with more than 2 orders
SELECT
        c.customer_id,
        c.full_name,
        COUNT(o.order_id) AS total_orders
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY
        c.customer_id,
        c.full_name
    HAVING COUNT(o.order_id) > 2
    ORDER BY total_orders DESC; 



-- Q3: Get customers who never placed an order using LEFT JOIN
SELECT
    c.customer_id,
    c.full_name,
    c.signup_date
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;



-- Q4: Show most expensive product purchased by each customer
SELECT
    o.customer_id,
    p.product_name,
    p.price
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
WHERE p.price = (   
    SELECT MAX(p2.price)    
    FROM orders o2
    JOIN order_items oi2
        ON o2.order_id = oi2.order_id
    JOIN products p2
        ON oi2.product_id = p2.product_id
    WHERE o2.customer_id = o.customer_id
);



-- Q5: Find order with largest number of items
WITH order_totals AS (
    SELECT
        order_id,
        SUM(quantity) AS total_items
    FROM order_items
    GROUP BY order_id
)
SELECT
    order_id,
    total_items
FROM order_totals
WHERE total_items = (
    SELECT MAX(total_items)
    FROM order_totals
)
ORDER BY order_id;



-- Q6: List customers who ordered within 30 days of signup
WITH first_orders AS (
    SELECT
        customer_id,
        MIN(order_date) AS first_order_date
    FROM orders
    GROUP BY customer_id
)
 
SELECT
    c.customer_id,
    c.full_name,
    c.signup_date,
    f.first_order_date,
    (f.first_order_date - c.signup_date) AS days_difference
FROM customers AS c
INNER JOIN first_orders AS f
    ON c.customer_id = f.customer_id
WHERE
    (f.first_order_date - c.signup_date) BETWEEN 0 AND 30
ORDER BY
    days_difference ASC,
    c.customer_id;



-- Q7: Count orders per status per country
SELECT
    c.country,
    o.status,
    COUNT(o.order_id) AS order_count
FROM customers AS c
INNER JOIN orders AS o
    ON c.customer_id = o.customer_id
GROUP BY c.country, o.status
ORDER BY c.country, o.status;



-- Q8: Calculate Customer Lifetime Value
SELECT
    c.customer_id,
    c.full_name,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS total_revenue
FROM customers AS c
INNER JOIN orders AS o
    ON c.customer_id = o.customer_id
INNER JOIN order_items AS oi
    ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.full_name
ORDER BY total_revenue DESC;



-- Q9: Identify repeat customers - more than 1 order per month
SELECT
    c.customer_id,
    c.full_name,
    DATE_TRUNC('month', o.order_date) AS order_month,
    COUNT(o.order_id) AS monthly_order_count
FROM customers AS c
INNER JOIN orders AS o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.full_name, DATE_TRUNC('month', o.order_date)
HAVING COUNT(o.order_id) > 1
ORDER BY c.customer_id, order_month;



-- Q10: Monthly revenue trend
SELECT
    EXTRACT(YEAR FROM o.order_date) AS year,
    EXTRACT(MONTH FROM o.order_date) AS month,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS total_revenue
FROM orders AS o
INNER JOIN order_items AS oi
    ON o.order_id = oi.order_id
GROUP BY EXTRACT(YEAR FROM o.order_date), EXTRACT(MONTH FROM o.order_date)
ORDER BY year, month;



-- Q11: Most returned products where status=Returned
SELECT
    p.product_id,
    p.product_name,
    COUNT(*) AS return_count
FROM orders AS o
INNER JOIN order_items AS oi
    ON o.order_id = oi.order_id
INNER JOIN products AS p
    ON oi.product_id = p.product_id
WHERE o.status = 'Returned'
GROUP BY p.product_id, p.product_name
ORDER BY return_count DESC, p.product_id;


-- Q12: Top 3 revenue-generating categories
SELECT
    p.category,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS total_revenue
FROM order_items AS oi
INNER JOIN products AS p
    ON oi.product_id = p.product_id
GROUP BY p.category
ORDER BY total_revenue DESC
LIMIT 3;



-- Q13: Products frequently bought together - basket analysis
SELECT
    oi1.product_id AS product_id_1,
    oi2.product_id AS product_id_2,
    COUNT(DISTINCT oi1.order_id) AS times_bought_together
FROM order_items AS oi1
INNER JOIN order_items AS oi2
    ON oi1.order_id = oi2.order_id
    AND oi1.product_id < oi2.product_id
GROUP BY oi1.product_id, oi2.product_id
ORDER BY times_bought_together DESC, product_id_1, product_id_2;



-- Q14: Customer retention - ordered again within 90 days
WITH customer_orders AS (
    SELECT
        o.customer_id,
        o.order_date,
        LEAD(o.order_date) OVER (
            PARTITION BY o.customer_id
            ORDER BY o.order_date
        ) AS next_order_date
    FROM orders AS o
)
SELECT
    c.customer_id,
    c.full_name,
    co.order_date AS first_order_date,
    co.next_order_date,
    (co.next_order_date - co.order_date) AS days_between_orders
FROM customer_orders AS co
INNER JOIN customers AS c
    ON co.customer_id = c.customer_id
WHERE
    co.next_order_date IS NOT NULL
    AND (co.next_order_date - co.order_date) BETWEEN 1 AND 90
ORDER BY days_between_orders ASC, c.customer_id;



-- Q15: Net Revenue After Discounts & Tax monthly country-wise
SELECT
    c.country,
    EXTRACT(YEAR FROM o.order_date) AS year,
    EXTRACT(MONTH FROM o.order_date) AS month,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS gross_revenue,
    ROUND(SUM(o.discount_amount), 2) AS total_discount,
    ROUND(SUM(o.tax_amount), 2) AS total_tax,
    ROUND(SUM(oi.quantity * oi.unit_price) - SUM(o.discount_amount) + SUM(o.tax_amount), 2) AS net_revenue
FROM customers AS c
INNER JOIN orders AS o
    ON c.customer_id = o.customer_id
INNER JOIN order_items AS oi
    ON o.order_id = oi.order_id
GROUP BY c.country, EXTRACT(YEAR FROM o.order_date), EXTRACT(MONTH FROM o.order_date)
ORDER BY c.country, year, month;



-- Q16: Discount Sensitivity - customers who only order with discounts
SELECT
    c.customer_id,
    c.full_name,
    COUNT(o.order_id) AS total_orders,
    COUNT(CASE WHEN o.discount_amount > 0 THEN 1 END) AS discounted_orders
FROM customers AS c
INNER JOIN orders AS o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.full_name
HAVING COUNT(o.order_id) = COUNT(CASE WHEN o.discount_amount > 0 THEN 1 END)
ORDER BY c.customer_id;



-- Q17: First vs Most Recent Purchase Product using ROW_NUMBER
WITH ranked_orders AS (
    SELECT
        o.customer_id,
        p.product_name,
        ROW_NUMBER() OVER (
            PARTITION BY o.customer_id
            ORDER BY o.order_date, o.order_id
        ) AS first_rank,
        ROW_NUMBER() OVER (
            PARTITION BY o.customer_id
            ORDER BY o.order_date DESC, o.order_id DESC
        ) AS last_rank
    FROM orders AS o
    INNER JOIN order_items AS oi
        ON o.order_id = oi.order_id
    INNER JOIN products AS p
        ON oi.product_id = p.product_id
)
SELECT
    customer_id,
    MAX(CASE WHEN first_rank = 1 THEN product_name END) AS first_product_name,
    MAX(CASE WHEN last_rank = 1 THEN product_name END) AS last_product_name
FROM ranked_orders
GROUP BY customer_id
ORDER BY customer_id;



-- Q18: Revenue Contribution Pareto Analysis - top customers for 80% revenue
WITH customer_revenue AS (
    SELECT
        c.customer_id,
        c.full_name,
        SUM(oi.quantity * oi.unit_price) AS customer_revenue
    FROM customers AS c
    INNER JOIN orders AS o
        ON c.customer_id = o.customer_id
    INNER JOIN order_items AS oi
        ON o.order_id = oi.order_id
    GROUP BY c.customer_id, c.full_name
),
revenue_totals AS (
    SELECT
        customer_id,
        full_name,
        customer_revenue,
        SUM(customer_revenue) OVER (
            ORDER BY customer_revenue DESC, customer_id
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS cumulative_revenue,
        SUM(customer_revenue) OVER () AS total_revenue
    FROM customer_revenue
)
SELECT
    customer_id,
    full_name,
    ROUND(customer_revenue, 2) AS customer_revenue,
    ROUND(cumulative_revenue, 2) AS cumulative_revenue,
    ROUND((cumulative_revenue / total_revenue) * 100, 2) AS cumulative_percentage
FROM revenue_totals
WHERE (cumulative_revenue / total_revenue) <= 0.80
ORDER BY customer_revenue DESC, customer_id;



-- Q19: Brand Affinity per Customer
SELECT
    c.customer_id,
    p.brand,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS brand_revenue
FROM customers AS c
INNER JOIN orders AS o
    ON c.customer_id = o.customer_id
INNER JOIN order_items AS oi
    ON o.order_id = oi.order_id
INNER JOIN products AS p
    ON oi.product_id = p.product_id
GROUP BY c.customer_id, p.brand
ORDER BY c.customer_id, brand_revenue DESC;



-- Q20: Payment Failure Impact - orders with failed then successful payment
WITH payment_summary AS (
    SELECT
        order_id,
        COUNT(CASE WHEN payment_status = 'Failed' THEN 1 END) AS failed_attempts,
        MAX(CASE WHEN payment_status = 'Completed' THEN payment_date END) AS successful_payment_date,
        MAX(CASE WHEN payment_status = 'Completed' THEN 1 ELSE 0 END) AS has_successful_payment,
        MAX(CASE WHEN payment_status = 'Completed' THEN payment_date END) AS success_date
    FROM payments
    GROUP BY order_id
)
SELECT
    o.order_id,
    o.customer_id,
    ps.failed_attempts,
    ps.successful_payment_date
FROM orders AS o
INNER JOIN payment_summary AS ps
    ON o.order_id = ps.order_id
WHERE ps.failed_attempts > 0
    AND ps.has_successful_payment = 1
ORDER BY o.order_id;



-- Q21: Customer Order Velocity - avg days between orders 
WITH order_dates AS (
    SELECT
        o.customer_id,
        o.order_date,
        LAG(o.order_date) OVER (
            PARTITION BY o.customer_id
            ORDER BY o.order_date
        ) AS previous_order_date
    FROM orders AS o
)
SELECT
    c.customer_id,
    c.full_name,
    COUNT(od.order_date) AS total_orders,
    ROUND(AVG(od.order_date - od.previous_order_date), 2) AS avg_days_between_orders
FROM customers AS c
INNER JOIN order_dates AS od
    ON c.customer_id = od.customer_id
GROUP BY c.customer_id, c.full_name
HAVING COUNT(od.order_date) > 1
ORDER BY avg_days_between_orders, c.customer_id;
