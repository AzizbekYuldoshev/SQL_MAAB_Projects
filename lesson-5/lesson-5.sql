-- Table Structure
CREATE TABLE Employees(
    EmployeeID    INT,
    Name          VARCHAR(50),
    Department    VARCHAR(50),
    Salary        DECIMAL(10,2),
    HireDate      DATE
);

--1. Assign a Unique Rank to Each Employee Based on Salary
SELECT *,
	   ROW_NUMBER() OVER(ORDER BY Salary) AS UniqueRank
FROM dbo.Employees;
GO

--2. Find Employees Who Have the Same Salary Rank
SELECT 
    A.EmployeeID,
    A.Name,
    A.Salary
FROM dbo.Employees A
JOIN dbo.Employees B
    ON A.Salary = B.Salary
    AND A.EmployeeID <> B.EmployeeID   
ORDER BY A.Salary DESC;
GO

-- 3. Identify the Top 2 Highest Salaries in Each Department
SELECT *
FROM (SELECT *,
       DENSE_RANK() OVER(PARTITION BY Department ORDER BY Salary DESC) AS DeptSalaryRank
FROM dbo.Employees) AS mytable
WHERE DeptSalaryRank in (1,2)
ORDER BY Department;

-- 4. Find the Lowest-Paid Employee in Each Department
SELECT *
FROM (SELECT *,
       DENSE_RANK() OVER(PARTITION BY Department ORDER BY Salary) AS DeptSalaryRank
FROM dbo.Employees) AS mytable
WHERE DeptSalaryRank = 1
ORDER BY Department;

-- 5. Calculate the Running Total of Salaries in Each Department
SELECT *,
	   SUM(Salary) OVER(PARTITION BY Department ORDER BY HireDate) AS DeptRunningTotal
FROM dbo.Employees;
GO
  
-- 6. Find the Total Salary of Each Department Without GROUP BY
SELECT *,
	   SUM(Salary) OVER(PARTITION BY Department) AS DeptTotal
FROM dbo.Employees;
GO

-- 7. Calculate the Average Salary in Each Department Without GROUP BY
SELECT *,
	   CAST(AVG(Salary) OVER(PARTITION BY Department) AS DECIMAL(10,2)) AS DeptAverage
FROM dbo.Employees;
GO

-- 8. Find the Difference Between an Employee’s Salary and Their Department’s Average
SELECT *,
	   Salary - CAST(AVG(Salary) OVER(PARTITION BY Department) AS DECIMAL(10,2)) AS SalaryDifferenceFromAverage
FROM dbo.Employees;
GO

-- 9. Calculate the Moving Average Salary Over 3 Employees (Including Current, Previous, and Next)
SELECT *,
	   CAST(AVG(Salary) OVER(ORDER BY HireDate ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS DECIMAL(10,2)) AS ThreeMovingAvg
FROM dbo.Employees
ORDER BY HireDate;
GO

-- 10. Find the Sum of Salaries for the Last 3 Hired Employees
SELECT MAX(DeptTotal) AS Last3EmpSalary
FROM (SELECT TOP 3 *,
	   SUM(Salary) OVER(ORDER BY HireDate DESC) AS DeptTotal
FROM dbo.Employees) AS mytable;
GO

-- 11. Calculate the Running Average of Salaries Over All Previous Employees
SELECT *,
	   CAST(AVG(Salary) OVER(ORDER BY HireDate ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS DECIMAL(10,2)) AS RunningAvgUntilHere
FROM dbo.Employees
ORDER BY HireDate;
GO

-- 12. Find the Maximum Salary Over a Sliding Window of 2 Employees Before and After
SELECT *,
	   MAX(Salary) OVER(ORDER BY HireDate ROWS BETWEEN 2 PRECEDING AND 2 FOLLOWING) AS SlidingWindowMaxSalary
FROM dbo.Employees
ORDER BY HireDate;
GO

-- 13. Determine the Percentage Contribution of Each Employee’s Salary to Their Department’s Total Salary
SELECT *,
		CAST(100.0 * Salary / SUM(Salary) OVER(PARTITION BY Department) AS DECIMAL(5,1)) AS DeptPercent
FROM dbo.Employees
ORDER BY Department;
GO

