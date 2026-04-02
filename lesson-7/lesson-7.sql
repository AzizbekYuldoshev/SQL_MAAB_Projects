CREATE TABLE dbo.Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100)
);
GO

CREATE TABLE dbo.Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE
);
GO

CREATE TABLE dbo.OrderDetails (
    OrderDetailID INT PRIMARY KEY,
    OrderID INT FOREIGN KEY REFERENCES Orders(OrderID),
    ProductID INT,
    Quantity INT,
    Price DECIMAL(10,2)
);
GO

CREATE TABLE dbo.Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50)
);
GO

-- 1 Retrieve All Customers With Their Orders (Include Customers Without Orders)
--   Use an appropriate `JOIN` to list all customers, their order IDs, and order dates.
--   Ensure that customers with no orders still appear.
SELECT  c.CustomerID,
        c.CustomerName,
        o.OrderID,
        o.OrderDate
FROM dbo.Customers AS c
LEFT JOIN dbo.Orders AS o
ON c.CustomerID = o.CustomerID;
GO

-- 2 Find Customers Who Have Never Placed an Order
--  Return customers who have no orders.
SELECT  c.CustomerID,
        c.CustomerName
FROM dbo.Customers AS c
LEFT JOIN dbo.Orders AS o
ON c.CustomerID = o.CustomerID
WHERE o.OrderID IS NULL;
GO

-- 3 List All Orders With Their Products
--  Show each order with its product names and quantity.
SELECT o.OrderID,
       od.OrderDetailID,
       od.Quantity,
       p.ProductName
FROM dbo.Orders AS o
JOIN dbo.OrderDetails AS od
ON o.OrderID = od.OrderID
JOIN dbo.Products AS p
ON od.ProductID = p.ProductID;
GO

-- 4 Find Customers With More Than One Order
--  List customers who have placed more than one order.
SELECT c.CustomerName
FROM dbo.Customers AS c
JOIN dbo.Orders AS o
ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerName
HAVING COUNT(o.OrderId) > 1;
GO

-- 5 Find the Most Expensive Product in Each Order
SELECT OrderID,
       ProductName,
       MaxPrice
FROM (SELECT od.OrderID,
             p.ProductName,
             od.Price,
             MAX(od.Price) OVER(PARTITION BY od.OrderID) AS MaxPrice
      FROM dbo.OrderDetails AS od
      JOIN dbo.Products AS p
      ON od.ProductID = p.ProductID) AS t
WHERE MaxPrice = Price;
GO

-- 6 Find the Latest Order for Each Customer
SELECT c.*,
       mytable.LatestOrderDate
FROM dbo.Customers AS c
JOIN (SELECT CustomerID,
       MAX(OrderDate) AS LatestOrderDate
FROM dbo.Orders
GROUP BY CustomerID) AS mytable
ON c.CustomerID = mytable.CustomerID;
GO

-- 7 Find Customers Who Ordered Only 'Electronics' Products
--  List customers who only purchased items from the 'Electronics' category.
SELECT c.CustomerName 
FROM dbo.Customers AS c
JOIN dbo.Orders AS o
ON c.CustomerID = o.CustomerID
JOIN dbo.OrderDetails AS od
ON o.OrderID = od.OrderID
JOIN dbo.Products AS p
ON od.ProductID = p.ProductID
GROUP BY c.CustomerName
HAVING COUNT(DISTINCT p.Category) = 1 AND MAX(p.Category) = 'Electronics';
GO

-- 8 Find Customers Who Ordered at Least One 'Stationery' Product
--  List customers who have purchased at least one product from the 'Stationery' category.
SELECT DISTINCT c.CustomerName 
FROM dbo.Customers AS c
JOIN dbo.Orders AS o
ON c.CustomerID = o.CustomerID
JOIN dbo.OrderDetails AS od
ON o.OrderID = od.OrderID
JOIN dbo.Products AS p
ON od.ProductID = p.ProductID
WHERE p.Category = 'Stationery';
GO

-- 9 Find Total Amount Spent by Each Customer
--  Show `CustomerID`, `CustomerName`, and `TotalSpent`.
SELECT c.CustomerID, 
       c.CustomerName,
       SUM(od.Quantity * od.Price) AS TotalSpent
FROM dbo.Customers AS c
JOIN dbo.Orders AS o
ON c.CustomerID = o.CustomerID
JOIN dbo.OrderDetails AS od
ON o.OrderID = od.OrderID
JOIN dbo.Products AS p
ON od.ProductID = p.ProductID
GROUP BY c.CustomerID, c.CustomerName;
GO