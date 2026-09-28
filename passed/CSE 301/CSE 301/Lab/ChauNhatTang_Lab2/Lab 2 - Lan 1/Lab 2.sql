use lab2;

SELECT * FROM lab2.employees;

alter table employees
add constraint fk 
foreign key (managerID)
references employees (employeeID); 

alter table employees
add constraint fk1 
foreign key (departmentID)
references department (departmentID); 

SELECT * FROM lab2.department;

alter table department
add constraint fk2
foreign key (managerID)
references employees (employeeID); 

SELECT * FROM lab2.assignment;
insert into assignment (employeeID, projectID, workingHour) values
(123, 1, 22.5),
(123, 2, 7.5),
(123, 3, 10), 
(333, 10, 10), 
(333, 20, 10),
(453, 1, 20),
(453, 2, 20),
(666, 3, 40),
(888, 20, 0), 
(987, 20, 15);

alter table assignment
add constraint fk5
foreign key (employeeID)
references employees (employeeID); 

alter table assignment
add constraint fk6
foreign key (projectID)
references project (projectID); 

SELECT * FROM lab2.project;
insert into project (projectID, projectName, projectAddress, departmentID) values
(1, 'San pham X', 'VUNG TAU', 5),
(2, 'San pham Y', 'NHA TRANG', 5),
(3, 'San pham Z', 'TP HCM', 5),
(10, 'Tin hoc hoa', 'HA NOI', 4),
(20, 'Cap Quang', 'TP HCM', 1),
(30, 'Dao tao', 'HA NOI', 4);

alter table project
add constraint fk4
foreign key (departmentID)
references department (departmentID); 

SELECT * FROM lab2.relative;
insert into relative (employeeID, relativeName, gender, dateOfBirth, relationship) values
(123, 'Chau', 'Nu', '1978-12-31', 'Con gai'),
(123, 'Duy', 'Nam', '1978-01-01', 'Con trai'),
(123, 'Phuong', 'Nu', '1957-05-05', 'Vo chong'),
(333, 'Duong', 'Nu', '1948-05-03', 'Vo chong'),
(333, 'Tung', 'Nam', '1973-10-25', 'Con trai'),
(333, 'Quang', 'Nu', '1976-04-05', 'Con gai'),
(987, 'Dang', 'Nam', '1932-02-29', 'Vo chong');

alter table relative
add constraint fk7
foreign key (employeeID)
references employees (employeeID); 

SELECT * FROM lab2.departmentaddress;

alter table project add column startingDate DATE; 

alter table project modify column startingDate YEAR;

alter table project drop column startingDate; 

alter table employees modify column gender VARCHAR(3);

alter table relative modify column gender VARCHAR(3);

alter table employees 
add constraint check_gender CHECK (gender IN ('Nam', 'Nu')); 

alter table relative 
add constraint check_gender_relative CHECK (gender IN ('Nam', 'Nu')); 

alter table employees
add constraint checkDateOfBirthEmployee Check (dateOfBirth < '2025-07-14');

use lab2;

SELECT * FROM lab2.employees;

alter table employees
add constraint fk 
foreign key (managerID)
references employees (employeeID); 

alter table employees
add constraint fk1 
foreign key (departmentID)
references department (departmentID); 

SELECT * FROM lab2.department;

alter table department
add constraint fk2
foreign key (managerID)
references employees (employeeID); 

SELECT * FROM lab2.assignment;
insert into assignment (employeeID, projectID, workingHour) values
(123, 1, 22.5),
(123, 2, 7.5),
(123, 3, 10), 
(333, 10, 10), 
(333, 20, 10),
(453, 1, 20),
(453, 2, 20),
(666, 3, 40),
(888, 20, 0), 
(987, 20, 15);

alter table assignment
add constraint fk5
foreign key (employeeID)
references employees (employeeID); 

alter table assignment
add constraint fk6
foreign key (projectID)
references project (projectID); 

SELECT * FROM lab2.project;
insert into project (projectID, projectName, projectAddress, departmentID) values
(1, 'San pham X', 'VUNG TAU', 5),
(2, 'San pham Y', 'NHA TRANG', 5),
(3, 'San pham Z', 'TP HCM', 5),
(10, 'Tin hoc hoa', 'HA NOI', 4),
(20, 'Cap Quang', 'TP HCM', 1),
(30, 'Dao tao', 'HA NOI', 4);

alter table project
add constraint fk4
foreign key (departmentID)
references department (departmentID); 

SELECT * FROM lab2.relative;
insert into relative (employeeID, relativeName, gender, dateOfBirth, relationship) values
(123, 'Chau', 'Nu', '1978-12-31', 'Con gai'),
(123, 'Duy', 'Nam', '1978-01-01', 'Con trai'),
(123, 'Phuong', 'Nu', '1957-05-05', 'Vo chong'),
(333, 'Duong', 'Nu', '1948-05-03', 'Vo chong'),
(333, 'Tung', 'Nam', '1973-10-25', 'Con trai'),
(333, 'Quang', 'Nu', '1976-04-05', 'Con gai'),
(987, 'Dang', 'Nam', '1932-02-29', 'Vo chong');

alter table relative
add constraint fk7
foreign key (employeeID)
references employees (employeeID); 

SELECT * FROM lab2.departmentaddress;

alter table project add column startingDate DATE; 

alter table project modify column startingDate YEAR;

alter table project drop column startingDate; 

alter table employees modify column gender VARCHAR(3);

alter table relative modify column gender VARCHAR(3);

alter table employees 
add constraint check_gender CHECK (gender IN ('Nam', 'Nu')); 

alter table relative 
add constraint check_gender_relative CHECK (gender IN ('Nam', 'Nu')); 

alter table employees
add constraint checkDateOfBirthEmployee Check (dateOfBirth < '2025-07-14');

alter table department 
add constraint uniqueIdDepartment UNIQUE(departmentID);

create database managementproject;

