
-- reset  sales_management
DROP DATABASE IF  EXISTS sales_management;

CREATE DATABASE IF NOT EXISTS sales_management;
USE sales_management;


-- Q2: Create 5 tables , Q3: define primary key and foreign keys and Q4: Apply constraints
CREATE TABLE IF NOT EXISTS salesmen(
	salesman_number VARCHAR(15) PRIMARY KEY,
    first_name		VARCHAR(15)	NOT NULL,
	middle_name		VARCHAR(15)	NULL,
	last_name		VARCHAR(15)	NOT NULL,
    address			VARCHAR(30)	NULL,
    city			VARCHAR(30)	NULL,
    pincode			VARCHAR(10)	NULL,
    province		VARCHAR(25)	NULL,
    salary			DECIMAL(15,4)	DEFAULT 0 CHECK (salary>=0),
    sales_target	INT				DEFAULT 0 CHECK (sales_target>=0),
    target_achieved	INT				DEFAULT 0 CHECK (target_achieved>=0),
	phone 			VARCHAR(15)	NULL
);
CREATE TABLE IF NOT EXISTS clients(
	client_number		VARCHAR(10)		PRIMARY KEY,
    first_name 			VARCHAR(15)		NOT NULL,
    middle_name 		VARCHAR(15)		NULL,
    last_name 			VARCHAR(15)		NOT NULL,
	address				VARCHAR(30)		NULL,
	city				VARCHAR(30)		NULL,
	pincode				VARCHAR(10)		NULL,
	province			VARCHAR(25)		NULL,
    amount_paid			DECIMAL(15,4)	DEFAULT 0 CHECK (amount_paid>=0),
    amount_due			DECIMAL(15,4)	DEFAULT 0 CHECK (amount_due>=0)
    
);

CREATE TABLE IF NOT EXISTS products(
	product_number		VARCHAR(15)		PRIMARY KEY,
    product_name		VARCHAR(25)		NOT NULL,
    quantity_on_hand	INT				DEFAULT 0 CHECK (quantity_on_hand>=0),
    quantity_sold		INT				DEFAULT 0 CHECK (quantity_sold>=0),
    sale_price			DECIMAL(15,4)	DEFAULT 0 CHECK (sale_price>=0),
    cost_price			DECIMAL(15,4)	DEFAULT 0 CHECK (cost_price>=0)
);

CREATE TABLE IF NOT EXISTS sales_orders (
	order_number	VARCHAR(15)		PRIMARY KEY,
    order_date		DATE			NOT NULL,
    client_number	VARCHAR(10),	
    salesman_number	VARCHAR(15),
    delivery_status	ENUM('PENDING', 'In Process', 'Delivered', 'On Way', 'Ready to Ship')			DEFAULT "PENDING",
    delivery_date	DATE			NULL,
    order_status	ENUM('PENDING', 'In Process', 'Successful', 'Cancelled')			DEFAULT "In Process"
);
CREATE TABLE IF NOT EXISTS sales_order_details(
	order_number		VARCHAR(15)	,
    product_number		VARCHAR(15)	,
    order_quantity		INT				DEFAULT 1 CHECK (order_quantity>0),
    PRIMARY KEY (order_number, product_number)
);

-- Create table product_cost    
CREATE TABLE IF NOT EXISTS product_cost(
	product_id INT AUTO_INCREMENT PRIMARY KEY,
	product_name VARCHAR(50) NOT NULL UNIQUE,
    buying_price DECIMAL(15,4)
);


