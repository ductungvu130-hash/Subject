-- =========================================================
-- DATABASE: TechNova Electronics Store
-- Compatible with older XAMPP / MySQL / MariaDB
-- Usage: Ctrl + A => Ctrl + Shift + Enter
-- =========================================================

DROP DATABASE IF EXISTS technova_store_db;
CREATE DATABASE technova_store_db;
USE technova_store_db;

-- =========================================================
-- TABLE: customer
-- =========================================================
CREATE TABLE customer (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    email VARCHAR(100),
    registration_date DATE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =========================================================
-- TABLE: product
-- =========================================================
CREATE TABLE product (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(150) NOT NULL,
    category VARCHAR(50) NOT NULL,
    unit_price DECIMAL(15,2) NOT NULL,
    stock_quantity INT NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =========================================================
-- TABLE: order_header
-- Note: "order" is a reserved word, so use order_header
-- =========================================================
CREATE TABLE order_header (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    status VARCHAR(20) NOT NULL,
    total_amount DECIMAL(15,2) NOT NULL DEFAULT 0,
    CONSTRAINT fk_order_customer
        FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =========================================================
-- TABLE: order_detail
-- =========================================================
CREATE TABLE order_detail (
    detail_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(15,2) NOT NULL,
    CONSTRAINT fk_detail_order
        FOREIGN KEY (order_id) REFERENCES order_header(order_id),
    CONSTRAINT fk_detail_product
        FOREIGN KEY (product_id) REFERENCES product(product_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =========================================================
-- TABLE: payment
-- =========================================================
CREATE TABLE payment (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    payment_date DATE NOT NULL,
    payment_method VARCHAR(30) NOT NULL,
    amount DECIMAL(15,2) NOT NULL,
    CONSTRAINT fk_payment_order
        FOREIGN KEY (order_id) REFERENCES order_header(order_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =========================================================
-- SAMPLE DATA: customer
-- =========================================================
INSERT INTO customer (full_name, phone, email, registration_date) VALUES
('Nguyen Minh Khang', '0903123456', 'khang.nguyen@gmail.com', '2023-11-15'),
('Tran Bao Chau', '0914567890', 'chau.tran@yahoo.com', '2024-01-05'),
('Le Hoang Nam', '0988123456', 'hoangnam.le@outlook.com', '2024-01-20'),
('Pham Thu Ha', '0933777888', 'thuha.pham@gmail.com', '2024-02-12'),
('Vo Quoc Huy', '0977666555', 'quochuy.vo@gmail.com', '2024-02-28'),
('Bui Gia Han', '0944555666', 'giahan.bui@gmail.com', '2024-03-10'),
('Do Thanh Tung', '0966888999', 'thanhtung.do@outlook.com', '2024-03-22'),
('Hoang My Linh', '0922333444', 'mylinh.hoang@gmail.com', '2024-04-06'),
('Nguyen Tuan Dat', '0911222333', 'tuandat.nguyen@yahoo.com', '2024-04-18'),
('Dang Khanh Vy', '0987000111', 'khanhvy.dang@gmail.com', '2024-05-01'),
('Phan Duc Anh', '0909000222', 'ducanh.phan@gmail.com', '2024-05-16'),
('Luu Bao Nhi', '0938111222', 'baonhi.luu@gmail.com', '2024-06-03');

-- =========================================================
-- SAMPLE DATA: product
-- =========================================================
INSERT INTO product (product_name, category, unit_price, stock_quantity) VALUES
('Dell Inspiron 15', 'Laptop', 18990000, 25),
('HP Pavilion 14', 'Laptop', 21490000, 18),
('Asus Vivobook 15', 'Laptop', 17650000, 20),
('MacBook Air M1', 'Laptop', 19990000, 10),
('Lenovo ThinkPad E14', 'Laptop', 23990000, 12),
('iPad 10', 'Tablet', 11490000, 30),
('Samsung Galaxy Tab S9', 'Tablet', 16990000, 15),
('Xiaomi Redmi Pad SE', 'Tablet', 5490000, 40),
('Logitech MX Master 3S', 'Accessory', 2490000, 35),
('Logitech K380 Keyboard', 'Accessory', 790000, 50),
('Samsung 27 Inch Monitor', 'Monitor', 4590000, 20),
('Dell 24 Inch Monitor', 'Monitor', 3890000, 25),
('Anker 65W Charger', 'Accessory', 890000, 60),
('External SSD 1TB', 'Storage', 2390000, 28),
('TP-Link Archer AX23 Router', 'Networking', 1490000, 22);

-- =========================================================
-- SAMPLE DATA: order_header
-- =========================================================
INSERT INTO order_header (customer_id, order_date, status, total_amount) VALUES
(1,  '2024-01-10', 'completed', 19780000),
(2,  '2024-01-15', 'completed', 12280000),
(3,  '2024-02-02', 'completed', 26460000),
(4,  '2024-02-18', 'completed', 45540000),
(1,  '2024-03-05', 'pending',   28550000),
(5,  '2024-03-20', 'completed', 28060000),
(6,  '2024-04-12', 'cancelled', 11490000),
(7,  '2024-04-28', 'completed', 7170000),
(8,  '2024-05-09', 'completed', 41750000),
(2,  '2024-05-17', 'completed', 23220000),
(9,  '2024-06-01', 'completed', 52640000),
(10, '2024-06-18', 'pending',   6380000),
(3,  '2024-07-02', 'completed', 25560000),
(11, '2024-07-19', 'completed', 4680000),
(12, '2024-08-04', 'completed', 32650000),
(4,  '2024-08-22', 'completed', 10440000),
(5,  '2024-09-10', 'pending',   23990000),
(7,  '2024-09-25', 'completed', 24130000);

-- =========================================================
-- SAMPLE DATA: order_detail
-- =========================================================
INSERT INTO order_detail (order_id, product_id, quantity, unit_price) VALUES
-- Order 1 = 19,780,000
(1, 1, 1, 18990000),
(1, 13, 1, 890000),

-- Order 2 = 12,280,000
(2, 6, 1, 11490000),
(2, 10, 1, 790000),

-- Order 3 = 26,460,000
(3, 7, 1, 16990000),
(3, 11, 1, 4590000),
(3, 9, 1, 2490000),
(3, 14, 1, 2390000),

-- Order 4 = 45,540,000
(4, 4, 2, 19990000),
(4, 14, 1, 2390000),
(4, 13, 1, 890000),
(4, 15, 1, 1490000),
(4, 10, 1, 790000),

-- Order 5 = 28,550,000
(5, 2, 1, 21490000),
(5, 12, 1, 3890000),
(5, 13, 1, 890000),
(5, 10, 1, 790000),
(5, 15, 1, 1490000),

-- Order 6 = 28,060,000
(6, 5, 1, 23990000),
(6, 10, 1, 790000),
(6, 13, 1, 890000),
(6, 14, 1, 2390000),

-- Order 7 = 11,490,000
(7, 6, 1, 11490000),

-- Order 8 = 7,170,000
(8, 8, 1, 5490000),
(8, 10, 1, 790000),
(8, 13, 1, 890000),

-- Order 9 = 41,750,000
(9, 5, 1, 23990000),
(9, 6, 1, 11490000),
(9, 11, 1, 4590000),
(9, 13, 1, 890000),
(9, 10, 1, 790000),

-- Order 10 = 23,220,000
(10, 3, 1, 17650000),
(10, 12, 1, 3890000),
(10, 10, 1, 790000),
(10, 13, 1, 890000),

-- Order 11 = 52,640,000
(11, 4, 1, 19990000),
(11, 5, 1, 23990000),
(11, 11, 1, 4590000),
(11, 14, 1, 2390000),
(11, 13, 1, 890000),
(11, 10, 1, 790000),

-- Order 12 = 6,380,000
(12, 8, 1, 5490000),
(12, 13, 1, 890000),

-- Order 13 = 25,560,000
(13, 2, 1, 21490000),
(13, 14, 1, 2390000),
(13, 13, 1, 890000),
(13, 10, 1, 790000),

-- Order 14 = 4,680,000
(14, 12, 1, 3890000),
(14, 10, 1, 790000),

-- Order 15 = 32,650,000
(15, 5, 1, 23990000),
(15, 11, 1, 4590000),
(15, 14, 1, 2390000),
(15, 13, 1, 890000),
(15, 10, 1, 790000),

-- Order 16 = 10,440,000
(16, 14, 2, 2390000),
(16, 9, 1, 2490000),
(16, 13, 1, 890000),
(16, 15, 1, 1490000),
(16, 10, 1, 790000),

-- Order 17 = 23,990,000
(17, 5, 1, 23990000),

-- Order 18 = 24,130,000
(18, 6, 1, 11490000),
(18, 11, 1, 4590000),
(18, 9, 1, 2490000),
(18, 13, 1, 890000),
(18, 10, 1, 790000),
(18, 15, 1, 1490000),
(18, 14, 1, 2390000);

-- =========================================================
-- SAMPLE DATA: payment
-- Some orders are fully paid, some are partially paid, some unpaid
-- =========================================================
INSERT INTO payment (order_id, payment_date, payment_method, amount) VALUES
(1,  '2024-01-10', 'cash',          19780000),
(2,  '2024-01-15', 'bank transfer', 12280000),
(3,  '2024-02-02', 'credit card',   26460000),
(4,  '2024-02-18', 'bank transfer', 45540000),
(5,  '2024-03-05', 'cash',          20000000),
(6,  '2024-03-20', 'credit card',   28060000),
(8,  '2024-04-28', 'cash',          7170000),
(9,  '2024-05-09', 'bank transfer', 41750000),
(10, '2024-05-17', 'credit card',   23220000),
(11, '2024-06-01', 'bank transfer', 52640000),
(12, '2024-06-18', 'cash',          3000000),
(13, '2024-07-02', 'credit card',   25560000),
(14, '2024-07-19', 'cash',          4680000),
(15, '2024-08-04', 'bank transfer', 32650000),
(16, '2024-08-22', 'cash',          10440000),
(18, '2024-09-25', 'bank transfer', 24130000);

-- =========================================================
-- QUICK CHECKS
-- =========================================================
SELECT * FROM customer;
SELECT * FROM product;
SELECT * FROM order_header;
SELECT * FROM order_detail;
SELECT * FROM payment;