# Northwind Advanced SQL Analysis

This project contains a series of advanced SQL queries and business case analyses using the classic Northwind database. The goal is to demonstrate practical SQL skills applied to real-world sales and customer data scenarios.

## Project Objectives

- Analyze customer behavior and segment them based on total spending
- Identify top-selling and most profitable products
- Track sales performance over time
- Use window functions to rank items within categories
- Retrieve earliest order activity per customer
- Implement clean and professional SQL code organization

## Dataset

This project includes the `northwind.db` SQLite file used to run all queries. You can open it using SQLite clients like DB Browser for SQLite or use it directly in your local setup.

The analysis uses the Northwind dataset, a well-known sample database for sales, customers, products, and orders. This dataset provides enough complexity to simulate realistic business reporting scenarios.

## SQL Topics Covered

- Aggregate functions (SUM, COUNT, AVG, ROUND)
- GROUP BY and HAVING clauses
- JOIN operations across multiple tables
- Common Table Expressions (CTEs)
- Window Functions (ROW_NUMBER with PARTITION BY)
- CASE WHEN statements for segmentation
- Date formatting with strftime for time-series analysis

## Query Categories

1. **Customer Analysis**
   - Total spending by customer
   - Most frequent ordering customers
   - Average order value (AOV) per customer
   - High/Mid/Low customer segmentation
   - First 3 orders per customer using ROW_NUMBER()

2. **Product Performance**
   - Best-selling products by quantity
   - Most profitable products by revenue
   - Top 3 products per category using window functions

3. **Sales Performance Over Time**
   - Monthly sales and revenue tracking
   - Year-on-year growth potential

4. **Business Insights**
   - Largest single orders
   - Revenue and quantity analysis by product category

## How to Use

- All SQL queries are included in the `advanced_sql_queries_with_explanations.sql` file
- Queries are grouped and commented clearly
- You can run these queries using SQLite tools, PostgreSQL, or any SQL execution environment with Northwind data

## Author

This project was created as part of a personal portfolio to demonstrate advanced SQL capability and simulate real-life business data scenarios.
