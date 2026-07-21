-- ============================================================
-- SQL INTERVIEW PREP - 40 MUST-PRACTICE EXERCISES
-- ============================================================
-- Dialect: Microsoft SQL Server (T-SQL) — runs in SSMS.
-- Run against the SqlPractice database created by the mock DB script.
-- Tip: Try writing each query yourself BEFORE reading the solution.
-- ============================================================

USE SqlPractice;
GO

-- ************************************************************
-- WEEK 1: CORE SQL
-- ************************************************************

-- ============================================================
-- DAY 1: SELECT + WHERE + ORDER BY
-- ============================================================

-- Q1: Find all premium customers from the USA.
-- Pattern: Basic filtering
SELECT first_name, last_name, city, state
FROM customers
WHERE is_premium = 1 AND country = 'USA';

-- Q2: Products priced between $100 and $500, sorted by price desc.
-- Pattern: Range filter + sorting
SELECT product_name, price, stock_quantity
FROM products
WHERE price BETWEEN 100 AND 500
ORDER BY price DESC;

-- Q3: Find orders that were never shipped.
-- Pattern: NULL check (very common trap)
SELECT id, customer_id, order_date, status
FROM orders
WHERE shipped_date IS NULL;

-- ============================================================
-- DAY 2: AGGREGATION + GROUP BY + HAVING
-- ============================================================

-- Q4: Number of employees in each department.
-- Pattern: Basic GROUP BY
SELECT department_id, COUNT(*) AS employee_count
FROM employees
GROUP BY department_id
ORDER BY employee_count DESC;

-- Q5: Departments where average salary exceeds $90,000.
-- Pattern: HAVING filter on aggregate
SELECT department_id, ROUND(AVG(salary), 2) AS avg_salary
FROM employees
GROUP BY department_id
HAVING AVG(salary) > 90000;

-- Q6: Customers who placed more than 2 delivered orders.
-- Pattern: GROUP BY + HAVING COUNT
SELECT customer_id, COUNT(*) AS order_count
FROM orders
WHERE status = 'delivered'
GROUP BY customer_id
HAVING COUNT(*) > 2
ORDER BY order_count DESC;

-- Q7: Total revenue per country, only countries with revenue > $2000.
-- Pattern: Aggregate + filter groups
SELECT
    shipping_country,
    SUM(total) AS total_revenue,
    COUNT(*) AS order_count
FROM orders
WHERE status = 'delivered'
GROUP BY shipping_country
HAVING SUM(total) > 2000
ORDER BY total_revenue DESC;

-- ============================================================
-- DAY 3: JOINs (Most tested in interviews!)
-- ============================================================

-- Q8: Show all orders with customer names.
-- Pattern: Basic INNER JOIN
-- NOTE (T-SQL): string concatenation uses + , not ||
SELECT
    o.id AS order_id,
    c.first_name + ' ' + c.last_name AS customer,
    o.order_date,
    o.total
FROM orders o
INNER JOIN customers c ON o.customer_id = c.id
ORDER BY o.order_date DESC;

-- Q9: Customers who have NEVER placed an order.
-- Pattern: LEFT JOIN + IS NULL (top interview question!)
SELECT c.first_name, c.last_name, c.email
FROM customers c
LEFT JOIN orders o ON c.id = o.customer_id
WHERE o.id IS NULL;

-- Q10: Show each employee with their manager's name.
-- Pattern: Self-join
SELECT
    e.first_name + ' ' + e.last_name AS employee,
    e.job_title,
    COALESCE(m.first_name + ' ' + m.last_name, 'No Manager') AS manager
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.id;

-- Q11: Order details with product names and customer info.
-- Pattern: Multi-table JOIN (3+ tables)
SELECT
    o.id AS order_id,
    c.first_name + ' ' + c.last_name AS customer,
    p.product_name,
    oi.quantity,
    oi.unit_price,
    oi.quantity * oi.unit_price AS line_total
FROM orders o
JOIN customers c ON o.customer_id = c.id
JOIN order_items oi ON o.id = oi.order_id
JOIN products p ON oi.product_id = p.id
ORDER BY o.id;

