/*
========================================================================
DDL Script: Create Silver tables
========================================================================
Script purpose:
	This script creates tables in 'silver' schema, dropping existing tables
	if they already exist.
	Run this script to re-define the DDL structure of 'silver' Tables

========================================================================
*/

IF OBJECT_ID ('silver.Customers', 'U') IS NOT NULL
	DROP TABLE silver.Customers;
create table silver.Customers(
customer_id int Primary key,
first_name varchar(max),
last_name varchar(max),
phone varchar(max),
email varchar(max),
street varchar(max),
city varchar(max),
state varchar(max),
zip_code int
,create_date datetime2 default getdate()
);

IF OBJECT_ID ('silver.Stores', 'U') IS NOT NULL
	DROP TABLE silver.Stores
create table silver.Stores(
store_id int Primary key,
store_name varchar(max),
phone varchar(max),
email varchar(max),
street varchar(max),
city varchar(max),
state varchar(max),
zip_code int
,create_date datetime2 default getdate()
);

IF OBJECT_ID ('silver.Orders', 'U') IS NOT NULL
	DROP TABLE silver.Orders
create table silver.Orders(
order_id int primary key,
customer_id INT,
order_status varchar(max),
order_date date NULL,
required_date date NULL,
shipped_date  varchar(max),
store_id  INT,
staff_id int
,create_date datetime2 default getdate()
);
/*
IF OBJECT_ID ('silver.Staffs_Staging', 'U') IS NOT NULL
	DROP TABLE silver.Staffs_Staging
create table silver.Staffs_Staging(
staff_id  int ,
first_name varchar(max),
last_name varchar(max),
email varchar(max),
phone varchar(max),
active int,
store_id int,
manager_id varchar(30)

);
*/

INSERT INTO bronze.Staffs(staff_id, first_name, last_name, email, phone, active, store_id, manager_id)
SELECT staff_id, first_name, last_name, email, phone, active, store_id, NULLIF(manager_id, 'NULL') 
FROM bronze.Staffs_Staging

IF OBJECT_ID ('silver.Staffs', 'U') IS NOT NULL
	DROP TABLE silver.Staffs
create table silver.Staffs(
staff_id  int ,
first_name varchar(max),
last_name varchar(max),
email varchar(max),
phone varchar(max),
active int,
store_id int,
manager_id int
,create_date datetime2 default getdate()
);

IF OBJECT_ID ('silver.brands', 'U') IS NOT NULL
	DROP TABLE silver.brands
create table silver.brands(
brand_id int Primary key,
brand_name varchar(max)
,create_date datetime2 default getdate()
);

IF OBJECT_ID ('silver.Categories', 'U') IS NOT NULL
	DROP TABLE silver.Categories
create table silver.Categories(
category_id int Primary key,
category_name varchar(max)
,create_date datetime2 default getdate()
);

IF OBJECT_ID ('silver.Products', 'U') IS NOT NULL
	DROP TABLE silver.Products
create table silver.Products(
product_id int Primary key,
product_name varchar(max),
brand_id  int ,
category_id int ,
model_year int,
list_price DECIMAL(10,2)
,create_date datetime2 default getdate()
);

IF OBJECT_ID ('silver.stocks', 'U') IS NOT NULL
	DROP TABLE silver.stocks
create table silver.stocks(
store_id int ,
product_id int,
quantity int
,create_date datetime2 default getdate()
)

IF OBJECT_ID ('silver.order_items', 'U') IS NOT NULL
	DROP TABLE silver.order_items
create table silver.order_items(
order_id int,
item_id int,
product_id int,
quantity int,
list_price DECIMAL(10,2),
discount DECIMAL(4,2)
,create_date datetime2 default getdate()
);
