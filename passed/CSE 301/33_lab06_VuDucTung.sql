-- ==============================================================================
-- AI DECLARATION:
-- AI tool used: Gemini
-- Purpose: Query drafting, syntax optimization, and bug fixing.
-- Verification: I ran all SQL statements in MySQL Workbench and fixed errors before submission.
-- ==============================================================================

-- ==============================================================================
-- 6. Problem 1. Sales Management Database
-- ==============================================================================
USE sales_management;

-- A. Index creation, index inspection, and EXPLAIN practice

-- Q1. Display all tables in database
SHOW TABLES;

-- Q2. Display indexes defined on clients
SHOW INDEX FROM clients;

-- Q3. Inspect query filtering clients by province
EXPLAIN SELECT * FROM clients WHERE province = 'Ho Chi Minh City';

-- Q4. Create index on client province
CREATE INDEX idx_clients_province ON clients(province);

-- Q5. Inspect again and compare index usage
-- Before: possible_keys = NULL, key = NULL; After: possible_keys = idx_clients_province, key = idx_clients_province
EXPLAIN SELECT * FROM clients WHERE province = 'Ho Chi Minh City';

-- Q6. Create composite index on city and province
CREATE INDEX idx_clients_city_province ON clients(city, province);

-- Q7. Inspect composite query on city and province
EXPLAIN SELECT * FROM clients WHERE city = 'Thu Duc Ward' AND province = 'Ho Chi Minh City';

-- Q8. Display indexes defined on products
SHOW INDEX FROM products;

-- Q9. Create index on product sale price
CREATE INDEX idx_products_sale_price ON products(sale_price);

-- Q10. Inspect range query on sale price
EXPLAIN SELECT * FROM products WHERE sale_price BETWEEN 50 AND 500;

-- Q11. Create index on order date
CREATE INDEX idx_sales_orders_order_date ON sales_orders(order_date);

-- Q12. Inspect date range query on orders
EXPLAIN SELECT * FROM sales_orders WHERE order_date BETWEEN '2022-04-01' AND '2022-05-31';

-- Q13. Create composite index on status and order date
CREATE INDEX idx_sales_orders_status_date ON sales_orders(delivery_status, order_date);

-- Q14. Inspect query filtering by status and date
EXPLAIN SELECT * FROM sales_orders WHERE delivery_status = 'Delivered' AND order_date > '2022-03-01';

-- Q15. Display all indexes on sales orders
SHOW INDEX FROM sales_orders;

-- Q16. Drop sale price index and verify
DROP INDEX idx_products_sale_price ON products;
SHOW INDEX FROM products;

-- Q17. Recreate sale price index
CREATE INDEX idx_products_sale_price ON products(sale_price);


-- B. MySQL date function practice on sales orders

-- Q18. Format order date as dd/mm/yyyy
SELECT order_number, order_date, DATE_FORMAT(order_date, '%d/%m/%Y') AS order_date_text
FROM sales_orders;

-- Q19. Calculate delivery days for shipped orders
SELECT order_number, order_date, delivery_date, DATEDIFF(delivery_date, order_date) AS delivery_days
FROM sales_orders 
WHERE delivery_date IS NOT NULL;

-- Q20. Calculate follow-up date (7 days after)
SELECT order_number, order_date, DATE_ADD(order_date, INTERVAL 7 DAY) AS follow_up_date
FROM sales_orders;

-- Q21. Extract year, month, and day from order date
SELECT order_number, order_date, YEAR(order_date) AS order_year, MONTH(order_date) AS order_month, DAY(order_date) AS order_day
FROM sales_orders;

-- Q22. Calculate days elapsed since order date
SELECT order_number, order_date, CURDATE() AS current_date_value, DATEDIFF(CURDATE(), order_date) AS days_since_order
FROM sales_orders;

-- Q23. Evaluate delivery speed label
SELECT order_number, delivery_status, order_date, delivery_date,
  CASE 
    WHEN delivery_date IS NULL THEN 'Not Delivered'
    WHEN DATEDIFF(delivery_date, order_date) <= 30 THEN 'Fast Delivery'
    ELSE 'Slow Delivery'
  END AS delivery_speed_label
