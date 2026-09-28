ALTER TABLE clients
ADD CONSTRAINT chk_amount CHECK (Amount_Paid >=0 AND Amount_Due >=0);

ALTER TABLE clients DROP CONSTRAINT chk_pincode;

ALTER TABLE clients DROP CHECK chk_pincode;

ALTER TABLE Product ADD CONSTRAINT unique_sell_price UNIQUE (Sell_Price);
ALTER TABLE Product ADD CONSTRAINT unique_cost_price UNIQUE (Cost_Price);
DESCRIBE product;

ALTER TABLE Product DROP CONSTRAINT unique_sell_price;
ALTER TABLE Product DROP CONSTRAINT unique_cost_price;
DESCRIBE product;

UPDATE salesorder
SET Delivery_Status = 'Delivered'
WHERE Order_Number IN (
	SELECT Order_Number FROM salesorderdetails WHERE Product_Number = 'P1007'
);
SELECT * FROM salesorder;

UPDATE clients
SET Address = 'Phu Hoa', City = 'Thu Dau Mot'
WHERE Client_Number = 'C104';
SELECT * FROM clients;

ALTER TABLE product ADD COLUMN Exp_Date DATE;
SELECT * FROM product;

ALTER TABLE clients ADD COLUMN Phone VARCHAR(15);
SELECT * FROM clients;

ALTER TABLE salesman ADD COLUMN Remarks VARCHAR(15);
UPDATE salesman
SET Remarks = 'Good';
SELECT * FROM salesman;

UPDATE salesman
SET Remarks = 'Bad'
WHERE Salesman_Number = 'S004';
SELECT * FROM salesman;

ALTER TABLE clients
MODIFY Phone VARCHAR(10);
DESCRIBE clients;

ALTER TABLE clients DROP COLUMN Phone;
SELECT * FROM clients;

UPDATE product
SET Sell_Price = '120'
WHERE Product_Name = 'Mouse';
SELECT * FROM product;

UPDATE clients
SET City = 'Ben Cat'
WHERE Client_Number = 'C104';
SELECT * FROM clients;

ALTER TABLE salesorderdetails ADD COLUMN Discount INT;
UPDATE salesorderdetails
SET Discount =
	CASE
		WHEN Order_Quantity > 5 AND Order_Quantity <= 10 then 10
        WHEN Order_Quantity > 10 then 15
        ELSE 0
	END;
SELECT * FROM salesorderdetails;
        