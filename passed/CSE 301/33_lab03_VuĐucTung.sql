
-- Q1: Create database
CREATE DATABASE IF NOT EXISTS sales_management;
USE sales_management;

-- Q2: Create tables
-- Q3: Define primary keys and foreign keys
-- Q4: Apply constraints

CREATE TABLE salesmen (
    salesman_number VARCHAR(15) PRIMARY KEY,
    first_name VARCHAR(15) NOT NULL,
    middle_name VARCHAR(15) NULL,
    last_name VARCHAR(15) NOT NULL,
    address VARCHAR(30) NULL,
    city VARCHAR(30) NULL,
    pincode VARCHAR(10) NULL,
    province VARCHAR(25) NULL,
    salary DECIMAL(15,4) DEFAULT 0,
    sales_target INT DEFAULT 0,
    target_achieved INT DEFAULT 0,
    phone VARCHAR(15) NULL,
    CONSTRAINT chk_salesman_salary CHECK (salary >= 0),
    CONSTRAINT chk_sales_target CHECK (sales_target >= 0),
    CONSTRAINT chk_target_achieved CHECK (target_achieved >= 0)
);

CREATE TABLE clients (
    client_number VARCHAR(10) PRIMARY KEY,
    first_name VARCHAR(15) NOT NULL,
    middle_name VARCHAR(15) NULL,
    last_name VARCHAR(15) NOT NULL,
    address VARCHAR(30) NULL,
    city VARCHAR(30) NULL,
    pincode VARCHAR(10) NULL,
    province VARCHAR(25) NULL,
    amount_paid DECIMAL(15,4) DEFAULT 0,
    amount_due DECIMAL(15,4) DEFAULT 0,
    CONSTRAINT chk_amount_paid CHECK (amount_paid >= 0),
    CONSTRAINT chk_amount_due CHECK (amount_due >= 0)
);

CREATE TABLE products (
    product_number VARCHAR(15) PRIMARY KEY,
    product_name VARCHAR(25) NOT NULL,
    quantity_on_hand INT DEFAULT 0,
    quantity_sold INT DEFAULT 0,
    sale_price DECIMAL(15,4) DEFAULT 0,
    cost_price DECIMAL(15,4) DEFAULT 0,
    CONSTRAINT chk_qty_on_hand CHECK (quantity_on_hand >= 0),
    CONSTRAINT chk_qty_sold CHECK (quantity_sold >= 0),
    CONSTRAINT chk_sale_price CHECK (sale_price >= 0),
    CONSTRAINT chk_cost_price CHECK (cost_price >= 0)
);

CREATE TABLE sales_orders (
    order_number VARCHAR(15) PRIMARY KEY,
    order_date DATE NOT NULL,
    client_number VARCHAR(10),
    salesman_number VARCHAR(15),
    delivery_status ENUM('Pending', 'In Transit', 'Delivered', 'Cancelled') DEFAULT 'Pending',
    delivery_date DATE NULL,
    order_status ENUM('In Process', 'Completed', 'Cancelled') DEFAULT 'In Process',
    CONSTRAINT fk_so_client FOREIGN KEY (client_number) REFERENCES clients(client_number),
    CONSTRAINT fk_so_salesman FOREIGN KEY (salesman_number) REFERENCES salesmen(salesman_number)
);

CREATE TABLE sales_order_details (
    order_number VARCHAR(15),
    product_number VARCHAR(15),
    order_quantity INT DEFAULT 1,
    PRIMARY KEY (order_number, product_number),
    CONSTRAINT fk_sod_order FOREIGN KEY (order_number) REFERENCES sales_orders(order_number),
    CONSTRAINT fk_sod_product FOREIGN KEY (product_number) REFERENCES products(product_number),
    CONSTRAINT chk_order_quantity CHECK (order_quantity > 0)
);

-- 1.3 ALTER TABLE Practice Tasks

-- Create a table named product_cost to store product cost information
CREATE TABLE product_cost (
    product_cost_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(25) NOT NULL UNIQUE,
    buying_price DECIMAL(15,4) NOT NULL,
    CONSTRAINT chk_buying_price CHECK (buying_price > 0)
);

-- Enforce stricter validity for price-related attributes in products
ALTER TABLE products
MODIFY cost_price DECIMAL(15,4) NOT NULL,
MODIFY sale_price DECIMAL(15,4) NOT NULL,
ADD CONSTRAINT chk_strict_cost_price CHECK (cost_price > 0),
ADD CONSTRAINT chk_strict_sale_price CHECK (sale_price > 0);

-- Add a remarks column to salesmen
ALTER TABLE salesmen
ADD remarks VARCHAR(10),
ADD CONSTRAINT chk_remarks CHECK (remarks IN ('Good', 'Average', 'Poor'));

-- Normalize salesman remarks by creating a reference table
CREATE TABLE remark_levels (
    remark_id INT AUTO_INCREMENT PRIMARY KEY,
    remark_name VARCHAR(10) NOT NULL UNIQUE
);

