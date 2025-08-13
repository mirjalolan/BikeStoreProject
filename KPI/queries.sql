-- KPI parametrs
---------------------------------------------------
DECLARE @StoreID INT = 1;
DECLARE @StartDate DATE = '2018-01-01';
DECLARE @EndDate DATE = '2018-12-31';
DECLARE @Year1 INT = 2017;
DECLARE @Year2 INT = 2018;
DECLARE @Threshold INT = 5;
DECLARE @CustomerID INT = 7;

---------------------------------------------------
-- 1. Total Revenue
---------------------------------------------------
SELECT SUM(total_revenue) AS TotalRevenue
FROM vw_StoreSalesSummary
WHERE order_date BETWEEN @StartDate AND @EndDate;

EXEC sp_CalculateStoreKPI
    @StoreID = @StoreID,
    @StartDate = @StartDate,
    @EndDate = @EndDate;

---------------------------------------------------
-- 2. Average Order Value (AOV)
---------------------------------------------------
SELECT store_name, avg_order_value
FROM vw_StoreSalesSummary
WHERE order_date BETWEEN @StartDate AND @EndDate
ORDER BY avg_order_value DESC;

EXEC sp_CalculateStoreKPI
    @StoreID = @StoreID,
    @StartDate = @StartDate,
    @EndDate = @EndDate;

---------------------------------------------------
-- 3. Inventory Turnover
---------------------------------------------------
SELECT inv.store_name,
       SUM(sales_qty.total_sold) / NULLIF(SUM(inv.stock_quantity),0) AS InventoryTurnover
FROM vw_InventoryStatus inv
JOIN (
    SELECT store_id, product_id, SUM(quantity) AS total_sold
    FROM order_items oi
    JOIN orders o ON oi.order_id = o.order_id
    WHERE o.order_date BETWEEN @StartDate AND @EndDate
    GROUP BY store_id, product_id
) sales_qty
  ON inv.store_id = sales_qty.store_id 
 AND inv.product_id = sales_qty.product_id
GROUP BY inv.store_name;

EXEC sp_GenerateRestockList
    @StoreID = @StoreID,
    @Threshold = @Threshold   

---------------------------------------------------
-- 4. Revenue by Store
---------------------------------------------------
SELECT store_name, total_revenue
FROM vw_StoreSalesSummary
WHERE order_date BETWEEN @StartDate AND @EndDate



EXEC sp_CompareSalesYearOverYear
    @StoreID = @StoreID,
    @Year1 = @Year1,
    @Year2 = @Year2;

---------------------------------------------------
-- 5. Gross Revenue by Category
---------------------------------------------------
SELECT category_name, total_revenue
FROM vw_SalesByCategory
WHERE order_date BETWEEN @StartDate AND @EndDate
ORDER BY total_revenue DESC;

-- нет отдельной SP для категорий

---------------------------------------------------
-- 6. Sales by Brand
---------------------------------------------------
SELECT brand_name,
       SUM(total_revenue) AS Revenue
FROM vw_TopSellingProducts
WHERE order_date BETWEEN @StartDate AND @EndDate
GROUP BY brand_name
ORDER BY Revenue DESC;

-- нет отдельной SP для брендов

---------------------------------------------------
-- 7. Staff Revenue Contribution
---------------------------------------------------
SELECT first_name, last_name, store_name, total_revenue
FROM vw_StaffPerformance
WHERE order_date BETWEEN @StartDate AND @EndDate
ORDER BY total_revenue DESC;

EXEC sp_CalculateStoreKPI
    @StoreID = @StoreID,
    @StartDate = @StartDate,
    @EndDate = @EndDate;

---------------------------------------------------
-- 8. Customer Profile
---------------------------------------------------
EXEC sp_GetCustomerProfile
    @CustomerID = @CustomerID;


