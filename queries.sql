
-- Top 10 spending customers

SELECT Customers.CompanyName, SUM(details.Quantity * details.UnitPrice) AS total_expenses
FROM order_details details
JOIN Orders ON Orders.OrderID = details.OrderID
JOIN Customers ON Customers.CustomerID = Orders.CustomerID
GROUP BY Customers.CompanyName
ORDER BY total_expenses DESC
LIMIT 10;

---

-- Top 10 customers with the most orders

SELECT Customers.CompanyName, COUNT(Orders.CustomerID) AS count_order
FROM Customers
JOIN Orders ON Customers.CustomerID = Orders.CustomerID
GROUP BY Customers.CompanyName
ORDER BY count_order DESC
LIMIT 10;

---

-- Top 10 best-selling products by quantity

SELECT Products.ProductName, SUM(order_details.Quantity) AS total_sold
FROM Products
JOIN order_details ON Products.ProductID = order_details.ProductID
GROUP BY Products.ProductName
ORDER BY total_sold DESC
LIMIT 10;

---

-- Top 10 most profitable products by revenue

SELECT Products.ProductName, SUM(order_details.Quantity * order_details.UnitPrice) AS total_income
FROM Products
JOIN order_details ON Products.ProductID = order_details.ProductID
GROUP BY Products.ProductName
ORDER BY total_income DESC
LIMIT 10;

---

-- Total quantity and revenue by product category

SELECT Categories.CategoryName AS Category, SUM(order_details.Quantity) AS total_sold,
SUM(order_details.Quantity * order_details.UnitPrice) AS total_income
FROM Products
JOIN order_details ON Products.ProductID = order_details.ProductID
JOIN Categories ON Categories.CategoryID = Products.CategoryID
GROUP BY Categories.CategoryName
ORDER BY total_income DESC;

---

-- Monthly sales and revenue trend (2022-01 to 2022-03)

SELECT strftime('%Y-%m', Orders.OrderDate) AS order_date,
SUM(order_details.Quantity) AS total_sold,
SUM(order_details.Quantity * order_details.UnitPrice) AS total_income
FROM order_details
JOIN Orders ON Orders.OrderID = order_details.OrderID
WHERE strftime('%Y-%m', Orders.OrderDate) BETWEEN '2022-01' AND '2022-03'
GROUP BY order_date
ORDER BY order_date;

---

-- Customer who made the single highest-value order

SELECT Orders.OrderID AS order_id, SUM(order_details.Quantity * order_details.UnitPrice) AS total_sold,
Customers.CompanyName AS company_name
FROM Orders
JOIN Customers ON Orders.CustomerID = Customers.CustomerID
JOIN order_details ON Orders.OrderID = order_details.OrderID
GROUP BY Orders.OrderID
ORDER BY total_sold DESC
LIMIT 1;

---

-- Top 3 customers by average order value 

WITH order_totals AS (
    SELECT Orders.OrderID, Orders.CustomerID,
    SUM(order_details.Quantity * order_details.UnitPrice) AS order_total
    FROM order_details
    JOIN Orders ON Orders.OrderID = order_details.OrderID
    GROUP BY Orders.OrderID
)
SELECT Customers.CompanyName, COUNT(order_totals.OrderID) AS total_orders,
SUM(order_totals.order_total) AS total_spent,
ROUND(AVG(order_totals.order_total), 2) AS avg_order_value
FROM order_totals
JOIN Customers ON order_totals.CustomerID = Customers.CustomerID
GROUP BY Customers.CompanyName
ORDER BY avg_order_value DESC
LIMIT 3;

---

-- Customer segmentation based on total spend

SELECT Customers.CompanyName, total_spent,
CASE
    WHEN total_spent >= 5000000 THEN 'High'
    WHEN total_spent >= 2000000 THEN 'Mid'
    ELSE 'Low'
END AS customer_segment
FROM (
    SELECT Orders.CustomerID, SUM(order_details.UnitPrice * order_details.Quantity) AS total_spent
    FROM order_details
    JOIN Orders ON order_details.OrderID = Orders.OrderID
    GROUP BY Orders.CustomerID
) AS sub
JOIN Customers ON sub.CustomerID = Customers.CustomerID
ORDER BY total_spent DESC;

---

-- Top 3 best-selling products in each category using window function

WITH sub AS (
    SELECT Products.ProductName AS product_name, Categories.CategoryName AS category_name,
    SUM(order_details.Quantity) AS total_sold
    FROM order_details
    JOIN Products ON order_details.ProductID = Products.ProductID
    JOIN Categories ON Categories.CategoryID = Products.CategoryID
    GROUP BY Products.ProductName, Categories.CategoryName
),
ranked AS (
    SELECT category_name, product_name, total_sold,
    ROW_NUMBER() OVER (PARTITION BY category_name ORDER BY total_sold DESC) AS rank
    FROM sub
)
SELECT * FROM ranked WHERE rank <= 3;

---

-- First 3 Orders per Customer

WITH product AS (
  SELECT 
  	p.ProductName AS product_name,
  	o.OrderDate AS order_date,
  	o.CustomerID
  FROM Orders o
  JOIN order_details od ON od.OrderID = o.OrderID
  JOIN Products p ON p.ProductID = od.ProductID

  ),ranked AS (
SELECT c.CompanyName AS company_name,
	   pr.product_name AS product_name,
       pr.order_date AS order_date,
       ROW_NUMBER() OVER(PARTITION BY c.CompanyName ORDER BY pr.order_date) AS rank
FROM product pr
JOIN Customers c ON pr.CustomerID = c.CustomerID
)

SELECT *
FROM ranked
WHERE rank <= 3
       