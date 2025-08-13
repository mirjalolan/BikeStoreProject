--•	sp_CalculateStoreKPI: Input store ID, return full KPI breakdown
create procedure sp_CalculateStoreKPI @store_id int
as 
begin
SET NOCOUNT ON
SELECT 
    o.store_id,
    SUM(oi.list_price * oi.quantity * (1-oi.discount)) AS TotalRevenueByStore,
    COUNT(DISTINCT o.order_id) AS NumOfOrdersByStore,
    CAST(SUM(oi.list_price * oi.quantity * (1-oi.discount)) AS DECIMAL(10,2)) 
        / COUNT(DISTINCT o.order_id) AS AOV
FROM Orders o
LEFT JOIN order_items oi 
    ON o.order_id = oi.order_id
where o.store_id = @store_id
GROUP BY o.store_id;
end


--•	sp_GenerateRestockList: Output low-stock items per store
create procedure sp_GenerateRestockList @inventory_limit int
as 
begin
select store_id, sum(quantity)as stock_level from stocks
group by store_id
having sum(quantity) < @inventory_limit
end

--•	sp_CompareSalesYearOverYear: Compare sales between two years
CREATE PROCEDURE sp_CompareSalesQuantityYearOverYear
    @Year1 INT,
    @Year2 INT
AS
BEGIN
    SET NOCOUNT ON;

    WITH QtyByYear AS (
        SELECT 
            o.store_id,
            YEAR(o.order_date) AS SalesYear,
            SUM(oi.quantity) AS TotalQuantity
        FROM Orders o
        JOIN order_items oi 
            ON o.order_id = oi.order_id
        WHERE YEAR(o.order_date) IN (@Year1, @Year2)
        GROUP BY o.store_id, YEAR(o.order_date)
    )
    SELECT 
        q1.store_id,
        q1.TotalQuantity AS Qty_Year1,
        q2.TotalQuantity AS Qty_Year2,
        q2.TotalQuantity - q1.TotalQuantity AS YoY_Change,
        CAST(
            (q2.TotalQuantity - q1.TotalQuantity) * 100.0 / NULLIF(q1.TotalQuantity, 0) 
            AS DECIMAL(10,2)
        ) AS YoY_Percent_Change
    FROM QtyByYear q1
    LEFT JOIN QtyByYear q2
        ON q1.store_id = q2.store_id
       AND q2.SalesYear = @Year2
    WHERE q1.SalesYear = @Year1
    ORDER BY YoY_Percent_Change DESC;
END;

exec sp_CompareSalesQuantityYearOverYear @Year1 = 2016, @Year2 = 2018

--•	sp_GetCustomerProfile: Returns total spend, orders, and most bought items
CREATE PROCEDURE sp_GetCustomerProfile
    @customer_id INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        o.customer_id,
        SUM(oi.list_price * oi.quantity * (1 - oi.discount)) AS TotalSpend,
        COUNT(DISTINCT o.order_id) AS TotalOrders
    FROM Orders AS o
    JOIN order_items AS oi 
        ON o.order_id = oi.order_id
    WHERE o.customer_id = @customer_id
    GROUP BY o.customer_id;
    SELECT TOP 5
        oi.product_id,
        SUM(oi.quantity) AS TotalQuantityBought
    FROM Orders AS o
    JOIN order_items AS oi 
        ON o.order_id = oi.order_id
    WHERE o.customer_id = @customer_id
    GROUP BY oi.product_id
    ORDER BY TotalQuantityBought DESC;
END;
