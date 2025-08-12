
create database prokect_neww
use prokect_neww


create table Customers(
customer_id int Primary key,
firt_name varchar(max),
last_name varchar(max),
phone varchar(max),
email varchar(max),
street varchar(max),
city varchar(max),
state varchar(max),
zip_code int)


BULK INSERT customers
FROM 'D:\Learning\DataAnalytics\Project2\customers.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
  KEEPNULLS
);


select * from Customers



create table Strores(
store_id int Primary key,
store_name varchar(max),
phone varchar(max),
email varchar(max),
street varchar(max),
city varchar(max),
state varchar(max),
zip_code int)


BULK INSERT Strores
FROM 'D:\Learning\DataAnalytics\Project2\stores.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
  );

create table Orders(
order_id int primary key  ,
customer_id INT REFERENCES Customers(customer_id),
order_status varchar(max),
order_date date NULL,
required_date date NULL,
shipped_date  varchar(max),
store_id  INT REFERENCES Strores(store_id),
staff_id int)




BULK INSERT Orders
FROM 'D:\Learning\DataAnalytics\Project2\orders.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    KEEPNULLS
);

UPDATE Orders
SET shipped_date = TRY_CONVERT(DATE, NULLIF(shipped_date, 'NULL'));


create table Staffs(
staff_id  int ,
firt_name varchar(max),
last_name varchar(max),
email varchar(max),
phone varchar(max),
active int,
store_id int  REFERENCES Strores(store_id),
manager_id int 
)

ALTER TABLE Staffs
ALTER COLUMN staff_id INT NOT NULL;


BULK INSERT Staffs
FROM 'D:\Learning\DataAnalytics\Project2\staffs.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    KEEPNULLS
);



create table brands(
brand_id int Primary key,
brand_name varchar(max)
)

BULK INSERT brands
FROM 'D:\Learning\DataAnalytics\Project2\brands.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    KEEPNULLS
);


create table Categories(
category_id int Primary key,
category_name varchar(max)

)


BULK INSERT Categories
FROM 'D:\Learning\DataAnalytics\Project2\Categories.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    KEEPNULLS
);






create table Products(
product_id int Primary key,
product_name varchar(max),
brand_id  int REFERENCES brands(brand_id),
category_id int references Categories(category_id),
model_year int,
list_price DECIMAL(10,2)
)


BULK INSERT Products
FROM 'D:\Learning\DataAnalytics\Project2\products.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    KEEPNULLS
);



create table stocks(
store_id int REFERENCES Strores(store_id),
product_id int REFERENCES Products(product_id),
quantity int
)



BULK INSERT stocks
FROM 'D:\Learning\DataAnalytics\Project2\stocks.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    KEEPNULLS
);

create table order_items(
order_id int REFERENCES Orders(order_id),
item_id int,
product_id int REFERENCES Products(product_id),
quantity int,
list_price DECIMAL(10,2),
discount DECIMAL(4,2),

)



BULK INSERT order_items
FROM 'D:\Learning\DataAnalytics\Project2\order_items.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    KEEPNULLS
);



select * from order_items

select * from orders


select * from stocks


select *from Products


select * from Categories

select * from brands

select * from Staffs

select customer_id, COUNT(*) as Customer_1 from Orders
where store_id = 1
group by customer_id
having(COUNT(customer_id)>1)

select * from Strores

select * from Customers

