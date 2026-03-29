-- DDL
CREATE TABLE dbo.Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Department VARCHAR(50),
    Salary DECIMAL(10,2),
    HireDate DATE
);
GO

CREATE TABLE dbo.Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    OrderDate DATE,
    TotalAmount DECIMAL(10,2),
    Status VARCHAR(20) CHECK (Status IN ('Pending', 'Shipped', 'Delivered', 'Cancelled'))
);
GO

CREATE TABLE dbo.Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10,2),
    Stock INT
);
GO

-- Sample Data Inserting
INSERT INTO dbo.Employees (EmployeeID, FirstName, LastName, Department, Salary, HireDate) VALUES
(1, 'John', 'Smith', 'HR', 45000.00, '2021-02-15'),
(2, 'Emma', 'Johnson', 'Finance', 52000.00, '2020-06-10'),
(3, 'Michael', 'Brown', 'IT', 65000.00, '2019-11-01'),
(4, 'Sophia', 'Davis', 'Marketing', 48000.00, '2022-01-20'),
(5, 'James', 'Wilson', 'Sales', 50000.00, '2021-09-12'),
(6, 'Olivia', 'Miller', 'HR', 47000.00, '2023-03-05'),
(7, 'William', 'Moore', 'IT', 72000.00, '2018-07-25'),
(8, 'Isabella', 'Taylor', 'Finance', 56000.00, '2022-10-18'),
(9, 'Benjamin', 'Anderson', 'Sales', 51000.00, '2020-12-30'),
(10, 'Ava', 'Thomas', 'Marketing', 49000.00, '2021-04-14'),
(11, 'Liam', 'Jackson', 'IT', 68000.00, '2017-08-09'),
(12, 'Mia', 'White', 'HR', 46000.00, '2023-01-11'),
(13, 'Noah', 'Harris', 'Finance', 59000.00, '2019-03-22'),
(14, 'Charlotte', 'Martin', 'Sales', 53000.00, '2022-05-19'),
(15, 'Elijah', 'Thompson', 'Marketing', 51000.00, '2020-08-08'),
(16, 'Amelia', 'Garcia', 'IT', 70000.00, '2021-12-01'),
(17, 'Lucas', 'Martinez', 'Finance', 61000.00, '2018-04-16'),
(18, 'Harper', 'Robinson', 'HR', 44000.00, '2022-09-27'),
(19, 'Ethan', 'Clark', 'Sales', 54000.00, '2019-05-06'),
(20, 'Evelyn', 'Rodriguez', 'Marketing', 50000.00, '2023-02-28');
GO

INSERT INTO dbo.Orders (OrderID, CustomerName, OrderDate, TotalAmount, Status) VALUES
(1, 'David Wilson', '2023-01-12', 245.50, 'Pending'),
(2, 'Sarah Johnson', '2023-01-15', 189.99, 'Shipped'),
(3, 'Mike Chen', '2023-01-20', 350.75, 'Delivered'),
(4, 'Lisa Brown', '2023-01-25', 120.00, 'Pending'),
(5, 'Tom Rivera', '2023-02-03', 675.30, 'Shipped'),
(6, 'Emma Davis', '2023-02-10', 89.25, 'Delivered'),
(7, 'James Park', '2023-02-18', 410.80, 'Cancelled'),
(8, 'Rachel Lee', '2023-03-05', 299.00, 'Pending'),
(9, 'Carlos Gomez', '2023-03-12', 150.45, 'Shipped'),
(10, 'Anna Taylor', '2024-03-20', 520.90, 'Delivered'),
(11, 'Kevin Patel', '2023-04-02', 75.00, 'Pending'),
(12, 'Maria Silva', '2024-04-09', 890.25, 'Shipped'),
(13, 'Brian Wong', '2023-04-17', 210.50, 'Delivered'),
(14, 'Sophia Kim', '2025-05-01', 340.75, 'Cancelled'),
(15, 'Alex Turner', '2023-05-08', 125.99, 'Pending'),
(16, 'Linda Ortiz', '2023-05-15', 780.00, 'Shipped'),
(17, 'Daniel Brooks', '2023-06-03', 455.30, 'Delivered'),
(18, 'Grace Nguyen', '2020-06-12', 95.80, 'Pending'),
(19, 'Mark Evans', '2022-06-22', 610.45, 'Shipped'),
(20, 'Julia Moore', '2023-07-05', 275.20, 'Delivered');
GO

