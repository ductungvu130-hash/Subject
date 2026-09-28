-- 6. Problem 1. Sales Management Database

USE sales_management;

-- A. String function practice

-- Q1. Display client_number and the client full name using CONCAT_WS
SELECT client_number, CONCAT_WS(' ', first_name, middle_name, last_name) AS client_full_name 
FROM clients;

-- Q2. Display client_number and client_full_name in uppercase
SELECT client_number, UPPER(CONCAT_WS(' ', first_name, middle_name, last_name)) AS client_name_upper 
FROM clients;

-- Q3. Display salesman_number and a contact label
SELECT salesman_number, CONCAT_WS(' | ', CONCAT_WS(' ', first_name, middle_name, last_name), phone) AS salesman_contact_label 
FROM salesmen;

-- Q4. Display product_name_length using CHAR_LENGTH
SELECT product_number, product_name, CHAR_LENGTH(product_name) AS product_name_length 
FROM products;

-- Q5. Display the first three characters of product_name
SELECT product_number, product_name, LEFT(product_name, 3) AS product_prefix 
FROM products;

-- Q6. Display cleaned_address using TRIM
SELECT client_number, address, TRIM(address) AS cleaned_address 
FROM clients;

-- Q7. Display a city_code made from the first 5 characters of city in uppercase
SELECT client_number, city, UPPER(LEFT(city, 5)) AS city_code 
FROM clients;

-- Q8. Display phone_last_4 using RIGHT
SELECT salesman_number, phone, RIGHT(phone, 4) AS phone_last_4 
FROM salesmen;

-- Q9. Replace TV with Television
SELECT product_number, product_name, REPLACE(product_name, 'TV', 'Television') AS product_name_with_item 
FROM products;

-- Q10. Display position of 'Nguyen' using LOCATE
SELECT client_number, CONCAT_WS(' ', first_name, middle_name, last_name) AS client_full_name, 
       LOCATE('Nguyen', CONCAT_WS(' ', first_name, middle_name, last_name)) AS position_of_nguyen 
FROM clients;


-- B. Aggregate functions and GROUP BY practice

-- Q11. Count the number of clients in each province
SELECT province, COUNT(client_number) AS client_count 
FROM clients 
GROUP BY province;

-- Q12. Calculate the total amount_due by province
SELECT province, SUM(amount_due) AS total_amount_due 
FROM clients 
GROUP BY province;

-- Q13. Calculate the average amount_paid by province
SELECT province, AVG(amount_paid) AS avg_amount_paid 
FROM clients 
GROUP BY province;

-- Q14. Find the minimum and maximum sale_price
SELECT MIN(sale_price) AS min_sale_price, MAX(sale_price) AS max_sale_price 
FROM products;

-- Q15. Calculate the total stock value by product
SELECT product_number, product_name, (quantity_on_hand * sale_price) AS stock_value 
FROM products;

-- Q16. Count the number of sales orders by delivery_status
SELECT delivery_status, COUNT(order_number) AS order_count 
FROM sales_orders 
GROUP BY delivery_status;

-- Q17. Count the number of sales orders by order_status
SELECT order_status, COUNT(order_number) AS order_count 
FROM sales_orders 
GROUP BY order_status;

-- Q18. Calculate the total ordered quantity for each product_number
SELECT product_number, SUM(order_quantity) AS total_order_quantity 
FROM sales_order_details 
GROUP BY product_number;

-- Q19. Calculate the total line value for each product
SELECT p.product_number, p.product_name, SUM(sod.order_quantity * p.sale_price) AS total_line_value 
FROM sales_order_details sod 
INNER JOIN products p ON sod.product_number = p.product_number 
GROUP BY p.product_number, p.product_name;

-- Q20. Calculate the number of orders handled by each salesman
SELECT s.salesman_number, CONCAT_WS(' ', s.first_name, s.middle_name, s.last_name) AS salesman_full_name, COUNT(so.order_number) AS order_count 
FROM salesmen s 
INNER JOIN sales_orders so ON s.salesman_number = so.salesman_number 
GROUP BY s.salesman_number, salesman_full_name;


