USE BikeStore
GO

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @filePath NVARCHAR(200) = 'D:\Learning\DataAnalytics\Project2\';
	DECLARE @sql NVARCHAR(MAX);
	
	TRUNCATE TABLE bronze.customers;
	SET @sql = '
	BULK INSERT bronze.customers
	FROM ''' + @filePath + 'customers.csv''
	WITH (
		FORMAT = ''CSV'',
		FIRSTROW = 2,
		FIELDTERMINATOR = '','',
		ROWTERMINATOR = ''\n'',
		KEEPNULLS
	);';

	EXEC sp_executesql @sql;
	--Stores table
	TRUNCATE TABLE bronze.Stores;
	SET @sql = '
	BULK INSERT bronze.Stores
	FROM ''' + @filePath + 'Stores.csv''
	WITH (
		FORMAT = ''CSV'',
		FIRSTROW = 2,
		FIELDTERMINATOR = '','',
		ROWTERMINATOR = ''\n'',
		KEEPNULLS
	);';
	EXEC sp_executesql @sql;

	TRUNCATE TABLE bronze.Orders;
	SET @sql = '
	BULK INSERT bronze.Orders
	FROM ''' + @filePath + 'Orders.csv''
	WITH (
		FORMAT = ''CSV'',
		FIRSTROW = 2,
		FIELDTERMINATOR = '','',
		ROWTERMINATOR = ''\n'',
		KEEPNULLS
	);';
	EXEC sp_executesql @sql;
	--Staffs table 1st staging area

	TRUNCATE TABLE bronze.Staffs_Staging;
	SET @sql = '
	BULK INSERT bronze.Staffs_Staging
	FROM ''' + @filePath + 'staffs.csv''
	WITH (
		FORMAT = ''CSV'',
		FIRSTROW = 2,
		FIELDTERMINATOR = '','',
		ROWTERMINATOR = ''\n'',
		KEEPNULLS
	);';
	EXEC sp_executesql @sql;
	--get red of errors
	--INSERT INTO bronze.Staffs(staff_id, first_name, last_name, email, phone, active, store_id, manager_id)
	--SELECT staff_id, first_name, last_name, email, phone, active, store_id, NULLIF(manager_id, 'NULL') 
	--FROM bronze.Staffs_Staging

	--brands table
	TRUNCATE TABLE bronze.brands;
	SET @sql = '
	BULK INSERT bronze.brands
	FROM ''' + @filePath + 'brands.csv''
	WITH (
		FORMAT = ''CSV'',
		FIRSTROW = 2,
		FIELDTERMINATOR = '','',
		ROWTERMINATOR = ''\n'',
		KEEPNULLS
	);';
	EXEC sp_executesql @sql;

	--Categories table
	TRUNCATE TABLE bronze.Categories;
	SET @sql = '
	BULK INSERT bronze.Categories
	FROM ''' + @filePath + 'Categories.csv''
	WITH (
		FORMAT = ''CSV'',
		FIRSTROW = 2,
		FIELDTERMINATOR = '','',
		ROWTERMINATOR = ''\n'',
		KEEPNULLS
	);';
	EXEC sp_executesql @sql;

	--Products table

	TRUNCATE TABLE bronze.Products;
	SET @sql = '
	BULK INSERT bronze.Products
	FROM ''' + @filePath + 'Products.csv''
	WITH (
		FORMAT = ''CSV'',
		FIRSTROW = 2,
		FIELDTERMINATOR = '','',
		ROWTERMINATOR = ''\n'',
		KEEPNULLS
	);';
	EXEC sp_executesql @sql;

	--stocks table
	TRUNCATE TABLE bronze.stocks;
	SET @sql = '
	BULK INSERT bronze.stocks
	FROM ''' + @filePath + 'stocks.csv''
	WITH (
		FORMAT = ''CSV'',
		FIRSTROW = 2,
		FIELDTERMINATOR = '','',
		ROWTERMINATOR = ''\n'',
		KEEPNULLS
	);';
	EXEC sp_executesql @sql;

	--order_items table
	TRUNCATE TABLE bronze.order_items;
	SET @sql = '
	BULK INSERT bronze.order_items
	FROM ''' + @filePath + 'order_items.csv''
	WITH (
		FORMAT = ''CSV'',
		FIRSTROW = 2,
		FIELDTERMINATOR = '','',
		ROWTERMINATOR = ''\n'',
		KEEPNULLS
	);';
	EXEC sp_executesql @sql;
END
