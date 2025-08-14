/*
========================================================================
Stored Procedure: Load Silver layer tables (Bronze -> Silver)
========================================================================
Script purpose:
	This stored procedure performs the ETL (Extract, Transform, load) process to
	populate the 'silver' schema tables from the 'bronze' schema.

Actions Performed:
	-Truncates Silver tables.
	-Inserts transfermed and cleansed data

Parameters:
	None. This stored procedure does not take any parameters.

Usage Example:

	EXEC silver.load_silver_insert;

========================================================================
*/

CREATE OR ALTER PROCEDURE silver.load_silver_insert AS
BEGIN
	PRINT '=============================================';
	PRINT '>>Loading Silver Layer>>>>>>>>>>>>>>>>>>>>>>>';
	PRINT '=============================================';

	PRINT '>>Truncating table: silver.Customers';
	TRUNCATE TABLE silver.Customers;
	PRINT '>>Inserting Date Into: silver.Customers';
	INSERT INTO silver.Customers(
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
	FROM bronze.Customers
	;
	PRINT '>>Truncating table: silver.Stores';
	TRUNCATE TABLE silver.Stores
	PRINT '>>Inserting Date Into: silver.Stores';
	INSERT INTO silver.Stores(
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
	FROM bronze.Stores;
	PRINT '>>Truncating table: silver.Orders';
	TRUNCATE TABLE silver.Orders
	PRINT '>>Inserting Date Into: silver.Orders';
	INSERT INTO silver.Orders(
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
	FROM bronze.Orders;

	PRINT '>>Truncating table: silver.Staffs';
	TRUNCATE TABLE silver.Staffs
	PRINT '>>Inserting Date Into: silver.Staffs';
	INSERT INTO silver.Staffs(
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
	FROM bronze.Staffs;
	PRINT '>>Truncating table: silver.brands';
	TRUNCATE TABLE silver.brands
	PRINT '>>Inserting Date Into: silver.brands';
	INSERT INTO silver.brands(
		brand_id,
		brand_name
	)
	SELECT 
		brand_id,
		brand_name
	FROM bronze.brands;

	PRINT '>>Truncating table: silver.Categories';
	TRUNCATE TABLE silver.Categories
	PRINT '>>Inserting Date Into: silver.Categories';
	INSERT INTO silver.Categories(
		category_id,
		category_name
	)
	SELECT 
		category_id,
		category_name
	FROM bronze.Categories;

	PRINT '>>Truncating table: silver.Products';
	TRUNCATE TABLE silver.Products
	PRINT '>>Inserting Date Into: silver.Products';
	INSERT INTO silver.Products(
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
	FROM bronze.Products;

	PRINT '>>Truncating table: silver.stocks';
	TRUNCATE TABLE silver.stocks
	PRINT '>>Inserting Date Into: silver.stocks';
	INSERT INTO silver.stocks(
		store_id,
		product_id,
		quantity
	)

	SELECT 
		store_id,
		product_id,
		quantity
	FROM bronze.stocks

	PRINT '>>Truncating table: silver.order_items';
	TRUNCATE TABLE silver.order_items
	PRINT '>>Inserting Date Into: silver.order_items';
	INSERT INTO silver.order_items(
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
	FROM bronze.order_items;

	PRINT '=============================================';
	PRINT '>>Loading Silver Layer is complete;'
	PRINT '=============================================';
END
