-- AI DECLARATION:
-- AI tool used: Claude Code
-- Purpose: debugging 
-- Verification: I ran all SQL statements in MySQL Workbench and fixed errors before submission.


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

-- A. Index creation, index inspection, and EXPLAIN practice
USE sales_management;
-- Q1. Use the sales_management database and display all tables in the database.
SHOW TABLES;

-- Q2. Display the indexes currently defined on clients by using SHOW INDEX FROM clients.
SHOW INDEXES FROM clients;

-- Q3. Use EXPLAIN to inspect this query: select clients whose province is 'Ho Chi Minh City'.
EXPLAIN SELECT * FROM clients WHERE province ='Ho Chi Minh City';

-- Q4. Create an index named idx_clients_province on clients(province).
CREATE INDEX idx_clients_province ON clients(province);

-- Q5. Run EXPLAIN again for the query in Q3 and write a one-line SQL comment comparing the possible_keys and key columns before and after creating the index.
-- Before: possible_keys=NULL, key=NULL; After: possible_keys=idx_clients_province, key=idx_clients_province (index now used for faster lookup)
EXPLAIN SELECT * FROM clients WHERE province='Ho Chi Minh City';

-- Q6. Create a composite index named idx_clients_city_province on clients(city, province).
CREATE INDEX idx_clients_city_province ON clients(city,province);

-- Q7. Use EXPLAIN to inspect a query that filters clients by city = 'Thu Duc Ward' and province = 'Ho Chi Minh City'.
EXPLAIN SELECT * FROM clients WHERE city='Thu Duc Ward' AND province='Ho Chi Minh City';

-- Q8. Display the indexes currently defined on products by using SHOW INDEX FROM products.
SHOW INDEXES FROM products;

-- Q9. Create an index named idx_products_sale_price on products(sale_price).
CREATE INDEX idx_products_sale_price ON products(sale_price);

-- Q10. Use EXPLAIN to inspect a query that filters products whose sale_price is between 50 and 500.
EXPLAIN SELECT * FROM products WHERE sale_price BETWEEN 50 AND 500;

-- Q11. Create an index named idx_sales_orders_order_date on sales_orders(order_date).
CREATE INDEX idx_sales_orders_order_date ON sales_orders(order_date);

-- Q12. Use EXPLAIN to inspect a query that filters sales orders from '2022-04-01' to '2022-05-31'.
EXPLAIN SELECT * FROM sales_orders WHERE order_date BETWEEN '2022-04-01' AND '2022-05-31';

-- Q13. Create a composite index named idx_sales_orders_status_date on sales_orders(delivery_status, order_date).
CREATE INDEX idx_sales_orders_status_date ON sales_orders(delivery_status,order_date);

-- Q14. Use EXPLAIN to inspect a query that filters sales orders where delivery_status = 'Delivered' and order_date is after '2022-03-01'.
EXPLAIN SELECT * FROM sales_orders WHERE delivery_status ='Delivered' AND order_date > '2022-03-01';

-- Q15. Display all indexes currently defined on sales_orders.
SHOW INDEXES FROM sales_orders;

-- Q16. Drop the index idx_products_sale_price from products, then display the indexes on products again to verify the result.
DROP INDEX idx_products_sale_price ON products;
SHOW INDEXES FROM products;

-- Q17. Recreate the index idx_products_sale_price on products(sale_price) so later practice queries can use it again.
CREATE INDEX idx_products_sale_price ON products(sale_price);

-- B. MySQL date function practice on sales orders
-- Q18. Display order_number, order_date, and order_date formatted as dd/mm/yyyy. Alias the formatted column as order_date_text.
SELECT order_number,order_date,DATE_FORMAT(order_date,'%d/%m/%Y') AS order_date_text
FROM sales_orders;

-- Q19. Display order_number, order_date, delivery_date, and the number of days between order_date and delivery_date. Alias the computed column as delivery_days. Only use rows where delivery_date is not NULL.
SELECT order_number, order_date, delivery_date, DATEDIFF(delivery_date,order_date) AS delivery_days
FROM sales_orders 
WHERE delivery_date IS NOT NULL;