USE sales_management;
INSERT INTO clients (client_number, first_name, middle_name, last_name, address, city, pincode, province, amount_paid, amount_due) VALUES
('C101', 'Mai', 'Xuan', 'Phuc', 'Nguyen An Ninh Street', 'Di An Ward', '700001', 'Ho Chi Minh City', 10000, 5000),
('C102', 'Le', 'Van', 'Khanh', 'Yersin Street', 'Thu Dau Mot Ward', '700051', 'Ho Chi Minh City', 18000, 3000),
('C103', 'Trinh', 'Huu', 'Loc', 'Tran Phu Street', 'Xuan Huong - Da Lat Ward', '700051', 'Lam Dong', 7000, 3200),
('C104', 'Tran', 'Quang', 'Tuan', 'Vo Nguyen Giap Street', 'Binh Duong Ward', '700080', 'Ho Chi Minh City', 8000, 0),
('C105', 'Ho', 'Ngoc', 'Nhu', 'Xuan Thuy Street', 'Cau Giay Ward', '700005', 'Hanoi', 7000, 150),
('C106', 'Tran', 'Minh', 'Hai', 'Vo Van Ngan Street', 'Thu Duc Ward', '700002', 'Ho Chi Minh City', 7000, 1300),
('C107', 'Nguyen', 'Thanh', 'Dat', 'Pham Ngoc Thach Street', 'Phu Loi Ward', '700023', 'Ho Chi Minh City', 8500, 7500),
('C108', 'Nguyen', 'Sy', 'An', 'Yersin Street', 'Lam Vien - Da Lat Ward', '700032', 'Lam Dong', 15000, 1000),
('C109', 'Duong', 'Thanh', 'Phong', 'No Trang Long Street', 'Binh Thanh Ward', '700011', 'Ho Chi Minh City', 12000, 8000),
('C110', 'Tran', 'Van', 'Minh', 'Ton Duc Thang Street', 'Dong Da Ward', '700005', 'Hanoi', 9000, 1000);

INSERT INTO salesmen (salesman_number, first_name, middle_name, last_name, address, city, pincode, province, salary, sales_target, target_achieved, phone) VALUES
('S001', 'Nguyen', 'Huu', 'Thang', 'Le Loi Street', 'Ben Thanh Ward', '700002', 'Ho Chi Minh City', 15000, 50, 35, '0902361123'),
('S002', 'Tran', 'Van', 'Phat', 'Xuan Thuy Street', 'Cau Giay Ward', '700005', 'Hanoi', 25000, 100, 110, '0903216542'),
('S003', 'Le', 'Quoc', 'Khoa', 'Pham Ngoc Thach Street', 'Phu Loi Ward', '700051', 'Ho Chi Minh City', 17500, 40, 30, '0904589632'),
('S004', 'Pham', 'Tien', 'Dat', 'Nguyen An Ninh Street', 'Di An Ward', '700023', 'Ho Chi Minh City', 16500, 70, 72, '0908654723'),
('S005', 'Vo', 'Minh', 'Duc', 'Yersin Street', 'Thu Dau Mot Ward', '700051', 'Ho Chi Minh City', 13500, 60, 48, '0903213659'),
('S006', 'Nguyen', 'Thanh', 'Tin', 'Tran Phu Street', 'Xuan Huong - Da Lat Ward', '700032', 'Lam Dong', 20000, 80, 55, '0907853497');


INSERT INTO products (product_number, product_name, quantity_on_hand, quantity_sold, sale_price, cost_price) VALUES
('P1001', 'TV', 10, 30, 1000, 800),
('P1002', 'Laptop', 12, 25, 1500, 1100),
('P1003', 'AC', 23, 10, 400, 300),
('P1004', 'Modem', 22, 16, 250, 230),
('P1005', 'Pen', 19, 13, 12, 8),
('P1006', 'Mouse', 5, 10, 100, 105),
('P1007', 'Keyboard', 45, 60, 120, 90),
('P1008', 'Headset', 63, 75, 50, 40);

INSERT INTO sales_orders (order_number, order_date, client_number, salesman_number, delivery_status, delivery_date, order_status) VALUES
('O20001', '2022-01-15', 'C101', 'S003', 'Delivered', '2022-02-10', 'Successful'),
('O20002', '2022-01-25', 'C102', 'S003', 'Delivered', '2022-02-15', 'Cancelled'),
('O20003', '2022-01-31', 'C103', 'S002', 'Delivered', '2022-04-03', 'Successful'),
('O20004', '2022-02-10', 'C104', 'S003', 'Delivered', '2022-04-23', 'Successful'),
('O20005', '2022-02-18', 'C101', 'S003', 'On Way', NULL, 'Cancelled'),
('O20006', '2022-02-22', 'C105', 'S005', 'Ready to Ship', NULL, 'In Process'),
('O20007', '2022-04-03', 'C106', 'S001', 'Delivered', '2022-05-08', 'Successful'),
('O20008', '2022-04-16', 'C102', 'S006', 'Ready to Ship', NULL, 'In Process'),
('O20009', '2022-04-24', 'C101', 'S004', 'On Way', NULL, 'Successful'),
('O20010', '2022-04-29', 'C106', 'S006', 'Delivered', '2022-05-08', 'Successful'),
('O20011', '2022-05-08', 'C107', 'S005', 'Ready to Ship', NULL, 'Cancelled'),
('O20012', '2022-05-12', 'C108', 'S004', 'On Way', NULL, 'Successful'),
('O20013', '2022-05-16', 'C109', 'S001', 'Ready to Ship', NULL, 'In Process'),
('O20014', '2022-05-16', 'C110', 'S001', 'On Way', NULL, 'Successful');

