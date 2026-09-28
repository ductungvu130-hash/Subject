CREATE DATABASE HRManagement;
USE HRManagement;

CREATE TABLE employees(
	employeeID VARCHAR(3),
    lastName VARCHAR(20) NOT NULL,
    middleName VARCHAR(20),
    firstName VARCHAR(20) NOT NULL,
    date0fBirth Date NOT NULL,
    gender VARCHAR(5) NOT NULL,
	salary DECIMAL(15,4) NOT NULL,
    address VARCHAR(100) NOT NULL,
    managerID VARCHAR(3),
    departmentID INT,
    PRIMARY KEY(employeeID)
    
    -- Đặt tên cho key
    -- CONSTRAINT pk_ten PRIMARY KEY(employeeID),
    -- CONSTRAINT fk_tenbang_tenbang FOREIGN KEY(managerID) REFERENCES employees(employeeID),
    -- CONSTRAINT chk_wkh CHECK (workingHour > 0);
);
ALTER TABLE employees
ADD FOREIGN KEY (managerID) REFERENCES employees(employeeID);
ALTER TABLE employees
ADD FOREIGN KEY (departmentID) REFERENCES department(departmentID);

INSERT INTO employees
VALUES 
('123','Dinh','Ba','Tien','1995-1-9','Nam',30000,'731 Tran Hung Dao Q1 TPHCM','333',5),
('333','Nguyen','Thanh','Tung','1945-12-8','Nam',40000,'638 Nguyen Van Cu TPHCM','888',5),
('453','Tran','Thanh','Tam','1995-7-31','Name',30000,'731 Tran Hung Dao Q1 TPHCM','333',5),
('666','Nguyen','Manh','Hung','1952-9-15','Nam',38000, '975 Le Lai P3 Vung Tau','333',5),
('777','Tran','Hong','Quang','1959-3-29','Nam',25000, '980 Le Hong Phong Vung Tau','987',4),
('888','Vuong','Ngoc','Quyen','1927-10-10','Nu',55000, '450 Trung Vuong My Tho TG',NULL,1),
('987','Le','Thi','Nhan','1931-6-20','Nu', 43000,'291 Ho Van Hue Q.PN TPHCM','888',4),
('999','Bui','Thuy','Vu','1958-7-19','Nam', 25000,'332 Nguyen Thai Hoc Quy Nhon','987',4);

CREATE TABLE department(
	departmentID INT PRIMARY KEY,
    departmentName VARCHAR(10) NOT NULL,
    managerID VARCHAR(3),
    date0fEmployment DATE NOT NULL
);

INSERT INTO department
VALUES 
(1,'Quan ly','888','1971-6-19'),
(4,'Dieu hanh','987','1985-1-1'),
(5,'Nghien cuu','333','1978-5-22');

ALTER TABLE department
ADD FOREIGN KEY (managerID) REFERENCES employees(employeeID);

CREATE TABLE departmentaddress(
	departmentID INT,
    address VARCHAR(30),
    PRIMARY KEY(departmentID, address)
);

INSERT INTO departmentaddress
VALUES 
(1,'TP HCM'),
(4,'HA NOI'),
(5,'NHA TRANG'),
(5,'TP HCM'),
(5,'VUNG TAU');

ALTER TABLE departmentaddress
ADD FOREIGN KEY (departmentID) REFERENCES department(departmentID);

CREATE TABLE projects(
	projectID INT PRIMARY KEY,
    projectName VARCHAR(30) NOT NULL,
    projectAddress VARCHAR(100) NOT NULL,
    departmentID INT
);

INSERT INTO projects
VALUES 
(1,'San pham X','VUNG TAU',5),
(2,'San pham Y','NHA TRANG',5),
(3,'San pham Z','TP HCM',5),
(10,'Tin hoc hoa','HA NOI',4),
(20,'Cap Quang','TP HCM',1),
(30,'Dao tao','HA NOI',4);

ALTER TABLE projects
ADD FOREIGN KEY (departmentID) REFERENCES department(departmentID);

CREATE TABLE assignment(
	employeeID VARCHAR(3),
    projectID INT,
    workingHour FLOAT NOT NULL,
    PRIMARY KEY(employeeID, projectID)
);

INSERT INTO assignment
VALUES 
('123',1,'22.5'),
('123',2,'7.5'),
('123',3,'10'),
('333',10,'10'),
('333',20,'10'),
('453',1,'20'),
('453',2,'20'),
('666',3,'40'),
('888',20,'0'),
('987',20,'15');

ALTER TABLE assignment
ADD FOREIGN KEY (employeeID) REFERENCES employees(employeeID),
ADD FOREIGN KEY (projectID) REFERENCES projects(projectID);

CREATE TABLE relative(
	employeeID VARCHAR(3),
    relativeName VARCHAR(50),
    gender VARCHAR(5) NOT NULL,
    date0fBirth Date,
    relationship VARCHAR(30) NOT NULL,
    PRIMARY KEY(employeeID, relativeName)
);

INSERT INTO relative
VALUES 
('123','Chau','Nu','1978-12-31','Con gai'),
('123','Duy','Nam','1978-1-1','Con trai'),
('123','Phuong','Nu','1957-5-5','Vo chong'),
('333','Duong','Nu','1948-5-3','Vo chong'),
('333','Quang','Nu','1976-4-5','Con gai'),
('333','Tung','Nam','1973-10-25','Con trai'),
('987','Dang','Nam','1932-2-29','Vo chong');

ALTER TABLE relative
ADD FOREIGN KEY (employeeID) REFERENCES employees(employeeID);

DESCRIBE employees;
DESCRIBE department;
DESCRIBE departmentaddress;
DESCRIBE assignment;
DESCRIBE projects;
DESCRIBE relative;

SELECT * from employees;
SELECT * from department;
SELECT * from departmentaddress;
SELECT * from assignment;
SELECT * from projects;
SELECT * from relative;