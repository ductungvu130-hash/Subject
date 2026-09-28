-- I. Writing Function Stored the following tables in a new database ‘Assignment3’
drop database if exists assignment3;
create database assignment3;
use assignment3;

create table Clients (
	Client_Number varchar(10),
    Client_Name varchar(25) not null,
    Address varchar(30), 
    City varchar(30),
    Pincode int not null,
    Province char(25),
    Amount_Paid decimal(15, 4),
    Amount_Due decimal(15, 4),
    
    primary key (Client_Number), 
    
    check (Client_Number like 'C%')
);

create table Product (
	Product_Number varchar(15), 
    Product_Name varchar(25) not null unique,
    Quantity_On_Hand int not null,
    Quantity_Sell int not null, 
    Sell_Price decimal(15, 4) not null, 
    Cost_Price decimal(15, 4) not null,
    
    primary key (Product_Number),
    
    check (Product_Number like 'P%'),
    check (Cost_Price <> 0)
);

create table Salesman (
	Salesman_Number varchar(15),
    Salesman_Name varchar(25) not null,
    Address varchar(30), 
    City VARCHAR(30), 
    Pincode int not null, 
    Province char(25) DEFAULT('Viet Nam'),
    Salary DECIMAL(15, 4) not null, 
    Sales_Target int not null, 
	Target_Achieved int,
    Phone char(10) not null unique,
    
    PRIMARY KEY (Salesman_Number),
    
    CHECK (Salesman_Number like 'S%'),
    check (Salary <> 0),
    check (Sales_Target <> 0)
);

create table SalesOrder (
	Order_Number varchar(15), 
    Order_Date date, 
    Order_Status varchar(15),
    Client_Number VARCHAR(15), 
    Salesman_Number varchar(15), 
    Delivery_Status char(15), 
    Delivery_Date date,
    
    PRIMARY KEY (Order_Number), 
    FOREIGN KEY (Client_Number) REFERENCES clients(Client_Number), 
    FOREIGN KEY (Salesman_Number) REFERENCES salesman(Salesman_Number),
    
    CHECK (Order_Number like 'O%'),
    check (Client_Number like 'C%'), 
    check (Salesman_Number like 'S%'), 
    check (Delivery_Date > Order_Date), 
    check (Delivery_Status in ('Delivered', 'On Way', 'Ready to Ship')),
    check (Order_Status in ('In Process', 'Successful', 'Cancelled'))
);

create table SalesOrderDetails (
	Order_Number varchar(15),
    Product_Number varchar(15),
    Order_Quantity int, 
    Discount_Rate int, 
    
    FOREIGN KEY (Order_Number) REFERENCES salesorder(Order_Number), 
    FOREIGN KEY (Product_Number) REFERENCES product(Product_Number),
    
    check (order_number like 'O%'), 
    check (product_number like 'P%')
);

insert into clients(Client_Number, Client_Name, Address, City, Pincode, Province, Amount_Paid, Amount_Due)
VALUES 
('C101','Mai Xuan','Phu Hoa','Dai An',700001,'Binh Duong',10000,5000),
('C102','Le Xuan','Phu Hoa','Thu Dau Mot',700051,'Binh Duong',18000,3000),
('C103','Trinh Huu','Phu Loi','Da Lat',700051,'Lam Dong ',7000,3200),
('C104','Tran Tuan','Phu Tan','Thu Dau Mot',700080,'Binh Duong',8000,0),
('C105','Ho Nhu','Chanh My','Hanoi',700005,'Hanoi',7000,150),
('C106','Tran Hai','Phu Hoa','Ho Chi Minh',700002,'Ho Chi Minh',7000,1300),
('C107','Nguyen Thanh ','Hoa Phu','Dai An',700023,'Binh Duong',8500,7500),
('C108','Nguyen Sy','Tan An','Da Lat',700032,'Lam Dong ',15000,1000),
('C109','Duong Thanh','Phu Hoa','Ho Chi Minh',700011,'Ho Chi Minh',12000,8000),
('C110','Tran Minh','Phu My','Hanoi',700005,'Hanoi',9000,1000);

insert into product(Product_Number, Product_Name, Quantity_On_Hand, Quantity_Sell, Sell_Price, Cost_Price)
VALUES 
('P1001','TV',10,30,1000,800),
('P1002','Laptop',12,25,1500,1100),
('P1003','AC',23,10,400,300),
('P1004','Modem',22,16,250,230),
('P1005','Pen',19,13,12,8),
('P1006','Mouse',5,10,100,105),
('P1007','Keyboard',45,60,120,90),
('P1008','Headset',63,75,50,40);

