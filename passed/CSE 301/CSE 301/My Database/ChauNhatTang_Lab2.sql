CREATE database managementproject;
USE managementproject;

-- Tao bang EMPLOYEES
CREATE TABLE employees (
    employeeID VARCHAR(3) PRIMARY KEY NOT NULL,
    firstName VARCHAR(20) NOT NULL,
    middleName VARCHAR(20) NULL,
    lastName VARCHAR(20) NOT NULL,
    dateOfBirth DATE NOT NULL,
    gender VARCHAR(5) NOT NULL,
    salary DECIMAL(10,0) NOT NULL,
    address VARCHAR(100) NULL,
    managerID VARCHAR(3),
    departmentID INT NOT NULL
);

-- Tao bang DEPARTMENT
CREATE TABLE DEPARTMENT (
	departmentID INT PRIMARY KEY NOT NULL,
    departmentName VARCHAR(10) NOT NULL,
    date0fEmployment DATE NOT NULL,
    managerID VARCHAR(3) NULL
);

-- Tao bang DEPARTMENTADDRESS
CREATE TABLE DEPARTMENTADDRESS (
	departmentID INT NOT NULL,
    address VARCHAR(30) NOT NULL
);

-- Tao bang PROJECTS
CREATE TABLE PROJECTS (
	projectID INT PRIMARY KEY NOT NULL,
    projectName VARCHAR(30) NOT NULL,
    projectAddress VARCHAR(100) NOT NULL,
    departmentID INT NOT NULL
);

-- Tao bang ASSIGNMENT
CREATE TABLE ASSIGNMENT (
	employeeID VARCHAR(3) NOT NULL,
    projectID INT NOT NULL,
    workingHour FLOAT NOT NULL
);

-- Tao bang RELATIVE
CREATE TABLE RELATIVE (
	employeeID VARCHAR(3) NOT NULL,
    relativeName VARCHAR(50) NOT NULL,
    gender VARCHAR(5) NOT NULL,
    date0fBirth DATE NULL,
    relationship VARCHAR(30) NOT NULL
);

INSERT INTO employees (employeeID, firstName, middleName, lastName, dateOfBirth, gender, salary, address, managerID, departmentID) VALUES
('123', 'Tien', 'Ba', 'Dinh', '1955-09-01', 'Nam', 30000, '731 Tran Hung Dao, Q1, TPHCM', '333', 5),
('333', 'Tung', 'Thanh', 'Nguyen', '1945-08-12', 'Nam', 40000, '638 Nguyen Van Cu, Q5, TPHCM', '888', 5),
('453', 'Tam', 'Thanh', 'Tran', '1962-07-31', 'Nam', 25000, '543 Mai Thi Luu, Ba Dinh, Ha Noi', '333', 5),
('666', 'Hung', 'Manh', 'Nguyen', '1952-09-15', 'Nam', 38000, '975 Le Lai, P3, Vung Tau', '333', 5),
('888', 'Quyen', 'Ngoc', 'Vuong', '1927-10-10', 'Nu', 55000, '450 Trung Vuong, My Tho, TG', NULL, 1),
('987', 'Nhan', 'Thi', 'Le', '1931-06-20', 'Nu', 43000, '291 Ho Van Hue, Q.PN, TPHCM', '888', 4),
('777', 'Quang', 'Hong', 'Tran', '1959-03-29', 'Nam', 25000, '980 Le Hong Phong, Vung Tau', '987', 4),
('999', 'Vu', 'Thuy', 'Bui', '1958-07-19', 'Nam', 25000, '332 Nguyen Thai Hoc, Quy Nhon', '987', 4);

INSERT INTO DEPARTMENT (departmentID, departmentName, managerID, date0fEmployment) VALUES
(1, 'Quan ly', 888, '1971-06-19'),
(4, 'Dieu hanh', 777, '1985-01-01'),
(5, 'Nghien cuu', 333, '1978-05-22');

INSERT INTO DEPARTMENTADDRESS (departmentID, address) VALUES
(1, 'TP HCM'),
(4, 'HA NOI'),
(5, 'NHA TRANG'),
(5, 'TP HCM'),
(5, 'VUNG TAU');

INSERT INTO ASSIGNMENT (employeeID, projectID, workingHour) VALUES
('123', 1, 22.5),
('123', 2, 7.5),
('123', 3, 10),
('333', 10, 10),
('333', 20, 10),
('453', 1, 20),
('453', 2, 20),
('666', 3, 40),
('888', 20, 0),
('987', 20, 15);

