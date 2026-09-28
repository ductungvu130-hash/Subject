
-- PROBLEM 1: SALES MANAGEMENT DATABASE

-- Q1: Use the sales_management database
USE sales_management;

-- Q2: Verify that the five required tables exist
SHOW TABLES;

-- Q3: Verify the structure of each table
DESCRIBE salesmen;
DESCRIBE clients;
DESCRIBE products;
DESCRIBE sales_orders;
DESCRIBE sales_order_details;

-- Q4: Insert sample data into the correct tables
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

-- Note: 'On Way' mapped to 'In Transit', 'Ready to Ship' mapped to 'Pending' based on Lab 3 ENUM schema
INSERT INTO sales_orders (order_number, order_date, client_number, salesman_number, delivery_status, delivery_date, order_status) VALUES
('O20001', '2022-01-15', 'C101', 'S003', 'Delivered', '2022-02-10', 'Successful'),
('O20002', '2022-01-25', 'C102', 'S003', 'Delivered', '2022-02-15', 'Cancelled'),
('O20003', '2022-01-31', 'C103', 'S002', 'Delivered', '2022-04-03', 'Successful'),
('O20004', '2022-02-10', 'C104', 'S003', 'Delivered', '2022-04-23', 'Successful'),
('O20005', '2022-02-18', 'C101', 'S003', 'In Transit', NULL, 'Cancelled'), 
('O20006', '2022-02-22', 'C105', 'S005', 'Pending', NULL, 'In Process'), 
('O20007', '2022-04-03', 'C106', 'S001', 'Delivered', '2022-05-08', 'Successful'),
('O20008', '2022-04-16', 'C102', 'S006', 'Pending', NULL, 'In Process'),
('O20009', '2022-04-24', 'C101', 'S004', 'In Transit', NULL, 'Successful'),
('O20010', '2022-04-29', 'C106', 'S006', 'Delivered', '2022-05-08', 'Successful'),
('O20011', '2022-05-08', 'C107', 'S005', 'Pending', NULL, 'Cancelled'),
('O20012', '2022-05-12', 'C108', 'S004', 'In Transit', NULL, 'Successful'),
('O20013', '2022-05-16', 'C109', 'S001', 'Pending', NULL, 'In Process'),
('O20014', '2022-05-16', 'C110', 'S001', 'In Transit', NULL, 'Successful');

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

-- Q5: After inserting data, display the row count of each table
SELECT 'clients' AS table_name, COUNT(*) AS row_count FROM clients
UNION SELECT 'salesmen', COUNT(*) FROM salesmen
UNION SELECT 'products', COUNT(*) FROM products
UNION SELECT 'sales_orders', COUNT(*) FROM sales_orders
UNION SELECT 'sales_order_details', COUNT(*) FROM sales_order_details;

-- Q6: Display all clients
SELECT client_number, CONCAT_WS(' ', first_name, middle_name, last_name) AS client_full_name, city, province FROM clients;

-- Q7: Display all salesmen
SELECT salesman_number, CONCAT_WS(' ', first_name, middle_name, last_name) AS salesman_full_name, phone, province FROM salesmen;

-- Q8: List 
SELECT product_number, product_name, sale_price AS selling_price, cost_price FROM products;

-- Q9: Display the first 5 rows
SELECT * FROM products LIMIT 5;

-- Q10: Display the first 3 clients sorted by amount_due from highest to lowest
SELECT * FROM clients ORDER BY amount_due DESC LIMIT 3;

-- Q11: List all clients sorted by city ascending and then by last_name ascending
SELECT * FROM clients ORDER BY city ASC, last_name ASC;

-- Q12: Show the top 5 products sorted by sale_price descending
SELECT * FROM products ORDER BY sale_price DESC LIMIT 5;

-- Q13: Display clients whose province is Ho Chi Minh City
SELECT * FROM clients WHERE province = 'Ho Chi Minh City';

-- Q14: Display clients whose amount_due is greater than 5000
SELECT * FROM clients WHERE amount_due > 5000;

-- Q15: List products whose quantity_on_hand is less than 10
SELECT * FROM products WHERE quantity_on_hand < 10;

-- Q16: Display salesmen whose salary is greater than 15000 and sort by salary descending
SELECT * FROM salesmen WHERE salary > 15000 ORDER BY salary DESC;

-- Q17: List clients whose city is either Cau Giay Ward or Xuan Huong - Da Lat Ward
SELECT * FROM clients WHERE city IN ('Cau Giay Ward', 'Xuan Huong - Da Lat Ward');