INSERT into salesman(Salesman_Number, Salesman_Name, Address, City, Pincode, Province, Salary, Sales_Target, Target_AchieveD, Phone)
VALUES 
('S001','Huu','Phu Tan','Ho Chi Minh',700002,'Ho Chi Minh',15000,50,35,'0902361123'),
('S002','Phat','Tan An','Hanoi',700005,'Hanoi',25000,100,110,'0903216542'),
('S003','Khoa','Phu Hoa','Thu Dau Mot',700051,'Binh Duong',17500,40,30,'0904589632'),
('S004','Tien','Phu Hoa','Dai An',700023,'Binh Duong',16500,70,72,'0908654723'),
('S005','Deb','Hoa Phu','Thu Dau Mot',700051,'Binh Duong',13500,60,48,'0903213659'),
('S006','Tin','Chanh My','Da Lat',700032,'Lam Dong',20000,80,55,'0907853497');

INSERT into Salesorder(Order_Number, Order_Date, Client_Number, Salesman_Number, DeliveRy_Status, Delivery_Date, Order_Status)
VALUES 
('O20001','2022-01-15','C101','S003','Delivered','2022-02-10','Successful'),
('O20002','2022-01-25','C102','S003','Delivered','2022-02-15','Cancelled'),
('O20003','2022-01-31','C103','S002','Delivered','2022-04-03','Successful'),
('O20004','2022-02-10','C104','S003','Delivered','2022-04-23','Successful'),
('O20005','2022-02-18','C101','S003','On Way',null,'Cancelled'),
('O20006','2022-02-22','C105','S005','Ready to Ship',null,'In Process'),
('O20007','2022-04-03','C106','S001','Delivered','2022-05-08','Successful'),
('O20008','2022-04-16','C102','S006','Ready to Ship',null,'In Process'),
('O20009','2022-04-24','C101','S004','On Way',null,'Successful'),
('O20010','2022-04-29','C106','S006','Delivered','2022-05-08','Successful'),
('O20011','2022-05-08','C107','S005','Ready to Ship',null,'Cancelled'),
('O20012','2022-05-12','C108','S004','On Way',null,'Successful'),
('O20013','2022-05-16','C109','S001','Ready to Ship',null,'In Process'),
('O20014','2022-05-16','C110','S001','On Way',null,'Successful');


iNSERT Into salesorderdetails(Order_Number, Product_Number, Order_Quantity)
VALUES 
('O20001','P1001',5),
('O20001','P1002',4),
('O20002','P1007',10),
('O20003','P1003',12),
('O20004','P1004',3),
('O20005','P1001',8),
('O20005','P1008',15),
('O20005','P1002',14),
('O20006','P1002',5),
('O20007','P1005',6),
('O20008','P1004',8),
('O20009','P1008',2),
('O20010','P1006',11),
('O20010','P1001',9),
('O20011','P1007',6),
('O20012','P1005',3),
('O20012','P1001',2),
('O20013','P1006',10),
('O20014','P1002',20);

-- 1. Find the average salesman’s salary.
delimiter // 
create function average_salesman_salary()
returns decimal(15,4) 
deterministic 
begin 
	declare average decimal(15,4);
    set average = (
		select avg(salary) 
        from salesman
    );
	return average;
end //
delimiter ;

select average_salesman_salary() as average_salesman_salary;

-- 2. Find the name of the highest paid salesman.
drop function if exists highest_paid_salesman;
delimiter //
create function highest_paid_salesman()
returns varchar(25)
deterministic 
begin 
	declare name_salesman varchar(25); 
    set name_salesman = (
		select salesman_name 
        from salesman
        where salary = (
			select max(salary) 
            from salesman
		)
    );
    return name_salesman;
end // 
delimiter ;

select highest_paid_salesman() as highest_paid_salesman;

-- 3. Find the name of the salesman who is paid the lowest salary.
delimiter //
create function lowest_paid_salesman()
returns varchar(25)  
deterministic 
begin 
	declare name_salesman varchar(25);
    set name_salesman = (
		select salesman_name 
        from salesman 
        where salary = (	
			select min(salary) 
            from salesman 
        )
    );
    return name_salesman;
end //
delimiter ;

select lowest_paid_salesman() as lowest_paid_salesman;