-- C. WHERE and HAVING comparison practice

-- Q21. WHERE filter before GROUP BY
SELECT province, COUNT(client_number) AS client_count 
FROM clients 
WHERE province = 'Ho Chi Minh City' 
GROUP BY province;

-- Q22. HAVING filter after GROUP BY
SELECT province, COUNT(client_number) AS client_count 
FROM clients 
GROUP BY province 
HAVING COUNT(client_number) > 2;

-- Q23. Filter products price > 100 before group
SELECT product_name, AVG(sale_price) AS avg_sale_price 
FROM products 
WHERE sale_price > 100 
GROUP BY product_name;

-- Q24. Filter group using HAVING avg_sale_price > 100
SELECT product_name, AVG(sale_price) AS avg_sale_price 
FROM products 
GROUP BY product_name 
HAVING avg_sale_price > 100;

-- Q25. Filter Successful orders before grouping
SELECT salesman_number, COUNT(order_number) AS successful_order_count 
FROM sales_orders 
WHERE order_status = 'Successful' 
GROUP BY salesman_number;

-- Q26. Filter salesman groups with > 2 orders
SELECT salesman_number, COUNT(order_number) AS order_count 
FROM sales_orders 
GROUP BY salesman_number 
HAVING COUNT(order_number) > 2;

-- Q27. Filter delivered orders before grouping by status
SELECT order_status, COUNT(order_number) AS delivered_order_count 
FROM sales_orders 
WHERE delivery_status = 'Delivered' 
GROUP BY order_status;

-- Q28. Filter order groups with > 10 total items
SELECT order_number, SUM(order_quantity) AS total_order_quantity 
FROM sales_order_details 
GROUP BY order_number 
HAVING SUM(order_quantity) > 10;

-- Q29. Difference between WHERE and HAVING
-- Answer: WHERE filters individual rows BEFORE they are grouped. HAVING filters grouped records AFTER the GROUP BY operation is performed.

-- Q30. Using both WHERE and HAVING together
SELECT sod.product_number, SUM(sod.order_quantity) AS total_order_quantity 
FROM sales_order_details sod 
INNER JOIN products p ON sod.product_number = p.product_number 
WHERE p.sale_price >= 50 
GROUP BY sod.product_number 
HAVING SUM(sod.order_quantity) >= 10;


-- D. Subquery practice

-- Q31. Scalar subquery: price > average price
SELECT * FROM products 
WHERE sale_price > (SELECT AVG(sale_price) FROM products);

-- Q32. Scalar subquery: amount_due > average amount_due
SELECT * FROM clients 
WHERE amount_due > (SELECT AVG(amount_due) FROM clients);

-- Q33. Scalar subquery: salary > average salary
SELECT * FROM salesmen 
WHERE salary > (SELECT AVG(salary) FROM salesmen);

-- Q34. Subquery using IN: clients with orders
SELECT * FROM clients 
WHERE client_number IN (SELECT client_number FROM sales_orders);

-- Q35. Subquery using NOT IN: clients without orders
SELECT * FROM clients 
WHERE client_number NOT IN (SELECT client_number FROM sales_orders WHERE client_number IS NOT NULL);

-- Q36. Subquery using IN: products in order details
SELECT * FROM products 
WHERE product_number IN (SELECT product_number FROM sales_order_details);

-- Q37. Subquery using NOT IN: products not in order details
SELECT * FROM products 
WHERE product_number NOT IN (SELECT product_number FROM sales_order_details WHERE product_number IS NOT NULL);

-- Q38. Subquery using IN: salesmen with Cancelled orders
SELECT * FROM salesmen 
WHERE salesman_number IN (SELECT salesman_number FROM sales_orders WHERE order_status = 'Cancelled');