FROM sales_orders;


-- C. View creation and view usage practice

-- Q24. Create client contact view
DROP VIEW IF EXISTS v_client_contact; 
CREATE VIEW v_client_contact AS
SELECT client_number, CONCAT(first_name, ' ', middle_name, ' ', last_name) AS client_full_name, city, province, amount_paid, amount_due 
FROM clients;

-- Q25. Query client contact view for HCMC
SELECT * FROM v_client_contact 
WHERE province = 'Ho Chi Minh City';

-- Q26. Create product price status view
DROP VIEW IF EXISTS v_product_price_status; 
CREATE VIEW v_product_price_status AS
SELECT product_number, product_name, sale_price, cost_price, (sale_price - cost_price) AS profit_per_unit,  
  CASE 
    WHEN sale_price < cost_price THEN 'Loss'
    WHEN sale_price = cost_price THEN 'Break-even'
    ELSE 'Profit'
  END AS pricing_result
FROM products;

-- Q27. Query view for profitable products
SELECT * FROM v_product_price_status 
WHERE pricing_result = 'Profit';

-- Q28. Create order date status view
DROP VIEW IF EXISTS v_order_date_status; 
CREATE VIEW v_order_date_status AS
SELECT order_number, order_date, DATE_FORMAT(order_date, '%d/%m/%Y') AS order_date_text, delivery_date, delivery_status, order_status, 
  CASE 
    WHEN delivery_date IS NULL THEN 'Not Delivered'
    WHEN DATEDIFF(delivery_date, order_date) <= 30 THEN 'Fast Delivery'
    ELSE 'Slow Delivery'
  END AS delivery_speed_label
FROM sales_orders;

-- Q29. Query view for pending delivery states
SELECT * FROM v_order_date_status 
WHERE delivery_status IN ('On Way', 'Ready to Ship');

-- Q30. Create simple order client view
DROP VIEW IF EXISTS v_order_client_simple; 
CREATE VIEW v_order_client_simple AS
SELECT sales_orders.order_number, sales_orders.order_date, sales_orders.client_number,
       CONCAT(clients.first_name, ' ', clients.middle_name, ' ', clients.last_name) AS client_full_name,
       sales_orders.delivery_status, sales_orders.order_status
FROM sales_orders
INNER JOIN clients ON sales_orders.client_number = clients.client_number;

-- Q31. Query view for clients named Nguyen
SELECT * FROM v_order_client_simple
WHERE client_full_name LIKE '%Nguyen%';

-- Q32. Create simple order salesman view
DROP VIEW IF EXISTS v_order_salesman_simple; 
CREATE VIEW v_order_salesman_simple AS
SELECT sales_orders.order_number, sales_orders.order_date, sales_orders.salesman_number,
       CONCAT(salesmen.first_name, ' ', salesmen.middle_name, ' ', salesmen.last_name) AS salesman_full_name, 
       sales_orders.delivery_status, sales_orders.order_status
FROM sales_orders
INNER JOIN salesmen ON sales_orders.salesman_number = salesmen.salesman_number;

-- Q33. Query view for HCMC salesmen
SELECT v.* FROM v_order_salesman_simple v
INNER JOIN salesmen s ON v.salesman_number = s.salesman_number
WHERE s.province = 'Ho Chi Minh City';

-- Q34. Create simple order line view
DROP VIEW IF EXISTS v_order_line_simple; 
CREATE VIEW v_order_line_simple AS
SELECT sales_order_details.order_number, sales_order_details.product_number, products.product_name,
       sales_order_details.order_quantity, products.sale_price, 
       (sales_order_details.order_quantity * products.sale_price) AS line_total
FROM sales_order_details
INNER JOIN products ON sales_order_details.product_number = products.product_number;

-- Q35. Query view for large order totals
SELECT * FROM v_order_line_simple
WHERE line_total > 500;

-- Q36. Display all views in database
SHOW FULL TABLES WHERE Table_type = 'VIEW';