-- Q18: Display salesmen whose province is not Ho Chi Minh City
SELECT * FROM salesmen WHERE province != 'Ho Chi Minh City';

-- Q19: List products whose product_name starts with the letter K
SELECT * FROM products WHERE product_name LIKE 'K%';

-- Q20: Display clients whose address contains the word Nguyen
SELECT * FROM clients WHERE address LIKE '%Nguyen%';

-- Q21: Show clients whose amount_due is between 1000 and 8000
SELECT * FROM clients WHERE amount_due BETWEEN 1000 AND 8000;

-- B. Backup-table, UPDATE, and DELETE practice with safety rules

-- Q22: Create a backup table named clients_backup from clients
CREATE TABLE IF NOT EXISTS clients_backup AS SELECT * FROM clients;

-- Q23: Create a backup table named salesmen_backup from salesmen
CREATE TABLE IF NOT EXISTS salesmen_backup AS SELECT * FROM salesmen;

-- Q24: Create a backup table named products_backup from products
CREATE TABLE IF NOT EXISTS products_backup AS SELECT * FROM products;

-- Q25: Create a backup table named sales_orders_backup from sales_orders
CREATE TABLE IF NOT EXISTS sales_orders_backup AS SELECT * FROM sales_orders;

-- Q26: Create a backup table named sales_order_details_backup from sales_order_details
CREATE TABLE IF NOT EXISTS sales_order_details_backup AS SELECT * FROM sales_order_details;

-- Q27: Verify the number of rows in each backup table and compare it with the original table
SELECT 
    (SELECT COUNT(*) FROM clients) AS original_clients, (SELECT COUNT(*) FROM clients_backup) AS backup_clients,
    (SELECT COUNT(*) FROM salesmen) AS original_salesmen, (SELECT COUNT(*) FROM salesmen_backup) AS backup_salesmen,
    (SELECT COUNT(*) FROM products) AS original_products, (SELECT COUNT(*) FROM products_backup) AS backup_products,
    (SELECT COUNT(*) FROM sales_orders) AS original_orders, (SELECT COUNT(*) FROM sales_orders_backup) AS backup_orders,
    (SELECT COUNT(*) FROM sales_order_details) AS original_details, (SELECT COUNT(*) FROM sales_order_details_backup) AS backup_details;

-- Q28: Update the phone number of salesman S006 in salesmen_backup
UPDATE salesmen_backup SET phone = '090785349' WHERE salesman_number = 'S006';
SELECT * FROM salesmen_backup WHERE salesman_number = 'S006'; 

-- Q29: Increase sale_price by 5 percent in products_backup for products whose sale_price is less than 100
UPDATE products_backup SET sale_price = sale_price * 1.05 WHERE sale_price < 100;
SELECT * FROM products_backup WHERE sale_price < 100;

-- Q30: Update delivery_status to Delivered and delivery_date to 2022-05-30 for order O20006 in sales_orders_backup
UPDATE sales_orders_backup SET delivery_status = 'Delivered', delivery_date = '2022-05-30' WHERE order_number = 'O20006';
SELECT * FROM sales_orders_backup WHERE order_number = 'O20006'; 

-- Q31: Update order_status to Successful for order O20006 in sales_orders_backup after it has been delivered
UPDATE sales_orders_backup SET order_status = 'Successful' WHERE order_number = 'O20006' AND delivery_status = 'Delivered';
SELECT * FROM sales_orders_backup WHERE order_number = 'O20006'; 

-- Q32: Decrease amount_due by 500 for client C109 in clients_backup
UPDATE clients_backup SET amount_due = amount_due - 500 WHERE client_number = 'C109';
SELECT * FROM clients_backup WHERE client_number = 'C109'; 

-- Q33: Insert one new client into clients_backup 
INSERT INTO clients_backup (client_number, first_name, middle_name, last_name, address, city, pincode, province, amount_paid, amount_due) 
VALUES ('C111', 'Dieu', 'Minh', 'Anh', 'Vo Van Kiet Street', 'Ben Cat Ward', '789123', 'Ho Chi Minh City', 15000, 2000);
SELECT * FROM clients_backup WHERE client_number = 'C111';

-- Q34: Insert one new order into sales_orders_backup for the new client inserted
INSERT INTO sales_orders_backup (order_number, order_date, client_number, salesman_number, delivery_status, delivery_date, order_status) 
VALUES ('O20015', '2022-06-01', 'C111', 'S001', 'Pending', NULL, 'In Process');
SELECT * FROM sales_orders_backup WHERE order_number = 'O20015';