-- 4. Determine the total number of salespeople employed by the company
drop function if exists total_number_salespeople;
delimiter //
create function total_number_salespeople()
returns int
deterministic 
begin
	return (select count(salesman_number) from salesman); 
end // 
delimiter ;

select total_number_salespeople() as total_number_salespeople; 

-- 5. Compute the total salary paid to the company's salesman
delimiter //
create function total_salary_salesman()
returns decimal(15,4) 
deterministic 
begin
	return (select sum(salary) from salesman); 
end // 
delimiter ;

select total_salary_salesman() as total_salary_salesman;

-- 6. Find Clients in a Province
delimiter // 
create function find_province
(
	in_province char(25)
)
returns int 
deterministic 
begin 
	return (
		select count(province) 
        from clients 
        where province = in_province
    );
end // 
delimiter ;

select find_province('Binh Duong') as BinhDuong;

-- 7. Calculate Total Order Amount
drop function if exists total_order_amount;
delimiter // 
create function total_order_amount()
returns decimal(15,4)
deterministic 
begin
	return (
		select sum(total_price) from (
			select (sod.order_quantity * p.sell_price) total_price 
            from salesorderdetails sod 
            inner join product p using(product_number) 
        ) as cnt_list
    );
end //
delimiter ;

select total_order_amount() as total_order_amount;

-- II. Creating constraint for database “Assignment2
drop database if exists assignment2;
CREATE database assignment2;
USE assignment2;

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

-- a) Check constraint to value of gender in “Nam” or “Nu”.
alter table employees 
add constraint check_gender_employee 
check (gender in ('Nam', 'Nu')); 

alter table relative 
add constraint check_gender_relative 
check (gender in ('Nam', 'Nu'));

-- b) Check constraint to value of salary > 0.
alter table employees 
add constraint check_salary_employee 
check (salary > 0); 

-- c) Check constraint to value of relationship in Relative table in “Vo chong”, “Con trai”, “Con gai”, “Me ruot”, “Cha ruot”. 
alter table relative 
add constraint check_relationship_relative 
check (relationship in ('Vo chong', 'Con trai', 'Con gai', 'Me ruot', 'Cha ruot'));

-- III. Writing SQL Queries by database “Assignment2”
-- a) Look for employees with salaries above 25,000 in room 4 or employees with salaries above 30,000 in room 5.
select * 
from employees 
where (salary > 25000 and departmentID = 4) or (salary > 30000 and departmentID = 5);

-- b) Provide full names of employees in HCM city.
select firstName, middleName, lastName 
from employees 
where address like '%TPHCM%';

-- c) Indicate the date of birth and address of Dinh Ba Tien staff
select dateOfBirth 
from employees 
where firstName = 'Tien' and middleName = 'Ba' and lastName = 'Dinh';

-- d) The names of the employees of Room 5 are involved in the "San pham X" project and this employee is directly managed by "Nguyen Thanh Tung"
select e.firstName, e.middleName, e.lastName 
from employees e
inner join projects p using(departmentID)
where p.projectName = 'San Pham X' and e.departmentID = 5 and e.managerID in (
	select e2.employeeID from employees e2
    where e2.firstName = 'Tung' and e2.middleName = 'Thanh' and e2.lastName = 'Nguyen'
); 

-- e) Find the names of department heads of each department.
select e.firstName, e.middleName, e.lastName 
from employees e
where e.employeeID in (
	select managerID from department 
);

-- f) Find projectID, projectName, projectAddress, departmentID, departmentName, departmentID, date0fEmployment
select projectID, projectName, projectAddress, departmentID, departmentName, departmentID, date0fEmployment
from projects 
inner join department using(departmentID);

-- g) Find the names of female employees and their relatives
select concat_ws(' ', e.lastName, e.middleName, e.firstName) employeeFullName, r.relativeName 
from employees e 
left join relative r using(employeeID)
where e.gender = 'Nu';

-- h) For all projects in "Hanoi", list the project code (projectID), the code of the project lead department (departmentID), 
-- the full name of the manager as well as the address (Address) and date of birth (date0fBirth) of the Employees.
select p.projectID, d.departmentID, concat_ws(' ', e.lastName, e.middleName, e.firstName) managerName, e.address, e.dateOfBirth
from departmentaddress da
join projects p using(departmentID) 
join department d using(departmentID)
join employees e using(departmentID)
where da.address = 'HA NOI';