-- Q20. Display order_number, order_date, and a follow-up date calculated as 7 days after order_date. Alias the computed column as follow_up_date.
SELECT order_number, order_date, DATE_ADD(order_date, INTERVAL 7 DAY) AS follow_up_date
FROM sales_orders;

-- Q21. Display order_number, order_date, YEAR(order_date) as order_year, MONTH(order_date) as order_month, and DAY(order_date) as order_day.
SELECT order_number, order_date, YEAR(order_date) AS order_year, MONTH(order_date) AS order_month, DAY(order_date) AS order_day
FROM sales_orders;

-- Q22. Display order_number, order_date, CURDATE() as current_date_value, and the number of days from order_date to today using DATEDIFF. Alias the computed column as days_since_order.
SELECT order_number, order_date, CURDATE() AS current_date_value, DATEDIFF(CURDATE(),order_date) AS days_since_order
FROM sales_orders;

-- Q23. Display order_number, delivery_status, order_date, delivery_date, and a CASE expression that returns Not Delivered when delivery_date is NULL, Fast Delivery when DATEDIFF(delivery_date, order_date) <= 30, and Slow Delivery otherwise. Alias the column as delivery_speed_label.
SELECT order_number, delivery_status, order_date, delivery_date,
CASE 
	WHEN delivery_date IS NULL THEN 'Not Delivery'
    WHEN DATEDIFF(delivery_date,order_date)<=30 THEN 'Fast Delivery'
	ELSE 'Slow Delivery'
END AS delivery_speed_label
FROM sales_orders;

-- C. View creation and view usage practice
-- Q24. Create or replace a view named v_client_contact that displays client_number, client_full_name, city, province, amount_paid, and amount_due from clients.
DROP VIEW IF EXISTS v_client_contact; 
CREATE VIEW v_client_contact AS
SELECT client_number,CONCAT(first_name,' ',middle_name,' ',last_name)AS client_full_name, city, province, amount_paid, amount_due 
FROM clients;

-- Q25. Query v_client_contact to display clients whose province is 'Ho Chi Minh City'.
SELECT * FROM v_client_contact 
WHERE province='Ho Chi Minh City';

-- Q26. Create or replace a view named v_product_price_status that displays product_number, product_name, sale_price, cost_price, profit_per_unit, and a CASE column named pricing_result.
DROP VIEW IF EXISTS v_product_price_status; 
CREATE VIEW v_product_price_status AS
SELECT product_number, product_name, sale_price, cost_price, sale_price-cost_price AS profit_per_unit,  
CASE 
	WHEN sale_price-cost_price>0 THEN 'Profit'
	WHEN sale_price-cost_price<0 THEN 'Loss'
	ELSE 'Break Even'
END AS pricing_result
FROM products;

-- Q27. Query v_product_price_status to display products where pricing_result = 'Profit'.
SELECT * FROM v_product_price_status 
WHERE pricing_result ='Profit';

-- Q28. Create or replace a view named v_order_date_status that displays order_number, order_date, order_date_text, delivery_date, delivery_status, order_status, and delivery_speed_label from sales_orders.
DROP VIEW IF EXISTS v_order_date_status; 
CREATE VIEW v_order_date_status AS
SELECT order_number, order_date, DATE_FORMAT(order_date,'%d/%m/%Y') AS order_date_text, delivery_date, delivery_status, order_status, 
CASE 
	WHEN delivery_date IS NULL THEN 'Not Delivery'
    WHEN DATEDIFF(delivery_date,order_date)<=30 THEN 'Fast Delivery'
	ELSE 'Slow Delivery'
END AS delivery_speed_label
FROM sales_orders;

-- Q29. Query v_order_date_status to display orders whose delivery_status is 'On Way' or 'Ready to Ship'.
SELECT * FROM v_order_date_status 
WHERE delivery_status = 'On Way' OR delivery_status = 'Ready To Ship';

