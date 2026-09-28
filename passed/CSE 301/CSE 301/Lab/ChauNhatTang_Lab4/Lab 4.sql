create database Assignment4; 
use Assignment4;

create table clients(
	Client_Number varchar(10),
	Client_Name varchar(25) not null,
	Address varchar(30),
	City varchar(30),
	Pincode int not null,
	Province char(25),
	Amount_Paid decimal(15,4),
	Amount_Due decimal(15,4),
	check (Client_Number like 'C%'),
	primary key (Client_Number)
);

create table product(
	Product_Number varchar(15),
	Product_Name varchar(25) not null unique,
	Quantity_On_Hand int not null,
	Quantity_Sell int not null,
	Sell_Price decimal(15,4) not null,
	Cost_Price decimal(15,4) not null,
	check (Product_Number like 'P%'),
	check (Cost_Price <> 0),
	primary key(Product_Number)
);

create table Salesman(
	Salesman_Number varchar(15),
	Salesman_Name varchar(25) not null,
	Address varchar(30),
	City varchar(30),
	Pincode int not null,
	Province char(25) default('Viet Nam'),
	Salary decimal(15,4) not null,
	Sales_Target int not null,
	Target_Achieved int,
	Phone char(10) not null unique,
	check (Salesman_Number like 'S%'),
	check (Salary <> 0),
	check (Sales_Target <> 0),
	primary key(Salesman_Number)
);

create table SalesOrder(
	Order_Number varchar(15),
	Order_Date date,
	Client_Number varchar(15),
	Salesman_Number varchar(15),
	Delivery_Status char(15),
	Delivery_Date date,
	Order_Status varchar(15),
	primary key (Order_Number),
	foreign key (Client_Number) references clients(Client_Number),
	foreign key (Salesman_Number) references salesman(Salesman_Number),
	check (Order_Number like 'O%'),
	check (Client_Number like 'C%'),
	check (Salesman_Number like 'S%' ),
	check (Delivery_Status in ('Delivered', 'On Way', 'Ready to Ship')),
	check (Delivery_Date>Order_Date),
	check (Order_Status in ('In Process', 'Successful', 'Cancelled'))
);

create table SalesOrderDetails(
	Order_Number varchar(15),
	Product_Number varchar(15),
	Order_Quantity int,
	Discount_Rate int,
	check (order_number like 'O%'),
	check (Product_Number like 'P%'),
	foreign key (Order_Number)
	references salesorder(Order_Number),
	foreign key (Product_Number)
	references product (Product_Number)
);

INSERT INTO CLIENTS (Client_Number, Client_Name, Address, City, Pincode, Province, Amount_Paid, Amount_Due) VALUES 
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

INSERT INTO PRODUCT (Product_Number, Product_Name, Quantity_On_Hand, Quantity_Sell, Sell_Price, Cost_Price) VALUES 
('P1001','TV',10,30,1000,800),
('P1002','Laptop',12,25,1500,1100),
('P1003','AC',23,10,400,300),
('P1004','Modem',22,16,250,230),
('P1005','Pen',19,13,12,8),
('P1006','Mouse',5,10,100,105),
('P1007','Keyboard',45,60,120,90),
('P1008','Headset',63,75,50,40);

INSERT INTO SALESMAN (Salesman_Number, Salesman_Name, Address, City, Pincode, Province, Salary, Sales_Target, Target_Achieved, Phone) VALUES 
('S001','Huu','Phu Tan','Ho Chi Minh',700002,'Ho Chi Minh',15000,50,35,'0902361123'),
('S002','Phat','Tan An','Hanoi',700005,'Hanoi',25000,100,110,'0903216542'),
('S003','Khoa','Phu Hoa','Thu Dau Mot',700051,'Binh Duong',17500,40,30,'0904589632'),
('S004','Tien','Phu Hoa','Dai An',700023,'Binh Duong',16500,70,72,'0908654723'),
('S005','Deb','Hoa Phu','Thu Dau Mot',700051,'Binh Duong',13500,60,48,'0903213659'),
('S006','Tin','Chanh My','Da Lat',700032,'Lam Dong',20000,80,55,'0907853497');

INSERT INTO SALESORDER (Order_Number, Order_Date, Client_Number, Salesman_Number, Delivery_Status, Delivery_Date, Order_Status) VALUES
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

