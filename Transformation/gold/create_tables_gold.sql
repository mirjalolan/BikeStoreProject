/*
========================================================================
DDL Script: Create final tables
========================================================================
Script purpose:
	This script creates tables for final schema, dropping existing tables
	if they already exist.

========================================================================
*/
Use BikeStore
GO
IF OBJECT_ID ('Customers', 'U') IS NOT NULL
	DROP TABLE Customers;
create table Customers(
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

IF OBJECT_ID ('Stores', 'U') IS NOT NULL
	DROP TABLE Stores
create table Stores(
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

IF OBJECT_ID ('Orders', 'U') IS NOT NULL
	DROP TABLE Orders
create table Orders(
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

IF OBJECT_ID ('Staffs', 'U') IS NOT NULL
	DROP TABLE Staffs
create table Staffs(
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

IF OBJECT_ID ('brands', 'U') IS NOT NULL
	DROP TABLE brands
create table brands(
brand_id int Primary key,
brand_name varchar(max)
,create_date datetime2 default getdate()
);

IF OBJECT_ID ('Categories', 'U') IS NOT NULL
	DROP TABLE Categories
create table Categories(
category_id int Primary key,
category_name varchar(max)
,create_date datetime2 default getdate()
);

IF OBJECT_ID ('Products', 'U') IS NOT NULL
	DROP TABLE Products
create table Products(
product_id int Primary key,
product_name varchar(max),
brand_id  int ,
category_id int ,
model_year int,
list_price DECIMAL(10,2)
,create_date datetime2 default getdate()
);

IF OBJECT_ID ('stocks', 'U') IS NOT NULL
	DROP TABLE stocks
create table stocks(
store_id int ,
product_id int,
quantity int
,create_date datetime2 default getdate()
)

IF OBJECT_ID ('order_items', 'U') IS NOT NULL
	DROP TABLE order_items
create table order_items(
order_id int,
item_id int,
product_id int,
quantity int,
list_price DECIMAL(10,2),
discount DECIMAL(4,2)
,create_date datetime2 default getdate()
);
