/*
================================================================
Create Database and Schemas
================================================================
Script Purpose:
	The script creates a new database 'BikeStore' after checking if it already exists.
	If the database exists, it drops and recreates it. Also, the script sets up three
	schemas with the database: 'bronze', 'silver' and 'gold'.

WARNING: 
	Running this script will drop entire 'BikeStore' database if it exists.
	All data in the database will be permamently deleted. Proceed with caution and
	ensure you have proper backups before running this script.
*/


USE master;
GO

--Drop and recreate the database 'BikeStore' database;
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'BikeStore')
BEGIN
	ALTER DATABASE BikeStore SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE BikeStore;
END;
GO

--Creating database 'BikeStore'
CREATE DATABASE BikeStore;
GO
USE BikeStore;
GO	

--Create Schemas;
CREATE SCHEMA bronze;
GO
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;