-- Q35: Insert one new order detail into sales_order_details_backup for the new order
INSERT INTO sales_order_details_backup (order_number, product_number, order_quantity) 
VALUES ('O20015', 'P1002', 2);
SELECT * FROM sales_order_details_backup WHERE order_number = 'O20015';

-- Q36: Delete the new order detail inserted from sales_order_details_backup
DELETE FROM sales_order_details_backup WHERE order_number = 'O20015' AND product_number = 'P1002';
SELECT * FROM sales_order_details_backup WHERE order_number = 'O20015'; 

-- Q37: Delete the new order inserted from sales_orders_backup
DELETE FROM sales_orders_backup WHERE order_number = 'O20015';
SELECT * FROM sales_orders_backup WHERE order_number = 'O20015'; 

-- Q38: Delete the new client inserted from clients_backup
DELETE FROM clients_backup WHERE client_number = 'C111';
SELECT * FROM clients_backup WHERE client_number = 'C111'; 

-- Q39: Delete products from products_backup whose quantity_on_hand is 0
DELETE FROM products_backup WHERE quantity_on_hand = 0;



-- PROBLEM 2: HUMAN RESOURCES MANAGEMENT DATABASE



-- Q40: Use the human_resources_management database
USE human_resources_management;

-- Q41: Verify that the six required tables exist
SHOW TABLES;

-- Q42: Verify the structure of each table
DESCRIBE employees;
DESCRIBE departments;
DESCRIBE department_addresses;
DESCRIBE projects;
DESCRIBE assignments;
DESCRIBE relatives;

-- Q43: Insert the sample data into the correct tables

INSERT INTO departments (department_id, department_name, manager_id, manager_start_date) VALUES
(1, 'Administration', NULL, '2021-01-10'),
(2, 'Human Resources', NULL, '2021-02-15'),
(3, 'Information Technology', NULL, '2021-03-20'),
(4, 'Finance', NULL, '2021-04-25');


INSERT INTO employees (employee_id, last_name, middle_name, first_name, date_of_birth, gender, salary, address, manager_id, department_id) VALUES
('E01', 'Nguyen', 'Van', 'An', '1980-05-12', 'Male', 35000, 'Ben Thanh Ward, Ho Chi Minh City', NULL, 1),
('E02', 'Tran', 'Thi Thai', 'Binh', '1985-08-20', 'Female', 28000, 'Cau Giay Ward, Hanoi', 'E01', 2),
('E03', 'Le', 'Quoc', 'Cuong', '1990-11-02', 'Male', 30000, 'Thu Duc Ward, Ho Chi Minh City', 'E01', 3),
('E04', 'Pham', 'Minh', 'Dung', '1992-03-15', 'Male', 22000, 'Di An Ward, Ho Chi Minh City', 'E03', 3),
('E05', 'Hoang', 'Thuy', 'Linh', '1994-07-25', 'Female', 24000, 'Dong Da Ward, Hanoi', 'E02', 2),
('E06', 'Vo', 'Thanh', 'Mai', '1988-12-01', 'Female', 26000, 'Xuan Huong - Da Lat Ward, Lam Dong', 'E01', 4),
('E07', 'Dang', 'Huu', 'Nam', '1996-09-09', 'Male', 18000, 'Binh Thanh Ward, Ho Chi Minh City', 'E03', 3),
('E08', 'Bui', 'Ngoc', 'Oanh', '1995-01-19', 'Female', 21000, 'Lam Vien - Da Lat Ward, Lam Dong', 'E06', 4);

-- Update department managers
UPDATE departments SET manager_id = 'E01' WHERE department_id = 1;
UPDATE departments SET manager_id = 'E02' WHERE department_id = 2;
UPDATE departments SET manager_id = 'E03' WHERE department_id = 3;
UPDATE departments SET manager_id = 'E06' WHERE department_id = 4;

-- Insert department_addresses
INSERT INTO department_addresses (department_id, address) VALUES
(1, 'Ben Thanh Ward, Ho Chi Minh City'),
(1, 'Thu Duc Ward, Ho Chi Minh City'),
(2, 'Cau Giay Ward, Hanoi'),
(3, 'Di An Ward, Ho Chi Minh City'),
(3, 'Thu Duc Ward, Ho Chi Minh City'),
(4, 'Dong Da Ward, Hanoi');

