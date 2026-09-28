USE salemanagement;

-- II --
INSERT INTO salesman (Salesman_Number, Salesman_Name, Address, City, Pincode, Province, Salary, Sales_Target, Target_Achieved, Phone)
VALUES 
('S007','Quang','Chanh My','Da Lat',700032,'Lam Dong',25000,90,95,'0900853487'), 
('S008','Hoa','Hoa Phu','Thu Dau Mot',700051,'Binh Duong',13500,50,75,'0998213659');

INSERT INTO salesorder
VALUES 
('O20015','2022-05-12','C108','S007','On Way', '2022-05-15','Successful'),
('O20016','2022-05-16','C109','S008','Ready to Ship',null,'In Process');

INSERT INTO salesorderdetails (Order_Number, Product_Number, Order_Quantity)
VALUES 
('O20015','P1008',15),
('O20015','P1007',10),
('O20016','P1007',20),
('O20016','P1003',5);

-- III -- 
SELECT DISTINCT cl1.Client_Name
FROM clients cl1
JOIN clients cl2 ON cl1.City = cl2.City AND cl1.Client_Number <> cl2.Client_Number;

SELECT cl.City, cl.Client_Name, sm.Salesman_Name
FROM clients cl
JOIN salesman sm ON cl.City = sm.City
WHERE cl.City = 'Thu Dau Mot';

SELECT cl.Client_Name, so.Client_Number, so.Order_Number, so.Salesman_Number, sod.Product_Number
FROM salesorder so
JOIN clients cl ON cl.Client_Number = so.Client_Number
JOIN salesorderdetails sod on sod.Order_Number = so.Order_Number;

SELECT so.Client_Number, cl.Client_Name, so.Order_Number
FROM salesorder so
JOIN clients cl ON cl.Client_Number = so.Client_Number;

SELECT cl.Client_Number, cl.Client_Name, COUNT(so.Order_Number) AS Total_Orders
FROM clients cl 
JOIN salesorder so ON cl.Client_Number = so.Client_Number
WHERE so.Order_Status = 'Successful'
GROUP BY cl.Client_Number, cl.Client_Name;

SELECT cl.Client_Number, cl.Client_Name
FROM clients cl 
JOIN salesorder so ON cl.Client_Number = so.Client_Number
WHERE so.Order_Status = 'Successful'
GROUP BY cl.Client_Number, cl.Client_Name
HAVING COUNT(so.Order_Number) > 2;

SELECT cl.Client_Number, cl.Client_Name
FROM clients cl 
JOIN salesorder so ON cl.Client_Number = so.Client_Number
WHERE so.Order_Status = 'Successful'
GROUP BY cl.Client_Number, cl.Client_Name
HAVING COUNT(so.Order_Number) > 1
ORDER BY cl.Client_Number DESC;

SELECT sm.Salesman_Name
FROM salesman sm 
JOIN salesorder so ON sm.Salesman_Number = so.Salesman_Number
JOIN salesorderdetails sod ON so.Order_Number = sod.Order_Number
GROUP BY sm.Salesman_Name
HAVING SUM(sod.Order_Quantity) > 20;

SELECT cl.Client_Number, cl.Client_Name, so.Order_Number
FROM clients cl 
JOIN salesorder so ON cl.Client_Number = so.Client_Number
WHERE so.Order_Status = 'Cancelled';

SELECT cl.Client_Number, cl.Client_Name, COUNT(so.Order_Number) AS Successful_Orders
FROM clients cl 
JOIN salesorder so ON cl.Client_Number = so.Client_Number
WHERE cl.Client_Number = 'C101' AND so.Order_Status = 'Successful'
GROUP BY cl.Client_Number, cl.Client_Name;

SELECT sod.Product_Number, COUNT(DISTINCT so.Order_Number) AS Total_Client_Orders
FROM salesorder so
JOIN salesorderdetails sod ON so.Order_Number = sod.Order_Number
GROUP BY sod.Product_Number;

