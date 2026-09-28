drop database assignment5;
create database assignment5;
use assignment5;

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

-- 1. How to check constraint in a table?
SELECT 
	CONSTRAINT_NAME, 
	CONSTRAINT_TYPE
FROM 
	INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE 
	TABLE_SCHEMA = 'assignment5' AND TABLE_NAME = 'salesman';

SELECT 
	CONSTRAINT_NAME, 
    TABLE_NAME, 
    COLUMN_NAME
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE 
	TABLE_SCHEMA = 'assignment5' AND TABLE_NAME = 'salesman';

SELECT *
FROM INFORMATION_SCHEMA.CHECK_CONSTRAINTS
WHERE CONSTRAINT_SCHEMA = 'assignment5';

-- 2. Create a separate table name as “ProductCost” from “Product” table, which contains the information about product name and its buying price. 
CREATE TABLE ProductCost
SELECT 
	PRODUCT_NAME, 
    COST_PRICE
FROM PRODUCT;

SELECT *
FROM PRODUCTCOST;

-- 3. Compute the profit percentage for all products. Note: profit = (sell-cost)/cost*100
SELECT 
	Product_Name, 
	Cost_Price, 
    round((Sell_Price-Cost_Price)/Cost_Price*100) as Profit_Percentage
FROM PRODUCT;

-- 4. If a salesman exceeded his sales target by more than equal to 75%, his remarks should be ‘Good’.
ALTER TABLE SALESMAN 
ADD COLUMN Remarks VARCHAR(20);

UPDATE SALESMAN 
SET Remarks = 'Good'
WHERE Sales_Target > 0 AND Target_Achieved / Sales_Target >= 175/100;

SELECT * 
FROM SALESMAN;

-- 5. If a salesman does not reach more than 60% of his sales objective, he is labeled as 'Average'.
UPDATE SALESMAN
SET Remarks = 'Average'
WHERE Sales_Target > 0 AND Target_Achieved / Sales_Target < 60/100;

SELECT * 
FROM SALESMAN;   

-- 6. If a salesman does not meet more than half of his sales objective, he is considered 'Poor'.
UPDATE SALESMAN
SET Remarks = 'Poor'
WHERE Sales_Target > 0 AND Target_Achieved / Sales_Target < 50/100;

SELECT * 
FROM SALESMAN;   

-- 7. find the total quantity for each product.
select 
	p.product_number,
    p.product_name,
    sum(sod.order_quantity) as Total_Quantity
from product p
inner join salesorderdetails sod on sod.product_number = p.product_number
group by p.product_number; 

-- 8. Add a new column and find the total quantity for each product
alter table product 
add column Total_Quantity int default 0;

update product p
set Total_Quantity = (
	select sum(sod.order_quantity) 
    from salesorderdetails sod 
    where sod.product_number = p.product_number
);

select * from product;

-- 9. If the order quantity for each product is more than five, change the discount rate to 10 otherwise set to 5
update salesorderdetails 
set discount_rate = 
	case 
		when order_quantity > 5 then 10 else 5
	end;
    
select * from salesorderdetails;

-- 10. If the order quantity for each product is more than equal to eight, change the discount rate to 10, 
-- if it is between 5 and 8 then change to 5, if it is less than 5 then change to 6 otherwise set to 0.
update salesorderdetails
set discount_rate = 
	case 
		when order_quantity >= 8 then 10
		when 5 <= order_quantity and order_quantity < 8 then 5
        when 0 < order_quantity and order_quantity < 5 then 6 else 0
	end; 
    
select * from salesorderdetails;

-- 11. The first number of pin code in client table should be start with 7.
ALTER TABLE CLIENTS 
ADD constraint check_pincode_client CHECK (Pincode like '7%');

-- 12. Creates a view name as clients_view that shows all customers information from Thu Dau Mot
create view clients_view as 
select * 
from clients 
where city = 'Thu Dau Mot'; 

select * from clients_view;

-- 13. Drop the “client_view”.
drop view if exists clients_view;

-- 14. Creates a view name as clients_order that shows all clients and their order details from Thu Dau Mot.
create view clients_order as
select c.*, so.order_number, so.order_date
from clients c
inner join salesorder so on so.client_number = c.client_number
where c.city = 'Thu Dau Mot';

select * from clients_order;

-- 15. Creates a view that selects every product in the "Products" table with a sell price higher than the average sell price
create view high_price_products  as
select * 
from product
where sell_price > (
	select avg(sell_price) from product
);

select * from high_price_products;

-- 16. Creates a view name as salesman_view that show all salesman information and products (product names, product price, quantity order) were sold by them
create view salesman_view as 
select 
	s.*, 
	p.product_name, 
    p.sell_price,
    sod.order_quantity
from salesman s 
join salesorder so on so.salesman_number = s.salesman_number
join salesorderdetails sod on sod.order_number = so.order_number
join product p on p.product_number = sod.product_number;

select * from salesman_view;

-- 17. Creates a view name as sale_view that show all salesman information and product 
-- (product names, product price, quantity order) were sold by them with order_status = 'Successful'.
create view sale_view as
select
	s.*, 
	p.product_name, 
    p.sell_price,
    sod.order_quantity