-- Insert projects
INSERT INTO projects (project_id, project_name, project_address, department_id) VALUES
(101, 'Office Digitalization', 'Ben Thanh Ward, Ho Chi Minh City', 1),
(102, 'Recruitment Portal', 'Cau Giay Ward, Hanoi', 2),
(103, 'Inventory System', 'Thu Duc Ward, Ho Chi Minh City', 3),
(104, 'Payroll System', 'Dong Da Ward, Hanoi', 4),
(105, 'Data Backup Project', 'Di An Ward, Ho Chi Minh City', 3);

-- Insert assignments
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

-- Insert relatives
INSERT INTO relatives (employee_id, relative_name, gender, date_of_birth, relationship) VALUES
('E01', 'Nguyen Minh Khang', 'Male', '2010-04-12', 'Son'),
('E02', 'Tran Ngoc Han', 'Female', '2013-09-03', 'Daughter'),
('E03', 'Le Thanh Tam', 'Female', '1989-01-22', 'Spouse'),
('E04', 'Pham Bao Anh', 'Female', '2018-06-14', 'Daughter'),
('E06', 'Vo Thanh Phuc', 'Male', '2015-02-26', 'Son'),
('E08', 'Bui Minh Tri', 'Male', '2020-11-08', 'Son');

-- Q44: After inserting data, display the row count of each table
SELECT 'departments' AS table_name, COUNT(*) AS row_count FROM departments
UNION SELECT 'employees', COUNT(*) FROM employees
UNION SELECT 'department_addresses', COUNT(*) FROM department_addresses
UNION SELECT 'projects', COUNT(*) FROM projects
UNION SELECT 'assignments', COUNT(*) FROM assignments
UNION SELECT 'relatives', COUNT(*) FROM relatives;


-- Q45: Display all employees with employee_id, full name, gender, salary, and department_id
SELECT employee_id, CONCAT_WS(' ', last_name, middle_name, first_name) AS employee_full_name, gender, salary, department_id FROM employees;

-- Q46: Display all departments with department_id, department_name, manager_id, and manager_start_date
SELECT department_id, department_name, manager_id, manager_start_date FROM departments;

-- Q47: Display all projects with project_id, project_name, project_address, and department_id
SELECT project_id, project_name, project_address, department_id FROM projects;

-- Q48: Display the first 5 rows from employees
SELECT * FROM employees LIMIT 5;

-- Q49: Display the first 3 employees sorted by salary from highest to lowest
SELECT * FROM employees ORDER BY salary DESC LIMIT 3;

-- Q50: List all employees sorted by department_id ascending and then last_name ascending
SELECT * FROM employees ORDER BY department_id ASC, last_name ASC;

-- Q51: Display employees whose gender is Female
SELECT * FROM employees WHERE gender = 'Female';

-- Q52: Display employees whose salary is greater than 25000
SELECT * FROM employees WHERE salary > 25000;

-- Q53: Display employees whose manager_id is NULL
SELECT * FROM employees WHERE manager_id IS NULL;

-- Q54: Display employees whose manager_id is not NULL
SELECT * FROM employees WHERE manager_id IS NOT NULL;

-- Q55: Display employees whose address contains Ho Chi Minh City
SELECT * FROM employees WHERE address LIKE '%Ho Chi Minh City%';

-- Q56: Display projects whose project_name contains the word System
SELECT * FROM projects WHERE project_name LIKE '%System%';

-- Q57: Display assignments whose working_hours is between 10 and 18
SELECT * FROM assignments WHERE working_hours BETWEEN 10 AND 18;

-- Q58: Display relatives whose relationship is Son or Daughter
SELECT * FROM relatives WHERE relationship IN ('Son', 'Daughter');

-- Q59: Display employees with an extra column name_upper showing the full name in uppercase
SELECT e.*, UPPER(CONCAT_WS(' ', last_name, middle_name, first_name)) AS name_upper FROM employees e;

-- Q60: Display employees with an extra column age_in_years calculated from date_of_birth
SELECT e.*, TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) AS age_in_years FROM employees e;

-- Q61: Display departments with an extra column manager_start_text formatted from manager_start_date
SELECT d.*, DATE_FORMAT(manager_start_date, '%M %d, %Y') AS manager_start_text FROM departments d;

-- Q62: Display assignments with an extra column work_level using CASE
SELECT a.*, 
       CASE 
           WHEN working_hours >= 15 THEN 'High' 
           ELSE 'Normal' 
       END AS work_level 
FROM assignments a;


