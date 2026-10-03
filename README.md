# Online Retail Analytics - SQL Case Study

## Overview

This project analyzes an online retail database to understand customer behavior, product performance, sales trends, revenue, customer retention, and order fulfillment.

The project uses PostgreSQL and SQL queries ranging from basic aggregations to advanced concepts such as CTEs, window functions, subqueries, and customer retention analysis.

## Objectives

* Design and work with a relational e-commerce database.
* Load and analyze customer, product, order, order item, and payment data.
* Write SQL queries to answer 21 business analysis questions.
* Analyze revenue, customer behavior, product performance, and order trends.
* Use advanced SQL techniques for analytical reporting.

## Database Schema

The database contains five main tables:

* `customers` - Customer information and signup details.
* `products` - Product, category, and brand information.
* `orders` - Customer orders, dates, countries, and order status.
* `order_items` - Products and quantities included in each order.
* `payments` - Payment transactions and payment status.

## Project Files

| File                            | Description                                                            |
| ------------------------------- | ---------------------------------------------------------------------- |
| `Online_Retail_Analytics.ipynb` | Executes SQL queries through Python and displays the analysis results. |
| `setup_database.py`             | Creates the database tables and loads the provided data.               |
| `queries.sql`                   | Contains the SQL queries used for the 21 analytical questions.         |
| `customers.csv`                 | Customer dataset.                                                      |
| `products.csv`                  | Product dataset.                                                       |
| `orders.xlsx`                   | Order dataset.                                                         |
| `order_items.xlsx`              | Order item dataset.                                                    |
| `payment.csv`                   | Payment transaction dataset.                                           |

## SQL Analysis

The case study contains 21 analytical questions covering:

1. Basic sales and customer analysis
2. Product and order analysis
3. Revenue calculations
4. Customer ordering behavior
5. Customer signup and first-order analysis
6. Customers ordering within 30 days of signup
7. Order status by country
8. Customer Lifetime Value
9. Repeat customer analysis
10. Monthly revenue trends
11. Most returned products
12. Top revenue-generating categories
13. Frequently bought-together products
14. Customer retention within 90 days
15. Net revenue after discounts and tax
16. Discount sensitivity
17. First vs. most recent purchase analysis
18. Revenue contribution and Pareto analysis
19. Brand affinity per customer
20. Payment failure impact
21. Customer order velocity

## SQL Concepts Used

* SELECT and filtering
* WHERE
* GROUP BY and HAVING
* ORDER BY
* Aggregate functions
* INNER JOIN and other joins
* Subqueries
* Common Table Expressions (CTEs)
* Window functions
* ROW_NUMBER()
* Date calculations
* CASE expressions
* Self joins
* Revenue and customer analysis
* Retention analysis
* Pareto analysis
* Basket analysis

## Tools and Technologies

* PostgreSQL
* SQL
* Python
* Pandas
* SQLAlchemy
* Jupyter Notebook
* VS Code
* Git and GitHub

## Deliverables

* SQL database schema and setup
* `queries.sql` containing all 21 analytical queries
* Jupyter Notebook with executed queries
* Query outputs for each question
* Database schema documentation
* Brief business insights from each analysis

## Key Insights

The analysis is used to identify:

* Customer purchasing and retention patterns
* High-value customers
* Revenue trends over time
* Best-performing products and categories
* Frequently purchased product combinations
* Impact of discounts on customer purchasing behavior
* Product return patterns
* Payment failure impact on successful orders
* Customer ordering frequency and purchase velocity

## How to Run

1. Install the required Python dependencies.
2. Configure the PostgreSQL database connection.
3. Run `setup_database.py` to create the tables and load the data.
4. Open `Online_Retail_Analytics.ipynb`.
5. Execute the notebook cells to run the analytical queries and view the results.

## Repository Structure

```text
Online_Retail_Analytics/
│
├── Online_Retail_Analytics.ipynb
├── setup_database.py
├── queries.sql
├── customers.csv
├── products.csv
├── orders.xlsx
├── order_items.xlsx
├── payment.csv
└── README.md
```