INSERT INTO sales_order_details (order_number, product_number, order_quantity) VALUES
('O20001', 'P1001', 5), ('O20001', 'P1002', 4),
('O20002', 'P1007', 10), ('O20003', 'P1003', 12),
('O20004', 'P1004', 3), ('O20005', 'P1001', 8),
('O20005', 'P1008', 15), ('O20005', 'P1002', 14),
('O20006', 'P1002', 5), ('O20007', 'P1005', 6),
('O20008', 'P1004', 8), ('O20009', 'P1008', 2),
('O20010', 'P1006', 11), ('O20010', 'P1001', 9),
('O20011', 'P1007', 6), ('O20012', 'P1005', 3),
('O20012', 'P1001', 2), ('O20013', 'P1006', 10),
('O20014', 'P1002', 20);

-- Q1. Use USE sales_management; before writing SQL statements.
USE sales_management;

-- Q2. Verify that the required tables exist by using SHOW TABLES;
SHOW TABLES;

-- Q3. Verify the structure of products, clients, salesmen, sales_orders, and sales_order_details by using DESCRIBE table_name;
DESCRIBE products;
DESCRIBE clients;
DESCRIBE salesmen;
DESCRIBE sales_orders;
DESCRIBE sales_order_details;

-- Q4. Create backup tables for trigger and DML testing: lab8_products_backup, lab8_clients_backup, lab8_sales_orders_backup, and lab8_sales_order_details_backup.
CREATE TABLE IF NOT EXISTS lab8_products_backup AS 
SELECT * FROM products;

CREATE TABLE IF NOT EXISTS lab8_clients_backup AS 
SELECT * FROM clients;

CREATE TABLE IF NOT EXISTS lab8_sales_orders_backup AS 
SELECT * FROM sales_orders;

CREATE TABLE IF NOT EXISTS lab8_sales_order_details_backup AS 
SELECT * FROM sales_order_details;

-- Q5. Create required log tables only when a trigger task asks for them.
-- Q6. Drop an old procedure, function, or trigger only if needed to recreate your answer during testing.

-- Q7. Create a stored procedure named sp_show_all_clients that displays all columns from clients.
DELIMITER //
CREATE PROCEDURE sp_show_all_clients()
BEGIN 
	SELECT * FROM clients;
END //
DELIMITER ;


-- Q8. Create a stored procedure named sp_get_clients_by_province that receives p_province as an input parameter and displays client_number, client_full_name, city, province, amount_paid, and amount_due for clients in that province.
DELIMITER //
CREATE PROCEDURE sp_get_clients_by_province(p_province VARCHAR(50))
BEGIN
	SELECT client_number, CONCAT_WS(' ',first_name,middle_name,last_name) AS client_full_name,
			city,province, amount_paid, amount_due
	FROM clients
    WHERE province = p_province;
END //
DELIMITER ;


-- Q9. Create a stored procedure named sp_get_products_by_price_range that receives p_min_price and p_max_price and displays products whose sale_price is within that range.
DELIMITER //
CREATE PROCEDURE sp_get_products_by_price_range(p_min_price DECIMAL(15,4),p_max_price DECIMAL(15,4))
BEGIN 
	SELECT *
    FROM products
    WHERE sale_price BETWEEN p_min_price AND p_max_price;
END //
DELIMITER ;