-- Q63: Create a backup table named employees_backup from employees
CREATE TABLE IF NOT EXISTS employees_backup AS SELECT * FROM employees;

-- Q64: Create a backup table named departments_backup from departments
CREATE TABLE IF NOT EXISTS departments_backup AS SELECT * FROM departments;

-- Q65: Create a backup table named department_addresses_backup from department_addresses
CREATE TABLE IF NOT EXISTS department_addresses_backup AS SELECT * FROM department_addresses;

-- Q66: Create a backup table named projects_backup from projects
CREATE TABLE IF NOT EXISTS projects_backup AS SELECT * FROM projects;

-- Q67: Create a backup table named assignments_backup from assignments
CREATE TABLE IF NOT EXISTS assignments_backup AS SELECT * FROM assignments;

-- Q68: Create a backup table named relatives_backup from relatives
CREATE TABLE IF NOT EXISTS relatives_backup AS SELECT * FROM relatives;

-- Q69: Verify the number of rows in each backup table and compare it with the original table
SELECT 
    (SELECT COUNT(*) FROM employees) AS orig_employees, (SELECT COUNT(*) FROM employees_backup) AS back_employees,
    (SELECT COUNT(*) FROM departments) AS orig_departments, (SELECT COUNT(*) FROM departments_backup) AS back_departments,
    (SELECT COUNT(*) FROM department_addresses) AS orig_addresses, (SELECT COUNT(*) FROM department_addresses_backup) AS back_addresses,
    (SELECT COUNT(*) FROM projects) AS orig_projects, (SELECT COUNT(*) FROM projects_backup) AS back_projects,
    (SELECT COUNT(*) FROM assignments) AS orig_assignments, (SELECT COUNT(*) FROM assignments_backup) AS back_assignments,
    (SELECT COUNT(*) FROM relatives) AS orig_relatives, (SELECT COUNT(*) FROM relatives_backup) AS back_relatives;

-- Q70: Update the salary of employee E07 in employees_backup by increasing it by 10 percent
UPDATE employees_backup SET salary = salary * 1.10 WHERE employee_id = 'E07';
SELECT * FROM employees_backup WHERE employee_id = 'E07'; 

-- Q71: Update the address of employee E08 in employees_backup
UPDATE employees_backup SET address = 'New Test Ward, Lam Dong' WHERE employee_id = 'E08';
SELECT * FROM employees_backup WHERE employee_id = 'E08'; 

-- Q72: Update working_hours to 16.5 for employee E04 on project 105 in assignments_backup
UPDATE assignments_backup SET working_hours = 16.5 WHERE employee_id = 'E04' AND project_id = 105;
SELECT * FROM assignments_backup WHERE employee_id = 'E04' AND project_id = 105; 

-- Q73: Insert one new employee into employees_backup
INSERT INTO employees_backup (employee_id, last_name, middle_name, first_name, date_of_birth, gender, salary, address, manager_id, department_id) 
VALUES ('E99', 'Le', 'Thi', 'Test', '1995-01-01', 'Female', 20000, 'Test Address', 'E01', 1);
SELECT * FROM employees_backup WHERE employee_id = 'E99'; 

-- Q74: Insert one new project into projects_backup
INSERT INTO projects_backup (project_id, project_name, project_address, department_id) 
VALUES (999, 'Test Project', 'Test Address', 1);
SELECT * FROM projects_backup WHERE project_id = 999; 

-- Q75: Insert one new assignment into assignments_backup for the new employee and project
INSERT INTO assignments_backup (employee_id, project_id, working_hours) 
VALUES ('E99', 999, 10.0);
SELECT * FROM assignments_backup WHERE employee_id = 'E99' AND project_id = 999; 

-- Q76: Delete the new assignment inserted from assignments_backup
DELETE FROM assignments_backup WHERE employee_id = 'E99' AND project_id = 999;
SELECT * FROM assignments_backup WHERE employee_id = 'E99' AND project_id = 999; 

-- Q77: Delete the new project inserted from projects_backup
DELETE FROM projects_backup WHERE project_id = 999;
SELECT * FROM projects_backup WHERE project_id = 999; 

-- Q78: Delete the new employee inserted from employees_backup
DELETE FROM employees_backup WHERE employee_id = 'E99';
SELECT * FROM employees_backup WHERE employee_id = 'E99'; 

-- Q79: Delete relatives from relatives_backup whose relationship is Other
DELETE FROM relatives_backup WHERE relationship = 'Other';
SELECT * FROM relatives_backup WHERE relationship = 'Other';