-- Q39. Subquery using EXISTS: clients with Successful orders
SELECT * FROM clients c 
WHERE EXISTS (SELECT 1 FROM sales_orders so WHERE so.client_number = c.client_number AND so.order_status = 'Successful');

-- Q40. Scalar subquery: price > price of P1006
SELECT * FROM products 
WHERE sale_price > (SELECT sale_price FROM products WHERE product_number = 'P1006');


-- E. Safe INSERT, UPDATE, and DELETE practice on backup tables

-- Q41. Create products backup
CREATE TABLE lab7_products_backup AS SELECT * FROM products;

-- Q42. Create clients backup
CREATE TABLE lab7_clients_backup AS SELECT * FROM clients;

-- Q43. Create sales orders backup
CREATE TABLE lab7_sales_orders_backup AS SELECT * FROM sales_orders;

-- Q44. Insert new product
INSERT INTO lab7_products_backup (product_number, product_name, quantity_on_hand, quantity_sold, sale_price, cost_price) 
VALUES ('P9000', 'Mech Keyboard', 40, 15, 150, 100);

-- Q45. Update new product
UPDATE lab7_products_backup 
SET sale_price = sale_price * 1.10 
WHERE product_number = 'P9000';

-- Q46. Delete new product
DELETE FROM lab7_products_backup 
WHERE product_number = 'P9000';

-- Q47. Insert new client
INSERT INTO lab7_clients_backup (client_number, first_name, middle_name, last_name, address, city, pincode, province, amount_paid, amount_due) 
VALUES ('C900', 'Tung', 'Duc', 'Vu', 'Nam Ky Khoi Nghia', 'Thu Dau Mot', '700000', 'Binh Duong', 200, 50);

-- Q48. Update new client
UPDATE lab7_clients_backup 
SET amount_due = amount_due - 100 
WHERE client_number = 'C900';

-- Q49. Delete new client
DELETE FROM lab7_clients_backup 
WHERE client_number = 'C900';

-- Q50. Display row counts to verify original remains unchanged
SELECT 'Original' AS table_type, COUNT(*) AS row_count FROM products
UNION ALL 
SELECT 'Backup' AS table_type, COUNT(*) AS row_count FROM lab7_products_backup;
-- The counts are identical since all DML statements were safely executed on the backup table.


-- ==============================================================================
-- 7. Problem 2. Human Resources Management Database
-- ==============================================================================
USE human_resources_management;

-- F. String function practice

-- Q51. Display employee_full_name using CONCAT_WS
SELECT employee_id, CONCAT_WS(' ', last_name, middle_name, first_name) AS employee_full_name 
FROM employees;

-- Q52. Display employee_full_name in uppercase
SELECT employee_id, UPPER(CONCAT_WS(' ', last_name, middle_name, first_name)) AS employee_name_upper 
FROM employees;

-- Q53. Display address_length using CHAR_LENGTH
SELECT employee_id, address, CHAR_LENGTH(address) AS address_length 
FROM employees;

-- Q54. Display city_hint using RIGHT
SELECT employee_id, address, RIGHT(address, 20) AS city_hint 
FROM employees;

-- Q55. Display first_name_prefix using LEFT
SELECT employee_id, first_name, LEFT(first_name, 2) AS first_name_prefix 
FROM employees;

-- Q56. Display padded_employee_id using LPAD
SELECT employee_id, last_name, LPAD(employee_id, 5, '0') AS padded_employee_id 
FROM employees;

-- Q57. Display department_name_lower using LOWER
SELECT department_id, department_name, LOWER(department_name) AS department_name_lower 
FROM departments;

-- Q58. Display project_code using LEFT and UPPER
SELECT project_id, project_name, UPPER(LEFT(project_name, 3)) AS project_code 
FROM projects;

-- Q59. Display relationship_label
SELECT relative_name, CONCAT(relative_name, ' - ', relationship) AS relationship_label 
FROM relatives;