INSERT INTO PROJECTS (projectID, projectName, projectAddress, departmentID) VALUES
(1, 'San pham X', 'VUNG TAU', 5),
(2, 'San pham Y', 'NHA TRANG', 5),
(3, 'San pham Z', 'TP HCM', 5),
(10, 'Tin hoc hoa', 'HA NOI', 4),
(20, 'Cap Quang', 'TP HCM', 1),
(30, 'Dao tao', 'HA NOI', 4);

INSERT INTO RELATIVE (employeeID, relativeName, gender, date0fBirth, relationship) VALUES
(123, 'Chau', 'Nu', '1978-12-31', 'Con gai'),
(123, 'Duy Nam', 'Nam', '1978-01-01', 'Con trai'),
(123, 'Phuong', 'Nu', '1957-05-05', 'Vo chong'),
(333, 'Duong', 'Nu', '1948-05-03', 'Vo chong'),
(333, 'Tung', 'Nam', '1973-10-25', 'Con trai'),
(333, 'Quang', 'Nu', '1976-04-05', 'Con gai'),
(987, 'Dang', 'Nam', '1932-02-29', 'Vo chong');

-- Tao khoa ngoai managerID cho employees
ALTER TABLE employees 
ADD CONSTRAINT fk_employees_manager
FOREIGN KEY (managerID) REFERENCES employees(employeeID);

-- Tao khoa ngoai DepartmentID tham chieu qua bang Department cho employees
ALTER TABLE employees 
ADD CONSTRAINT fk_employees_department
FOREIGN KEY (departmentID) REFERENCES department(departmentID);

-- Tao khoa ngoai departmentID cho DepartmentAddress
ALTER TABLE DEPARTMENTADDRESS
ADD CONSTRAINT fk_departmentaddress_department
FOREIGN KEY (departmentID) REFERENCES department(departmentID);

-- Tao khoa ngoai departmentID cho Project 
ALTER TABLE PROJECTS 
ADD CONSTRAINT fk_projects_department
FOREIGN KEY (departmentID) REFERENCES department(departmentID);

-- Tao khoa ngoai employeeID cho Assignment 
ALTER TABLE ASSIGNMENT
ADD CONSTRAINT fk_assignment_employee
FOREIGN KEY (employeeID) REFERENCES employees(employeeID);

 -- Tao khoa ngoai projectID cho assignment
 ALTER TABLE ASSIGNMENT 
 ADD CONSTRAINT fk_assignment_project 
 FOREIGN KEY (projectID) REFERENCES projects(projectID);
 
 -- Tao khoa ngoai employeeID cho relative
 ALTER TABLE RELATIVE
ADD CONSTRAINT fk_relative_employee
FOREIGN KEY (employeeID) REFERENCES employees(employeeID);

-- Add startingDate kieu Date vao Projects
ALTER TABLE PROJECTS 
ADD COLUMN startingDate DATE; 

-- Thay doi kieu Date cua startingDate thanh YEAR trong Projects
ALTER TABLE PROJECTS 
MODIFY COLUMN startingDate YEAR; 

-- Xoa cot startingDate trong Projects 
ALTER TABLE PROJECTS
DROP COLUMN startingDate;

-- thay doi kieu VARCHAR(3) Gender
ALTER TABLE EMPLOYEES 
MODIFY COLUMN gender VARCHAR(3);
ALTER TABLE RELATIVE 
MODIFY COLUMN gender VARCHAR(3);

-- Them Check Gender 
ALTER TABLE EMPLOYEES
ADD CONSTRAINT check_gender_employees
CHECK (gender in ('Nam', 'Nu')); 
ALTER TABLE RELATIVE 
ADD CONSTRAINT CHECK_GENDER_RELATIVE
CHECK (GENDER IN ('Nam', 'Nu'));

-- Them Check Date Of Birth
ALTER TABLE EMPLOYEES 
ADD CONSTRAINT CHECK_ĐATEOFBIRTH_EMPLOYEES
CHECK (DATEOFBIRTH < '2025-07-27');
ALTER TABLE RELATIVE 
ADD CONSTRAINT CHECK_DATEOFBIRTH_RELATIVE
CHECK (DATE0FBIRTH < '2025-07-27');

-- TThem Unique cho Department
ALTER TABLE DEPARTMENT 
ADD CONSTRAINT UNIQUE_DEPARTMENT_ID
UNIQUE (departmentID);

drop database managementproject;