-- Q37. Drop and recreate product price view
DROP VIEW IF EXISTS v_product_price_status; 
CREATE VIEW v_product_price_status AS
SELECT product_number, product_name, sale_price, cost_price, (sale_price - cost_price) AS profit_per_unit,  
  CASE 
    WHEN sale_price < cost_price THEN 'Loss'
    WHEN sale_price = cost_price THEN 'Break-even'
    ELSE 'Profit'
  END AS pricing_result
FROM products;


-- ==============================================================================
-- 7. Problem 2. Human Resources Management Database
-- ==============================================================================
USE human_resources_management;

-- D. Index creation, index inspection, and EXPLAIN practice

-- Q38. Display all tables in HR database
SHOW TABLES;

-- Q39. Display indexes defined on employees
SHOW INDEX FROM employees;

-- Q40. Inspect query filtering by department
EXPLAIN SELECT * FROM employees WHERE department_id = 3;

-- Q41. Create index on employee department ID
CREATE INDEX idx_employees_department_id ON employees(department_id);

-- Q42. Inspect again and compare department index usage
-- Before: possible_keys = NULL, key = NULL; After: possible_keys = idx_employees_department_id, key = idx_employees_department_id
EXPLAIN SELECT * FROM employees WHERE department_id = 3;

-- Q43. Create index on employee manager ID
CREATE INDEX idx_employees_manager_id ON employees(manager_id);

-- Q44. Inspect self join execution plan for managers
EXPLAIN SELECT employee.manager_id, manager.employee_id
FROM employees employee
INNER JOIN employees manager ON employee.manager_id = manager.employee_id;

-- Q45. Create index on employee salary
CREATE INDEX idx_employees_salary ON employees(salary);

-- Q46. Inspect range query on salary
EXPLAIN SELECT * FROM employees WHERE salary BETWEEN 20000 AND 30000;

-- Q47. Create composite index on department and salary
CREATE INDEX idx_employees_department_salary ON employees(department_id, salary);

-- Q48. Inspect composite query on department and salary
EXPLAIN SELECT * FROM employees WHERE department_id = 3 AND salary > 20000;

-- Q49. Display indexes defined on projects
SHOW INDEX FROM projects;

-- Q50. Create index on project department ID
CREATE INDEX idx_projects_department_id ON projects(department_id);

-- Q51. Inspect join query between projects and departments
EXPLAIN SELECT * FROM projects
INNER JOIN departments ON projects.department_id = departments.department_id;

-- Q52. Display indexes defined on assignments
SHOW INDEX FROM assignments;

-- Q53. Create index on assignment project ID
CREATE INDEX idx_assignments_project_id ON assignments(project_id);

-- Q54. Inspect join query between assignments and projects
EXPLAIN SELECT * FROM assignments
INNER JOIN projects ON assignments.project_id = projects.project_id;

-- Q55. Drop salary index and verify
DROP INDEX idx_employees_salary ON employees;
SHOW INDEX FROM employees;

-- Q56. Recreate salary index
CREATE INDEX idx_employees_salary ON employees(salary);


-- E. MySQL date function practice on HR data

-- Q57. Format employee date of birth
SELECT employee_id, date_of_birth, DATE_FORMAT(date_of_birth, '%d/%m/%Y') AS birth_date_text
FROM employees;

-- Q58. Calculate employee age in years
SELECT employee_id, date_of_birth, TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) AS age_in_years
FROM employees;

-- Q59. Calculate retirement date (60 years added)
SELECT employee_id, date_of_birth, DATE_ADD(date_of_birth, INTERVAL 60 YEAR) AS estimated_retirement_date
FROM employees;

-- Q60. Format manager start date as Month dd, yyyy
SELECT department_id, department_name, manager_start_date, DATE_FORMAT(manager_start_date, '%M %d, %Y') AS manager_start_text
FROM departments;

-- Q61. Calculate manager days in current role
SELECT department_id, department_name, manager_start_date, DATEDIFF(CURDATE(), manager_start_date) AS manager_days_in_role
FROM departments;

-- Q62. Calculate relative age in years
SELECT relative_name, date_of_birth, TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) AS relative_age_in_years
FROM relatives
WHERE date_of_birth IS NOT NULL;


-- F. View creation and view usage practice

