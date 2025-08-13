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
FROM 'E:\MAAB\project\customers.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
  KEEPNULLS
);


select * from Customers



create table stores(
store_id int Primary key,
store_name varchar(max),
phone varchar(max),
email varchar(max),
street varchar(max),
city varchar(max),
state varchar(max),
zip_code int)


BULK INSERT stores
FROM 'E:\MAAB\project\stores.csv'
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
FROM 'E:\MAAB\project\orders.csv'
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
FROM 'E:\MAAB\project\staffs.csv'
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
FROM 'E:\MAAB\project\brands.csv'
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
FROM 'E:\MAAB\project\Categories.csv'
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
FROM 'E:\MAAB\project\products.csv'
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
FROM 'E:\MAAB\project\stocks.csv'
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
FROM 'E:\MAAB\project\order_items.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    KEEPNULLS
);
