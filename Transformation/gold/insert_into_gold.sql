/*
========================================================================
Stored Procedure: Load gold layer tables (Silver -> Gold)
========================================================================
Script purpose:
	This stored procedure performs the ETL (Extract, Transform, load) process to
	populate the gold schema tables from the 'sivler' schema.

Actions Performed:
	-Truncates gold tables.
	-Inserts transfermed and cleansed data

Parameters:
	None. This stored procedure does not take any parameters.

Usage Example:

	EXEC load_gold_insert;

========================================================================
*/
CREATE OR ALTER PROCEDURE load_gold_insert
AS
BEGIN

	TRUNCATE TABLE Customers;
		PRINT '>>Inserting Date Into: Customers';
		INSERT INTO Customers(
			customer_id,
			first_name,
			last_name,
			phone,
			email,
			street,
			city,
			state,
			zip_code
		)
		SELECT 
			customer_id ,
			first_name,
			last_name,
			phone,
			email,
			street,
			city,
			state,
			zip_code
		FROM silver.Customers
		;
		PRINT '>>Truncating table: Stores';
		TRUNCATE TABLE Stores
		PRINT '>>Inserting Date Into: Stores';
		INSERT INTO Stores(
			store_id,
			store_name,
			phone,
			email,
			street,
			city,
			state,
			zip_code
		)
		SELECT 
			store_id ,
			store_name,
			phone,
			email,
			street,
			city,
			state,
			zip_code
		FROM silver.Stores;
		PRINT '>>Truncating table: Orders';
		TRUNCATE TABLE Orders
		PRINT '>>Inserting Date Into: Orders';
		INSERT INTO Orders(
			order_id ,
			customer_id,
			order_status,
			order_date,
			required_date,
			shipped_date ,
			store_id ,
			staff_id)
		SELECT 
			order_id ,
			customer_id,
			order_status,
			order_date,
			required_date,
			shipped_date ,
			store_id ,
			staff_id
		FROM silver.Orders;

		PRINT '>>Truncating table: Staffs';
		TRUNCATE TABLE Staffs
		PRINT '>>Inserting Date Into: Staffs';
		INSERT INTO Staffs(
			staff_id,
			first_name,
			last_name,
			email,
			phone,
			active,
			store_id,
			manager_id
		)
		SELECT 
			staff_id ,
			first_name,
			last_name,
			email,
			phone,
			active,
			store_id,
			manager_id
		FROM silver.Staffs;
		PRINT '>>Truncating table: brands';
		TRUNCATE TABLE brands
		PRINT '>>Inserting Date Into: brands';
		INSERT INTO brands(
			brand_id,
			brand_name
		)
		SELECT 
			brand_id,
			brand_name
		FROM silver.brands;

		PRINT '>>Truncating table: Categories';
		TRUNCATE TABLE Categories
		PRINT '>>Inserting Date Into: Categories';
		INSERT INTO Categories(
			category_id,
			category_name
		)
		SELECT 
			category_id,
			category_name
		FROM silver.Categories;

		PRINT '>>Truncating table: Products';
		TRUNCATE TABLE Products
		PRINT '>>Inserting Date Into: Products';
		INSERT INTO Products(
			product_id,
			product_name,
			brand_id,
			category_id,
			model_year,
			list_price
		)
		SELECT 
			product_id,
			product_name,
			brand_id,
			category_id,
			model_year,
			list_price
		FROM silver.Products;

		PRINT '>>Truncating table: stocks';
		TRUNCATE TABLE stocks
		PRINT '>>Inserting Date Into: stocks';
		INSERT INTO stocks(
			store_id,
			product_id,
			quantity
		)

		SELECT 
			store_id,
			product_id,
			quantity
		FROM silver.stocks

		PRINT '>>Truncating table: order_items';
		TRUNCATE TABLE order_items
		PRINT '>>Inserting Date Into: order_items';
		INSERT INTO order_items(
			order_id,
			item_id,
			product_id,
			quantity,
			list_price,
			discount
		)
		SELECT 
			order_id,
			item_id,
			product_id,
			quantity,
			list_price,
			discount
		FROM silver.order_items;
END;