-- Q63. Create employee profile view
DROP VIEW IF EXISTS v_employee_profile;
CREATE VIEW v_employee_profile AS 
SELECT employee_id, CONCAT(first_name, ' ', middle_name, ' ', last_name) AS employee_full_name, gender, salary, address, manager_id, department_id 
FROM employees;

-- Q64. Query view for HCMC employees
SELECT * FROM v_employee_profile
WHERE address LIKE '%Ho Chi Minh City%';
 
-- Q65. Create employee age profile view
DROP VIEW IF EXISTS v_employee_age_profile;
CREATE VIEW v_employee_age_profile AS 
SELECT employee_id, CONCAT(first_name, ' ', middle_name, ' ', last_name) AS employee_full_name, date_of_birth, 
       DATE_FORMAT(date_of_birth, '%d/%m/%Y') AS birth_date_text,
       TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) AS age_in_years, 
       DATE_ADD(date_of_birth, INTERVAL 60 YEAR) AS estimated_retirement_date
FROM employees;

-- Q66. Query view for employees aged 30 and above
SELECT * FROM v_employee_age_profile
WHERE age_in_years >= 30;
 
-- Q67. Create simple department manager view
DROP VIEW IF EXISTS v_department_manager_simple;
CREATE VIEW v_department_manager_simple AS 
SELECT departments.department_id, departments.department_name, departments.manager_id,
       CONCAT(employees.first_name, ' ', employees.middle_name, ' ', employees.last_name) AS manager_full_name, 
       departments.manager_start_date
FROM departments
INNER JOIN employees ON departments.manager_id = employees.employee_id;

-- Q68. Query view for managers started after specific date
SELECT * FROM v_department_manager_simple
WHERE manager_start_date > '2021-02-01';
 
-- Q69. Create simple project department view
DROP VIEW IF EXISTS v_project_department_simple;
CREATE VIEW v_project_department_simple AS 
SELECT projects.project_id, projects.project_name, projects.project_address, projects.department_id, departments.department_name
FROM projects
INNER JOIN departments ON projects.department_id = departments.department_id;

-- Q70. Query view for project names containing System
SELECT * FROM v_project_department_simple
WHERE project_name LIKE '%System%';
 
-- Q71. Create assignment profile view
DROP VIEW IF EXISTS v_assignment_profile;
CREATE VIEW v_assignment_profile AS 
SELECT assignments.employee_id, CONCAT(employees.first_name, ' ', employees.middle_name, ' ', employees.last_name) AS employee_full_name, 
       assignments.project_id, projects.project_name, assignments.working_hours, projects.project_address
FROM assignments
INNER JOIN employees ON assignments.employee_id = employees.employee_id
INNER JOIN projects ON assignments.project_id = projects.project_id;

-- Q72. Query view for heavy working hours
SELECT * FROM v_assignment_profile
WHERE working_hours > 12;
 
-- Q73. Create simple relative employee view
DROP VIEW IF EXISTS v_relative_employee_simple;
CREATE VIEW v_relative_employee_simple AS 
SELECT relatives.employee_id, CONCAT(employees.first_name, ' ', employees.middle_name, ' ', employees.last_name) AS employee_full_name,
       relatives.relative_name, relatives.gender, relatives.date_of_birth, 
       TIMESTAMPDIFF(YEAR, relatives.date_of_birth, CURDATE()) AS relative_age_in_years, relatives.relationship
FROM relatives
INNER JOIN employees ON relatives.employee_id = employees.employee_id;

-- Q74. Query view for children relatives
SELECT * FROM v_relative_employee_simple
WHERE relationship IN ('Son', 'Daughter');
 
-- Q75. Display all views in HR database
SHOW FULL TABLES WHERE Table_type = 'VIEW';

-- Q76. Drop and recreate employee age view
DROP VIEW IF EXISTS v_employee_age_profile;
CREATE VIEW v_employee_age_profile AS 
SELECT employee_id, CONCAT(first_name, ' ', middle_name, ' ', last_name) AS employee_full_name, date_of_birth, 
       DATE_FORMAT(date_of_birth, '%d/%m/%Y') AS birth_date_text,
       TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) AS age_in_years, 
       DATE_ADD(date_of_birth, INTERVAL 60 YEAR) AS estimated_retirement_date
FROM employees;