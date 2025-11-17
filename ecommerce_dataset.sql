-- Ecommerce SQL Database Dump

CREATE DATABASE IF NOT EXISTS ecommerce_db;
USE ecommerce_db;
-- Customers Table
CREATE TABLE IF NOT EXISTS Customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(50),
    email VARCHAR(100),
    country VARCHAR(50)
);

INSERT INTO Customers VALUES
(1, 'Amit Sharma', 'amit@gmail.com', 'India'),
(2, 'Riya Patel', 'riya@gmail.com', 'India'),
(3, 'John Miller', 'john@gmail.com', 'USA'),
(4, 'Sara Kim', 'sara@gmail.com', 'Korea'),
(5, 'David Lee', 'david@gmail.com', 'Canada');

-- Products Table
CREATE TABLE IF NOT EXISTS Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2)
);

INSERT INTO Products VALUES
(101, 'Laptop', 'Electronics', 55000.00),
(102, 'Smartphone', 'Electronics', 25000.00),
(103, 'Headphones', 'Electronics', 2000.00),
(104, 'Office Chair', 'Furniture', 7000.00),
(105, 'Keyboard', 'Electronics', 900.00);

-- Orders Table
CREATE TABLE IF NOT EXISTS Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

INSERT INTO Orders VALUES
(1001, 1, '2023-01-15', 57000.00),
(1002, 2, '2023-02-10', 26000.00),
(1003, 3, '2023-03-05', 9000.00),
(1004, 1, '2023-04-20', 2500.00),
(1005, 4, '2023-05-11', 7000.00);

-- OrderItems Table
CREATE TABLE IF NOT EXISTS OrderItems (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    subtotal DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

INSERT INTO OrderItems VALUES
(1, 1001, 101, 1, 55000.00),
(2, 1001, 103, 1, 2000.00),
(3, 1002, 102, 1, 25000.00),
(4, 1002, 105, 1, 900.00),
(5, 1003, 104, 1, 7000.00),
(6, 1003, 105, 2, 1800.00),
(7, 1004, 103, 1, 2000.00),
(8, 1005, 104, 1, 7000.00);

SHOW TABLES;

SELECT c.country, COUNT(o.order_id) AS total_orders
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.country;

SELECT c.name, SUM(o.total_amount) AS total_spent
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.name
ORDER BY total_spent DESC
LIMIT 1;

SELECT p.product_name, SUM(oi.subtotal) AS revenue
FROM Products p
JOIN OrderItems oi ON p.product_id = oi.product_id
GROUP BY p.product_name
ORDER BY revenue DESC
LIMIT 1;

SELECT DATE_FORMAT(order_date, '%Y-%m') AS month, SUM(total_amount) AS revenue
FROM Orders
GROUP BY month
ORDER BY month; 

SELECT c.name, COUNT(o.order_id) AS orders_count
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.name
HAVING orders_count > 1;

SELECT DISTINCT c.name
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
JOIN OrderItems oi ON o.order_id = oi.order_id
JOIN Products p ON p.product_id = oi.product_id
WHERE p.category = 'Electronics'; 