-- Q10. Create a stored procedure named sp_get_orders_by_status that receives p_order_status and displays order_number, order_date, client_number, salesman_number, delivery_status, delivery_date, and order_status.
DELIMITER //
CREATE PROCEDURE sp_get_orders_by_status(p_order_status ENUM('PENDING', 'In Process', 'Successful', 'Cancelled'))
BEGIN
	SELECT order_number, order_date, client_number, salesman_number, delivery_status, order_status
	FROM sales_orders
    WHERE order_status = p_order_status;
END //
DELIMITER ;


-- Q11. Create a stored procedure named sp_get_order_details that receives p_order_number and displays order_number, product_number, order_quantity, sale_price, and line_total using an INNER JOIN between sales_order_details and products.
DELIMITER //
CREATE PROCEDURE sp_get_order_details(p_order_number VARCHAR(15))
BEGIN
	SELECT sales_order_details.order_number, sales_order_details.product_number, sales_order_details.order_quantity, products.sale_price,
			(products.sale_price * sales_order_details.order_quantity) AS line_total
    FROM sales_order_details
    
    INNER JOIN products ON sales_order_details.product_number = products.product_number
    WHERE sales_order_details.order_number = p_order_number;
END //
DELIMITER ;


-- Q12. Create a stored procedure named sp_get_client_balance that receives p_client_number and displays client_number, client_full_name, amount_paid, amount_due, and total_transaction_value.
DELIMITER //
CREATE PROCEDURE sp_get_client_balance(p_client_number VARCHAR(10))
BEGIN
	SELECT client_number, CONCAT_WS(' ',first_name,middle_name,last_name) AS client_full_name, amount_paid, amount_due,
		(amount_paid + amount_due) AS total_transaction_value
	FROM clients
    WHERE client_number = p_client_number;
END //
DELIMITER ;


-- Q13. Create a stored procedure named sp_update_client_due_backup that receives p_client_number and p_payment_amount, then decreases amount_due in lab8_clients_backup. The procedure must use a WHERE condition.
DELIMITER //
CREATE PROCEDURE sp_update_client_due_backup(p_client_number VARCHAR(10),p_payment_amount DECIMAL(12,4))
BEGIN
	UPDATE lab8_clients_backup
    SET amount_due = amount_due - p_payment_amount
    WHERE p_client_number = client_number;
END //
DELIMITER ;


-- Q14. Create a stored procedure named sp_update_product_price_backup that receives p_product_number and p_increase_percent, then increases sale_price in lab8_products_backup by that percentage.

DELIMITER //
CREATE PROCEDURE sp_update_product_price_backup(p_product_number VARCHAR(15), p_increase_percent DECIMAL(15,4))
BEGIN
	UPDATE lab8_products_backup
    SET sale_price = sale_price * (1+ p_increase_percent/100)
    WHERE p_product_number = product_number;
END //
DELIMITER ;

-- Q15. Create a stored procedure named sp_insert_test_client_backup that inserts one test client into lab8_clients_backup. Use parameters for client_number, first_name, last_name, province, amount_paid, and amount_due.
DELIMITER //
CREATE PROCEDURE sp_insert_test_client_backup(
	p_client_number VARCHAR(10), 
    p_first_name VARCHAR(15), 
    p_last_name VARCHAR(15), 
    p_province  VARCHAR(25), 
    p_amount_paid DECIMAL(15,4),
    p_amount_due DECIMAL(15,4))
BEGIN
	INSERT INTO lab8_clients_backup
    (client_number, first_name, middle_name, last_name, address,city,pincode,province,amount_paid,amount_due) 
    VALUES(p_client_number, p_first_name,NULL ,p_last_name,'Test Address','Test City',NULL,p_province, p_amount_paid , p_amount_due);
END //
DELIMITER ;

-- Q16. Create a stored procedure named sp_delete_test_client_backup that receives p_client_number and deletes that test client from lab8_clients_backup.

DELIMITER //
CREATE PROCEDURE sp_delete_test_client_backup(p_client_number VARCHAR(10))
BEGIN
	DELETE FROM lab8_clients_backup 
    WHERE p_client_number= client_number;
END //
DELIMITER ;

-- Q17. Create a stored procedure named sp_check_product_stock_level that receives p_product_number and displays product_number, product_name, quantity_on_hand, and a CASE-based stock_label: Low Stock if quantity_on_hand < 10, Normal Stock otherwise.
DELIMITER //
CREATE PROCEDURE sp_check_product_stock_level(p_product_number VARCHAR(15))
BEGIN
	SELECT product_number, product_name,quantity_on_hand,
		CASE 
			WHEN quantity_on_hand < 10 THEN 'Low Stock'
			ELSE 'Normal Stock'
			END AS stock_label
	FROM products
    WHERE p_product_number= product_number;
