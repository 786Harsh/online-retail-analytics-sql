# Online Retail Analytics - Database Schema

## Overview

The Online Retail Analytics database is a PostgreSQL database consisting of five tables:

- `customers`
- `products`
- `orders`
- `order_items`
- `payments`

The database is designed to analyze customer behavior, product performance, sales metrics, retention, revenue trends, payment activity, and order fulfillment.

---

## 1. Customers

The `customers` table stores customer information and signup details.

| Column | Data Type | Key | Description |
|---|---|---|---|
| `customer_id` | INT | Primary Key | Unique identifier for each customer |
| `full_name` | VARCHAR(100) | | Customer's full name |
| `email` | VARCHAR(150) | | Customer's email address |
| `phone` | VARCHAR(20) | | Customer's phone number |
| `country` | VARCHAR(100) | | Customer's country |
| `signup_date` | DATE | | Date when the customer signed up |
| `signup_channel` | VARCHAR(50) | | Channel used for customer signup |
| `loyalty_points` | INT | | Loyalty points associated with the customer |

---

## 2. Products

The `products` table stores information about products available for purchase.

| Column | Data Type | Key | Description |
|---|---|---|---|
| `product_id` | INT | Primary Key | Unique identifier for each product |
| `product_name` | VARCHAR(150) | | Name of the product |
| `price` | NUMERIC(10,2) | | Product price |
| `category` | VARCHAR(100) | | Product category |
| `brand` | VARCHAR(100) | | Product brand |
| `created_at` | TIMESTAMP | | Date and time when the product was created |
| `updated_at` | TIMESTAMP | | Date and time when the product was last updated |

---

## 3. Orders

The `orders` table stores information about customer orders.

| Column | Data Type | Key | Description |
|---|---|---|---|
| `order_id` | INT | Primary Key | Unique identifier for each order |
| `customer_id` | INT | Foreign Key | References `customers.customer_id` |
| `order_date` | DATE | | Date when the order was placed |
| `status` | VARCHAR(50) | | Current status of the order |
| `discount_amount` | NUMERIC(10,2) | | Discount applied to the order |
| `tax_amount` | NUMERIC(10,2) | | Tax charged on the order |
| `payment_method` | VARCHAR(50) | | Payment method used for the order |
| `shipping_address` | TEXT | | Shipping address for the order |

---

## 4. Order Items

The `order_items` table stores the individual products included in each order.

| Column | Data Type | Key | Description |
|---|---|---|---|
| `order_item_id` | INT | Primary Key | Unique identifier for each order item |
| `order_id` | INT | Foreign Key | References `orders.order_id` |
| `product_id` | INT | Foreign Key | References `products.product_id` |
| `quantity` | INT | | Number of units purchased |
| `unit_price` | NUMERIC(10,2) | | Price per unit at the time of purchase |

---

## 5. Payments

The `payments` table stores payment information associated with orders.

| Column | Data Type | Key | Description |
|---|---|---|---|
| `payment_id` | INT | Primary Key | Unique identifier for each payment |
| `order_id` | INT | Foreign Key | References `orders.order_id` |
| `payment_date` | TIMESTAMP | | Date and time of the payment |
| `payment_amount` | NUMERIC(10,2) | | Amount of the payment |
| `payment_status` | VARCHAR(50) | | Status of the payment |
| `payment_type` | VARCHAR(50) | | Type of payment |

---

