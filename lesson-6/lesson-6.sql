-- Given Tables
CREATE TABLE dbo.Employees(
	EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
	Name VARCHAR(50),
	DepartmentID INT,
	Salary INT
);
GO

INSERT INTO dbo.Employees(Name, DepartmentID, Salary) VALUES  
('Alice', 101 , 60000),  
('Bob', 102 , 70000),  
('Charlie', 101 , 65000),  
('David', 103 , 72000),  
('Eva', NULL, 68000);  
GO

CREATE TABLE dbo.Departments(
	DepartmentID INT,
	DepartmentName VARCHAR(50)
);  
GO

INSERT INTO dbo.Departments VALUES
(101, 'IT'),  
(102, 'HR'),  
(103, 'Finance'),  
(104, 'Marketing')  
GO

CREATE TABLE dbo.Projects(
	ProjectID INT IDENTITY(1,1),
	ProjectName VARCHAR(50),
	EmployeeID INT FOREIGN KEY REFERENCES Employees(EmployeeID)
);  
GO

INSERT INTO dbo.Projects(ProjectName, EmployeeID) VALUES
('Alpha', 1), 
('Beta ', 2), 
('Gamma', 1), 
('Delta', 4), 
('Omega', NULL) 
GO

-- QUESTIONS
-- 1. INNER JOIN - Write a query to get a list of employees along with their department names.  
SELECT e.*,
	   d.DepartmentName
FROM dbo.Employees AS e
INNER JOIN dbo.Departments as d
ON e.DepartmentID = d.DepartmentID;
GO

-- 2. LEFT JOIN - Write a query to list all employees, including those who are not assigned to any department.  
SELECT e.EmployeeID,
	   e.Name,
	   e.Salary,
	   e.DepartmentID,
	   d.DepartmentName
FROM dbo.Employees AS e
LEFT JOIN dbo.Departments as d
ON e.DepartmentID = d.DepartmentID;
GO

-- 3. RIGHT JOIN - Write a query to list all departments, including those without employees.  
SELECT e.EmployeeID,
	   e.Name,
	   e.Salary,
	   d.DepartmentName,
	   d.DepartmentID
FROM dbo.Employees AS e
RIGHT JOIN dbo.Departments as d
ON e.DepartmentID = d.DepartmentID;
GO

-- 4. FULL OUTER JOIN - Write a query to retrieve all employees and all departments, even if there’s no match between them.   
SELECT e.EmployeeID,
	   e.Name,
	   e.Salary,
	   d.DepartmentName,
	   d.DepartmentID
FROM dbo.Employees AS e
FULL JOIN dbo.Departments as d
ON e.DepartmentID = d.DepartmentID;
GO

-- 5. JOIN with Aggregation - Write a query to find the total salary expense for each department.  
SELECT d.DepartmentName,
	   SUM(Salary) AS DeptTotalSalary
FROM dbo.Employees AS e
JOIN dbo.Departments as d
ON e.DepartmentID = d.DepartmentID
GROUP BY d.DepartmentName;
GO

-- 6. CROSS JOIN - Write a query to generate all possible combinations of departments and projects.
-- WAY 1
SELECT *
FROM dbo.Projects 
CROSS JOIN dbo.Departments;
GO

-- WAY 2
SELECT *
FROM dbo.Projects, dbo.Departments;
GO

-- 7. MULTIPLE JOINS - Write a query to get a list of employees with their department names and assigned project names. 
-- Include employees even if they don’t have a project.
SELECT e.EmployeeID,
	   e.Name,
	   d.DepartmentName,
	   p.ProjectName
FROM dbo.Employees AS e
LEFT JOIN dbo.Departments as d
ON e.DepartmentID = d.DepartmentID
LEFT JOIN dbo.Projects AS p
ON e.EmployeeID = p.EmployeeID;
GO