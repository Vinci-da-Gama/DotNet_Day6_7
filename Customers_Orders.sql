USE [Customer_Orders]
GO

CREATE TABLE [dbo].[Orders](
	[OrderId] [int] IDENTITY(1,1) NOT NULL,
	[OrderProduct] [nvarchar](50) NOT NULL,
	[OrderPrice] [varchar](18) NOT NULL,
	[OrderDate] [smalldatetime] NOT NULL,
	[CustomerId] [int] NOT NULL,
 CONSTRAINT [PK_Orders] PRIMARY KEY CLUSTERED 
(
	[OrderId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[Orders]  WITH CHECK ADD  CONSTRAINT [FK_Orders_Customers] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[Customers] ([CustomerId])
GO

ALTER TABLE [dbo].[Orders] CHECK CONSTRAINT [FK_Orders_Customers]
GO

ALTER TABLE [dbo].[Orders] ADD  CONSTRAINT [DF_Orders_OrderDate]  DEFAULT (getdate()) FOR [OrderDate]
GO

-- Select rows from a Table or View 'Customers' in schema 'dbo'
SELECT c.First_Name, c.Last_Name, c.Email, o.OrderPrice, o.OrderDate FROM dbo.Customers c Inner Join dbo.Orders o
ON c.CustomerId = o.CustomerId
WHERE c.CustomerId = 1 /* add search conditions here */
GO


/* If 2 tables has Parent-Child relationship, so it has to delete Child row (Row in Orders Table) first, then delete parent row (Row in Customers Table). */
-- Delete rows from table 'Orders'
DELETE FROM Orders
WHERE CustomerId = 2 /* add search conditions here */
GO

-- Delete rows from table 'Customers'
DELETE FROM Customers
WHERE CustomerId = 2 /* add search conditions here */
GO

Select * From Orders

/* After Delete One row in both Table, the ids are not consistency. So, It require re-order them. To reorder child (Order Table), Disable Identity and FK, Then in Parent (Customers Table), disable Identity (The table id) */ 
-- Update rows in table 'Orders'
UPDATE Orders
SET
	[OrderId] = OrderId - 1,
	[CustomerId] = CustomerId - 1
	-- add more columns and values here
WHERE OrderId > 1 /* add search conditions here */
GO

Select * From Orders

-- Update rows in table 'Customers'
UPDATE Customers
SET
	[CustomerId] = CustomerId - 1
	-- add more columns and values here
WHERE CustomerId > 1 /* add search conditions here */
GO

Select * From Customers

/* Key Distinct */
Select Distinct OrderDate From Orders

/* Key Union */
Select First_Name+' '+Last_Name as FullName, Email From Customers
UNION
Select OrderProduct as ProductName, OrderPrice From Orders

-- Select rows from a Table or View 'Customers' in schema 'dbo'
SELECT COUNT(OrderId) as OrderId_Count, MIN(OrderPrice) as Min_Price, MAX(OrderPrice) as Max_Price, AVG(OrderId) as Average_Id, SUM(OrderId) as Ids_Sum FROM dbo.Orders
GO

--Change Column Type.
Alter Table Orders
Alter COLUMN OrderPrice smallmoney Not Null

--Complex Like, Exists, Between...And
-- Select rows from a Table or View 'Orders' in schema 'dbo'
SELECT OrderProduct as ProductName FROM dbo.Orders
WHERE OrderProduct Like '_h_%_%s%-%e' And EXISTS(Select OrderProduct From Orders Where OrderId > 6) And OrderPrice Between 4.00 And 9.00 /* add search conditions here */
GO

/* Any - Return true, If one of subquery meets condition */
Select c.Email as Account, o.OrderProduct as ProductName, o.OrderPrice From Orders o Inner Join dbo.Customers c On o.CustomerId = c.CustomerId
Where Exists(Select o.OrderId From Orders Where o.OrderId > 20) AND o.OrderPrice = Any(Select o.OrderPrice From Orders Where o.OrderDate > '2015')
Order By o.OrderId DESC

/* All - Return true, if all of subquery meets condition */
Select c.Email as Account, o.OrderProduct as ProductName, o.OrderPrice From Orders o Inner Join dbo.Customers c On o.CustomerId = c.CustomerId
Where Exists(Select o.OrderId From Orders Where o.OrderId > 20) AND o.OrderPrice = ALL(Select o.OrderPrice From Orders Where o.OrderDate > '2015')
Order By o.OrderId DESC

--Group By And Having
Select COUNT(OrderPrice) as ShowTimes, OrderPrice From dbo.Orders
Group By OrderPrice
Having Count(OrderPrice) > 1
Order By OrderPrice DESC

Select COUNT(First_Name) as FN, First_Name, Gender From Customers
Where Gender != 'M'
Group By First_Name, Gender
Having COUNT(First_Name) > 0
Order By First_Name DESC

--Create New Table
-- Create a new table called 'Products' in schema 'dbo'
-- Drop the table if it already exists
IF OBJECT_ID('dbo.Products', 'U') IS NOT NULL
DROP TABLE dbo.Products
GO
-- Create the table in the specified schema
CREATE TABLE dbo.Products
(
	ProductsId INT NOT NULL IDENTITY(1,1), -- primary key column
	Price smallmoney NOT NULL DEFAULT 0.00,
	ProduceDate smalldatetime NOT NULL DEFAULT getdate(),
	Comment nvarchar(100) Null DEFAULT 'Conment...',
	CustomerId INT Not Null,
	PRIMARY KEY (ProductsId),
	CONSTRAINT FK_Orders_Customers FOREIGN Key (CustomerId) REFERENCES dbo.Customers(CustomerId),
	CONSTRAINT UC_Product Unique(ProductsId, CustomerId)
	-- specify more columns here
);
GO

/* Example of Over Clause, http://www.sqlservercentral.com/articles/over+clause/132079/ */


-- Insert rows into table 'Products'
INSERT INTO Products
( -- columns to insert data into
 [Price], [ProduceDate], [Comment], [CustomerId]
)
VALUES
( -- first row: values for the columns in the list above
 6.21, '2015-01-21', '', 1
)
-- add more rows here
GO

--Delete one row
-- Delete rows from table 'Products'
DELETE FROM Products
WHERE ProductsId = 1 /* add search conditions here */
GO

--WhileLoop insert 120 rows
Declare @cnt INT = 0;
WHILE @cnt < 120
Begin
	-- Insert rows into table 'Products'
	INSERT INTO Products
	(
		-- columns to insert data into
		[Price], [ProduceDate], [Comment], [CustomerId]
	)
	VALUES
	(
		-- first row: values for the columns in the list above
		Abs(Checksum(NewId())) % 10, '2015-01-21', '', @cnt + 1
	)
	SET @cnt = @cnt + 1;
End

Select * From Products

/* Delete Duplicated Rows, only First Row Left. */
WITH products_cte AS(
	SELECT ProductsId, [Price], ProduceDate, Comment, [CustomerId], RN = ROW_NUMBER()Over(PARTITION By Price Order By ProductsId) From Products
)
DELETE FROM products_cte WHERE RN > 1

SELECT * FROM Products
/* END Delete Duplicated Rows */


/* Start Home work Solution */

select * from dbo.Orders

-- Select rows from a Table or View 'Orders' in schema 'dbo'
SELECT * FROM dbo.Orders
WHERE OrderDate >= '2015-08-01' /* add search conditions here */
GO

Select Top 5 * From dbo.Orders
Where OrderPrice > '$10.00'
Order By OrderDate DESC
GO

-- Select rows from a Table or View 'Customers' in schema 'dbo'
SELECT * FROM dbo.Customers
WHERE Email like '%.org' /* add search conditions here */
GO

-- Select rows from a Table or View 'Customers c Inner Join ' in schema 'dbo'
SELECT Top 10 c.Email, o.OrderPrice, o.OrderProduct FROM dbo.Customers c Inner Join dbo.Orders o
ON c.CustomerId = o.CustomerId 
WHERE c.CustomerId = o.OrderId /* add search conditions here */
GO