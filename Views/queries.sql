--1
CREATE OR ALTER VIEW vw_Customer_Profile   
AS
	SELECT
        o.customer_id,
        SUM(oi.list_price * oi.quantity * (1 - oi.discount)) AS TotalSpendByCustomer,
        COUNT(DISTINCT o.order_id) AS NumOrdersByCustomer,
        CAST(SUM(oi.list_price * oi.quantity * (1 - oi.discount)) AS DECIMAL(10,2)) 
            / COUNT(DISTINCT o.order_id) AS AOVPerCustomer
    FROM Orders o
    LEFT JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY o.customer_id


SELECT * FROM vw_Customer_Profile


--2
CREATE OR ALTER VIEW vw_InventoryStatus
AS
SELECT product_id, SUM(quantity) as TotalProducts
FROM stocks
GROUP BY product_id
HAVING(SUM(quantity))<10

--3
CREATE OR ALTER VIEW vw_RegionalTrends
AS
SELECT Customers.city
,SUM(order_items.list_price * order_items.quantity * (1 - order_items.discount)) AS revenue
FROM order_items
LEFT JOIN Orders ON order_items.order_id = Orders.order_id
LEFT JOIN Customers ON Orders.customer_id = Customers.customer_id
GROUP BY Customers.city

--4
CREATE OR ALTER VIEW vw_SalesByCategory
AS
SELECT 
Products.category_id
, SUM(order_items.quantity) AS Cat_Volume
, SUM(order_items.list_price * order_items.quantity * (1 - order_items.discount)) AS revenue
, SUM(order_items.list_price * order_items.quantity * order_items.discount) AS DiscountMargin
FROM Orders
LEFT JOIN order_items ON Orders.order_id = order_items.order_id
LEFT JOIN Products ON order_items.product_id = Products.product_id
GROUP BY Products.category_id

--5
CREATE OR ALTER VIEW vw_StaffPerformance
AS
SELECT Orders.staff_id
,Staffs.firt_name+' '+Staffs.last_name AS StaffsName
,SUM(order_items.list_price * order_items.quantity * (1 - order_items.discount)) AS revenue
FROM Orders
LEFT JOIN order_items ON Orders.order_id=order_items.order_id
LEFT JOIN Staffs ON Orders.staff_id = Staffs.staff_id
GROUP BY Orders.staff_id, Staffs.firt_name+' '+Staffs.last_name 

--6
CREATE OR ALTER VIEW vw_TopSellingProducts
AS
	WITH SalesByProduct AS (
		SELECT 
			product_id,
			SUM(list_price * quantity * (1 - discount)) AS totalsale
		FROM order_items
		GROUP BY product_id
	)
	SELECT
		product_id,
		totalsale,
		DENSE_RANK() OVER (ORDER BY totalsale DESC) AS Rank_
	FROM SalesByProduct;

--7
CREATE OR ALTER VIEW vw_StoreSalesSummary AS
SELECT 
    o.store_id,
    SUM(oi.list_price * oi.quantity * (1-oi.discount)) AS TotalRevenueByStore,
    COUNT(DISTINCT o.order_id) AS NumOfOrdersByStore,
    CAST(SUM(oi.list_price * oi.quantity * (1-oi.discount)) AS DECIMAL(10,2)) 
        / COUNT(DISTINCT o.order_id) AS AOV
FROM Orders o
LEFT JOIN order_items oi 
    ON o.order_id = oi.order_id
GROUP BY o.store_id;


SELECT * FROM vw_StoreSalesSummary 
ORDER BY store_id