-- i) For each employee, include the employee's full name and the employee's line manager
select concat_ws(' ', e.lastName, e.middleName, e.firstName) employeeName, 
	   concat_ws(' ', m.lastName, m.middleName, m.firstName) managerName
from employees e 
join employees m on e.managerID = m.employeeID; 

-- j) For each employee, indicate the employee's full name and the full name of the head of the department in which the employee works.
select concat_ws(' ', e.lastName, e.middleName, e.firstName) employeeName,
	   concat_ws(' ', m.lastName, m.middleName, m.firstName) managerName
from employees e 
join department d using(departmentID)
join employees m on d.managerID = m.employeeID; 

-- k) Provide the employee's full name and the names of the projects in which the employee participated, if any
select concat_ws(' ', e.lastName, e.middleName, e.firstName) employeeName, p.projectName
from employees e 
join projects p using(departmentID);

-- l) For each scheme, list projectName and the total number of hours worked per week of all employees attending that project.
select p.projectName, sum(workingHour) total_hours 
from projects p 
join assignment a using(projectID)
group by projectID; 

-- m) For each department, list the name of the department (departmentName) and the average salary of the employees who work for that department.
select d.departmentName, avg(e.salary) average_salary 
from department d 
join employees e using(departmentID) 
group by departmentID, departmentName;

-- n) For departments with an average salary above 30,000, list the name of the department and the number of employees of that department.
select d.departmentName, count(e.employeeID) employee
from department d
join employees e using(departmentID)
group by departmentID, departmentName
having avg(e.salary) > 30000; 

-- o) Indicate the list of schemes (projectID) that has: workers with them (lastName) as 'Dinh' or , 
-- whose head of department presides over the scheme with them (lastName) as 'Dinh'.
select p.projectID 
from projects p 
join department d using(departmentID)
join employees e using(departmentID)
where e.lastName = 'Dinh' or e.managerID in (
	select e1.employeeID 
    from employees e1
    where e1.lastName = 'Dinh'
);

-- p) List of employees (lastName, middleName, firstName) with more than 2 relatives.
select e.lastName, e.middleName, e.firstName 
from employees e 
join relative r using(employeeID)
group by e.lastName, e.middleName, e.firstName
having count(*) > 2;

-- q) List of employees (lastName, middleName, firstName) without any relatives.
select e.lastName, e.middleName, e.firstName 
from employees e 
join relative r using(employeeID)
group by e.lastName, e.middleName, e.firstName
having not count(*) > 0;

-- r) List of department heads (lastName, middleName, firstName) with at least one relative
select e.lastName, e.middleName, e.firstName 
from employees e 
join relative r using(employeeID)
group by e.lastName, e.middleName, e.firstName
having count(*) >= 1;

-- s) Find the surname (lastName) of unmarried department heads.
select e.lastName 
from employees e
join department d on e.employeeID = d.managerID
where d.managerID not in (
	select r.employeeID 
    from relative r 
    where r.relationship = 'Vo Chong'
);

-- t) Indicate the full name of the employee whose salary is above the average salary of the "Research" department.
select e.lastName, e.middleName, e.firstName 
from employees e 
where e.salary > (
	select avg(e1.salary) 
    from employees e1 
    join department d 
    where d.departmentName = 'Nghien cuu'
);

-- u) Indicate the name of the department and the full name of the head of the department with the largest number of employees.
select d.departmentName, concat_ws(' ', e.lastName, e.middleName, e.firstName) fullname 
from department d 
join employees e on d.managerID = e.employeeID
join employees e1 on d.departmentID = e1.departmentID
group by d.departmentID
order by count(*) desc
limit 1; 

-- v) Find the full names (lastName, middleName, firstName) and addresses (Address) of employees 
-- who work on a project in 'HCMC' but the department they belong to is not located in 'HCMC'
select concat_ws(' ', e.lastName, e.middleName, e.firstName) fullname, e.address 
from employees e 
join projects p using(departmentID)
where (p.projectAddress like '%HCM%') and (e.address not like '%HCM%')
group by e.employeeID;

-- w) In general verse 16, find the names and addresses of employees who work on a scheme in a city 
-- but the department to which they belong is not located in that city
drop procedure if exists find_employees;
delimiter //
create procedure find_employees()
begin
	select concat_ws(' ', e.lastName, e.middleName, e.firstName) fullname, e.address 
	from employees e 
	join projects p using(departmentID)
	where p.projectAddress <> e.address
    group by e.employeeID;
end //
delimiter ; 

call find_employees();