-- Q60. Replace Ho Chi Minh City with HCMC
SELECT employee_id, address, REPLACE(address, 'Ho Chi Minh City', 'HCMC') AS address_without_city 
FROM employees;


-- G. Aggregate functions and GROUP BY practice

-- Q61. Count employees by department
SELECT department_id, COUNT(employee_id) AS employee_count 
FROM employees 
GROUP BY department_id;

-- Q62. Average salary by department
SELECT department_id, AVG(salary) AS avg_salary 
FROM employees 
GROUP BY department_id;

-- Q63. Min and max salary by department
SELECT department_id, MIN(salary) AS min_salary, MAX(salary) AS max_salary 
FROM employees 
GROUP BY department_id;

-- Q64. Count employees by gender
SELECT gender, COUNT(employee_id) AS employee_count 
FROM employees 
GROUP BY gender;

-- Q65. Count projects by department
SELECT department_id, COUNT(project_id) AS project_count 
FROM projects 
GROUP BY department_id;

-- Q66. Total working hours by project
SELECT project_id, SUM(working_hours) AS total_working_hours 
FROM assignments 
GROUP BY project_id;

-- Q67. Average working hours by employee
SELECT employee_id, AVG(working_hours) AS avg_working_hours 
FROM assignments 
GROUP BY employee_id;

-- Q68. Count relatives by employee
SELECT employee_id, COUNT(relative_name) AS relative_count 
FROM relatives 
GROUP BY employee_id;

-- Q69. Employee count by department name (using join)
SELECT d.department_name, COUNT(e.employee_id) AS employee_count 
FROM departments d 
LEFT JOIN employees e ON d.department_id = e.department_id 
GROUP BY d.department_id, d.department_name;

-- Q70. Total working hours by project name (using join)
SELECT p.project_name, SUM(a.working_hours) AS total_working_hours 
FROM projects p 
LEFT JOIN assignments a ON p.project_id = a.project_id 
GROUP BY p.project_id, p.project_name;


-- H. WHERE and HAVING comparison practice

-- Q71. WHERE filter salary >= 22000 before group
SELECT department_id, COUNT(employee_id) AS employee_count 
FROM employees 
WHERE salary >= 22000 
GROUP BY department_id;

-- Q72. HAVING filter group count > 1
SELECT department_id, COUNT(employee_id) AS employee_count 
FROM employees 
GROUP BY department_id 
HAVING COUNT(employee_id) > 1;

-- Q73. WHERE filter Female employees before group
SELECT department_id, COUNT(employee_id) AS female_employee_count 
FROM employees 
WHERE gender = 'Female' 
GROUP BY department_id;

-- Q74. HAVING filter avg_salary > 23000
SELECT department_id, AVG(salary) AS avg_salary 
FROM employees 
GROUP BY department_id 
HAVING AVG(salary) > 23000;

-- Q75. WHERE filter working_hours >= 10 before group
SELECT project_id, SUM(working_hours) AS total_working_hours 
FROM assignments 
WHERE working_hours >= 10 
GROUP BY project_id;

-- Q76. HAVING filter total_working_hours > 15
SELECT project_id, SUM(working_hours) AS total_working_hours 
FROM assignments 
GROUP BY project_id 
HAVING SUM(working_hours) > 15;

-- Q77. WHERE filter projects in department 3
SELECT department_id, COUNT(project_id) AS project_count 
FROM projects 
WHERE department_id = 3 
GROUP BY department_id;

-- Q78. HAVING filter relationship groups >= 2
SELECT relationship, COUNT(relative_name) AS relative_count 
FROM relatives 
GROUP BY relationship 
HAVING COUNT(relative_name) >= 2;

-- Q79. Why WHERE cannot directly use aggregate aliases
-- Answer: The WHERE clause evaluates conditions row-by-row before any grouping or aggregations are calculated, meaning aliases like `employee_count` do not exist in memory at the WHERE stage.

