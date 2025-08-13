USE [msdb]
GO

/****** Object:  Job [LoadCsvFiles]    Script Date: 8/13/2025 10:23:00 PM ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 8/13/2025 10:23:00 PM ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'LoadCsvFiles', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'No description available.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'DESKTOP-7UAM6H9\Azamat', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [SP_DDL]    Script Date: 8/13/2025 10:23:00 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'SP_DDL', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'Use BikeStore
GO
IF OBJECT_ID (''bronze.Customers'', ''U'') IS NOT NULL
	DROP TABLE bronze.Customers;
create table bronze.Customers(
customer_id int Primary key,
first_name varchar(max),
last_name varchar(max),
phone varchar(max),
email varchar(max),
street varchar(max),
city varchar(max),
state varchar(max),
zip_code int
);

IF OBJECT_ID (''bronze.Stores'', ''U'') IS NOT NULL
	DROP TABLE bronze.Stores
create table bronze.Stores(
store_id int Primary key,
store_name varchar(max),
phone varchar(max),
email varchar(max),
street varchar(max),
city varchar(max),
state varchar(max),
zip_code int
);

IF OBJECT_ID (''bronze.Orders'', ''U'') IS NOT NULL
	DROP TABLE bronze.Orders
create table bronze.Orders(
order_id int primary key,
customer_id INT,
order_status varchar(max),
order_date date NULL,
required_date date NULL,
shipped_date  varchar(max),
store_id  INT,
staff_id int
);

IF OBJECT_ID (''bronze.Staffs_Staging'', ''U'') IS NOT NULL
	DROP TABLE bronze.Staffs_Staging
create table bronze.Staffs_Staging(
staff_id  int ,
first_name varchar(max),
last_name varchar(max),
email varchar(max),
phone varchar(max),
active int,
store_id int,
manager_id varchar(30)
);

IF OBJECT_ID (''bronze.Staffs'', ''U'') IS NOT NULL
	DROP TABLE bronze.Staffs
create table bronze.Staffs(
staff_id  int ,
first_name varchar(max),
last_name varchar(max),
email varchar(max),
phone varchar(max),
active int,
store_id int,
manager_id int
);

IF OBJECT_ID (''bronze.brands'', ''U'') IS NOT NULL
	DROP TABLE bronze.brands
create table bronze.brands(
brand_id int Primary key,
brand_name varchar(max)
);

IF OBJECT_ID (''bronze.Categories'', ''U'') IS NOT NULL
	DROP TABLE bronze.Categories
create table bronze.Categories(
category_id int Primary key,
category_name varchar(max)
);

IF OBJECT_ID (''bronze.Products'', ''U'') IS NOT NULL
	DROP TABLE bronze.Products
create table bronze.Products(
product_id int Primary key,
product_name varchar(max),
brand_id  int ,
category_id int ,
model_year int,
list_price DECIMAL(10,2)
);

IF OBJECT_ID (''bronze.stocks'', ''U'') IS NOT NULL
	DROP TABLE bronze.stocks
create table bronze.stocks(
store_id int ,
product_id int,
quantity int
)

IF OBJECT_ID (''bronze.order_items'', ''U'') IS NOT NULL
	DROP TABLE bronze.order_items
create table bronze.order_items(
order_id int,
item_id int,
product_id int,
quantity int,
list_price DECIMAL(10,2),
discount DECIMAL(4,2)
);', 
		@database_name=N'BikeStore', 
		@output_file_name=N'D:\Learning\DataAnalytics\Project2\logs.txt', 
		@flags=10
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [bulk_insert]    Script Date: 8/13/2025 10:23:00 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'bulk_insert', 
		@step_id=2, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'USE BikeStore
GO

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @filePath NVARCHAR(200) = ''D:\Learning\DataAnalytics\Project2\'';
	DECLARE @sql NVARCHAR(MAX);
	
	TRUNCATE TABLE bronze.customers;
	SET @sql = ''
	BULK INSERT bronze.customers
	FROM '''''' + @filePath + ''customers.csv''''
	WITH (
		FORMAT = ''''CSV'''',
		FIRSTROW = 2,
		FIELDTERMINATOR = '''','''',
		ROWTERMINATOR = ''''\n'''',
		KEEPNULLS
	);'';

	EXEC sp_executesql @sql;
	--Stores table
	TRUNCATE TABLE bronze.Stores;
	SET @sql = ''
	BULK INSERT bronze.Stores
	FROM '''''' + @filePath + ''Stores.csv''''
	WITH (
		FORMAT = ''''CSV'''',
		FIRSTROW = 2,
		FIELDTERMINATOR = '''','''',
		ROWTERMINATOR = ''''\n'''',
		KEEPNULLS
	);'';
	EXEC sp_executesql @sql;

	TRUNCATE TABLE bronze.Orders;
	SET @sql = ''
	BULK INSERT bronze.Orders
	FROM '''''' + @filePath + ''Orders.csv''''
	WITH (
		FORMAT = ''''CSV'''',
		FIRSTROW = 2,
		FIELDTERMINATOR = '''','''',
		ROWTERMINATOR = ''''\n'''',
		KEEPNULLS
	);'';
	EXEC sp_executesql @sql;
	--Staffs table 1st staging area

	TRUNCATE TABLE bronze.Staffs_Staging;
	SET @sql = ''
	BULK INSERT bronze.Staffs_Staging
	FROM '''''' + @filePath + ''staffs.csv''''
	WITH (
		FORMAT = ''''CSV'''',
		FIRSTROW = 2,
		FIELDTERMINATOR = '''','''',
		ROWTERMINATOR = ''''\n'''',
		KEEPNULLS
	);'';
	EXEC sp_executesql @sql;
	--get red of errors
	--INSERT INTO bronze.Staffs(staff_id, first_name, last_name, email, phone, active, store_id, manager_id)
	--SELECT staff_id, first_name, last_name, email, phone, active, store_id, NULLIF(manager_id, ''NULL'') 
	--FROM bronze.Staffs_Staging

	--brands table
	TRUNCATE TABLE bronze.brands;
	SET @sql = ''
	BULK INSERT bronze.brands
	FROM '''''' + @filePath + ''brands.csv''''
	WITH (
		FORMAT = ''''CSV'''',
		FIRSTROW = 2,
		FIELDTERMINATOR = '''','''',
		ROWTERMINATOR = ''''\n'''',
		KEEPNULLS
	);'';
	EXEC sp_executesql @sql;

	--Categories table
	TRUNCATE TABLE bronze.Categories;
	SET @sql = ''
	BULK INSERT bronze.Categories
	FROM '''''' + @filePath + ''Categories.csv''''
	WITH (
		FORMAT = ''''CSV'''',
		FIRSTROW = 2,
		FIELDTERMINATOR = '''','''',
		ROWTERMINATOR = ''''\n'''',
		KEEPNULLS
	);'';
	EXEC sp_executesql @sql;

	--Products table

	TRUNCATE TABLE bronze.Products;
	SET @sql = ''
	BULK INSERT bronze.Products
	FROM '''''' + @filePath + ''Products.csv''''
	WITH (
		FORMAT = ''''CSV'''',
		FIRSTROW = 2,
		FIELDTERMINATOR = '''','''',
		ROWTERMINATOR = ''''\n'''',
		KEEPNULLS
	);'';
	EXEC sp_executesql @sql;

	--stocks table
	TRUNCATE TABLE bronze.stocks;
	SET @sql = ''
	BULK INSERT bronze.stocks
	FROM '''''' + @filePath + ''stocks.csv''''
	WITH (
		FORMAT = ''''CSV'''',
		FIRSTROW = 2,
		FIELDTERMINATOR = '''','''',
		ROWTERMINATOR = ''''\n'''',
		KEEPNULLS
	);'';
	EXEC sp_executesql @sql;

	--order_items table
	TRUNCATE TABLE bronze.order_items;
	SET @sql = ''
	BULK INSERT bronze.order_items
	FROM '''''' + @filePath + ''order_items.csv''''
	WITH (
		FORMAT = ''''CSV'''',
		FIRSTROW = 2,
		FIELDTERMINATOR = '''','''',
		ROWTERMINATOR = ''''\n'''',
		KEEPNULLS
	);'';
	EXEC sp_executesql @sql;
END', 
		@database_name=N'BikeStore', 
		@output_file_name=N'D:\Learning\DataAnalytics\Project2\log_sp2.txt', 
		@flags=10
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [exec_all_to_load_csv]    Script Date: 8/13/2025 10:23:00 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'exec_all_to_load_csv', 
		@step_id=3, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'USE BikeStore
GO

EXEC bronze.sp_bronze_ddl
GO
EXEC bronze.load_bronze', 
		@database_name=N'BikeStore', 
		@output_file_name=N'loading_csv_files_log.txt', 
		@flags=10
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'run_load_csv_scheduled', 
		@enabled=1, 
		@freq_type=8, 
		@freq_interval=9, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20250813, 
		@active_end_date=20250827, 
		@active_start_time=211500, 
		@active_end_time=235959, 
		@schedule_uid=N'16b09300-3809-4c12-bbee-262f2cad0127'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO


