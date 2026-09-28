-- 1. Create a new MySQL Database call “assignment2”.
drop database if exists assignment2;
create database assignment2;
use assignment2;

-- 2. Create all of tables in Database with attribute and conditions about data type and constraints (primary key, null, not null) in descriptive above.
drop table if exists employees;
CREATE TABLE `employees` (
  `employeeID` VARCHAR(3) NOT NULL,
  `lastName` VARCHAR(20) NOT NULL,
  `middleName` VARCHAR(20) NULL,
  `firstName` VARCHAR(20) NOT NULL,
  `dateOfBirth` DATE NOT NULL,
  `gender` VARCHAR(5) NOT NULL,
  `salary` DECIMAL NOT NULL,
  `address` VARCHAR(100) NULL,
  `managerID` VARCHAR(3) NULL,
  `departmentID` INT NOT NULL,
  PRIMARY KEY (`employeeID`)
  );

create table department (
	departmentID int not null,
    departmentName varchar(10) not null,
    managerID varchar(3) null,
    dateOfEmployment date not null,
    primary key (departmentID)
);

create table departmentaddress (
	departmentID int not null,
    address varchar(30) not null
);

create table projects (
	projectID int not null,
    projectName varchar(30) not null,
    projectAddress varchar(100) not null,
    departmentID int not null,
    primary key (projectID)
);

create table assignment (
	employeeID varchar(3) not null, 
    projectID int not null, 
    workingHour float not null
);

create table relative (
	employeeID varchar(3) not null,
    relativeName varchar(50) not null,
    gender varchar(5) not null,
    dateOfBirth date null,
    relationship varchar(30) not null
);

-- 3. Insert new records of attributes in all of table.
INSERT INTO employees (employeeID, firstName, middleName, lastName, dateOfBirth, gender, salary, address, managerID, departmentID) VALUES
('123', 'Tien', 'Ba', 'Dinh', '1955-09-01', 'Nam', 30000, '731 Tran Hung Dao, Q1, TPHCM', '333', 5),
('333', 'Tung', 'Thanh', 'Nguyen', '1945-08-12', 'Nam', 40000, '638 Nguyen Van Cu, Q5, TPHCM', '888', 5),
('453', 'Tam', 'Thanh', 'Tran', '1962-07-31', 'Nam', 25000, '543 Mai Thi Luu, Ba Dinh, Ha Noi', '333', 5),
('666', 'Hung', 'Manh', 'Nguyen', '1952-09-15', 'Nam', 38000, '975 Le Lai, P3, Vung Tau', '333', 5),
('888', 'Quyen', 'Ngoc', 'Vuong', '1927-10-10', 'Nu', 55000, '450 Trung Vuong, My Tho, TG', NULL, 1),
('987', 'Nhan', 'Thi', 'Le', '1931-06-20', 'Nu', 43000, '291 Ho Van Hue, Q.PN, TPHCM', '888', 4),
('777', 'Quang', 'Hong', 'Tran', '1959-03-29', 'Nam', 25000, '980 Le Hong Phong, Vung Tau', '987', 4),
('999', 'Vu', 'Thuy', 'Bui', '1958-07-19', 'Nam', 25000, '332 Nguyen Thai Hoc, Quy Nhon', '987', 4);

INSERT INTO DEPARTMENT (departmentID, departmentName, managerID, dateOfEmployment) VALUES
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

INSERT INTO RELATIVE (employeeID, relativeName, gender, dateOfBirth, relationship) VALUES
(123, 'Chau', 'Nu', '1978-12-31', 'Con gai'),
(123, 'Duy Nam', 'Nam', '1978-01-01', 'Con trai'),
(123, 'Phuong', 'Nu', '1957-05-05', 'Vo chong'),
(333, 'Duong', 'Nu', '1948-05-03', 'Vo chong'),
(333, 'Tung', 'Nam', '1973-10-25', 'Con trai'),
(333, 'Quang', 'Nu', '1976-04-05', 'Con gai'),
(987, 'Dang', 'Nam', '1932-02-29', 'Vo chong');

-- 4. Create constraints (foreign key) in database according to descriptive above
alter table employees
add constraint employee_fk_managerID 
foreign key (managerID) references employees(employeeID); 

alter table employees 
add constraint employee_fk_dapartmentID 
foreign key (departmentID) references department(departmentID); 

alter table departmentaddress 
add constraint departmentaddress_fk_departmentID
foreign key (departmentID) references department(departmentID);

alter table projects 
add constraint project_fk_departmentID 
foreign key (departmentID) references department(departmentID);

alter table assignment 
add constraint assignment_fk_employeeID 
foreign key (employeeID) references employees(employeeID);

alter table assignment
add constraint assignment_fk_projectID 
foreign key (projectID) references projects(projectID);

alter table relative 
add constraint relative_fk_employeeID 
foreign key (employeeID) references employees(employeeID);

-- a) Find employees who work in room 4.
select * 
from employees 
where departmentID = 4; 

-- b) Find employees with salaries above 30000.
select * 
from employees 
where salary > 30000;

-- c) For each department, indicate the department name and room location.
select d.departmentID, d.departmentName, da.address 
from department d
join departmentaddress da using(departmentID);

-- d) The average salary of all female employees.
select avg(salary) average_salary 
from employees
where gender = 'Nu';

-- e) Find the names and addresses of all employees of the "Nghien Cuu" department
select d.departmentID, d.departmentName, da.address 
from department d
join departmentaddress da using(departmentID)
where d.departmentName = 'Nghien Cuu';