
-- 5. Problem 1. Sales Management Database 
-- ==============================================================================
USE sales_management; 

-- A. SELECT-list practice 

-- Q1. Distinct client provinces 
SELECT DISTINCT province AS client_province
FROM clients;

-- Q2. Distinct city-province pairs sorted 
SELECT DISTINCT city, province
FROM clients 
ORDER BY province, city;

-- Q3. Product number and name 
SELECT product_number, product_name
FROM products;

-- Q4. Order columns with alias 
SELECT order_number, order_date AS created_date, delivery_status, order_status
FROM sales_orders;

-- Q5. Concatenated client full name 
SELECT client_number, CONCAT(first_name, ' ', middle_name, ' ', last_name) AS client_full_name
FROM clients;

-- Q6. Concatenated salesman contact 
SELECT salesman_number, CONCAT(first_name, ' ', middle_name, ' ', last_name, ' - ', phone) AS salesman_contact
FROM salesmen;

-- Q7. Profit per unit calculation 
SELECT product_number, product_name, sale_price, cost_price, (sale_price - cost_price) AS profit_per_unit
FROM products;

-- Q8. Stock value calculation 
SELECT product_number, product_name, quantity_on_hand, sale_price, (quantity_on_hand * sale_price) AS stock_value
FROM products;

-- Q9. Total transaction value 
SELECT client_number, amount_paid, amount_due, (amount_paid + amount_due) AS total_transaction_value
FROM clients;

-- Q10. Delivery days calculation 
SELECT order_number, order_date, delivery_date, DATEDIFF(delivery_date, order_date) AS delivery_days
FROM sales_orders;

-- Q11. Order lifecycle case expression 
SELECT order_number, order_status, 
  CASE 
    WHEN order_status IN ('Successful', 'Cancelled') THEN 'Closed'
    WHEN order_status = 'In Process' THEN 'Open'
  END AS order_lifecycle
FROM sales_orders;

-- Q12. Pricing result case expression 
SELECT product_number, product_name, cost_price, sale_price, 
  CASE 
    WHEN sale_price < cost_price THEN 'Loss'
    WHEN sale_price = cost_price THEN 'Break-even'
    ELSE 'Profit'
  END AS pricing_result
FROM products;

-- B. WHERE practice 

-- Q13. Filter clients by province (IN) 
SELECT * FROM clients
WHERE province IN ('Hanoi', 'Lam Dong');

-- Q14. Filter products by price limits 
SELECT * FROM products
WHERE sale_price > 100 AND cost_price < 1000;

-- Q15. Filter products price NOT BETWEEN 
SELECT * FROM products
WHERE sale_price NOT BETWEEN 50 AND 500;   

-- Q16. Filter clients by province and amount_due 
SELECT * FROM clients
WHERE province = 'Ho Chi Minh City' AND amount_due > 3000;   
								
-- Q17. Filter clients by name prefix (LIKE) 
SELECT * FROM clients
WHERE last_name LIKE 'P%' OR first_name LIKE 'N%';  

-- Q18. Salesmen exceeding target 
SELECT * FROM salesmen
WHERE target_achieved > sales_target;  

-- Q19. Salesmen location and salary filter 
SELECT * FROM salesmen
WHERE province != 'Ho Chi Minh City' AND salary >= 20000;  

-- Q20. In-process orders without delivery date 
SELECT * FROM sales_orders
WHERE delivery_date IS NULL AND order_status = 'In Process';  

-- Q21. Delivered orders with valid delivery date 
SELECT * FROM sales_orders
WHERE delivery_status = 'Delivered' AND delivery_date IS NOT NULL;  

-- Q22. Orders within specific date range 
SELECT * FROM sales_orders
WHERE order_date BETWEEN '2022-04-01' AND '2022-05-31';

-- Q23. Cancelled or On Way orders 
SELECT * FROM sales_orders
WHERE (order_status = 'Cancelled' OR delivery_status = 'On Way');

-- Q24. Products by name pattern and stock 
SELECT * FROM products
WHERE product_name LIKE '%o%' AND quantity_on_hand > quantity_sold;

-- Q25. Clients in specific HCMC wards 
SELECT * FROM clients
WHERE province = 'Ho Chi Minh City' AND city IN ('Di An Ward', 'Thu Duc Ward', 'Binh Thanh Ward');

-- C. Cartesian product and JOIN practice 

-- Q26. Cartesian product limited to 20 rows 
SELECT clients.client_number, salesmen.salesman_number, clients.city AS client_city, salesmen.city AS salesman_city
FROM clients, salesmen
LIMIT 20;

-- Q27. Cartesian product with matching city 
SELECT clients.client_number, salesmen.salesman_number, clients.city AS client_city, salesmen.city AS salesman_city
FROM clients, salesmen
WHERE clients.city = salesmen.city;

-- Q28. Explanation for Q26 and Q27 
-- Answer: Q26 lacks a join condition resulting in a Cartesian product (all possible combinations), while Q27 filters meaningful pairs using a WHERE condition on the city column.