-- Q12: Revenue by product category.
-- Pattern: JOIN chain + aggregation
SELECT
    cat.name AS category,
    SUM(oi.quantity * oi.unit_price) AS revenue,
    COUNT(DISTINCT o.id) AS order_count
FROM order_items oi
JOIN products p ON oi.product_id = p.id
JOIN categories cat ON p.category_id = cat.id
JOIN orders o ON oi.order_id = o.id
WHERE o.status = 'delivered'
GROUP BY cat.name
ORDER BY revenue DESC;

-- ============================================================
-- DAY 4: SUBQUERIES
-- ============================================================

-- Q13: Products priced above the average.
-- Pattern: Subquery in WHERE
SELECT product_name, price
FROM products
WHERE price > (SELECT AVG(price) FROM products)
ORDER BY price;

-- Q14: Customers who ordered the most expensive product.
-- Pattern: Subquery with TOP (T-SQL uses TOP, not LIMIT)
SELECT DISTINCT c.first_name, c.last_name
FROM customers c
JOIN orders o ON c.id = o.customer_id
JOIN order_items oi ON o.id = oi.order_id
WHERE oi.product_id = (
    SELECT TOP 1 id FROM products ORDER BY price DESC
);

-- Q15: Employees who earn more than their department average.
-- Pattern: Correlated subquery (classic!)
SELECT e.first_name, e.last_name, e.salary, e.department_id
FROM employees e
WHERE e.salary > (
    SELECT AVG(e2.salary)
    FROM employees e2
    WHERE e2.department_id = e.department_id
);

-- Q16: Products that have never been ordered.
-- Pattern: NOT EXISTS
SELECT p.product_name, p.price
FROM products p
WHERE NOT EXISTS (
    SELECT 1 FROM order_items oi WHERE oi.product_id = p.id
);

-- ============================================================
-- DAY 5: CTEs (Common Table Expressions)
-- ============================================================

-- Q17: Top 5 customers by total spending using CTE.
-- Pattern: CTE + TOP
WITH customer_spending AS (
    SELECT
        customer_id,
        SUM(total) AS total_spent,
        COUNT(*) AS order_count
    FROM orders
    WHERE status = 'delivered'
    GROUP BY customer_id
)
SELECT TOP 5
    c.first_name + ' ' + c.last_name AS customer,
    cs.total_spent,
    cs.order_count
FROM customer_spending cs
JOIN customers c ON cs.customer_id = c.id
ORDER BY cs.total_spent DESC;

-- Q18: Departments where salary cost exceeds budget.
-- Pattern: CTE to simplify complex logic
WITH dept_costs AS (
    SELECT department_id, SUM(salary) AS total_salary
    FROM employees
    WHERE is_active = 1
    GROUP BY department_id
)
SELECT
    d.name AS department,
    d.budget,
    dc.total_salary,
    dc.total_salary - d.budget AS over_budget_by
FROM departments d
JOIN dept_costs dc ON d.id = dc.department_id
WHERE dc.total_salary > d.budget;

-- Q19: Products that are both highly rated AND best sellers.
-- Pattern: Multiple CTEs combined
WITH top_rated AS (
    SELECT product_id, ROUND(AVG(CAST(rating AS DECIMAL(4,2))), 1) AS avg_rating
    FROM reviews
    GROUP BY product_id
    HAVING AVG(CAST(rating AS DECIMAL(4,2))) >= 4.5
),
top_sellers AS (
    SELECT product_id, SUM(quantity) AS units_sold
    FROM order_items
    GROUP BY product_id
    HAVING SUM(quantity) >= 3
)
SELECT
    p.product_name,
    tr.avg_rating,
    ts.units_sold,
    p.price
FROM top_rated tr
JOIN top_sellers ts ON tr.product_id = ts.product_id
JOIN products p ON tr.product_id = p.id
ORDER BY tr.avg_rating DESC;