END //
DELIMITER ;
        
-- Q18. Call each stored procedure created from Q7 to Q18 with suitable test values and include the CALL statements in your answer file.
CALL sp_show_all_clients();
 
CALL sp_get_clients_by_province('Ho Chi Minh City');
 
CALL sp_get_products_by_price_range(100, 500);
 
CALL sp_get_orders_by_status('In Process');
 
CALL sp_get_order_details('O20001');
 
CALL sp_get_client_balance('C101');
 
CALL sp_update_client_due_backup('C101', 100);
 
CALL sp_update_product_price_backup('P1001', 5);
 
CALL sp_insert_test_client_backup('C999', 'Test', 'Client', 'Ho Chi Minh City', 1000, 2000);
 
CALL sp_delete_test_client_backup('C999');
 
CALL sp_check_product_stock_level('P1001');

-- Q19. Use SHOW PROCEDURE STATUS WHERE Db = 'sales_management'; to verify your stored procedures.
SHOW PROCEDURE STATUS WHERE Db='sales_management';

-- Q20. Write one SQL comment explaining when a stored procedure is more suitable than writing repeated SQL statements directly in an application.
-- Stored procedures are more suitable than repeated SQL in applications when:
-- 1) The operation contains multiple SQL statements that need to be executed together as a transaction
-- 2) Complex business logic involving conditional statements (IF/CASE), loops, or multiple steps
-- 3) The same operation is reused multiple times in different parts of the application
-- 4) Security: restricting direct table access and forcing operations through predefined procedures
-- 5) Performance: reducing network traffic by executing multiple statements on the server side
-- 6) Maintainability: changes to business logic only need to be made in the database, not in application code

-- Q21. Create a function named fn_client_full_name that receives p_client_number and returns the full name of that client.
DELIMITER //
CREATE FUNCTION fn_client_full_name(p_client_number VARCHAR(10))
RETURNS VARCHAR(50)
DETERMINISTIC
READS SQL DATA
BEGIN
	DECLARE full_name VARCHAR(50);
    
    SELECT CONCAT_WS(' ',first_name,middle_name,last_name) INTO full_name
    FROM clients
    
    WHERE p_client_number = client_number;
    RETURN full_name;
END //
DELIMITER ;

-- Q22. Create a function named fn_salesman_full_name that receives p_salesman_number and returns the full name of that salesman.
DELIMITER //
CREATE FUNCTION fn_salesman_full_name(p_salesman_number VARCHAR(15))
RETURNS VARCHAR(50)
DETERMINISTIC
READS SQL DATA
BEGIN
	DECLARE full_name VARCHAR(50);
    SELECT CONCAT_WS(' ',first_name,middle_name,last_name) INTO full_name
    FROM salesmen
    
    WHERE p_salesman_number = salesman_number;
    RETURN full_name;
END //
DELIMITER ;


-- Q23. Create a function named fn_product_profit that receives p_product_number and returns sale_price - cost_price for that product.
DELIMITER //
CREATE FUNCTION fn_product_profit(p_product_number VARCHAR(15))
RETURNS DECIMAL(15,4)
DETERMINISTIC
READS SQL DATA
BEGIN
	DECLARE profit_price DECIMAL(15,4);
    SELECT sale_price - cost_price INTO profit_price
    FROM products
    
    WHERE p_product_number = product_number;
    RETURN profit_price;
END //
DELIMITER ;

-- Q24. Create a function named fn_product_profit_percent that receives p_product_number and returns (sale_price - cost_price) / cost_price * 100. Handle division by zero safely.
DELIMITER //
CREATE FUNCTION fn_product_profit_percent(p_product_number VARCHAR(15))
RETURNS DECIMAL(15,4)
DETERMINISTIC
READS SQL DATA
BEGIN
	DECLARE profit_percent DECIMAL(15,4);
    DECLARE p_sale_price DECIMAL(15,4);
    DECLARE p_cost_price DECIMAL(15,4);
    
    SELECT sale_price, cost_price INTO p_sale_price, p_cost_price
    FROM products
	WHERE p_product_number = product_number;
    
	IF p_cost_price=0 OR p_cost_price IS NULL THEN
		RETURN 0;
    ELSE 
		SET profit_percent = (p_sale_price - p_cost_price)/p_cost_price*100;
        RETURN profit_percent;
	END IF;
