
USE [Customer_Orders]
GO

/****** Object:  Table [dbo].[TestTable]    Script Date: 08/17/2017 17:46:34 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

-- Drop the table 'Customers' in schema 'dbo'
IF EXISTS (
	SELECT *
		FROM sys.tables
		JOIN sys.schemas
			ON sys.tables.schema_id = sys.schemas.schema_id
	WHERE sys.schemas.name = N'dbo'
		AND sys.tables.name = N'Customers'
)
	DROP TABLE dbo.Customers
GO

-- Drop the table 'TestTable' in schema 'dbo'
IF EXISTS (
	SELECT *
		FROM sys.tables
		JOIN sys.schemas
			ON sys.tables.schema_id = sys.schemas.schema_id
	WHERE sys.schemas.name = N'dbo'
		AND sys.tables.name = N'TestTable'
)
	DROP TABLE dbo.TestTable
GO

CREATE TABLE [dbo].[Customers](
	[CustomerId] [smallint] IDENTITY(1,1) NOT NULL,
	[First_Name] [nvarchar](50) NOT NULL,
	[Last_Name] [nvarchar](50) NOT NULL,
	[Email] [varchar](100) NOT NULL,
	[Gender] [char](1) NULL,
	[Join_Date] [smalldatetime] NOT NULL,
 CONSTRAINT [PK_Customers] PRIMARY KEY CLUSTERED 
(
	[CustomerId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

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

SET ANSI_PADDING OFF
GO

IF  EXISTS (SELECT * FROM sys.objects 
	WHERE object_id = OBJECT_ID(N'[dbo].[Orders]') AND type in (N'U'))
	DROP TABLE [dbo].[Orders]
GO

Select * From [dbo].[Customers]

-- Select rows from a Table or View 'Customers' in schema 'dbo'
SELECT First_Name as Fn, Last_Name as Ln FROM dbo.Customers
WHERE Gender = 'F'	/* add search conditions here */
GO

-- Select rows from a Table or View 'Customers' in schema 'dbo'
SELECT First_Name + ' ' + Last_Name as FullName FROM dbo.[Customers]
WHERE Gender = 'M'	/* add search conditions here */
GO

-- Insert rows into table 'Customers'
INSERT INTO Customers
( -- columns to insert data into
 [First_Name], [Last_Name], [Email], Gender, Join_Date
)
VALUES
( -- first row: values for the columns in the list above
 'NameF0', 'NameL0', 'newEmail0@sth.com', 'F', GETDATE()
),
( -- second row: values for the columns in the list above
 'NameF1', 'NameL1', 'newEmail1@sth.com', 'F', GETDATE()
)
-- add more rows here
GO

Select * From dbo.Customers
Where Gender='F' And CustomerId > 120

-- Update rows in table 'Customers'
UPDATE [Customers]
SET
	[First_Name] = 'WuhaFN',
	[Last_Name] = 'WahaLn'
	-- add more columns and values here
WHERE CustomerId = 1 /* add search conditions here */
GO

-- Delete rows from table 'Customers'
DELETE FROM Customers
WHERE CustomerId = 120 /* add search conditions here */
GO

-- Delete rows from table 'Customers'
DELETE FROM Customers
WHERE CustomerId = 120 And Gender <> 'M'	/* add search conditions here */
GO

Select * From Customers
Where Gender = 'F' And CustomerId > 115

-- Select rows from a Table or View 'Customers' in schema 'dbo'
SELECT First_Name as FN, Last_Name as LN FROM dbo.Customers
WHERE CustomerId > 90 AND Gender != 'F'	/* add search conditions here */
GO

/* between and || Date > || or x2 --- in(...) || 
Like '...%' || Order By */

-- Select rows from a Table or View 'Customers' in schema 'dbo'
SELECT * FROM dbo.Customers
WHERE Join_Date between '2014-07-14 00:00:00' AND '2017-02-05 00:00:00'/* add search conditions here */
GO

-- Select rows from a Table or View 'Customers' in schema 'dbo'
SELECT * FROM dbo.Customers
WHERE Join_Date between '2015-07-14' AND '2017-01-05'/* add search conditions here */
GO

-- Select rows from a Table or View 'Customers' in schema 'dbo'
SELECT * FROM dbo.Customers
WHERE Join_Date > '2017-01-05'/* add search conditions here */
GO

-- Select rows from a Table or View 'Customers' in schema 'dbo'
SELECT * FROM dbo.Customers
WHERE First_Name = 'John' Or Last_Name = 'Smith' Or Gender != 'M' /* add search conditions here */
GO

-- Select rows from a Table or View 'Customers' in schema 'dbo'
SELECT * FROM dbo.Customers
WHERE [Email] IN ('amacmechan0@unc.edu', 'dharridgei@rakuten.co.jp', 'dgibbett1o@pbs.org') /* add search conditions here */
GO

-- Select rows from a Table or View 'Customers' in schema 'dbo'
SELECT Top 10 * FROM dbo.Customers
WHERE Last_Name Like 'La%' /* add search conditions here */
Order By First_Name, Last_Name Desc
GO
