drop database assignment6;
create database assignment6;
use assignment6;

CREATE TABLE clients (
    Client_Number VARCHAR(10),
    Client_Name VARCHAR(25) NOT NULL,
    Address VARCHAR(30),
    City VARCHAR(30),
    Pincode INT NOT NULL,
    Province CHAR(25),
    Amount_Paid DECIMAL(15 , 4 ),
    Amount_Due DECIMAL(15 , 4 ),
    CHECK (Client_Number LIKE 'C%'),
    PRIMARY KEY (Client_Number)
);

CREATE TABLE product (
    Product_Number VARCHAR(15),
    Product_Name VARCHAR(25) NOT NULL UNIQUE,
    Quantity_On_Hand INT NOT NULL,
    Quantity_Sell INT NOT NULL,
    Sell_Price DECIMAL(15 , 4 ) NOT NULL,
    Cost_Price DECIMAL(15 , 4 ) NOT NULL,
    CHECK (Product_Number LIKE 'P%'),
    CHECK (Cost_Price <> 0),
    PRIMARY KEY (Product_Number)
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

CREATE TABLE SalesOrder (
    Order_Number VARCHAR(15),
    Order_Date DATE,
    Client_Number VARCHAR(15),
    Salesman_Number VARCHAR(15),
    Delivery_Status CHAR(15),
    Delivery_Date DATE,
    Order_Status VARCHAR(15),
    PRIMARY KEY (Order_Number),
    FOREIGN KEY (Client_Number)
        REFERENCES clients (Client_Number),
    FOREIGN KEY (Salesman_Number)
        REFERENCES salesman (Salesman_Number),
    CHECK (Order_Number LIKE 'O%'),
    CHECK (Client_Number LIKE 'C%'),
    CHECK (Salesman_Number LIKE 'S%'),
    CHECK (Delivery_Status IN ('Delivered' , 'On Way', 'Ready to Ship')),
    CHECK (Delivery_Date > Order_Date),
    CHECK (Order_Status IN ('In Process' , 'Successful', 'Cancelled'))
);

CREATE TABLE SalesOrderDetails (
    Order_Number VARCHAR(15),
    Product_Number VARCHAR(15),
    Order_Quantity INT,
    Discount_Rate INT,
    CHECK (order_number LIKE 'O%'),
    CHECK (Product_Number LIKE 'P%'),
    FOREIGN KEY (Order_Number)
        REFERENCES salesorder (Order_Number),
    FOREIGN KEY (Product_Number)
        REFERENCES product (Product_Number)
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

-- 1. Write a SQL query to find all salesman and clients located in the city of Ha Noi on a table with information: ID, Name, City and Type.
SELECT c.client_number ID, c.client_name Name, c.City City, 'Client' Type
FROM clients c
WHERE c.City = 'Hanoi' 
UNION 
SELECT s.salesman_number ID, s.salesman_name Name, s.City City, 'Salesman' Type
FROM salesman s
WHERE s.City = 'Hanoi';
    
-- 2. Write a SQL query to create a union of two queries that shows the salesman, cities, and target_Achieved of all salesmen. 
-- Those with a target of 60 or greater will have the words 'High Achieved', while the others will have the words 'Low Achieved'.
select s1.salesman_number, s1.salesman_name, s1.city, s1.target_achieved, 'High Achieved' status 
from salesman s1 
where s1.target_achieved >= 60 
union 
select s2.salesman_number, s2.salesman_name, s2.city, s2.target_achieved, 'Low Achieved' status 
from salesman s2 
where s2.target_achieved < 60;

-- 3. Write a SQL query to find those salesman and clients who have placed more than one order. Return ID, name and order by ID.
select s.salesman_number ID, s.salesman_name Name 
from salesorder so
join salesman s on s.salesman_number = so.salesman_number
group by s.salesman_number 
having count(s.salesman_number) > 1
union 
select c.client_number ID, c.client_name Name
from salesorder so
join clients c on c.client_number = so.client_number
group by c.client_number
having count(c.client_number) > 1
order by ID;

-- 4. Retrieve the distinct client names who placed orders and the salesman names who processed those orders
select distinct s.salesman_name Name 
from salesorder so 
join salesman s on s.salesman_number = so.salesman_number
union 
select distinct c.client_name Name
from salesorder so
join clients c on c.client_number = so.client_number;

-- 5. Create a procedure stores get_clients() saves the all Clients in table. Then Call procedure stores.
delimiter //
create procedure get_client()
begin
	select * from clients;
end //
delimiter ;

call get_client();

-- 6. Drop get_clients() procedure stores.
drop procedure if exists get_client;

-- 7. Create a stored procedure to retrieve all clients in a specific city
delimiter //
create procedure get_client_by_city
(
	IN city_name varchar(30)
)
begin
	select * from clients
    where city = city_name;
end //
delimiter ;

call get_client_by_city('Hanoi');

-- 8. Create a stored procedure to update the delivery status for a given product number.
drop procedure if exists update_delivery_status;

delimiter //
create procedure update_delivery_status
(
	IN in_product_number varchar(15),
    IN in_delivery_status char(15)
)
begin 
	update salesorder so 
    set so.delivery_status = in_delivery_status 
    where so.order_number in (
		select sod.order_number 
        from salesorderdetails sod
        where sod.product_number = in_product_number
    );
end // 
delimiter ;

call update_delivery_status('P1008', 'Ready to Ship');

-- 9. Create a stored procedure to retrieve the total quantity for each product.
drop procedure if exists get_total_quantity_product;

delimiter //
create procedure get_total_quantity_product()
begin
	select p.product_number, p.product_name, sum(sod.order_quantity) total_quantity
    from product p
    join salesorderdetails sod using (product_number) 
    group by p.product_number;
end //
delimiter ;

call get_total_quantity_product(); 

-- 10. Create a stored procedure to update the remarks for a specific salesman.
alter table salesman 
add column remark varchar(25);

delimiter //
create procedure update_remark_specific_salesman
(
	IN in_salesman_number varchar(25),
    IN in_salesman_remark varchar(25)
)
begin
	update salesman 
    set remark = in_salesman_remark
    where salesman_number = in_salesman_number; 
end // 
delimiter ;

call update_remark_specific_salesman('S001', 'Good');

-- 11. Create a procedure stores find_clients() saves all of clients and can call each client by client_number.
delimiter //
create procedure find_client
(
	IN in_client_number varchar(10)
)
begin
	select * from clients 
    where client_number = IFNULL(in_client_number, client_number);
end // 
delimiter ;

call find_client(NULL);
call find_client('C101');

-- 12. Create a procedure stores salary_salesman() saves all of clients (salesman_number, salesman_name, salary) having salary >15000. 
-- Then execute the first 2 rows and the first 4 rows from the salesman table.
drop procedure if exists salary_salesman;

delimiter //
create procedure salary_salesman
(
	IN limit_rows int
)
begin	
	select s.salesman_number, s.salesman_name, s.salary
    from salesman s
    where s.salary > 15000
    limit limit_rows;
end //     
delimiter ;

call salary_salesman(4);

-- 13. Procedure MySQL MAX() function retrieves maximum salary from MAX_SALARY of salary table.
drop function if exists max_salary_salesman;
delimiter //
create function max_salary_salesman()
returns decimal(15,4)
DETERMINISTIC
begin
	declare max_salary decimal(15,4);
	select max(salary) 
    into max_salary
    from salesman;
    return max_salary;
end // 
delimiter ;

select max_salary_salesman();

-- 14. Create a procedure stores execute finding amount of order_status by values order status of salesorder table.
drop procedure if exists find_amount_order_status;
delimiter //
create procedure find_amount_order_status
(	
	IN in_order_status varchar(15)
)
begin
	select count(*) amount_order_status from salesorder 
    where order_status = in_order_status; 
end //
delimiter ;

call find_amount_order_status('Successful');

-- 15. Create a stored procedure to calculate and update the discount rate for orders.
drop procedure if exists update_rate_order;
delimiter //
create procedure update_rate_order()
begin
	update salesorderdetails 
    set discount_rate = 
		case 
			when order_quantity > 10 then 15
            when order_quantity > 5 then 10 else 0
		end;
end // 
delimiter ;

call update_rate_order();

-- 16. Count the number of salesman with following conditions : SALARY < 20000; SALARY > 20000; SALARY = 20000.
drop procedure if exists count_the_number_of_salesman;
delimiter //
create procedure count_the_number_of_salesman()
begin
	select 'Under 20000' as Type, count(salary) count from salesman 
    where salary < 20000 
    union 
    select 'Equal 20000', count(salary) count from salesman 
    where salary = 20000 
    union 
    select 'Over 20000', count(salary) count from salesman 
    where salary > 20000;
end // 
delimiter ;

call count_the_number_of_salesman();

select 
	sum(IF(salary < 20000, 1, 0)) 'Under 20000',
    sum(IF(salary = 20000, 1, 0)) 'Equal 20000',
    sum(IF(salary > 20000, 1, 0)) 'Over 20000'
from salesman;

-- 17. Create a stored procedure to retrieve the total sales for a specific salesman
drop procedure if exists get_total_sale;
delimiter //
create procedure get_total_sale
(
	IN in_salesman_number varchar(15)
)
begin 
	select s.salesman_number, s.salesman_name, count(so.order_number) total_sale
    from salesman s 
    join salesorder so using (salesman_number)
    where s.salesman_number = in_salesman_number
    group by s.salesman_number, s.salesman_name;
end // 
delimiter ;

call get_total_sale('S001');

-- 18. Create a trigger before_total_quantity_update to update total quantity of product when Quantity_On_Hand and Quantity_sell change values. 
-- Then Update total quantity when Product P1004 have Quantity_On_Hand = 30, quantity_sell =35.
alter table product 
add column total_quantity int; 

update product 
set total_quantity = quantity_on_hand + quantity_sell; 

delimiter // 
create trigger before_total_quantity_update 
before update on product 
for each row 
begin
	set new.total_quantity = new.quantity_on_hand + new.quantity_sell; 
end //
delimiter ; 

update product 
set quantity_on_hand = 30, quantity_sell = 35 
where product_number = 'P1004';

-- 19. Create a trigger before_remark_salesman_update to update Percentage of per_remarks in a salesman
-- table (will be stored in PER_MARKS column) : per_remarks = target_achieved*100/sales_target.
alter table salesman 
add column per_remarks decimal(5,2); 

delimiter //
create trigger before_remark_salesman_update 
before update on salesman 
for each row 
begin 
	set new.per_remarks = new.target_achieved * 100 / new.sales_target;
end // 
delimiter ;

update salesman
set per_remarks = target_achieved * 100 / sales_target
where sales_target <> 0;

-- 20. Create a trigger before_product_insert to insert a product in product table.
delimiter // 
create trigger before_product_insert 
before insert on product
for each row 
begin
	if new.sell_price < new.cost_price then
		set new.sell_price = new.cost_price;
        -- Sell_price must be >= cost_price 
	end if;
end // 
delimiter ;

-- 21. Create a trigger to update the delivery status to "Delivered" when an order is marked as "Shipped".
delimiter //
create trigger after_order_shipped 
after update on salesorder 
for each row 
begin
	if new.order_status = 'Ready to ship' then 
    -- Don't have "shipped", but have "Ready to ship"
		update salesorder 
        set delivery_status = 'Delivered'
        where new.order_number = order_number; 
	end if; 
end //
delimiter ;

-- 22. Create a trigger to update the remarks for all salesmen to "Good" when a new salesman is inserted
delimiter // 
create trigger after_salesman_insert
after insert on salesman 
for each row 
begin 
	update salesman 
    set remark = 'Good'
    where new.salesman_number = salesman_number;
end // 
delimiter ;

-- 23. Create a trigger to enforce that the first digit of the pin code in the "Clients" table must be 7.
delimiter // 
create trigger before_client_insert 
before insert on clients 
for each row 
begin
	declare tmp_pincode int; 
    set tmp_pincode = pincode;
    while tmp_pincode > 10 do 
		set tmp_pincode = floor(tmp_pincode / 10);
	end while; 
    if (tmp_pincode <> 7) then
		signal sqlstate '45000'
        set message_text = 'Pincode must start with 7';
	end if;
end //
delimiter ;

-- 24. Create a trigger to update the city for a specific client to "Unknown" when the client is deleted.
alter table clients 
add column deleted_status boolean default false; 

delimiter //
create trigger before_client_delete
before delete on clients 
for each row 
begin 	
	update clients 
    set city = 'Unknown', deleted_status = true
    where old.client_number = client_number and deleted_status = false;
end //
delimiter ;

-- 25. Create a trigger to update the delivery status to "Cancelled" for corresponding order details when an order is cancelled
delimiter //
create trigger after_order_cancelled
after update on salesorder 
for each row 
begin 
	if new.order_status = 'Cancelled' then
		update salesorder
		set delivery_status = 'Cancelled'
		where new.order_number = order_number;
	end if; 
end // 
delimiter ;

-- 26. Create a trigger to update the delivery status to "Pending" for a specific order when an order is inserted
delimiter //
create trigger after_order_insert 
after insert on salesorder 
for each row 
begin
	update salesorder
    set new.delivery_status = 'Pending';
end //
delimiter ;
drop trigger after_order_insert;

-- 27. Create a trigger before_remark_salesman_update to update Percentage of per_remarks in a salesman table (will be stored in PER_MARKS column) 
-- If per_remarks >= 75%, his remarks is ‘Good’. If 50% <= per_remarks < 75%, he is 'Average'. If per_remarks <50%, he is 'Poor'.
delimiter //
create trigger before_remark_salesman_update
before update on salesman 
for each row
begin
	set new.per_remarks = new.target_achieved * 100 / new.sales_target; 
	update salesman
    set remark = case 
		when new.per_marks >= 75 then 'Good'
        when new.per_marks >= 50 then 'Average' else 'Poor'
	end;
end
delimiter ;