-- Q80. Combine WHERE and HAVING
SELECT department_id, AVG(salary) AS avg_salary 
FROM employees 
WHERE salary >= 18000 
GROUP BY department_id 
HAVING AVG(salary) >= 23000;


-- I. Subquery practice

-- Q81. Salary > average salary
SELECT * FROM employees 
WHERE salary > (SELECT AVG(salary) FROM employees);

-- Q82. Salary = maximum salary
SELECT * FROM employees 
WHERE salary = (SELECT MAX(salary) FROM employees);

-- Q83. Employees in departments with projects
SELECT * FROM employees 
WHERE department_id IN (SELECT department_id FROM projects WHERE department_id IS NOT NULL);

-- Q84. Departments without projects
SELECT * FROM departments 
WHERE department_id NOT IN (SELECT department_id FROM projects WHERE department_id IS NOT NULL);

-- Q85. Employees with assignments
SELECT * FROM employees 
WHERE employee_id IN (SELECT employee_id FROM assignments);

-- Q86. Employees without assignments
SELECT * FROM employees 
WHERE employee_id NOT IN (SELECT employee_id FROM assignments WHERE employee_id IS NOT NULL);

-- Q87. Employees with relatives using EXISTS
SELECT * FROM employees e 
WHERE EXISTS (SELECT 1 FROM relatives r WHERE r.employee_id = e.employee_id);

-- Q88. Employees without relatives using NOT EXISTS
SELECT * FROM employees e 
WHERE NOT EXISTS (SELECT 1 FROM relatives r WHERE r.employee_id = e.employee_id);

-- Q89. Projects in E03's department
SELECT * FROM projects 
WHERE department_id = (SELECT department_id FROM employees WHERE employee_id = 'E03');

-- Q90. Assignments with hours > average hours
SELECT * FROM assignments 
WHERE working_hours > (SELECT AVG(working_hours) FROM assignments);


-- J. Safe INSERT, UPDATE, and DELETE practice on backup tables

-- Q91. Create employees backup
CREATE TABLE lab7_employees_backup AS SELECT * FROM employees;

-- Q92. Create projects backup
CREATE TABLE lab7_projects_backup AS SELECT * FROM projects;

-- Q93. Create assignments backup
CREATE TABLE lab7_assignments_backup AS SELECT * FROM assignments;

-- Q94. Insert new employee
INSERT INTO lab7_employees_backup (employee_id, last_name, middle_name, first_name, date_of_birth, gender, salary, address, manager_id, department_id) 
VALUES ('E99', 'Vu', 'Duc', 'Tung', '2004-01-01', 'Male', 25000, 'Binh Duong', NULL, 3);

-- Q95. Update new employee
UPDATE lab7_employees_backup 
SET salary = salary * 1.05 
WHERE employee_id = 'E99';

-- Q96. Delete new employee
DELETE FROM lab7_employees_backup 
WHERE employee_id = 'E99';

-- Q97. Insert new project
INSERT INTO lab7_projects_backup (project_id, project_name, project_address, department_id) 
VALUES (999, 'AI Scoreboard Integration', 'EIU Binh Duong', 3);

-- Q98. Update new project
UPDATE lab7_projects_backup 
SET project_address = 'Remote' 
WHERE project_id = 999;

-- Q99. Delete new project
DELETE FROM lab7_projects_backup 
WHERE project_id = 999;

-- Q100. Display row counts to verify original remains unchanged
SELECT 'Original' AS table_type, COUNT(*) AS row_count FROM employees
UNION ALL 
SELECT 'Backup' AS table_type, COUNT(*) AS row_count FROM lab7_employees_backup;


-- ==============================================================================
-- AI Usage Declaration: 
-- I used Gemini to format the SQL answers, ensure exact matching of required column aliases, and safely validate subquery structures. All queries were fully tested and verified against the schema logic.
-- ==============================================================================