-- Q29. Old-style join for orders and clients 
SELECT sales_orders.order_number, sales_orders.order_date, sales_orders.client_number, 
       CONCAT(clients.first_name, ' ', clients.middle_name, ' ', clients.last_name) AS client_full_name
FROM sales_orders, clients
WHERE sales_orders.client_number = clients.client_number;

-- Q30. INNER JOIN for orders and clients 
SELECT sales_orders.order_number, sales_orders.order_date, sales_orders.client_number, 
       CONCAT(clients.first_name, ' ', clients.middle_name, ' ', clients.last_name) AS client_full_name
FROM sales_orders
INNER JOIN clients ON sales_orders.client_number = clients.client_number;

-- Q31. Old-style join for orders and salesmen 
SELECT sales_orders.order_number, sales_orders.order_date, sales_orders.salesman_number, 
       CONCAT(salesmen.first_name, ' ', salesmen.middle_name, ' ', salesmen.last_name) AS salesman_full_name
FROM sales_orders, salesmen
WHERE sales_orders.salesman_number = salesmen.salesman_number;

-- Q32. INNER JOIN for orders and salesmen 
SELECT sales_orders.order_number, sales_orders.order_date, sales_orders.salesman_number, 
       CONCAT(salesmen.first_name, ' ', salesmen.middle_name, ' ', salesmen.last_name) AS salesman_full_name
FROM sales_orders
INNER JOIN salesmen ON sales_orders.salesman_number = salesmen.salesman_number;

-- Q33. INNER JOIN for order details and products 
SELECT sales_order_details.order_number, sales_order_details.product_number, products.product_name, 
       sales_order_details.order_quantity, products.sale_price
FROM sales_order_details
INNER JOIN products ON sales_order_details.product_number = products.product_number;

-- Q34. INNER JOIN with line total calculation 
SELECT sales_order_details.order_number, products.product_name, sales_order_details.order_quantity, 
       products.sale_price, (sales_order_details.order_quantity * products.sale_price) AS line_total
FROM sales_order_details
INNER JOIN products ON sales_order_details.product_number = products.product_number;
	
-- Q35. INNER JOIN across orders, clients, and salesmen 
SELECT sales_orders.order_number, sales_orders.order_date, 
       CONCAT(clients.first_name, ' ', clients.middle_name, ' ', clients.last_name) AS client_full_name, 
       CONCAT(salesmen.first_name, ' ', salesmen.middle_name, ' ', salesmen.last_name) AS salesman_full_name, 
       sales_orders.delivery_status, sales_orders.order_status
FROM sales_orders
INNER JOIN clients ON sales_orders.client_number = clients.client_number
INNER JOIN salesmen ON sales_orders.salesman_number = salesmen.salesman_number;


-- ==============================================================================
-- 6. Problem 2. Human Resources Management Database [cite: 1]
-- ==============================================================================
USE human_resources_management;

-- D. SELECT-list practice 

-- Q36. Distinct department ID 
SELECT DISTINCT department_id AS employee_department_id
FROM employees;

-- Q37. Distinct employee gender 
SELECT DISTINCT gender AS employee_gender
FROM employees;

-- Q38. Select limited employee columns 
SELECT employee_id, first_name, last_name, department_id
FROM employees;

-- Q39. Project location with alias 
SELECT project_id, project_name, project_address AS project_location
FROM projects;

-- Q40. Concatenated employee full name 
SELECT employee_id, CONCAT(last_name, ' ', middle_name, ' ', first_name) AS employee_full_name
FROM employees;

-- Q41. Concatenated employee profile string 
SELECT employee_id, CONCAT(last_name, ' ', middle_name, ' ', first_name, ' - ', gender, ' - ', department_id) AS employee_profile
FROM employees;

-- Q42. Age calculation in years 
SELECT employee_id, date_of_birth, TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) AS age_in_years
FROM employees;

-- Q43. Monthly insurance estimate 
SELECT employee_id, salary, (salary * 0.105) AS estimated_insurance
FROM employees;

-- Q44. Project type label case expression 
SELECT project_id, project_name, department_id,
  CASE 
    WHEN department_id = 3 THEN 'IT Project'
    WHEN department_id = 2 THEN 'HR Project'
    ELSE 'Other Project'
  END AS project_type_label
FROM projects;

-- Q45. Assignment level case expression 
SELECT employee_id, project_id, working_hours,
  CASE 
    WHEN working_hours >= 15 THEN 'Heavy'
    WHEN working_hours >= 10 THEN 'Medium'
    ELSE 'Light'
  END AS assignment_level
FROM assignments;

-- E. WHERE practice 

-- Q46. Filter female employees by salary 
SELECT * FROM employees
WHERE gender = 'Female' AND salary > 22000;

-- Q47. Filter employees by salary range 
SELECT * FROM employees
WHERE salary BETWEEN 20000 AND 30000;

-- Q48. Employees without a manager 
SELECT * FROM employees
WHERE manager_id IS NULL;

-- Q49. Employees with manager in IT department 
SELECT * FROM employees
WHERE manager_id IS NOT NULL AND department_id = 3;

-- Q50. Employees located in HCMC 
SELECT * FROM employees
WHERE address LIKE '%Ho Chi Minh City%';