-- ************************************************************
-- WEEK 2: ADVANCED INTERVIEW PATTERNS
-- ************************************************************

-- ============================================================
-- DAY 8: WINDOW FUNCTIONS
-- ============================================================

-- Q20: Find the 2nd highest salary. (Classic!)
-- Pattern: DENSE_RANK
SELECT salary FROM (
    SELECT salary, DENSE_RANK() OVER (ORDER BY salary DESC) AS rnk
    FROM employees
) ranked
WHERE rnk = 2;

-- Q21: Rank employees by salary within each department.
-- Pattern: PARTITION BY + ROW_NUMBER
SELECT
    first_name + ' ' + last_name AS employee,
    department_id,
    salary,
    ROW_NUMBER() OVER (PARTITION BY department_id ORDER BY salary DESC) AS dept_rank
FROM employees
WHERE is_active = 1;

-- Q22: Top 2 earners per department.
-- Pattern: Top N per group (very common!)
WITH ranked AS (
    SELECT
        e.first_name, e.last_name, e.salary,
        d.name AS dept_name,
        ROW_NUMBER() OVER (PARTITION BY e.department_id ORDER BY e.salary DESC) AS rn
    FROM employees e
    JOIN departments d ON e.department_id = d.id
    WHERE e.is_active = 1
)
SELECT first_name, last_name, dept_name, salary
FROM ranked
WHERE rn <= 2
ORDER BY dept_name, rn;

-- Q23: Running total of revenue by date.
-- Pattern: Cumulative SUM
SELECT
    order_date,
    total,
    SUM(total) OVER (ORDER BY order_date) AS running_total
FROM orders
WHERE status = 'delivered'
ORDER BY order_date;

-- Q24: Compare each order to the previous order for same customer.
-- Pattern: LAG function
SELECT
    customer_id,
    order_date,
    total,
    LAG(total) OVER (PARTITION BY customer_id ORDER BY order_date) AS prev_order_total,
    total - LAG(total) OVER (PARTITION BY customer_id ORDER BY order_date) AS diff
FROM orders
WHERE status = 'delivered'
ORDER BY customer_id, order_date;

-- ============================================================
-- DAY 9: CASE WHEN + FUNCTIONS
-- ============================================================

-- Q25: Categorize employees into salary bands.
-- Pattern: CASE WHEN for bucketing
SELECT
    first_name + ' ' + last_name AS employee,
    salary,
    CASE
        WHEN salary >= 130000 THEN 'Executive'
        WHEN salary >= 100000 THEN 'Senior'
        WHEN salary >= 70000 THEN 'Mid-Level'
        ELSE 'Junior'
    END AS salary_band
FROM employees
WHERE is_active = 1
ORDER BY salary DESC;

-- Q26: Pivot — count orders by status.
-- Pattern: CASE WHEN as pivot (rows to columns)
SELECT
    shipping_country,
    COUNT(CASE WHEN status = 'delivered' THEN 1 END) AS delivered,
    COUNT(CASE WHEN status = 'pending' THEN 1 END) AS pending,
    COUNT(CASE WHEN status = 'cancelled' THEN 1 END) AS cancelled,
    COUNT(CASE WHEN status = 'processing' THEN 1 END) AS processing
FROM orders
GROUP BY shipping_country
ORDER BY delivered DESC;

-- Q27: Customer lifetime tier based on spending.
-- Pattern: CTE + CASE WHEN
WITH spending AS (
    SELECT customer_id, SUM(total) AS lifetime_value
    FROM orders WHERE status = 'delivered'
    GROUP BY customer_id
)
SELECT
    c.first_name + ' ' + c.last_name AS customer,
    s.lifetime_value,
    CASE
        WHEN s.lifetime_value >= 3000 THEN 'Platinum'
        WHEN s.lifetime_value >= 1500 THEN 'Gold'
        WHEN s.lifetime_value >= 500 THEN 'Silver'
        ELSE 'Bronze'
    END AS tier
FROM spending s
JOIN customers c ON s.customer_id = c.id
ORDER BY s.lifetime_value DESC;

