USE salemanagement;

SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE TABLE_NAME = 'salesman';

CREATE TABLE ProductCost AS
SELECT Product_Name, Cost_Price
FROM Product;

SELECT Product_Name, Sell_Price, Cost_Price, 
	   ((Sell_Price - Cost_Price) / Cost_Price) * 100 AS Profit_Percentage
FROM Product;

SELECT Salesman_Number, Salesman_Name, Sales_Target, Target_Achieved,
	   CASE
			WHEN Target_Achieved >= Sales_Target * 0.75 THEN 'Good'
            ELSE 'Average'
		END AS Remarks
FROM Salesman;

SELECT Salesman_Number, Salesman_Name, Sales_Target, Target_Achieved,
	   CASE
			WHEN Target_Achieved < Sales_Target * 0.75 THEN 'Average'
            ELSE 'Good'
		END AS Remarks
FROM Salesman;

SELECT Salesman_Number, Salesman_Name, Sales_Target, Target_Achieved,
	   CASE
			WHEN Target_Achieved <= Sales_Target * 0.5 THEN 'Poor'
            ELSE NULL
		END AS Remarks
FROM Salesman;

SELECT Product_Number, Product_Name, Quantity_On_Hand, Quantity_Sell, 
	   (Quantity_On_Hand + Quantity_Sell) AS Total_Quantity
FROM Product;

ALTER TABLE Product
ADD COLUMN Total_Quantity INT;
UPDATE Product
SET Total_Quantity = Quantity_On_Hand + Quantity_Sell;
SELECT * FROM product;

ALTER TABLE Product ADD COLUMN Discount_Rate INT;
UPDATE Product
SET Discount_Rate = 
    CASE 
        WHEN Quantity_On_Hand > 10 THEN 10
        ELSE 5
    END;
SELECT * FROM product;

UPDATE Product
SET Discount_Rate = 
    CASE 
        WHEN Quantity_On_Hand >= 20 THEN 10
        WHEN Quantity_On_Hand >= 10 AND Quantity_On_Hand < 20 THEN 5
        WHEN Quantity_On_Hand > 5 AND Quantity_On_Hand < 10 THEN 3
        ELSE 0
    END;
SELECT * FROM product;

UPDATE clients
SET Pincode = CONCAT('7', SUBSTRING(Pincode, 2))
WHERE Pincode NOT LIKE '7%';