-- Q30. Create or replace a view named v_order_client_simple using INNER JOIN between sales_orders and clients. Display order_number, order_date, client_number, client_full_name, delivery_status, and order_status.
DROP VIEW IF EXISTS v_order_client_simple; 
CREATE VIEW v_order_client_simple AS
SELECT sales_orders.order_number, sales_orders.order_date, sales_orders.client_number,
	CONCAT(clients.first_name, ' ', clients.middle_name, ' ', clients.last_name) AS client_full_name,
	sales_orders.delivery_status, sales_orders.order_status
FROM sales_orders
INNER JOIN clients ON sales_orders.client_number = clients.client_number;

-- Q31. Query v_order_client_simple to display orders whose client_full_name contains 'Nguyen'.
SELECT * FROM v_order_client_simple
WHERE client_full_name LIKE '%Nguyen%';

-- Q32. Create or replace a view named v_order_salesman_simple using INNER JOIN between sales_orders and salesmen. Display order_number, order_date, salesman_number, salesman_full_name, delivery_status, and order_status.
DROP VIEW IF EXISTS v_order_salesman_simple; 
CREATE VIEW v_order_salesman_simple AS
SELECT sales_orders.order_number, sales_orders.order_date, sales_orders.salesman_number,
	CONCAT(salesmen.first_name,' ',salesmen.middle_name,'',salesmen.last_name) AS salesman_full_name, sales_orders.delivery_status, sales_orders.order_status
FROM sales_orders
INNER JOIN salesmen ON sales_orders.salesman_number = salesmen.salesman_number;

-- Q33. Query v_order_salesman_simple to display orders handled by salesmen from 'Ho Chi Minh City'.
SELECT * FROM v_order_salesman_simple
INNER JOIN salesmen ON v_order_salesman_simple.salesman_number = salesmen.salesman_number
WHERE salesmen.province = 'Ho Chi Minh City';

-- Q34. Create or replace a view named v_order_line_simple using INNER JOIN between sales_order_details and products. Display order_number, product_number, product_name, order_quantity, sale_price, and line_total.
DROP VIEW IF EXISTS v_order_line_simple; 
CREATE VIEW v_order_line_simple AS
SELECT sales_order_details.order_number, sales_order_details.product_number, products.product_name,
	sales_order_details.order_quantity,products.sale_price, sales_order_details.order_quantity*products.sale_price AS line_total
FROM sales_order_details
INNER JOIN products ON sales_order_details.product_number = products.product_number;

-- Q35. Query v_order_line_simple to display rows where line_total is greater than 500.
SELECT * FROM v_order_line_simple
WHERE line_total>500;

-- Q36. Display all views in the sales_management database by using SHOW FULL TABLES WHERE Table_type = 'VIEW'.
SHOW FULL TABLES WHERE Table_type = 'VIEW';

-- Q37. Drop the view v_product_price_status, then create it again using the same required output columns.
DROP VIEW IF EXISTS v_product_price_status; 
CREATE VIEW v_product_price_status AS
SELECT product_number, product_name, sale_price, cost_price, sale_price-cost_price AS profit_per_unit,  
CASE 
	WHEN sale_price-cost_price>0 THEN 'Profit'
	WHEN sale_price-cost_price<0 THEN 'Loss'
	ELSE 'Break Even'
END AS pricing_result
FROM products;


-- Problem 2:  Human Resources Management Database 
DROP DATABASE IF EXISTS human_resources_management;

-- reset human_resources_management
CREATE DATABASE IF NOT EXISTS human_resources_management;

USE human_resources_management;

CREATE TABLE IF NOT EXISTS departments(
	department_id		INT				PRIMARY KEY,
    department_name		VARCHAR(50)		NOT NULL UNIQUE,
    manager_id			VARCHAR(3),
    manager_start_date	DATE NOT NULL
);

