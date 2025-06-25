-- STEP 1: Create the database
CREATE DATABASE IF NOT EXISTS smartmart;
USE smartmart;

-- STEP 2: Create category master
CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL,
    description TEXT
);

-- STEP 3: Product catalog
CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category_id INT,
    price DECIMAL(10,2) NOT NULL,
    stock_quantity INT DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

-- STEP 4: Customer profiles
CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15),
    gender ENUM('Male','Female','Other'),
    date_joined DATETIME DEFAULT CURRENT_TIMESTAMP,
    status ENUM('Active','Inactive') DEFAULT 'Active'
);

-- STEP 5: Orders (transactions)
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10,2),
    status ENUM('Processing', 'Shipped', 'Delivered', 'Cancelled'),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- STEP 6: Order items
CREATE TABLE order_items (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    price_each DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- STEP 7: Employees
CREATE TABLE employees (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100),
    department_id INT,
    hire_date DATE,
    salary DECIMAL(10,2),
    supervisor_id INT,
    FOREIGN KEY (supervisor_id) REFERENCES employees(employee_id)
);

-- STEP 8: Departments
CREATE TABLE departments (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    dept_name VARCHAR(50),
    location VARCHAR(100)
);

-- STEP 9: Inventory
CREATE TABLE inventory (
    inventory_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT,
    stock_level INT,
    restock_date DATE,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- STEP 10: Delivery tracking
CREATE TABLE deliveries (
    delivery_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    delivery_status ENUM('Pending', 'In Transit', 'Delivered', 'Failed'),
    delivery_date DATE,
    courier VARCHAR(100),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

-- STEP 11: Finance transactions
CREATE TABLE finance_transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    order_id INT,
    amount DECIMAL(10,2),
    transaction_type ENUM('Payment', 'Refund'),
    transaction_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    is_fraud BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

-- STEP 12: Promotions
CREATE TABLE promotions (
    promo_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT,
    promo_name VARCHAR(100),
    discount_percent DECIMAL(5,2),
    start_date DATE,
    end_date DATE,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- STEP 13: Customer reviews
CREATE TABLE reviews (
    review_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    product_id INT,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    review_text TEXT,
    review_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
-- STEP 2: Insert into Categories
INSERT INTO categories (category_name, description) VALUES
('Electronics', 'Devices and gadgets'),
('Apparel', 'Clothing and fashion'),
('Home & Kitchen', 'Appliances and home goods'),
('Books', 'Printed and digital books'),
('Health & Beauty', 'Health care and beauty products');

-- STEP 3: Insert into Products
INSERT INTO products (product_name, category_id, price, stock_quantity) VALUES
('Smartphone Pro X', 1, 899.99, 150),
('4K Smart TV', 1, 1299.49, 85),
('Blender 3000', 3, 124.99, 200),
('Yoga Mat Deluxe', 5, 29.99, 300),
('Fiction Novel - The Escape', 4, 15.99, 120);

-- STEP 4: Insert into Customers
INSERT INTO customers (full_name, email, phone, gender, status) VALUES
('Alice Johnson', 'alice.johnson@example.com', '1234567890', 'Female', 'Active'),
('Bob Smith', 'bob.smith@example.com', '2345678901', 'Male', 'Active'),
('Charlie Brown', 'charlie.brown@example.com', '3456789012', 'Male', 'Inactive'),
('Dana Scully', 'dana.scully@example.com', '4567890123', 'Female', 'Active'),
('Evan Wright', 'evan.wright@example.com', '5678901234', 'Other', 'Active');

-- STEP 5: Insert into Orders
INSERT INTO orders (customer_id, total_amount, status) VALUES
(1, 899.99, 'Delivered'),
(2, 1299.49, 'Shipped'),
(3, 124.99, 'Processing'),
(4, 15.99, 'Cancelled'),
(5, 29.99, 'Processing');

-- STEP 6: Insert into Order Items
INSERT INTO order_items (order_id, product_id, quantity, price_each) VALUES
(1, 1, 1, 899.99),
(2, 2, 1, 1299.49),
(3, 3, 1, 124.99),
(4, 5, 1, 15.99),
(5, 4, 1, 29.99);

-- STEP 7: Insert into Employees
INSERT INTO employees (full_name, department_id, hire_date, salary, supervisor_id) VALUES
('John Manager', NULL, '2020-01-15', 80000, NULL),
('Sara Executive', 1, '2021-03-22', 55000, 1),
('Mark Analyst', 2, '2022-07-11', 45000, 1);

-- STEP 8: Insert into Departments
INSERT INTO departments (dept_name, location) VALUES
('Sales', 'New York'),
('IT', 'San Francisco'),
('Logistics', 'Chicago');

-- STEP 9: Insert into Inventory
INSERT INTO inventory (product_id, stock_level, restock_date) VALUES
(1, 150, '2025-07-01'),
(2, 85, '2025-07-10'),
(3, 200, '2025-06-30');

-- STEP 10: Insert into Deliveries
INSERT INTO deliveries (order_id, delivery_status, delivery_date, courier) VALUES
(1, 'Delivered', '2025-06-25', 'DHL'),
(2, 'In Transit', NULL, 'FedEx'),
(3, 'Pending', NULL, 'Blue Dart');

-- STEP 11: Insert into Finance Transactions
INSERT INTO finance_transactions (customer_id, order_id, amount, transaction_type, is_fraud) VALUES
(1, 1, 899.99, 'Payment', FALSE),
(2, 2, 1299.49, 'Payment', FALSE),
(3, 3, 124.99, 'Payment', FALSE),
(4, 4, 15.99, 'Refund', FALSE),
(5, 5, 29.99, 'Payment', FALSE);

-- STEP 12: Insert into Promotions
INSERT INTO promotions (product_id, promo_name, discount_percent, start_date, end_date) VALUES
(1, 'Summer Sale', 10.00, '2025-06-15', '2025-07-15'),
(4, 'Fitness Fest', 20.00, '2025-06-20', '2025-07-05');

-- STEP 13: Insert into Reviews
INSERT INTO reviews (customer_id, product_id, rating, review_text) VALUES
(1, 1, 5, 'Amazing phone!'),
(2, 2, 4, 'Great TV, worth the price.'),
(3, 3, 3, 'Blender is okay for the price.'),
(4, 5, 4, 'Good read.'),
(5, 4, 5, 'Very comfortable mat!');

-- Query 1: List all active customers
SELECT * 
FROM customers 
WHERE status = 'Active';

-- Query 2: Show all products in the "Electronics" category
SELECT p.product_name, c.category_name, p.price 
FROM products p
JOIN categories c ON p.category_id = c.category_id
WHERE c.category_name = 'Electronics';

-- Query 3: Find top 3 most expensive products
SELECT product_name, price 
FROM products
ORDER BY price DESC
LIMIT 3;

-- Query 4: Get all distinct order statuses
SELECT DISTINCT status 
FROM orders;

-- Query 5: Show all customer names and emails who placed orders
SELECT DISTINCT c.full_name, c.email
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id;

-- Query 1: Total number of orders placed by each customer
SELECT 
    c.customer_id,
    c.full_name,
    COUNT(o.order_id) AS total_orders
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.full_name;

-- Query 2: Total revenue from each customer
SELECT 
    c.customer_id,
    c.full_name,
    SUM(o.total_amount) AS total_revenue
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.full_name;

-- Query 3: Average order value by order status
SELECT 
    status,
    COUNT(order_id) AS total_orders,
    AVG(total_amount) AS avg_order_value
FROM orders
GROUP BY status;

-- Query 4: Products with more than 1 review and average rating above 4
SELECT 
    p.product_name,
    COUNT(r.review_id) AS total_reviews,
    AVG(r.rating) AS avg_rating
FROM products p
JOIN reviews r ON p.product_id = r.product_id
GROUP BY p.product_name
HAVING COUNT(r.review_id) > 1 AND AVG(r.rating) > 4;

-- Query 5: Number of products per category
SELECT 
    c.category_name,
    COUNT(p.product_id) AS product_count
FROM categories c
LEFT JOIN products p ON c.category_id = p.category_id
GROUP BY c.category_name;

-- Query 1: INNER JOIN – Products and their categories
SELECT 
    p.product_id,
    p.product_name,
    c.category_name,
    p.price
FROM products p
INNER JOIN categories c ON p.category_id = c.category_id;

-- Query 2: LEFT JOIN – All customers and their orders (including those who haven’t ordered)
SELECT 
    c.customer_id,
    c.full_name,
    o.order_id,
    o.order_date,
    o.total_amount
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id;

-- Query 3: RIGHT JOIN – All orders and the customers who placed them
SELECT 
    o.order_id,
    o.total_amount,
    c.full_name
FROM orders o
RIGHT JOIN customers c ON o.customer_id = c.customer_id;

-- Query 4: FULL OUTER JOIN – All products and any orders containing them
SELECT 
    p.product_id,
    p.product_name,
    oi.order_id,
    oi.quantity
FROM products p
LEFT JOIN order_items oi ON p.product_id = oi.product_id

UNION

SELECT 
    p.product_id,
    p.product_name,
    oi.order_id,
    oi.quantity
FROM products p
RIGHT JOIN order_items oi ON p.product_id = oi.product_id;

-- Query 5: JOIN Multiple Tables – Orders with customer name and product details
SELECT 
    o.order_id,
    c.full_name AS customer,
    p.product_name,
    oi.quantity,
    oi.price_each,
    o.status
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id;

-- Query 1: Scalar Subquery – Find the customer who placed the highest total amount order
SELECT full_name, customer_id
FROM customers
WHERE customer_id = (
    SELECT customer_id 
    FROM orders 
    ORDER BY total_amount DESC 
    LIMIT 1
);

-- Query 2: IN Subquery – List products that were ever ordered
SELECT product_name
FROM products
WHERE product_id IN (
    SELECT product_id 
    FROM order_items
);

-- Query 3: NOT IN Subquery – Products that were never ordered
SELECT product_name
FROM products
WHERE product_id NOT IN (
    SELECT product_id 
    FROM order_items
);

-- Query 4: EXISTS Subquery – Customers who have at least one order
SELECT full_name
FROM customers c
WHERE EXISTS (
    SELECT 1 
    FROM orders o 
    WHERE o.customer_id = c.customer_id
);

-- Query 5: Correlated Subquery – Products with price greater than average in their category
SELECT product_name, price
FROM products p
WHERE price > (
    SELECT AVG(price) 
    FROM products 
    WHERE category_id = p.category_id
);

-- Query 1: Assign row numbers to customers ordered by join date
SELECT 
    customer_id,
    full_name,
    date_joined,
    ROW_NUMBER() OVER (ORDER BY date_joined) AS row_num
FROM customers;

-- Query 2: Rank products by price within each category
SELECT 
    product_id,
    product_name,
    category_id,
    price,
    RANK() OVER (PARTITION BY category_id ORDER BY price DESC) AS price_rank
FROM products;

-- Query 3: Show previous order amount for each customer using LAG()
SELECT 
    customer_id,
    order_id,
    order_date,
    total_amount,
    LAG(total_amount) OVER (PARTITION BY customer_id ORDER BY order_date) AS previous_order
FROM orders;

-- Query 4: Show next order amount for each customer using LEAD()
SELECT 
    customer_id,
    order_id,
    order_date,
    total_amount,
    LEAD(total_amount) OVER (PARTITION BY customer_id ORDER BY order_date) AS next_order
FROM orders;

-- Query 5: Running total of order amount for each customer
SELECT 
    customer_id,
    order_id,
    order_date,
    total_amount,
    SUM(total_amount) OVER (PARTITION BY customer_id ORDER BY order_date) AS running_total
FROM orders;

-- Query 1: Use a CTE to get top 5 most expensive products
WITH ranked_products AS (
    SELECT 
        product_id,
        product_name,
        price,
        RANK() OVER (ORDER BY price DESC) AS price_rank
    FROM products
)
SELECT *
FROM ranked_products
WHERE price_rank <= 5;

-- Query 2: CTE to calculate average rating per product and filter only high-rated ones
WITH product_ratings AS (
    SELECT 
        product_id,
        AVG(rating) AS avg_rating
    FROM reviews
    GROUP BY product_id
)
SELECT 
    p.product_name,
    pr.avg_rating
FROM products p
JOIN product_ratings pr ON p.product_id = pr.product_id
WHERE pr.avg_rating > 4.0;

-- Query 3: Chain multiple CTEs to get department-wise average salary
WITH dept_emps AS (
    SELECT 
        e.employee_id,
        e.department_id,
        e.salary
    FROM employees e
),
avg_salaries AS (
    SELECT 
        department_id,
        AVG(salary) AS avg_salary
    FROM dept_emps
    GROUP BY department_id
)
SELECT 
    d.dept_name,
    a.avg_salary
FROM avg_salaries a
JOIN departments d ON a.department_id = d.department_id;

-- Query 4: CTE to find customers with no orders
WITH customer_orders AS (
    SELECT customer_id
    FROM orders
)
SELECT *
FROM customers
WHERE customer_id NOT IN (SELECT customer_id FROM customer_orders);

-- VIEW 1: Active customers and their total orders and spend
CREATE OR REPLACE VIEW active_customers_summary AS
SELECT 
    c.customer_id,
    c.full_name,
    COUNT(o.order_id) AS total_orders,
    SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE c.status = 'Active'
GROUP BY c.customer_id, c.full_name;

-- VIEW 2: Product performance with total sold and stock left
CREATE OR REPLACE VIEW product_performance AS
SELECT 
    p.product_id,
    p.product_name,
    p.stock_quantity,
    IFNULL(SUM(oi.quantity), 0) AS total_sold
FROM products p
LEFT JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name, p.stock_quantity;

-- PROCEDURE 1: Get total revenue between two dates
DELIMITER //
CREATE PROCEDURE get_total_revenue(IN start_date DATE, IN end_date DATE)
BEGIN
    SELECT 
        SUM(total_amount) AS total_revenue
    FROM orders
    WHERE order_date BETWEEN start_date AND end_date;
END //
DELIMITER ;

-- PROCEDURE 2: Add new product with parameters
DELIMITER //
CREATE PROCEDURE add_product(
    IN pname VARCHAR(100),
    IN cat_id INT,
    IN pprice DECIMAL(10,2),
    IN qty INT
)
BEGIN
    INSERT INTO products(product_name, category_id, price, stock_quantity)
    VALUES (pname, cat_id, pprice, qty);
END //
DELIMITER ;

-- INDEXES

-- Index on product_name for faster product searches
CREATE INDEX idx_product_name ON products(product_name);

-- Index on order_date for faster filtering by date
CREATE INDEX idx_order_date ON orders(order_date);

-- Composite index on order_items for efficient joins
CREATE INDEX idx_order_product ON order_items(order_id, product_id);

-- TRIGGERS

-- Trigger to reduce stock when an order item is inserted
DELIMITER //
CREATE TRIGGER reduce_stock_after_order
AFTER INSERT ON order_items
FOR EACH ROW
BEGIN
    UPDATE products
    SET stock_quantity = stock_quantity - NEW.quantity
    WHERE product_id = NEW.product_id;
END;
//
DELIMITER ;

-- Trigger to prevent inactive customers from placing orders
DELIMITER //
CREATE TRIGGER prevent_inactive_customer_order
BEFORE INSERT ON orders
FOR EACH ROW
BEGIN
    IF (SELECT status FROM customers WHERE customer_id = NEW.customer_id) = 'Inactive' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Inactive customers cannot place orders';
    END IF;
END;
//
DELIMITER ;

-- TRANSACTIONS

-- Sample transaction to insert an order and its items safely
START TRANSACTION;

-- Insert into orders
INSERT INTO orders (customer_id, total_amount, status)
VALUES (1, 200.00, 'Processing');

-- Capture last inserted order ID
SET @last_order_id = LAST_INSERT_ID();

-- Insert related order items
INSERT INTO order_items (order_id, product_id, quantity, price_each)
VALUES 
(@last_order_id, 1, 2, 50.00),
(@last_order_id, 2, 1, 100.00);

-- Commit transaction
COMMIT;