SELECT sod.Product_Number
FROM salesorder so
JOIN salesorderdetails sod ON sod.Order_Number = so.Order_Number
GROUP BY sod.Product_Number
HAVING COUNT(DISTINCT so.Client_Number) > 2
ORDER BY sod.Product_Number DESC;

-- IV --
SELECT Salesman_Name
FROM salesman
WHERE Salary IN (
				SELECT MAX(Salary)
                FROM salesman
                WHERE Salary < (SELECT MAX(Salary) FROM salesman)
);

SELECT Salesman_Name
FROM salesman
WHERE Salary IN (
				SELECT MIN(Salary)
                FROM salesman
                WHERE Salary > (SELECT MIN(Salary) FROM salesman)
);

SELECT Salesman_Name, Salary
FROM salesman
WHERE Salary > (
				SELECT Salary
                FROM salesman
                WHERE Salesman_Number = 'S001'
);


SELECT DISTINCT sm.Salesman_Name
FROM salesman sm
WHERE EXISTS (
			SELECT 1
			FROM salesorder so
			JOIN salesorderdetails sod ON so.Order_Number = sod.Order_Number
			WHERE so.Salesman_Number = sm.Salesman_Number AND sod.Product_Number = 'P1002'
);

SELECT sm.Salesman_Name
FROM salesman sm
WHERE EXISTS (
    SELECT 1
    FROM salesorder so
    WHERE so.Salesman_Number = sm.Salesman_Number
	AND so.Client_Number = 'C108'
	AND so.Delivery_Status = 'Delivered'
);

SELECT pd.Product_Name
FROM product pd
WHERE pd.Product_Number = ANY (
    SELECT Product_Number
    FROM salesorderdetails sod
    WHERE sod.Order_Quantity = 5
);

SELECT DISTINCT sm.Salesman_Name, sm.Salesman_Number
FROM salesman sm
WHERE sm.Salesman_Number IN (
	SELECT so.Salesman_Number
    FROM salesorder so
    JOIN salesorderdetails sod ON so.Order_Number = sod.Order_Number
    JOIN product pd ON sod.Product_Number = pd.Product_Number
    WHERE pd.Product_Name IN ('Pen', 'TV', 'Laptop')
);

SELECT DISTINCT sm.Salesman_Name
FROM salesman sm
WHERE EXISTS (
	SELECT 1
    FROM salesorder so
    JOIN salesorderdetails sod ON so.Order_Number = sod.Order_Number
    JOIN product pd ON sod.Product_Number = pd.Product_Number
    WHERE so.Salesman_Number = sm.Salesman_Number
    AND pd.Sell_Price < 800
    AND pd.Quantity_On_Hand > 50
);

SELECT Salesman_Name, Salary
FROM salesman 
WHERE Salary > ANY (
	SELECT AVG(Salary)
    FROM Salesman
);

SELECT Client_Name, Amount_Paid
FROM clients
WHERE Amount_Paid > (
	SELECT AVG(Amount_Paid)
    FROM clients
);

-- V --
SELECT pd.Sell_Price
FROM product pd
JOIN salesorderdetails sod ON pd.Product_Number = sod.Product_Number
JOIN salesorder so ON sod.Order_Number = so.Order_Number
JOIN clients cl ON so.Client_Number = cl.Client_Number
WHERE cl.Client_Name = 'Le Xuan';

SELECT pd.Product_Name, cl.Client_Name, cl.Amount_Due
FROM salesorder so
JOIN salesorderdetails sod ON sod.Order_Number = so.Order_Number
JOIN product pd ON pd.Product_Number = sod.Product_Number
JOIN clients cl ON so.Client_Number = cl.Client_Number
WHERE so.Delivery_Status = 'Delivered';