INSERT INTO remark_levels (remark_name) VALUES ('Good'), ('Average'), ('Poor');

ALTER TABLE salesmen 
DROP CONSTRAINT chk_remarks,
DROP COLUMN remarks;

ALTER TABLE salesmen
ADD remark_id INT,
ADD CONSTRAINT fk_salesman_remark FOREIGN KEY (remark_id) REFERENCES remark_levels(remark_id);

-- Add total_quantity to products
ALTER TABLE products
ADD total_quantity INT DEFAULT 0,
ADD CONSTRAINT chk_total_quantity CHECK (total_quantity >= 0);

-- Add discount_rate to products
ALTER TABLE products
ADD discount_rate INT DEFAULT 0,
ADD CONSTRAINT chk_discount_rate CHECK (discount_rate IN (0, 3, 5, 10));

-- Q5: Verify tables (Problem 1)
DESCRIBE salesmen;
DESCRIBE clients;
DESCRIBE products;
DESCRIBE sales_orders;
DESCRIBE sales_order_details;
SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA = 'sales_management';


-- PROBLEM 2: HUMAN RESOURCES MANAGEMENT DATABASE


-- Q1: Create database
CREATE DATABASE IF NOT EXISTS human_resources_management;
USE human_resources_management;

-- Q2: Create tables (Created without circular FKs initially)
CREATE TABLE employees (
    employee_id VARCHAR(3) PRIMARY KEY,
    last_name VARCHAR(20) NOT NULL,
    middle_name VARCHAR(20) NULL,
    first_name VARCHAR(20) NOT NULL,
    date_of_birth DATE NOT NULL,
    gender ENUM('Male', 'Female', 'Other') NOT NULL,
    salary DECIMAL(15,4) NOT NULL,
    address VARCHAR(100) NOT NULL,
    manager_id VARCHAR(3) NULL,
    department_id INT
);

CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(50) NOT NULL UNIQUE,
    manager_id VARCHAR(3) NULL,
    manager_start_date DATE NOT NULL
);

CREATE TABLE department_addresses (
    department_id INT,
    address VARCHAR(100),
    PRIMARY KEY (department_id, address)
);

CREATE TABLE projects (
    project_id INT PRIMARY KEY,
    project_name VARCHAR(50) NOT NULL,
    project_address VARCHAR(100) NOT NULL,
    department_id INT
);

CREATE TABLE assignments (
    employee_id VARCHAR(3),
    project_id INT,
    working_hours DECIMAL(5,2) NOT NULL,
    PRIMARY KEY (employee_id, project_id)
);

CREATE TABLE relatives (
    employee_id VARCHAR(3),
    relative_name VARCHAR(50),
    gender ENUM('Male', 'Female', 'Other') NOT NULL,
    date_of_birth DATE NULL,
    relationship VARCHAR(30) NOT NULL,
    PRIMARY KEY (employee_id, relative_name)
);

-- Q3: Define primary keys and foreign keys (ALTER TABLE phase)
-- Q4: Apply constraints

-- Foreign keys and constraints for employees
ALTER TABLE employees
ADD CONSTRAINT fk_emp_manager FOREIGN KEY (manager_id) REFERENCES employees(employee_id),
ADD CONSTRAINT fk_emp_department FOREIGN KEY (department_id) REFERENCES departments(department_id),
ADD CONSTRAINT chk_emp_salary CHECK (salary >= 0),
ADD CONSTRAINT chk_emp_gender CHECK (gender IN ('Male', 'Female', 'Other'));

-- Foreign keys for departments
ALTER TABLE departments
ADD CONSTRAINT fk_dept_manager FOREIGN KEY (manager_id) REFERENCES employees(employee_id);

-- Foreign keys for department_addresses
ALTER TABLE department_addresses
ADD CONSTRAINT fk_dept_addr_dept FOREIGN KEY (department_id) REFERENCES departments(department_id);

-- Foreign keys for projects
ALTER TABLE projects
ADD CONSTRAINT fk_proj_department FOREIGN KEY (department_id) REFERENCES departments(department_id);

-- Foreign keys and constraints for assignments
ALTER TABLE assignments
ADD CONSTRAINT fk_assign_employee FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
ADD CONSTRAINT fk_assign_project FOREIGN KEY (project_id) REFERENCES projects(project_id),
ADD CONSTRAINT chk_assign_hours CHECK (working_hours >= 0);

-- Foreign keys for relatives
ALTER TABLE relatives
ADD CONSTRAINT fk_rel_employee FOREIGN KEY (employee_id) REFERENCES employees(employee_id);

-- Q5: Verify tables (Problem 2)
DESCRIBE employees;
DESCRIBE departments;
DESCRIBE department_addresses;
DESCRIBE projects;
DESCRIBE assignments;
DESCRIBE relatives;
SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA = 'human_resources_management';