END //
DELIMITER ;

-- Q25. Create a function named fn_order_delivery_days that receives p_order_number and returns DATEDIFF(delivery_date, order_date). If delivery_date is NULL, return NULL.
DELIMITER //
CREATE FUNCTION fn_order_delivery_days(p_order_number VARCHAR(15))
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
	DECLARE due_date INT;
    DECLARE p_delivery_date DATE;
    DECLARE p_order_date DATE;
    
    SELECT delivery_date, order_date INTO p_delivery_date, p_order_date
    FROM sales_orders
	WHERE p_order_number = order_number;
    
	IF p_delivery_date IS NULL THEN
		RETURN NULL;
    ELSE 
		SET due_date = DATEDIFF(p_delivery_date, p_order_date);
        RETURN due_date;
	END IF;
END //
DELIMITER ;

-- Q26. Create a function named fn_client_total_value that receives p_client_number and returns amount_paid + amount_due.
DELIMITER //
CREATE FUNCTION fn_client_total_value(p_client_number VARCHAR(15))
RETURNS DECIMAL(15,4)
DETERMINISTIC
READS SQL DATA
BEGIN
	DECLARE total_value DECIMAL(15,4);
    
    SELECT amount_paid + amount_due INTO total_value
    FROM clients
	WHERE p_client_number = client_number;
    RETURN total_value;
END //
DELIMITER ;

-- Q27. Use fn_product_profit in a SELECT statement to display product_number, product_name, sale_price, cost_price, and profit_per_unit for all products.
SELECT product_number, product_name, sale_price, cost_price,
	fn_product_profit(product_number) AS profit_per_unit
FROM products;

-- Q28. Use fn_client_full_name and fn_client_total_value in a SELECT statement to display client_number, client_full_name, and total_transaction_value for all clients.
SELECT client_number,
	fn_client_full_name(client_number) AS client_full_name,
    fn_client_total_value(client_number) AS total_transaction_value
FROM clients;

-- Q29. Use SHOW FUNCTION STATUS WHERE Db = 'sales_management'; to verify your stored functions.
SHOW FUNCTION STATUS WHERE Db = 'sales_management';

-- Q30. Write one SQL comment explaining why a stored function should normally return a single value and avoid changing table data.
-- Stored functions should normally return a single value and avoid changing table data because:
-- 1) Functions are designed for calculations and retrievals, not modifications
-- 2) Functions used in SELECT statements can only accept a return value, not result sets
-- 3) Functions called in WHERE conditions or computed columns need predictable single values
-- 4) Changing data in functions creates hidden side effects that are hard to debug
-- 5) Functions should be deterministic (same input = same output) for query optimization
-- 6) Data modifications should go through stored procedures, not functions
-- 7) Functions in SELECT statements are executed for every row, causing unexpected data changes