-- Q51. Filter employees by name prefix 
SELECT * FROM employees
WHERE first_name LIKE 'A%' OR last_name LIKE 'N%'; 

-- Q52. Filter employees by departments and salary 
SELECT * FROM employees
WHERE department_id IN (2, 3, 4) AND salary >= 21000;

-- Q53. Departments with manager started after date 
SELECT * FROM departments
WHERE manager_id IS NOT NULL AND manager_start_date > '2021-02-01';

-- Q54. Projects containing System or Portal 
SELECT * FROM projects
WHERE project_name LIKE '%System%' OR project_name LIKE '%Portal%';

-- Q55. Projects not in Hanoi 
SELECT * FROM projects
WHERE project_address NOT LIKE '%Hanoi%';

-- Q56. Assignments by working hours range 
SELECT * FROM assignments
WHERE working_hours > 12 AND working_hours <= 20;

-- Q57. Relatives filtering by relationship and birth date 
SELECT * FROM relatives
WHERE relationship IN ('Son', 'Daughter') AND date_of_birth > '2012-01-01';

-- Q58. Employees filtering with complex conditions 
SELECT * FROM employees
WHERE ((department_id = 3 AND salary > 20000) OR manager_id = 'E01');

-- F. Cartesian product and JOIN practice 

-- Q59. Cartesian product limited to 20 rows 
SELECT employees.employee_id, 
       CONCAT(employees.last_name, ' ', employees.middle_name, ' ', employees.first_name) AS employee_full_name, 
       employees.department_id, departments.department_name
FROM employees, departments
LIMIT 20;

-- Q60. Cartesian product with matching department 
SELECT employees.employee_id, 
       CONCAT(employees.last_name, ' ', employees.middle_name, ' ', employees.first_name) AS employee_full_name, 
       employees.department_id, departments.department_name
FROM employees, departments
WHERE employees.department_id = departments.department_id;

-- Q61. Explanation for Q59 and Q60 
-- Answer: Q59 returns a Cartesian product of all rows, whereas Q60 uses a WHERE clause to properly link rows based on the department_id foreign key relationship.

-- Q62. Old-style join for employees and departments 
SELECT employees.employee_id, 
       CONCAT(employees.last_name, ' ', employees.middle_name, ' ', employees.first_name) AS employee_full_name, 
       employees.department_id, departments.department_name
FROM employees, departments
WHERE employees.department_id = departments.department_id;

-- Q63. INNER JOIN for employees and departments 
SELECT employees.employee_id, 
       CONCAT(employees.last_name, ' ', employees.middle_name, ' ', employees.first_name) AS employee_full_name, 
       employees.department_id, departments.department_name
FROM employees
INNER JOIN departments ON employees.department_id = departments.department_id;

-- Q64. INNER JOIN for projects and departments 
SELECT projects.project_id, projects.project_name, projects.department_id, departments.department_name
FROM projects
INNER JOIN departments ON projects.department_id = departments.department_id;

-- Q65. INNER JOIN across assignments, employees, and projects 
SELECT assignments.employee_id, 
       CONCAT(employees.last_name, ' ', employees.middle_name, ' ', employees.first_name) AS employee_full_name, 
       assignments.project_id, projects.project_name, assignments.working_hours
FROM assignments
INNER JOIN employees ON assignments.employee_id = employees.employee_id
INNER JOIN projects ON assignments.project_id = projects.project_id;

-- Q66. INNER JOIN for relatives and employees 
SELECT relatives.employee_id, 
       CONCAT(employees.last_name, ' ', employees.middle_name, ' ', employees.first_name) AS employee_full_name, 
       relatives.relative_name, relatives.gender, relatives.relationship
FROM relatives
INNER JOIN employees ON relatives.employee_id = employees.employee_id;

-- Q67. Self join for employees and managers 
SELECT e.employee_id, 
       CONCAT(e.last_name, ' ', e.middle_name, ' ', e.first_name) AS employee_full_name, 
       e.manager_id, 
       CONCAT(m.last_name, ' ', m.middle_name, ' ', m.first_name) AS manager_full_name
FROM employees e
INNER JOIN employees m ON e.manager_id = m.employee_id;

-- Q68. INNER JOIN for departments and managers 
SELECT departments.department_id, departments.department_name, departments.manager_id, 
       CONCAT(employees.last_name, ' ', employees.middle_name, ' ', employees.first_name) AS manager_full_name
FROM departments
INNER JOIN employees ON departments.manager_id = employees.employee_id;

-- Q69. INNER JOIN for departments and addresses 
SELECT departments.department_id, departments.department_name, department_addresses.address
FROM departments
INNER JOIN department_addresses ON departments.department_id = department_addresses.department_id;

-- Q70. INNER JOIN across employees, assignments, and projects 
SELECT CONCAT(employees.last_name, ' ', employees.middle_name, ' ', employees.first_name) AS employee_full_name, 
       projects.project_name, assignments.working_hours, projects.project_address
FROM employees
INNER JOIN assignments ON employees.employee_id = assignments.employee_id
INNER JOIN projects ON assignments.project_id = projects.project_id;