CREATE TABLE IF NOT EXISTS employees (
	employee_id		VARCHAR(3)		PRIMARY KEY,
    last_name		VARCHAR(20)		NOT NULL,
    middle_name		VARCHAR(20)		NULL,
    first_name		VARCHAR(20)		NOT NULL,
    date_of_birth	DATE			NOT NULL,
    gender			ENUM("Male","Female","Other")			NOT NULL,
    salary			DECIMAL(15,4)	NOT NULL,
	address			VARCHAR(100)	NOT NULL,
    manager_id		VARCHAR(3),
    department_id	INT
);
CREATE TABLE IF NOT EXISTS department_addresses(
	department_id	INT,
    address		VARCHAR(100),
    PRIMARY KEY(department_id, address)
);
CREATE TABLE IF NOT EXISTS projects(
	project_id	INT PRIMARY KEY,
    project_name	VARCHAR(50)		NOT NULL,
    project_address	VARCHAR(100)		NOT NULL,
    department_id	INT
);
CREATE TABLE IF NOT EXISTS assignments(
	employee_id	VARCHAR(3),
    project_id	INT,
    working_hours	DECIMAL(5,2) NOT NULL,
    PRIMARY KEY (employee_id, project_id)
);
CREATE TABLE IF NOT EXISTS relatives(
	employee_id	VARCHAR(3),
    relative_name VARCHAR(50),
    gender ENUM("Male","Female","Other") NOT NULL,
    date_of_birth DATE NULL,
    relationship VARCHAR(30) NOT NULL,
    PRIMARY KEY (employee_id,relative_name)
);


-- Q38. Insert the sample data in Section 6.2 into the correct tables. Insert parent tables before child tables.
-- insert departments 
INSERT INTO departments (department_id,department_name, manager_id, manager_start_date) VALUES
('1','Administration', NULL, '2021-01-10'),
('2','Human Resources', NULL, '2021-02-15'),
('3','Information Technology', NULL, '2021-03-20'),
('4','Finance', NULL, '2021-04-25');

--  insert employees
INSERT INTO employees (employee_id, last_name, middle_name, first_name, date_of_birth, gender, salary, address, manager_id, department_id) VALUES
('E01', 'Nguyen', 'Van', 'An', '1980-05-12', 'Male', 35000, 'Ben Thanh Ward, Ho Chi Minh City', NULL, 1),
('E02', 'Tran', 'Thi Thai', 'Binh', '1985-08-20', 'Female', 28000, 'Cau Giay Ward, Hanoi', 'E01', 2),
('E03', 'Le', 'Quoc', 'Cuong', '1990-11-02', 'Male', 30000, 'Thu Duc Ward, Ho Chi Minh City', 'E01', 3),
('E04', 'Pham', 'Minh', 'Dung', '1992-03-15', 'Male', 22000, 'Di An Ward, Ho Chi Minh City', 'E03', 3),
('E05', 'Hoang', 'Thuy', 'Linh', '1994-07-25', 'Female', 24000, 'Dong Da Ward, Hanoi', 'E02', 2),
('E06', 'Vo', 'Thanh', 'Mai', '1988-12-01', 'Female', 26000, 'Xuan Huong - Da Lat Ward, Lam Dong', 'E01', 4),
('E07', 'Dang', 'Huu', 'Nam', '1996-09-09', 'Male', 18000, 'Binh Thanh Ward, Ho Chi Minh City', 'E03', 3),
('E08', 'Bui', 'Ngoc', 'Oanh', '1995-01-19', 'Female', 21000, 'Lam Vien - Da Lat Ward, Lam Dong', 'E06', 4);

-- update departments.manager_id
UPDATE departments SET manager_id = 'E01' WHERE department_id = 1;
UPDATE departments SET manager_id = 'E02' WHERE department_id = 2;
UPDATE departments SET manager_id = 'E03' WHERE department_id = 3;
UPDATE departments SET manager_id = 'E06' WHERE department_id = 4;

-- insert department_addresses
INSERT INTO department_addresses (department_id, address) VALUES
(1, 'Ben Thanh Ward, Ho Chi Minh City'),
(1, 'Thu Duc Ward, Ho Chi Minh City'),
(2, 'Cau Giay Ward, Hanoi'),
(3, 'Di An Ward, Ho Chi Minh City'),
(3, 'Thu Duc Ward, Ho Chi Minh City'),
(4, 'Dong Da Ward, Hanoi');

