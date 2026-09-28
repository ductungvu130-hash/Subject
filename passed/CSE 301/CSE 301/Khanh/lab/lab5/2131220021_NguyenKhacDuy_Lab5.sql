USE salemanagement;

-- Q1 --
-- a --
SELECT * 
FROM clients
WHERE Province = 'Binh Duong';

SELECT Client_Number, Client_Name 
FROM clients
WHERE Province <> 'Ha Noi';

SELECT Product_Name
FROM product
WHERE Quantity_On_Hand < 25;

SELECT *
FROM salesman
WHERE Sales_Target <= Target_Achieved;

SELECT Salesman_Name, City
FROM salesman
WHERE Salary NOT BETWEEN 10000 AND 17000;

SELECT Order_Date, Client_Number
FROM salesorder
WHERE Order_Date BETWEEN '2022-01-01' AND '2022-02-15';

-- b --
SELECT City
FROM clients
WHERE City LIKE 'N%';

SELECT *
FROM clients
WHERE Client_Name LIKE '%u_';

SELECT City
FROM clients
WHERE City LIKE 'D%n';

SELECT *
FROM clients
WHERE Client_Name NOT LIKE '%h';

SELECT *
FROM clients
WHERE City IN ('Ho Chi Minh', 'Hanoi', 'Da Lat');

SELECT *
FROM clients
WHERE City NOT IN ('Ho Chi Minh', 'Hanoi', 'Da Lat');

SELECT *
FROM clients
WHERE Amount_Due > 3000;

SELECT Client_Name, Province
FROM clients
WHERE Amount_Due = 0;

SELECT *
FROM clients
WHERE Amount_Paid BETWEEN 10000 AND 13000;

SELECT Product_Name, Sell_Price
FROM product;

SELECT Product_Name, Quantity_On_Hand
FROM product
WHERE Product_Name = 'TV';

SELECT *
FROM salesman
WHERE Salary BETWEEN 10000 AND 20000
AND Sales_Target <= Target_Achieved;

SELECT AVG(Salary) AS Avg_Salary
FROM salesman;

-- c --
SELECT Salesman_Name, Salary
FROM salesman
WHERE Salary = (SELECT MAX(Salary) FROM salesman);

SELECT Salesman_Name, Salary
FROM salesman
WHERE Salary = (SELECT MIN(Salary) FROM salesman);

SELECT COUNT(*) AS Total_Salespeople
FROM salesman;

SELECT SUM(Salary) AS Total_Salary
FROM salesman;

-- d --
SELECT * 
FROM salesman
ORDER BY Salary ASC;

SELECT Salesman_Name, Phone
FROM salesman
ORDER BY Target_Achieved ASC, City DESC;

SELECT Salesman_Name
FROM salesman
ORDER BY Salesman_Name DESC
LIMIT 3;

SELECT Salary, Salesman_Name
FROM salesman
WHERE Salary = (SELECT MAX(Salary) FROM Salesman);

SELECT Salary, Salesman_Name
FROM salesman
WHERE Salary = (SELECT MIN(Salary) FROM Salesman WHERE Salary > (SELECT MIN(Salary) FROM Salesman));

SELECT *
FROM salesorder
LIMIT 5;

SELECT *
FROM salesorder
LIMIT 5, 10;

-- e --
SELECT Province, COUNT(*) AS Clients_Number
FROM clients
GROUP BY Province
HAVING COUNT(*) > 1
ORDER BY Clients_Number DESC;

SELECT * 
FROM clients
WHERE Client_Number IN (SELECT Client_Number
						FROM salesorder
						GROUP BY Client_Number
                        HAVING COUNT(Order_Number) > 1);

-- Q2 --
SELECT *
FROM salesman
WHERE Sales_Target > Target_Achieved;

SELECT *
FROM salesman
WHERE Salary BETWEEN 20000 AND 30000 AND Sales_Target > Target_Achieved;

SELECT Client_Name
FROM clients
WHERE Client_Name LIKE '_r%' OR Client_Name LIKE '%a_';

SELECT * 
FROM clients
WHERE City LIKE 'D%' AND LENGTH(City) >= 3;

SELECT Salesman_Name, Salary, Target_Achieved
FROM salesman
ORDER BY Target_Achieved DESC;

SELECT Product_Name, Cost_Price, Sell_Price
FROM product
ORDER BY Quantity_On_Hand ASC;

SELECT *
FROM clients
ORDER BY City DESC, Amount_Due DESC;

SELECT * 
FROM salesorder
ORDER BY Order_Date DESC
LIMIT 5;

SELECT COUNT(DISTINCT pincode) AS Total_Pincode
FROM clients;

SELECT COUNT(*) AS Total_BD_Clients
FROM clients
WHERE Province = 'Binh Duong';

SELECT Province, COUNT(*) AS Total_Clients
FROM clients
GROUP BY Province
HAVING COUNT(*) > 3;

SELECT p.Product_Number, p.Product_Name, COUNT(o.Order_Quantity) AS Total_Sell
FROM product p
JOIN salesorderdetails o ON p.Product_Number = o.Product_Number
GROUP BY p.Product_Number, p.Product_Name
HAVING COUNT(o.Order_Quantity) > 1
ORDER BY Total_Sell ASC;

SELECT *
FROM product
WHERE Quantity_On_Hand > 20 AND Quantity_On_Hand < (SELECT AVG(Quantity_On_Hand) FROM product);