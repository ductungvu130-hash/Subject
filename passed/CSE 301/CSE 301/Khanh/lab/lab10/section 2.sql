USE electronicstore;

-- q1 --
INSERT INTO product
VALUES ('P006','Apple Vision Pro',null,'Apple','Tablet');
INSERT INTO storestock
VALUES ('SS008','S001','P006',50);

-- q2 --
UPDATE storestock ss
JOIN (
    SELECT od.ProductID, SUM(od.Quantity) AS total_sold
    FROM orderdetails od
    GROUP BY od.ProductID
) AS sales_summary
ON ss.ProductID = sales_summary.ProductID
SET ss.Quantity = ss.Quantity - sales_summary.total_sold;

-- q3 --
SELECT st.StoreName, p.ProductName, SUM(od.Quantity) AS Total_Quantity_Sold
FROM orderdetails od
JOIN ordertable ot ON od.OrderID = ot.OrderID
JOIN store st ON st.StoreID = ot.StoreID
JOIN product p ON od.ProductID = p.ProductID
WHERE od.SellingPrice > 20000000
GROUP BY st.StoreName, p.ProductName
HAVING SUM(od.Quantity) > 2;