INSERT INTO SalesOrderDetails (Order_Number, Product_Number, Order_Quantity) VALUES
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

-- Q1 Cach 1
select 
	sm.salesman_name, cl.client_name, sm.city
from 
	salesman sm 
join 
	clients cl
where 
	sm.city = cl.city; 
-- Q1 Cach 2
select 
	sm.salesman_name, cl.client_name, sm.city
from 
	salesman sm 
inner join 
	clients cl on sm.city = cl.city;

-- 2
select cl.client_number, cl.client_name, so.order_number
from clients cl 
inner join salesorder so on  cl.client_number = so.client_number;
    
-- 3
select cl.*, count(so.Order_Number) numberOfOrder
from clients cl
inner join  salesorder so on cl.client_number = so.client_number
group by cl.client_number, cl.client_name
having count(so.Order_Number) > 0; 

-- 4
select cl.*, count(so.Order_Number) numberOfOrder
from clients cl
inner join  salesorder so on cl.client_number = so.client_number
group by cl.client_number, cl.client_name
having count(so.Order_Number) > 3; 

-- 5
select cl.*, count(so.order_number) numberOfOrder
from clients cl
inner join salesorder so on cl.client_number = so.client_number
group by cl.client_number
having count(so.order_number) > 1
order by numberOfOrder DESC; 

-- 6
select sm.salesman_name, sum(sod.order_quantity) total_product_sold
from salesman sm 
inner join salesorder so on sm.salesman_number = so.salesman_number
inner join salesorderdetails sod on so.order_number = sod.order_number
group by sm.salesman_name
having sum(sod.order_quantity) > 20;

-- 7
select cl.*, count(so.order_status) numberOfCancelled 
from clients cl 
inner join salesorder so on cl.client_number = so.client_number
where so.order_status = 'Cancelled'
group by cl.client_number
having numberOfCancelled >  1;

-- 8
SELECT cl.Client_Name, cl.Client_Number, so.Order_Number, so.Salesman_Number, sod.Product_Number
FROM clients cl
inner JOIN salesorder so ON cl.Client_Number = so.Client_Number
inner JOIN salesorderdetails sod ON so.Order_Number = sod.Order_Number;

-- 9
select p.*, count(sod.order_number) numberOfClients 
from product p
inner join salesorderdetails sod on p.product_number = sod.product_number 
group by p.product_number;

SELECT 
    p.Product_Number,
    p.Product_Name,
    COUNT(DISTINCT sod.Order_Number) AS Number_of_Orders
FROM product p
JOIN salesorderdetails sod ON p.Product_Number = sod.Product_Number
GROUP BY p.Product_Number, p.Product_Name;

-- 10
select sod.product_number, count(distinct so.client_number) numberOfClient 
from salesorderdetails sod 
inner join salesorder so on sod.order_number = so.order_number
group by sod.product_number 
having numberOfClient > 2;

-- 11
select sm.salesman_name, sm.salary 
from salesman sm
order by sm.salary DESC
limit 1 offset 1;

-- 12
select sm.salesman_name, sm.salary 
from salesman sm 
order by sm.salary ASC 
limit 1 offset 1;

-- 13
select sm.salesman_number, sm.salesman_name 
from salesman sm 
inner join salesorder so on sm.salesman_number = so.salesman_number
where so.client_number = 'C108'
group by sm.salesman_number;

-- 14
select sm.salesman_name, sm.salary 
from salesman sm 
where sm.salary > (
	select salary from salesman sm1
    where sm1.salesman_number = 'S001'
);

-- 15
select sm.salesman_name
from salesman sm 
inner join salesorder so on so.salesman_number = sm.salesman_number
inner join salesorderdetails sod on sod.order_number = so.order_number 
where sod.product_number = 'P1002'
group by sm.salesman_number;

-- 16
select sm.salesman_number, sm.salesman_name
from salesman sm 
inner join salesorder so on so.salesman_number = sm.salesman_number
inner join salesorderdetails sod on sod.order_number = so.order_number 
inner join product p on p.product_number = sod.product_number
where p.product_name = 'Pen'
group by sm.salesman_number;

-- 17
select sm.salesman_name, sm.salary
from salesman sm 
where sm.salary > (
	select avg(salary) from salesman
)
group by sm.salesman_number;

-- 18
select cl.client_name, cl.amount_paid
from clients cl 
where cl.amount_paid > (
	select avg(amount_paid) from clients
)
group by cl.client_number; 