-- ============================================================
-- DAY 10: UNION + SET OPERATIONS
-- ============================================================

-- Q28: Combined contact list of premium customers and managers.
-- Pattern: UNION to merge different sources
SELECT first_name + ' ' + last_name AS name, email, 'Premium Customer' AS role
FROM customers WHERE is_premium = 1
UNION
SELECT first_name + ' ' + last_name, email, 'Manager'
FROM employees WHERE id IN (SELECT DISTINCT manager_id FROM employees WHERE manager_id IS NOT NULL)
ORDER BY role, name;

-- ============================================================
-- DAY 12-13: REAL INTERVIEW QUESTIONS
-- ============================================================

-- Q29: Find duplicate emails.
-- Pattern: GROUP BY + HAVING COUNT > 1
SELECT email, COUNT(*) AS dup_count
FROM customers
GROUP BY email
HAVING COUNT(*) > 1;
-- (Our data has unique emails, but THIS is the pattern)

-- Q30: Find the Nth highest salary (here N=3).
-- Pattern: T-SQL uses OFFSET/FETCH instead of LIMIT/OFFSET
SELECT DISTINCT salary
FROM employees
ORDER BY salary DESC
OFFSET 2 ROWS FETCH NEXT 1 ROWS ONLY;  -- skip 2 => 3rd highest

-- Q31: Employees who earn the max salary in their dept.
-- Pattern: Subquery or window function

-- Approach 1: Correlated subquery
SELECT first_name, last_name, salary, department_id
FROM employees e
WHERE salary = (
    SELECT MAX(salary) FROM employees WHERE department_id = e.department_id
);

-- Approach 2: Window function
WITH ranked AS (
    SELECT first_name, last_name, salary, department_id,
        RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) AS rk
    FROM employees
)
SELECT first_name, last_name, salary, department_id FROM ranked WHERE rk = 1;

-- Q32: Year-over-year revenue comparison.
-- Pattern: Self-join on year (T-SQL uses YEAR(), not EXTRACT)
WITH yearly AS (
    SELECT
        YEAR(order_date) AS yr,
        SUM(total) AS revenue
    FROM orders
    WHERE status = 'delivered'
    GROUP BY YEAR(order_date)
)
SELECT
    curr.yr AS [year],
    curr.revenue,
    prev.revenue AS prev_year_revenue,
    ROUND((curr.revenue - prev.revenue) / prev.revenue * 100, 1) AS growth_pct
FROM yearly curr
LEFT JOIN yearly prev ON curr.yr = prev.yr + 1
ORDER BY curr.yr;

-- Q33: Customers who ordered in 2022 but NOT in 2023.
-- Pattern: Set difference (NOT IN / NOT EXISTS)
SELECT DISTINCT c.first_name, c.last_name
FROM customers c
JOIN orders o ON c.id = o.customer_id
WHERE YEAR(o.order_date) = 2022
    AND c.id NOT IN (
        SELECT customer_id FROM orders
        WHERE YEAR(order_date) = 2023
    );

-- Q34: Retention rate (ordered again within 90 days of first order).
-- Pattern: Self-join with date math (T-SQL uses DATEADD, not INTERVAL)
WITH first_orders AS (
    SELECT customer_id, MIN(order_date) AS first_order_date
    FROM orders WHERE status = 'delivered'
    GROUP BY customer_id
),
repeat_orders AS (
    SELECT fo.customer_id
    FROM first_orders fo
    JOIN orders o ON fo.customer_id = o.customer_id
    WHERE o.order_date > fo.first_order_date
        AND o.order_date <= DATEADD(DAY, 90, fo.first_order_date)
        AND o.status = 'delivered'
)
SELECT
    COUNT(DISTINCT fo.customer_id) AS total_customers,
    COUNT(DISTINCT ro.customer_id) AS retained_customers,
    ROUND(COUNT(DISTINCT ro.customer_id) * 100.0 / COUNT(DISTINCT fo.customer_id), 1) AS retention_rate_pct