-- insert projects
INSERT INTO projects (project_id,project_name, project_address, department_id) VALUES
('101','Office Digitalization', 'Ben Thanh Ward, Ho Chi Minh City', 1),
('102','Recruitment Portal', 'Cau Giay Ward, Hanoi', 2),
('103','Inventory System', 'Thu Duc Ward, Ho Chi Minh City', 3),
('104','Payroll System', 'Dong Da Ward, Hanoi', 4),
('105','Data Backup Project', 'Di An Ward, Ho Chi Minh City', 3);

-- insert assignments
INSERT INTO assignments (employee_id, project_id, working_hours) VALUES
('E01', 101, 10.0),
('E02', 102, 18.5),
('E03', 103, 20.0),
('E04', 103, 15.5),
('E04', 105, 8.0),
('E05', 102, 12.0),
('E06', 104, 16.0),
('E07', 105, 14.0),
('E08', 104, 9.5);

-- insert relatives
INSERT INTO relatives (employee_id, relative_name, gender, date_of_birth, relationship) VALUES
('E01', 'Nguyen Minh Khang', 'Male', '2010-04-12', 'Son'),
('E02', 'Tran Ngoc Han', 'Female', '2013-09-03', 'Daughter'),
('E03', 'Le Thanh Tam', 'Female', '1989-01-22', 'Spouse'),
('E04', 'Pham Bao Anh', 'Female', '2018-06-14', 'Daughter'),
('E06', 'Vo Thanh Phuc', 'Male', '2015-02-26', 'Son'),
('E08', 'Bui Minh Tri', 'Male', '2020-11-08', 'Son');

-- D. Index creation, index inspection, and EXPLAIN practice
-- Q38. Use the human_resources_management database and display all tables in the database.
USE  human_resources_management;
SHOW TABLES;

-- Q39. Display the indexes currently defined on employees by using SHOW INDEX FROM employees.
SHOW INDEXES FROM employees;

-- Q40. Use EXPLAIN to inspect a query that filters employees by department_id = 3.
EXPLAIN SELECT * FROM employees
WHERE department_id=3;

-- Q41. Create an index named idx_employees_department_id on employees(department_id).
CREATE INDEX idx_employees_department_id ON employees(department_id);

-- Q42. Run EXPLAIN again for the query in Q40 and write a one-line SQL comment comparing the possible_keys and key columns before and after creating the index.
-- Before: possible_keys=NULL, key=NULL; After: possible_keys=idx_employees_department_id, key=idx_employees_department_id
EXPLAIN SELECT * FROM employees
WHERE department_id=3;

-- Q43. Create an index named idx_employees_manager_id on employees(manager_id).
CREATE INDEX idx_employees_manager_id ON employees(manager_id);

-- Q44. Use EXPLAIN to inspect a self join query that displays employees and their managers using employees.manager_id = manager.employee_id.
EXPLAIN SELECT employee.manager_id , manager.employee_id
FROM employees employee
INNER JOIN employees manager ON employee.manager_id = manager.employee_id;

-- Q45. Create an index named idx_employees_salary on employees(salary).
CREATE INDEX idx_employees_salary ON employees(salary);

-- Q46. Use EXPLAIN to inspect a query that filters employees whose salary is between 20000 and 30000.
EXPLAIN SELECT * FROM employees
WHERE salary BETWEEN 20000 AND 30000;

-- Q47. Create a composite index named idx_employees_department_salary on employees(department_id, salary).
CREATE INDEX idx_employees_department_salary ON  employees(department_id, salary);

-- Q48. Use EXPLAIN to inspect a query that filters employees by department_id = 3 and salary > 20000.
EXPLAIN SELECT * FROM employees
WHERE department_id = 3 AND salary> 20000;

-- Q49. Display the indexes currently defined on projects.
SHOW INDEXES FROM projects;

-- Q50. Create an index named idx_projects_department_id on projects(department_id).
CREATE INDEX idx_projects_department_id ON  projects(department_id);

-- Q51. Use EXPLAIN to inspect a query that joins projects and departments by department_id.
EXPLAIN SELECT * 
FROM projects
INNER JOIN departments ON projects.department_id = departments.department_id;

