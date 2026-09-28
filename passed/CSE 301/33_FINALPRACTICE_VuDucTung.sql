SELECT
    product_name,
    category,
    unit_price
FROM   product
WHERE  category IN ('Laptop', 'Tablet')
  AND  unit_price < 25000000
ORDER BY unit_price ASC;


SELECT
    c.full_name,
    COUNT(oh.order_id)    AS total_orders,
    SUM(oh.total_amount)  AS total_spent
FROM   customer     c
JOIN   order_header oh ON c.customer_id = oh.customer_id
GROUP BY c.customer_id, c.full_name
HAVING   COUNT(oh.order_id) >= 2
ORDER BY total_spent DESC;

SELECT DISTINCT
    c.customer_id, c.full_name, c.email
FROM
    customer c
WHERE
    c.customer_id IN (
		SELECT oh.customer_id
        FROM
            order_header oh
		JOIN order_detail od ON od.order_id = oh.order_id
		JOIN product p ON p.product_id = od.product_id
        WHERE p.category = 'Laptop'
        )
        OR 
        c.customer_id IN (
        SELECT  oh.customer_id
        FROM order_header oh
        GROUP BY oh.customer_id
        HAVING SUM(oh.total_amount) > 100000000
        );
        
        
CREATE VIEW v_order_invoice AS
SELECT 
	oh.order_id ,
    c.full_name AS customer_name, 
    oh.order_date,
    (SELECT SUM(od.quantity * od.unit_price) 
	 FROM order_detail od
     WHERE od.order_id = oh.order_id
    )AS total_product_amount,
    
    (SELECT IFNULL(SUM(p.amount),0) 
     FROM payment p
     WHERE p.order_id = oh.order_id
    ) AS total_payment,
    
    (
    (SELECT SUM(od.quantity * od.unit_price) 
	 FROM order_detail od
     WHERE od.order_id = oh.order_id)
     - 
     (SELECT IFNULL(SUM(p.amount),0) 
     FROM payment p
     WHERE p.order_id = oh.order_id)
     ) AS balance
     
FROM order_header oh
JOIN customer c ON c.customer_id = oh.customer_id;

SELECT * FROM v_order_invoice ;

DELIMITER $$

CREATE PROCEDURE sp_create_order (
	IN p_customer_id INT,
    IN p_product_id INT,
	IN p_quantity INT
)

BEGIN
	DECLARE v_stock INT;
    DECLARE v_price DECIMAL(15,2);
    DECLARE v_order_id INT;
    
    SELECT p.stock_quantity, p.unit_price
    INTO v_stock , v_price
    FROM product p
    WHERE p.product_id = p_product_id;
    
    IF v_stock < p_quantity THEN
		SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'Insufficient stock';
    END IF;
    
    INSERT INTO order_header(customer_id, order_date, status, total_amount)
	VALUES(p_customer_id, curdate(), 'pending', 0);
    
    SET v_order_id = last_insert_id();
    
    INSERT INTO order_detail(order_id, product_id, quantity, unit_price)
    VALUES(v_order_id, p_product_id, p_quantity, v_price);
	
    UPDATE product
    SET stock_quantity = stock_quantity- p_quantity
    WHERE product_id = p_product_id;
    
END$$

DELIMITER ;
        