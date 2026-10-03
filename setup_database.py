import pandas as pd
from sqlalchemy import create_engine, text
from sqlalchemy.engine import URL

customers = pd.read_csv("customers.csv")
products = pd.read_csv("products.csv")
orders = pd.read_excel("orders.xlsx")
order_items = pd.read_excel("order_items.xlsx")
payments = pd.read_csv("payment.csv")

connection_url = URL.create(
    "postgresql+psycopg2",
    username="postgres",
    password="yourpassword",
    host="localhost",
    port=5432,
    database="Online Retail"
)

engine = create_engine(connection_url)

with engine.connect() as connection:
    print("PostgreSQL connection successful")

with engine.begin() as connection:
    connection.execute(text("""
        CREATE TABLE IF NOT EXISTS customers (
            customer_id INT PRIMARY KEY,
            full_name VARCHAR(100),
            email VARCHAR(150),
            phone VARCHAR(20),
            country VARCHAR(100),
            signup_date DATE,
            signup_channel VARCHAR(50),
            loyalty_points INT
        )
    """))

    connection.execute(text("""
        CREATE TABLE IF NOT EXISTS products (
            product_id INT PRIMARY KEY,
            product_name VARCHAR(150),
            price NUMERIC(10,2),
            category VARCHAR(100),
            brand VARCHAR(100),
            created_at TIMESTAMP,
            updated_at TIMESTAMP
        )
    """))

    connection.execute(text("""
        CREATE TABLE IF NOT EXISTS orders (
            order_id INT PRIMARY KEY,
            customer_id INT,
            order_date DATE,
            status VARCHAR(50),
            discount_amount NUMERIC(10,2),
            tax_amount NUMERIC(10,2),
            payment_method VARCHAR(50),
            shipping_address TEXT,
            FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
        )
    """))

    connection.execute(text("""
        CREATE TABLE IF NOT EXISTS order_items (
            order_item_id INT PRIMARY KEY,
            order_id INT,
            product_id INT,
            quantity INT,
            unit_price NUMERIC(10,2),
            FOREIGN KEY (order_id) REFERENCES orders(order_id),
            FOREIGN KEY (product_id) REFERENCES products(product_id)
        )
    """))

    connection.execute(text("""
        CREATE TABLE IF NOT EXISTS payments (
            payment_id INT PRIMARY KEY,
            order_id INT,
            payment_date TIMESTAMP,
            payment_amount NUMERIC(10,2),
            payment_status VARCHAR(50),
            payment_type VARCHAR(50),
            FOREIGN KEY (order_id) REFERENCES orders(order_id)
        )
    """))

print("Tables created successfully")

customers.to_sql("customers", engine, if_exists="append", index=False)
products.to_sql("products", engine, if_exists="append", index=False)
orders.to_sql("orders", engine, if_exists="append", index=False)
order_items.to_sql("order_items", engine, if_exists="append", index=False)
payments.to_sql("payments", engine, if_exists="append", index=False)

print("All data loaded successfully")