FROM first_orders fo
LEFT JOIN repeat_orders ro ON fo.customer_id = ro.customer_id;

-- Q35: Delete duplicate rows keeping the one with lowest ID.
-- Pattern: CTE + ROW_NUMBER (asked at FAANG)
WITH duplicates AS (
    SELECT id, email,
        ROW_NUMBER() OVER (PARTITION BY email ORDER BY id) AS rn
    FROM customers
)
SELECT * FROM duplicates WHERE rn > 1;
-- To actually delete (T-SQL lets you DELETE straight from the CTE):
-- WITH duplicates AS (
--     SELECT id, ROW_NUMBER() OVER (PARTITION BY email ORDER BY id) AS rn
--     FROM customers
-- )
-- DELETE FROM duplicates WHERE rn > 1;

-- Q36: Moving average (3-row rolling average of order values).
-- Pattern: Window frame
SELECT
    order_date,
    total,
    ROUND(AVG(total) OVER (
        ORDER BY order_date
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ), 2) AS moving_avg_3
FROM orders
WHERE status = 'delivered'
ORDER BY order_date;

-- Q37: Products ordered together (market basket).
-- Pattern: Self-join on order_items
SELECT
    p1.product_name AS product_a,
    p2.product_name AS product_b,
    COUNT(*) AS times_ordered_together
FROM order_items oi1
JOIN order_items oi2 ON oi1.order_id = oi2.order_id AND oi1.product_id < oi2.product_id
JOIN products p1 ON oi1.product_id = p1.id
JOIN products p2 ON oi2.product_id = p2.id
GROUP BY p1.product_name, p2.product_name
HAVING COUNT(*) >= 2
ORDER BY times_ordered_together DESC;

-- Q38: Percentage of total (each product's share of revenue).
-- Pattern: Window function for percentage
WITH product_rev AS (
    SELECT
        p.product_name,
        SUM(oi.quantity * oi.unit_price) AS revenue
    FROM order_items oi
    JOIN products p ON oi.product_id = p.id
    JOIN orders o ON oi.order_id = o.id
    WHERE o.status = 'delivered'
    GROUP BY p.product_name
)
SELECT
    product_name,
    revenue,
    ROUND(revenue / SUM(revenue) OVER () * 100, 1) AS pct_of_total
FROM product_rev
ORDER BY revenue DESC;

-- Q39: Find gaps in sequential IDs.
-- Pattern: LEAD to find missing numbers
WITH gaps AS (
    SELECT id, LEAD(id) OVER (ORDER BY id) AS next_id
    FROM orders
)
SELECT id, next_id, next_id - id - 1 AS missing_count
FROM gaps
WHERE next_id - id > 1;

-- Q40: Full business dashboard in one query.
-- Pattern: Multiple CTEs (shows you can write production SQL)
WITH revenue AS (
    SELECT SUM(total) AS total_revenue, COUNT(*) AS total_orders
    FROM orders WHERE status = 'delivered'
),
top_product AS (
    SELECT TOP 1 p.product_name, SUM(oi.quantity) AS units
    FROM order_items oi
    JOIN products p ON oi.product_id = p.id
    GROUP BY p.product_name
    ORDER BY units DESC
),
top_customer AS (
    SELECT TOP 1 c.first_name + ' ' + c.last_name AS name, SUM(o.total) AS spent
    FROM orders o JOIN customers c ON o.customer_id = c.id
    WHERE o.status = 'delivered'
    GROUP BY c.first_name, c.last_name
    ORDER BY spent DESC
)
SELECT
    r.total_revenue,
    r.total_orders,
    ROUND(r.total_revenue / r.total_orders, 2) AS avg_order_value,
    tp.product_name AS best_seller,
    tc.name AS top_customer,
    tc.spent AS top_customer_spent
FROM revenue r, top_product tp, top_customer tc;

-- ============================================================
-- END OF INTERVIEW PREP EXERCISES
-- ============================================================
-- 40 questions covering ALL major interview patterns.
-- If you can solve these confidently, you're interview-ready.
-- ============================================================