from salesman s 
join salesorder so on so.salesman_number = s.salesman_number
join salesorderdetails sod on sod.order_number = so.order_number
join product p on p.product_number = sod.product_number
where so.order_status = 'Successful';

select * from sale_view;

-- 18. Display quantity_sell column add in sale_view
create or replace view sale_view as
select
	s.*, 
	p.product_name, 
    p.sell_price,
    p.quantity_sell,
    sod.order_quantity
from salesman s 
join salesorder so on so.salesman_number = s.salesman_number
join salesorderdetails sod on sod.order_number = so.order_number
join product p on p.product_number = sod.product_number
where so.order_status = 'Successful';

select * from sale_view;

-- 19. Creates a view name as sale_amount_view that show all salesman information and sum order quantity
-- of product greater than and equal 20 pieces were sold by them with order_status = 'Successful'.
create or replace view sale_amount_view as
select
	s.*,
    sum(sod.order_quantity) Total_Sold
from salesman s 
join salesorder so on so.salesman_number = s.salesman_number
join salesorderdetails sod on sod.order_number = so.order_number
join product p on p.product_number = sod.product_number
where so.order_status = 'Successful' 
group by s.salesman_number
having total_sold >= 20;

select * from sale_amount_view;

-- 20. Amount paid and amounted due should not be negative when you are inserting the data. 
alter table clients 
add constraint check_amount_paid check(amount_paid >= 0),
add constraint check_amount_due check(amount_due >= 0);

SELECT CONSTRAINT_NAME, CONSTRAINT_TYPE
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE TABLE_SCHEMA = 'assignment5' AND TABLE_NAME = 'clients';

-- 21. Do not enforce the check constraint for pincode
-- Answer: MySQL không hỗ trợ "disable" CHECK trực tiếp; cách để không enforce là DROP constraint. 

-- 22. How to alter a check constraint enforcement state?
-- Answer: MySQL không có ALTER CHECK ... WITH NOCHECK như SQL Server. Bạn cần DROP constraint rồi ADD lại. 

-- 23. Do not enforce the check constraint for pincode.
alter table clients 
drop constraint check_pincode_client;

SELECT CONSTRAINT_NAME, CONSTRAINT_TYPE
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE TABLE_SCHEMA = 'assignment5' AND TABLE_NAME = 'clients';

-- 24. The sell price and cost price should be unique
alter table product 
add constraint unq_sell_cost unique(sell_price, cost_price);

SELECT CONSTRAINT_NAME, CONSTRAINT_TYPE
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE TABLE_SCHEMA = 'assignment5' AND TABLE_NAME = 'product';

-- 25. The sell price and cost price should not be unique.
alter table product 
drop constraint unq_sell_cost;

SELECT CONSTRAINT_NAME, CONSTRAINT_TYPE
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE TABLE_SCHEMA = 'assignment5' AND TABLE_NAME = 'product';

-- 26. Remove unique constraint from product name.
alter table product
drop constraint product_name;

SELECT CONSTRAINT_NAME, CONSTRAINT_TYPE
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE TABLE_SCHEMA = 'assignment5' AND TABLE_NAME = 'product';

-- 27. Update the delivery status to “Delivered” for the product number P1007.
update salesorder so
join salesorderdetails sod on sod.order_number = so.order_number
set so.delivery_status = 'Delivered'
where sod.product_number = 'P1007'; 

select * from salesorder so
join salesorderdetails sod on sod.order_number = so.order_number
where sod.product_number = 'P1007'; 

-- 28. Change address and city to ‘Phu Hoa’ and ‘Thu Dau Mot’ where client number is C104.
update clients
set address = 'Phu Hoa', city = 'Thu Dau Mot'
where client_number = 'C104';

select * from clients
where client_number = 'C104';

-- 29. Add a new column to “Product” table named as “Exp_Date”, data type is Date.
alter table product 
add column exp_date date; 

select * from product;

-- 30. Add a new column to “Clients” table named as “Phone”, data type is varchar and size is 15.
alter table clients 
add column phone varchar(15);

select * from clients;

-- 31. Update remarks as “Good” for all salesman
update salesman 
set remarks = 'Good';

select * from salesman;

-- 32. Change remarks to "bad" whose salesman number is "S004".
update salesman 
set remarks ='bad'
where salesman_number = 'S004';

select * from salesman
where salesman_number = 'S004';

-- 33. Modify the data type of “Phone” in “Clients” table with varchar from size 15 to size is 10.
alter table clients 
modify column phone varchar(10);

-- 34. Delete the “Phone” column from “Clients” table.
-- 35. alter table Clients drop column Phone;
alter table clients 
drop column phone;

select * from clients;

-- 36. Change the sell price of Mouse to 120
update product 
set sell_price = 120
where product_name = 'Mouse';

select * from product
where product_name = 'Mouse';

-- 37. Change the city of client number C104 to “Ben Cat”.
update clients 
set city = 'Ben Cat'
where client_number = 'C104';

select * from clients
where client_number = 'C104';

-- 38. If Order_Quantity greater than 5, then 10% discount. If Order_Quantity greater than 10, then 15% discount. Othrwise, no discount.
update salesorderdetails
set discount_rate = 
	case 
        when order_quantity > 10 then 15
        when order_quantity > 5 then 10 else 0
	end;
    
select * from salesorderdetails;