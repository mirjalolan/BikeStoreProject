/*
========================================================================
DDL Script: Create bronze tables
========================================================================
Script purpose:
	This script creates tables in 'bronze' schema, dropping existing tables
	if they already exist.
	Run this script to re-define the DDL structure of 'bronze' Tables

========================================================================
*/
Use BikeStore
GO
IF OBJECT_ID ('bronze.Customers', 'U') IS NOT NULL
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

IF OBJECT_ID ('bronze.Stores', 'U') IS NOT NULL
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

IF OBJECT_ID ('bronze.Orders', 'U') IS NOT NULL
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

IF OBJECT_ID ('bronze.Staffs_Staging', 'U') IS NOT NULL
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

IF OBJECT_ID ('bronze.Staffs', 'U') IS NOT NULL
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

IF OBJECT_ID ('bronze.brands', 'U') IS NOT NULL
	DROP TABLE bronze.brands
create table bronze.brands(
brand_id int Primary key,
brand_name varchar(max)
);

IF OBJECT_ID ('bronze.Categories', 'U') IS NOT NULL
	DROP TABLE bronze.Categories
create table bronze.Categories(
category_id int Primary key,
category_name varchar(max)
);

IF OBJECT_ID ('bronze.Products', 'U') IS NOT NULL
	DROP TABLE bronze.Products
create table bronze.Products(
product_id int Primary key,
product_name varchar(max),
brand_id  int ,
category_id int ,
model_year int,
list_price DECIMAL(10,2)
);

IF OBJECT_ID ('bronze.stocks', 'U') IS NOT NULL
	DROP TABLE bronze.stocks
create table bronze.stocks(
store_id int ,
product_id int,
quantity int
)

IF OBJECT_ID ('bronze.order_items', 'U') IS NOT NULL
	DROP TABLE bronze.order_items
create table bronze.order_items(
order_id int,
item_id int,
product_id int,
quantity int,
list_price DECIMAL(10,2),
discount DECIMAL(4,2)
);
exec bronze.load_bronze;