-- Q52. Display the indexes currently defined on assignments.
SHOW INDEXES FROM assignments;

-- Q53. Create an index named idx_assignments_project_id on assignments(project_id).
CREATE INDEX idx_assignments_project_id ON  assignments(project_id);

-- Q54. Use EXPLAIN to inspect a query that joins assignments and projects by project_id.
EXPLAIN SELECT * 
FROM assignments
INNER JOIN projects ON assignments.project_id = projects.project_id;

-- Q55. Drop the index idx_employees_salary from employees, then display the indexes on employees again to verify the result.
DROP INDEX idx_employees_salary  ON employees;
SHOW INDEX FROM employees;

-- Q56. Recreate the index idx_employees_salary on employees(salary).
CREATE INDEX idx_employees_salary ON employees(salary);

-- E. MySQL date function practice on HR data
-- Q57. Display employee_id, date_of_birth, and date_of_birth formatted as dd/mm/yyyy. Alias the formatted column as birth_date_text.
SELECT employee_id, date_of_birth, DATE_FORMAT(date_of_birth,'%d/%m/%Y') AS birth_date_text
FROM employees;

-- Q58. Display employee_id, date_of_birth, and TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()). Alias the computed column as age_in_years.
SELECT employee_id, date_of_birth, TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) AS age_in_years
FROM employees;

-- Q59. Display employee_id, date_of_birth, and a retirement reference date calculated as DATE_ADD(date_of_birth, INTERVAL 60 YEAR). Alias the computed column as estimated_retirement_date.
SELECT employee_id, date_of_birth, DATE_ADD(date_of_birth, INTERVAL 60 YEAR) AS estimated_retirement_date
FROM employees;

-- Q60. Display department_id, department_name, manager_start_date, and manager_start_date formatted as Month dd, yyyy. Alias the formatted column as manager_start_text.
SELECT department_id, department_name, manager_start_date, DATE_FORMAT(manager_start_date, '%M %d,%Y') AS manager_start_text
FROM departments;

-- Q61. Display department_id, department_name, manager_start_date, and the number of days from manager_start_date to today using DATEDIFF. Alias the computed column as manager_days_in_role.
SELECT department_id, department_name, manager_start_date, DATEDIFF(CURDATE(),manager_start_date) AS manager_days_in_role
FROM departments;

-- Q62. Display relative_name, date_of_birth, and TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()). Alias the computed column as relative_age_in_years. Only use rows where date_of_birth is not NULL.
SELECT relative_name, date_of_birth, TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) AS relative_age_in_years
FROM relatives
WHERE date_of_birth IS NOT NULL;

-- F. View creation and view usage practice
-- Q63. Create or replace a view named v_employee_profile that displays employee_id, employee_full_name, gender, salary, address, manager_id, and department_id from employees.
DROP VIEW IF EXISTS v_employee_profile;
CREATE VIEW v_employee_profile AS 
SELECT employee_id, CONCAT(first_name,' ',middle_name,'',last_name) AS employee_full_name, gender, salary, address, manager_id, department_id 
FROM employees;

 -- Q64. Query v_employee_profile to display employees whose address contains 'Ho Chi Minh City'.
 SELECT * FROM v_employee_profile
 WHERE address LIKE '%Ho Chi Minh City%';
 
 -- Q65. Create or replace a view named v_employee_age_profile that displays employee_id, employee_full_name, date_of_birth, birth_date_text, age_in_years, and estimated_retirement_date from employees.
DROP VIEW IF EXISTS v_employee_age_profile;
CREATE VIEW v_employee_age_profile AS 
SELECT employee_id, CONCAT(first_name,' ',middle_name,'',last_name) AS employee_full_name, date_of_birth, DATE_FORMAT(date_of_birth,'%d/%m/%Y') AS birth_date_text,
	TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) AS age_in_years, 
	DATE_ADD(date_of_birth, INTERVAL 60 YEAR) AS estimated_retirement_date
FROM employees;