-- Q31. Create a log table named lab8_product_price_logs with columns log_id, product_number, old_sale_price, new_sale_price, changed_at.
CREATE TABLE IF NOT EXISTS lab8_product_price_logs(
	log_id INT AUTO_INCREMENT PRIMARY KEY,
    product_number VARCHAR(15) NOT NULL, 
    old_sale_price DECIMAL(15,4) , 
    new_sale_price DECIMAL(15,4), 
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Q32. Create a log table named lab8_deleted_client_logs with columns log_id, client_number, client_full_name, province, deleted_at.
CREATE TABLE IF NOT EXISTS lab8_deleted_client_logs(
	log_id INT AUTO_INCREMENT PRIMARY KEY,
    client_number VARCHAR(15) NOT NULL, 
    client_full_name VARCHAR(50) NOT NULL,
	province VARCHAR(100) NULL,
    deleted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Q33. Create a BEFORE INSERT trigger on lab8_sales_order_details_backup to prevent order_quantity less than or equal to 0. Use SIGNAL SQLSTATE '45000'.
DELIMITER //
CREATE TRIGGER trg_before_insert_order_detail_check_qty
BEFORE INSERT ON lab8_sales_order_details_backup
FOR EACH ROW 
BEGIN
	IF NEW.order_quantity<=0 THEN 
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: order_quantity must be greater than 0';
	END IF;
END //
DELIMITER ;

-- Q34. Test the trigger in Q33 by trying to insert an order detail with order_quantity = 0. Then write one SQL comment explaining the expected result.
INSERT INTO lab8_sales_order_details_backup(order_number, product_number, order_quantity)
	VALUES('O20001', 'P1001', 0);
-- Expected result: ERROR 1644 - "order_quantity must be greater than 0"
-- The trigger prevents insertion of invalid order quantity

-- Q35. Create a BEFORE INSERT trigger on lab8_sales_order_details_backup to prevent selling more than the available quantity_on_hand in lab8_products_backup.
DELIMITER //
CREATE TRIGGER trg_before_insert_order_detail_chk_stock
BEFORE INSERT ON lab8_sales_order_details_backup
FOR EACH ROW
BEGIN
	DECLARE available_quantity INT;
    SELECT quantity_on_hand INTO available_quantity
    FROM lab8_products_backup
    WHERE NEW.product_number = product_number;
    
	IF NEW.order_quantity > available_quantity  THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Error: Insufficient stock for this product';
    END IF;
END //
DELIMITER ;

-- Q36. Test the trigger in Q35 by trying to insert a quantity greater than the available stock. Then write one SQL comment explaining the expected result.
INSERT INTO lab8_sales_order_details_backup (order_number, product_number, order_quantity)
VALUES ('O20001', 'P1001', 1000);
-- Expected result: ERROR 1644 - "Insufficient stock for this product"
-- The trigger prevents selling more products than available quantity

-- Q37. Create an AFTER INSERT trigger on lab8_sales_order_details_backup that increases quantity_sold and decreases quantity_on_hand in lab8_products_backup after a valid order detail is inserted.
DELIMITER //
CREATE TRIGGER IF NOT EXISTS trg_after_insert_order_detail_update_stock
AFTER INSERT ON lab8_sales_order_details_backup
FOR EACH ROW
BEGIN
  UPDATE lab8_products_backup
  SET quantity_sold = quantity_sold + NEW.order_quantity,
      quantity_on_hand = quantity_on_hand - NEW.order_quantity
  WHERE product_number = NEW.product_number;
END //
DELIMITER ;

-- Q38. Test the trigger in Q37 by inserting a valid order detail into lab8_sales_order_details_backup and then selecting the affected product from lab8_products_backup.
INSERT INTO lab8_sales_order_details_backup (order_number, product_number, order_quantity)
VALUES ('O20001', 'P1001', 5);

SELECT product_number, quantity_on_hand, quantity_sold
FROM lab8_products_backup
WHERE product_number = 'P1001';

-- Q39. Create a BEFORE UPDATE trigger on lab8_sales_orders_backup that prevents delivery_date from being earlier than order_date.
DELIMITER //
CREATE TRIGGER trg_order_chk_date
BEFORE UPDATE ON lab8_sales_orders_backup
FOR EACH ROW
BEGIN
	IF NEW.delivery_date < NEW.order_date THEN	
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: delivery_date cannot earlier than order_date';
    END IF;
END //
DELIMITER ;

-- Q40. Test the trigger in Q39 by updating one order with an invalid delivery_date. Then write one SQL comment explaining the expected result.
UPDATE lab8_sales_orders_backup
SET delivery_date = '2022-01-01'
WHERE order_number = 'O20001';
-- Expected result: ERROR 1644 - "delivery_date cannot be earlier than order_date"
-- The trigger prevents logical inconsistencies where delivery happens before order

-- Q41. Create a BEFORE UPDATE trigger on lab8_sales_orders_backup that automatically sets delivery_status to Delivered when delivery_date is not NULL.
DELIMITER //
CREATE TRIGGER trg_order_chk_status
BEFORE UPDATE ON lab8_sales_orders_backup
FOR EACH ROW
BEGIN
	IF NEW.delivery_date IS NOT NULL THEN
		SET NEW.delivery_status = 'Delivered';
	END IF;
END //
DELIMITER ;

-- Q42. Test the trigger in Q41 by updating delivery_date for one order and selecting the affected row from lab8_sales_orders_backup.
UPDATE lab8_sales_orders_backup
SET delivery_date = '2022-05-20'
WHERE order_number = 'O20001';
 
SELECT order_number, delivery_date, delivery_status
FROM lab8_sales_orders_backup
WHERE order_number = 'O20001';

-- Q43. Create an AFTER UPDATE trigger on lab8_products_backup that inserts a row into lab8_product_price_logs whenever sale_price changes.
DELIMITER //
CREATE TRIGGER trg_order_chk_after_upd_sale_price
AFTER UPDATE ON lab8_products_backup
FOR EACH ROW
BEGIN
	IF NEW.sale_price != OLD.sale_price THEN
		INSERT INTO lab8_product_price_logs(product_number, old_sale_price,new_sale_price)
		VALUES (NEW.product_number, OLD.sale_price, NEW.sale_price);
	END IF;
END //
DELIMITER ;

-- Q44. Test the trigger in Q43 by updating sale_price of one product in lab8_products_backup and then selecting from lab8_product_price_logs.
UPDATE lab8_products_backup
SET sale_price = 1100
WHERE product_number = 'P1001';
 
SELECT * FROM lab8_product_price_logs;

-- Q45. Create a BEFORE DELETE trigger on lab8_clients_backup that inserts deleted client information into lab8_deleted_client_logs before the client is deleted.
DELIMITER //
CREATE TRIGGER trg_order_chk_before_del_client_info
BEFORE DELETE ON lab8_clients_backup
FOR EACH ROW
BEGIN
	INSERT INTO lab8_deleted_client_logs(client_number, client_full_name, province)
    VALUES (OLD.client_number, CONCAT_WS(' ', OLD.first_name, OLD.middle_name, OLD.last_name), OLD.province);
END //
DELIMITER ;

-- Q46. Test the trigger in Q45 by inserting a temporary client into lab8_clients_backup, deleting that client, and selecting from lab8_deleted_client_logs.
INSERT INTO lab8_clients_backup (client_number, first_name, middle_name, last_name, address, city, pincode, province, amount_paid, amount_due)
VALUES ('C222', 'Temp', NULL, 'Client', 'Temp', 'Temp City', '000000', 'Temp Province', 0, 0);
    
DELETE FROM lab8_clients_backup
WHERE client_number = 'C222';
	 
SELECT * FROM lab8_deleted_client_logs;
    
-- Q47. Create a BEFORE UPDATE trigger on lab8_products_backup that prevents sale_price from being lower than cost_price.
DELIMITER //
CREATE TRIGGER IF NOT EXISTS trg_before_update_product_check_sale_price
BEFORE UPDATE ON lab8_products_backup
FOR EACH ROW
BEGIN
  IF NEW.sale_price < NEW.cost_price THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Error: sale_price cannot be lower than cost_price';
  END IF;
END //
DELIMITER ;


-- Q48. Test the trigger in Q47 by trying to update sale_price to a value lower than cost_price. Then write one SQL comment explaining the expected result.
UPDATE lab8_products_backup
SET sale_price = 100
WHERE product_number = 'P1001' AND cost_price > 100;
-- Expected result: ERROR 1644 - "sale_price cannot be lower than cost_price"
-- The trigger prevents selling products at a loss

-- Q49. Use SHOW TRIGGERS FROM sales_management; to verify all triggers created in this lab.
SHOW TRIGGERS FROM sales_management;

-- Q50. Write one SQL comment comparing BEFORE and AFTER triggers using one example from this lab.
-- BEFORE triggers are used for validation and prevention:
--   Example: BEFORE INSERT trigger checks if order_quantity > 0, and blocks insertion if false
--   Use when you need to prevent invalid data from being saved or modify data before insertion
-- AFTER triggers are used for updates and logging:
--   Example: AFTER INSERT trigger updates product stock after a valid order detail is inserted
--   Use when you need to update related tables or record changes after data is successfully saved
-- Key difference: BEFORE can block operations with SIGNAL; AFTER always allows the operation but then updates/logs results


-- AI Usage Declaration:
-- I used AI tools Claude to:
-- Understand DELIMITER syntax
