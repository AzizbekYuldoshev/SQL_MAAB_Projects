-- 1. DELETE vs TRUNCATE vs DROP (with IDENTITY example)
--  Create a table `test_identity` with an `IDENTITY(1,1)` column and insert 5 rows.
--  Use `DELETE`, `TRUNCATE`, and `DROP` one by one (in different test cases) and observe how they behave.
--  Answer the following questions:
--  1. What happens to the identity column when you use `DELETE`?
--  2. What happens to the identity column when you use `TRUNCATE`?
--  3. What happens to the table when you use `DROP`?

CREATE TABLE dbo.test_identity(
	id INT IDENTITY(1,1),
	name VARCHAR(50)
);
GO

INSERT INTO dbo.test_identity(name)
VALUES ('Jon'), ('Tom'), ('Adam'), ('Lucy'), ('Jessica');
GO

SELECT *
FROM dbo.test_identity;
-- DELETE -> The values has been deleted, the count seed has been kept and new entry id was 6; WHEN is allowed
DELETE FROM dbo.test_identity;
GO
INSERT INTO dbo.test_identity(name)
VALUES ('Jon');
GO

-- TRUNCATE -> Cleares the values of the table and new id entries started from 1 again
TRUNCATE TABLE dbo.test_identity;
GO
INSERT INTO dbo.test_identity(name)
VALUES ('Jon'), ('Tom');
GO

-- DROP -> Totally removes the table itself
DROP TABLE dbo.test_identity;
GO

-- 2. Common Data Types
--  Create a table `data_types_demo` with columns covering at least one example of each data type covered in class.
--  Insert values into the table.
--  Retrieve and display the values.

CREATE TABLE dbo.data_types_demo(
	work_id UNIQUEIDENTIFIER,
	name CHAR(10),
	surname VARCHAR(25),
	nickname NVARCHAR(50),
	age TINYINT,
	salary SMALLINT,
	id INT,
	family_fund BIGINT,
	dob DATETIME,
	married_date DATE,
	married_time TIME,
	dob_child DATETIME2
);
GO

INSERT INTO dbo.data_types_demo(work_id, name, surname, nickname, age, salary, id, family_fund, dob, married_date, married_time, dob_child)
SELECT NEWID(), 'Adam', 'Ibrahim', 'Ali', 25, 30000, 2002302032, 129743028570, GETDATE(), '2010-10-10', '12:23:12.234', '22:12:43.1232123';

SELECT *
FROM dbo.data_types_demo;
GO

-- 3. Inserting and Retrieving an Image
-- Create a `photos` table with an `id` column and a `varbinary(max)` column.
-- Insert an image into the table using `OPENROWSET`.

CREATE TABLE dbo.photos(
	id INT IDENTITY(1,1),
	image VARBINARY(MAX)
);
GO

INSERT INTO dbo.photos(image)
SELECT * FROM OPENROWSET(BULK 'D:\2_Spring26_docs\PAE\1.png', SINGLE_BLOB) AS mytable;
GO

SELECT * FROM dbo.photos;

-- 4. Computed Columns
--- Create a `student` table with a computed column `total_tuition` as `classes * tuition_per_class`.
--- Insert 3 sample rows.
--- Retrieve all data and check if the computed column works correctly.

CREATE TABLE dbo.student(
	classes SMALLINT,
	tuition_per_class INT,
	total_tuition AS classes * tuition_per_class
);
GO

INSERT INTO dbo.student(classes, tuition_per_class)
VALUES (10, 2000000), (2, 1000000), (15, 3500000);
GO

SELECT * 
FROM dbo.student;

-- 5. CSV to SQL Server
--  Download or create a CSV file with at least 5 rows of worker data (`id, name`).
--  Use `BULK INSERT` to import the CSV file into the `worker` table.
--  Verify the imported data.

CREATE TABLE dbo.worker(
	id INT,
	name VARCHAR(50)
);
GO

BULK INSERT dbo.worker
FROM 'D:\4_Python\Sources\sample2.csv'
WITH(
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '\n',
	FIRSTROW = 2
);
GO

SELECT *
FROM dbo.worker;
GO