-- Q66. Query v_employee_age_profile to display employees whose age_in_years is at least 30.
 SELECT * FROM v_employee_age_profile
 WHERE age_in_years >=30;
 
 -- Q67. Create or replace a view named v_department_manager_simple using INNER JOIN between departments and employees. Display department_id, department_name, manager_id, manager_full_name, and manager_start_date.
DROP VIEW IF EXISTS v_department_manager_simple;
CREATE VIEW v_department_manager_simple AS 
SELECT departments.department_id, departments.department_name, departments.manager_id,
	CONCAT(employees.first_name,' ',employees.middle_name,' ',employees.last_name) AS manager_full_name, 
    departments.manager_start_date
FROM departments
INNER JOIN employees ON departments.department_id = employees.department_id;

-- Q68. Query v_department_manager_simple to display departments whose manager_start_date is after '2021-02-01'.
 SELECT * FROM v_department_manager_simple
 WHERE manager_start_date >'2021-02-01';
 
 -- Q69. Create or replace a view named v_project_department_simple using INNER JOIN between projects and departments. Display project_id, project_name, project_address, department_id, and department_name.
DROP VIEW IF EXISTS v_project_department_simple;
CREATE VIEW v_project_department_simple AS 
SELECT projects.project_id, projects.project_name, projects.project_address,
 projects.department_id, departments.department_name
FROM projects
INNER JOIN departments ON projects.department_id = departments.department_id;

-- Q70. Query v_project_department_simple to display projects whose project_name contains 'System'.
 SELECT * FROM v_project_department_simple
 WHERE project_name LIKE '%System%';
 
 -- Q71. Create or replace a view named v_assignment_profile using INNER JOIN among assignments, employees, and projects. Display employee_id, employee_full_name, project_id, project_name, working_hours, and project_address.
DROP VIEW IF EXISTS v_assignment_profile;
CREATE VIEW v_assignment_profile AS 
SELECT assignments.employee_id,CONCAT(employees.first_name,' ',employees.middle_name,' ',employees.last_name) AS employee_full_name, assignments.project_id, projects.project_name, 
	working_hours, projects.project_address
FROM assignments
INNER JOIN employees ON assignments.employee_id = employees.employee_id
INNER JOIN projects ON assignments.project_id = projects.project_id;

-- Q72. Query v_assignment_profile to display assignments whose working_hours is greater than 12.
 SELECT * FROM v_assignment_profile
 WHERE working_hours>12;
 
--  Q73. Create or replace a view named v_relative_employee_simple using INNER JOIN between relatives and relatives. Display employee_id, employee_full_name, relative_name, gender, date_of_birth, relative_age_in_years, and relationship.
DROP VIEW IF EXISTS v_relative_employee_simple;
CREATE VIEW v_relative_employee_simple AS 
SELECT relatives.employee_id, CONCAT(employees.first_name,' ',employees.middle_name,' ',employees.last_name) AS employee_full_name,
	relatives.relative_name, relatives.gender, relatives.date_of_birth, TIMESTAMPDIFF(YEAR, 
	relatives.date_of_birth, CURDATE()) AS relative_age_in_years,  relatives.relationship
FROM relatives
INNER JOIN employees ON relatives.employee_id = employees.employee_id;

-- Q74. Query v_relative_employee_simple to display relatives whose relationship is 'Son' or 'Daughter'.
 SELECT * FROM v_relative_employee_simple
 WHERE relationship = 'Son' OR relationship = 'Daughter';
 
--  Q75. Display all views in the human_resources_management database by using SHOW FULL TABLES WHERE Table_type = 'VIEW'.
SHOW FULL TABLES WHERE Table_type = 'VIEW';

-- Q76. Drop the view v_employee_age_profile, then create it again using the same required output columns.
DROP VIEW IF EXISTS v_employee_age_profile;
CREATE VIEW v_employee_age_profile AS 
SELECT employee_id, CONCAT(first_name,' ',middle_name,'',last_name) AS employee_full_name, date_of_birth, DATE_FORMAT(date_of_birth,'%d/%m/%Y') AS birth_date_text,
	TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) AS age_in_years, 
	DATE_ADD(date_of_birth, INTERVAL 60 YEAR) AS estimated_retirement_date
FROM employees;