-- 19
select p.* 
from product p 
inner join salesorderdetails sod on sod.product_number = p.product_number
inner join salesorder so on so.order_number = sod.order_number 
inner join clients cl on cl.client_number = so.client_number
where cl.client_name = 'Le Xuan';

-- 20
select p.product_name, cl.client_name, cl.amount_due
from product p 
inner join salesorderdetails sod on sod.product_number = p.product_number
inner join salesorder so on so.order_number = sod.order_number 
inner join clients cl on cl.client_number = so.client_number
inner join salesman sm on so.salesman_number = sm.salesman_number
where so.delivery_status = 'Delivered';

-- 21
select sm.salesman_name, p.product_name
from product p 
inner join salesorderdetails sod on sod.product_number = p.product_number
inner join salesorder so on so.order_number = sod.order_number 
inner join clients cl on cl.client_number = so.client_number
inner join salesman sm on so.salesman_number = sm.salesman_number
where so.order_status = 'Cancelled';

-- 22
select p.product_name, p.sell_price, p.cost_price, so.delivery_status
from product p 
inner join salesorderdetails sod on sod.product_number = p.product_number
inner join salesorder so on so.order_number = sod.order_number 
inner join clients cl on cl.client_number = so.client_number
inner join salesman sm on so.salesman_number = sm.salesman_number
where cl.client_name = 'Nguyen Thanh ';

-- 23
select cl.client_name, p.product_name, p.sell_price, sm.salesman_name, so.delivery_status, sod.order_quantity
from clients cl
inner join salesorder so on cl.client_number = so.client_number
inner join salesorderdetails sod on so.order_number = sod.order_number 
inner join product p on sod.product_number = p.product_number
inner join salesman sm on so.salesman_number = sm.salesman_number;

-- 24
select sm.salesman_name, p.product_name, so.order_date
from clients cl
inner join salesorder so on cl.client_number = so.client_number
inner join salesorderdetails sod on so.order_number = sod.order_number 
inner join product p on sod.product_number = p.product_number
inner join salesman sm on so.salesman_number = sm.salesman_number
where so.order_status = 'Successful' and so.delivery_status <> 'Delivered';

-- 25
select cl.client_name, p.product_name, so.order_number, so.delivery_status
from clients cl
inner join salesorder so on cl.client_number = so.client_number
inner join salesorderdetails sod on so.order_number = sod.order_number 
inner join product p on sod.product_number = p.product_number
inner join salesman sm on so.salesman_number = sm.salesman_number
where so.delivery_status = 'On Way';

-- 26
select distinct sm.salesman_name, p.product_name, cl.city
from clients cl
inner join salesorder so on cl.client_number = so.client_number
inner join salesorderdetails sod on so.order_number = sod.order_number 
inner join product p on sod.product_number = p.product_number
inner join salesman sm on so.salesman_number = sm.salesman_number
where 
	so.delivery_status = 'Delivered' 
    and exists (
		select 1 from clients cl1
		inner join salesorder so1 on cl1.client_number = so1.client_number
		inner join salesorderdetails sod1 on so1.order_number = sod1.order_number 
		inner join salesman sm1 on so1.salesman_number = sm1.salesman_number
		where 
			so1.delivery_status = 'Delivered' 
            and sm.salesman_name = sm1.salesman_name 
            and sod.product_number = sod1.product_number
            and cl.city = cl1.city 
            and cl.client_number <> cl1.client_number
	);

-- 27
select cl.client_name, p.product_name, count(*) times
from clients cl
inner join salesorder so on cl.client_number = so.client_number
inner join salesorderdetails sod on so.order_number = sod.order_number 
inner join product p on sod.product_number = p.product_number
inner join salesman sm on so.salesman_number = sm.salesman_number
group by cl.client_number, p.product_number
having times > 1;

-- 29
select sm.salesman_number, sm.salesman_name, sm.salary 
from salesman sm
where sm.salary > (
		select max(salary) 
        from (
			select sm1.salary from salesman sm1
			inner join salesorder so1 on sm1.salesman_number = so1.salesman_number 
			where so1.order_status = 'Successful'
		) as successful_salaries
)
order by sm.salary ASC;

-- 30
select * from salesman 
order by salary DESC
limit 1 offset 3;

-- 31
select * from salesman 
order by salary ASC
limit 1 offset 2;