INSERT INTO dbo.Products (ProductID, ProductName, Category, Price, Stock) VALUES
(1, 'Laptop', 'Electronics', 850.00, 1),
(2, 'Mouse', 'Electronics', 20.00, 20),
(3, 'Keyboard', 'Electronics', 35.50, 5),
(4, 'Monitor', 'Electronics', 180.00, 0),
(5, 'Desk Chair', 'Furniture', 120.00, 0),
(6, 'Office Desk', 'Furniture', 250.00, 2),
(7, 'Notebook', 'Stationery', 3.50, 5),
(8, 'Pen Pack', 'Stationery', 5.99, 0),
(9, 'Water Bottle', 'Accessories', 12.00, 0),
(10, 'Backpack', 'Accessories', 45.00, 60),
(11, 'Smartphone', 'Electronics', 699.99, 25),
(12, 'Tablet', 'Electronics', 399.99, 1),
(13, 'Printer', 'Electronics', 220.00, 10),
(14, 'Headphones', 'Electronics', 75.00, 7),
(15, 'Lamp', 'Furniture', 40.00, 55),
(16, 'File Folder', 'Stationery', 2.00, 1),
(17, 'Calculator', 'Stationery', 18.25, 12),
(18, 'USB Drive', 'Accessories', 15.00, 25),
(19, 'Speaker', 'Electronics', 90.00, 4),
(20, 'Desk Organizer', 'Furniture', 25.00, 6);
GO

-- Task 1: Employee Salary Report
-- Write an SQL query that:
--  Groups them by department and calculates the average salary per department.
--  Displays a new column `SalaryCategory`:
--    'High' if Salary > 80,000  
--    'Medium' if Salary is between 50,000 and 80,000  
--    'Low' otherwise.  
--  Orders the result by `AverageSalary` descending.
--  Skips the first 2 records and fetches the next 5.

SELECT *, 
       AVG(Salary) OVER(PARTITION BY Department) AS Avg_Salary_Dept,
       CASE 
            WHEN Salary > 80000 THEN 'High'
            WHEN Salary >= 50000 THEN 'Medium'
            ELSE 'Low'
       END AS SalaryCategory
FROM dbo.Employees
ORDER BY Avg_Salary_Dept DESC
OFFSET 2 ROWS FETCH NEXT 5 ROWS ONLY;
GO

-- Task 2: Customer Order Insights
-- Write an SQL query that:
--  Selects customers who placed orders between '2023-01-01' and '2023-12-31'.  
--  Includes a new column `OrderStatus` that returns:
--    'Completed' for Shipped or Delivered orders.  
--    'Pending' for Pending orders.  
--    'Cancelled' for Cancelled orders.  
--- Groups by `OrderStatus` and finds the total number of orders and total revenue.  
--- Filters only statuses where revenue is greater than 5000.  
--- Orders by `TotalRevenue` descending.

SELECT OrderStatus,
       COUNT(OrderStatus) AS TotalOrders,
       SUM(TotalAmount) AS TotalRevenue
FROM (SELECT *,
       CASE
            WHEN Status IN ('Shipped', 'Delivered') THEN 'Completed'
            WHEN Status = 'Pending' THEN 'Pending'
            ELSE 'Cancelled'
       END AS OrderStatus
FROM dbo.Orders
WHERE OrderDate BETWEEN '2023-01-01' AND '2023-12-31') AS mytable
GROUP BY OrderStatus
HAVING SUM(TotalAmount) > 5000
ORDER BY TotalRevenue DESC;
GO

-- Task 3: Product Inventory Check
-- Write an SQL query that:
--  Selects distinct product categories.
--  Finds the most expensive product in each category.
--  Assigns an inventory status using `IIF`:
--    'Out of Stock' if `Stock = 0`.  
--    'Low Stock' if `Stock` is between 1 and 10.  
--    'In Stock' otherwise.  
--  Orders the result by `Price` descending and skips the first 5 rows.

WITH MostExpensive AS (
    SELECT Category, MAX(Price) AS MostExpensivePrice
    FROM dbo.Products 
    GROUP BY Category
)
SELECT m.Category, m.MostExpensivePrice,
       IIF(p.Stock = 0, 'Out of Stock',
            IIF(p.Stock BETWEEN 1 AND 10, 'Low Stock', 'In Stock')) AS Status
FROM MostExpensive m
JOIN dbo.Products p ON m.Category = p.Category AND m.MostExpensivePrice = p.Price
ORDER BY m.MostExpensivePrice DESC
OFFSET 5 ROWS;
GO