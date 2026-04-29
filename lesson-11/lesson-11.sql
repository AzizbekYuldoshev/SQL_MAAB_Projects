-- Puzzle 1: The Shifting Employees
-- A company has a rotational transfer policy where employees 
-- switch departments every 6 months. You have an `Employees` table:  

--**Table: Employees**  
--| EmployeeID | Name	 | Department | Salary  |  
--|------------|---------|------------|---------|  
--| 1          | Alice	 | HR         | 5000    |  
--| 2          | Bob	 | IT         | 7000    |  
--| 3          | Charlie | Sales      | 6000    |  
--| 4          | David   | HR         | 5500    |  
--| 5          | Emma    | IT         | 7200    |  
					     
-- Task:
--1. Create a temporary table `#EmployeeTransfers` with the same structure as `Employees`.  
--2. Swap departments for each employee in a circular manner:  
--   - HR → IT → Sales → HR  
--   - Example: Alice (HR) moves to IT, Bob (IT) moves to Sales, 
--     Charlie (Sales) moves to HR.  
--3. Insert the updated records into `#EmployeeTransfers`.  
--4. Retrieve all records from `#EmployeeTransfers`.  

CREATE TABLE dbo.Employees (
	EmployeeID INT IDENTITY(1,1),
	Name VARCHAR(50),	 
	Department VARCHAR(50),
	Salary INT
);
GO

INSERT INTO dbo.Employees VALUES
('Alice','HR', 5000),  
('Bob','IT', 7000),  
('Charlie','Sales', 6000),  
('David','HR', 5500),  
('Emma','IT', 7200)
GO

CREATE TABLE #EmployeeTransfers(
	EmployeeID INT,
	Name VARCHAR(50),	 
	Department VARCHAR(50),
	Salary INT
);
GO

INSERT INTO #EmployeeTransfers
SELECT EmployeeID,
	   Name, 
	   CASE WHEN Department = 'HR' THEN 'IT'
		    WHEN Department = 'IT' THEN 'Sales'
			ELSE 'HR'
	   END AS Department,
	   Salary
FROM dbo.Employees
GO


SELECT *
FROM #EmployeeTransfers
GO

-- Puzzle 2: The Missing Orders  
-- An e-commerce company tracks orders in two separate systems, 
-- but some orders are missing in one of them. You need to find the missing records.  

-- Given Tables:  

-- Table 1: `Orders_DB1` (Main System)  
--| OrderID | CustomerName | Product | Quantity |  
--|---------|-------------|---------|----------|  
--| 101     | Alice       | Laptop  | 1        |  
--| 102     | Bob         | Phone   | 2        |  
--| 103     | Charlie     | Tablet  | 1        |  
--| 104     | David       | Monitor | 1        |  

-- Table 2: `Orders_DB2` (Backup System, with some missing records)
--| OrderID | CustomerName | Product | Quantity |  
--|---------|-------------|---------|----------|  
--| 101     | Alice       | Laptop  | 1        |  
--| 103     | Charlie     | Tablet  | 1        |  

-- Task: 
--1. Declare a table variable `@MissingOrders` with the same structure as `Orders_DB1`.  
--2. Insert all orders that exist in `Orders_DB1` but not in `Orders_DB2` into `@MissingOrders`.  
--3. Retrieve the missing orders.  

CREATE TABLE dbo.Orders_DB1 (
	OrderID INT,
	CustomerName VARCHAR(50),
	Product VARCHAR(100),
	Quantity INT
); 
GO

INSERT INTO dbo.Orders_DB1 VALUES
(101, 'Alice', 'Laptop', 1),
(102, 'Bob', 'Phone', 2),
(103, 'Charlie', 'Tablet', 1),
(104, 'David', 'Monitor', 1);
GO

CREATE TABLE dbo.Orders_DB2 (
	OrderID INT,
	CustomerName VARCHAR(50),
	Product VARCHAR(100),
	Quantity INT
);
GO

INSERT INTO dbo.Orders_DB2 VALUES
(101, 'Alice', 'Laptop', 1),
(103, 'Charlie', 'Tablet', 1);
GO

DECLARE @MissingOrders TABLE (
	OrderID INT,
	CustomerName VARCHAR(50),
	Product VARCHAR(100),
	Quantity INT
);

INSERT INTO @MissingOrders
SELECT * FROM dbo.Orders_DB1
EXCEPT
SELECT * FROM dbo.Orders_DB2

SELECT * 
FROM @MissingOrders
GO

-- Puzzle 3: The Unbreakable View  
-- You are given a database that tracks employee working hours. 
--  The company needs a monthly summary report that calculates:  
-- Total hours worked per employee
-- Total hours worked per department
-- Average hours worked per department 

-- Given Table: `WorkLog`
--| EmployeeID | EmployeeName | Department | WorkDate   | HoursWorked |  
--|------------|-------------|------------|------------|-------------|  
--| 1          | Alice       | HR         | 2024-03-01 | 8           |  
--| 2          | Bob         | IT         | 2024-03-01 | 9           |  
--| 3          | Charlie     | Sales      | 2024-03-02 | 7           |  
--| 1          | Alice       | HR         | 2024-03-03 | 6           |  
--| 2          | Bob         | IT         | 2024-03-03 | 8           |  
--| 3          | Charlie     | Sales      | 2024-03-04 | 9           |  

-- Task:
--1. Create a view `vw_MonthlyWorkSummary` that calculates:  
--   - `EmployeeID`, `EmployeeName`, `Department`, TotalHoursWorked (SUM of hours per employee).  
--   - `Department`, TotalHoursDepartment (SUM of all hours per department).  
--   - `Department`, AvgHoursDepartment (AVG hours worked per department).  
--2. Retrieve all records from `vw_MonthlyWorkSummary`.

CREATE TABLE dbo.Worklog (
	EmployeeID INT,
	EmployeeName VARCHAR(50),
	Department VARCHAR(50),
	WorkDate DATE,
	HoursWorked INT
);
GO

INSERT INTO dbo.Worklog VALUES
(1, 'Alice', 'HR', '2024-03-01', 8),
(2, 'Bob', 'IT', '2024-03-01', 9),
(3, 'Charlie', 'Sales', '2024-03-02', 7),
(1, 'Alice', 'HR', '2024-03-03', 6),
(2, 'Bob', 'IT', '2024-03-03', 8),
(3, 'Charlie', 'Sales', '2024-03-04', 9);
GO

CREATE VIEW vw_MonthlyWorkSummary AS
SELECT DISTINCT EmployeeID, EmployeeName,Department, 
	   SUM(HoursWorked) OVER(PARTITION BY EmployeeName) AS TotalHoursWorked,
	   SUM(HoursWorked) OVER(PARTITION BY Department) AS TotalHoursDepartment,
	   AVG(HoursWorked) OVER(PARTITION BY Department) AS AvgHoursDepartment
FROM dbo.Worklog;
GO