SELECT pd.Product_Name, cl.Client_Name, cl.Amount_Due
FROM salesorder so
JOIN clients cl ON so.Client_Number = cl.Client_Number
JOIN salesorderdetails sod ON sod.Order_Number = so.Order_Number
JOIN product pd ON pd.Product_Number = sod.Product_Number
WHERE so.Delivery_Status = 'Delivered';

SELECT sm.Salesman_Name, pd.Product_Name
FROM salesman sm
JOIN salesorder so ON so.Salesman_Number = sm.Salesman_Number
JOIN salesorderdetails sod ON sod.Order_Number = so.Order_Number
JOIN product pd ON pd.Product_Number = sod.Product_Number
WHERE so.Order_Status = 'Cancelled';

SELECT pd.Product_Name, pd.Sell_Price, so.Delivery_Status
FROM product pd
JOIN salesorderdetails sod ON pd.Product_Number = sod.Product_Number
JOIN salesorder so ON sod.Order_Number = so.Order_Number
JOIN clients cl ON so.Client_Number = cl.Client_Number
WHERE cl.Client_Name = 'Nguyen Thanh';

SELECT cl.Client_Name, pd.Product_Name, pd.Sell_Price, sm.Salesman_Name, so.Delivery_Status, sod.Order_Quantity
FROM clients cl
JOIN salesorder so ON cl.Client_Number = so.Client_Number
JOIN salesman sm ON sm.Salesman_Number = so.Salesman_Number
JOIN salesorderdetails sod ON sod.Order_Number = so.Order_Number
JOIN product pd ON sod.Product_Number = pd.Product_Number;

SELECT sm.Salesman_Name, pd.Product_Name, so.Order_Date
FROM salesman sm
JOIN salesorder so ON sm.Salesman_Number = so.Salesman_Number
JOIN salesorderdetails sod ON sod.Order_Number = so.Order_Number
JOIN product pd ON sod.Product_Number = pd.Product_Number
WHERE so.Order_Status = 'Successful' AND so.Delivery_Status <> 'Delivered';

SELECT cl.Client_Name, pd.Product_Name
FROM clients cl
JOIN salesorder so ON cl.Client_Number = so.Client_Number
JOIN salesorderdetails sod ON sod.Order_Number = so.Order_Number
JOIN product pd ON sod.Product_Number = pd.Product_Number
WHERE so.Delivery_Status = 'On Way';

SELECT Salary, Salesman_Name
FROM salesman
WHERE Salary = (
				SELECT MAX(Salary) 
				FROM salesman
);

SELECT Salary, Salesman_Name
FROM salesman
WHERE Salary IN (
				SELECT MIN(Salary)
                FROM salesman
                WHERE Salary > (SELECT MIN(Salary) FROM salesman)
);

SELECT DISTINCT Product_Name
FROM product
WHERE Product_Number = ANY (
	SELECT Product_Number
    FROM salesorderdetails
    WHERE Order_Quantity > 9
);

SELECT cl.Client_Name
FROM clients cl
JOIN salesorder so ON cl.Client_Number = so.Client_Number
JOIN salesorderdetails sod ON so.Order_Number = sod.Order_Number
GROUP BY cl.Client_Name, sod.Product_Number
HAVING COUNT(sod.Order_Number) > 1;

SELECT Salesman_Name, Salesman_Number, Salary
FROM salesman
WHERE Salary < (
	SELECT AVG(Salary) 
    FROM salesman
)
AND City = 'Thu Dau Mot';

SELECT Salesman_Name, Salesman_Number, Salary
FROM salesman
WHERE Salary > ALL (
	SELECT Salary 
    FROM salesman
    WHERE Salesman_Number IN (
		SELECT Salesman_Number
        FROM salesorder
        WHERE Order_Status = 'Cancelled'
	)
)
ORDER BY Salary ASC;

SELECT DISTINCT Salary
FROM salesman
ORDER BY Salary DESC
LIMIT 1 OFFSET 3;

SELECT DISTINCT Salary
FROM salesman
ORDER BY Salary ASC
LIMIT 1 OFFSET 2;