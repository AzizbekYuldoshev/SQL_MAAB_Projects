-- 1. NOT NULL Constraint
-- Create a table named `student` with columns:  
--  `id` (integer, should not allow NULL values**)  
--  `name` (string, can allow NULL values)  
--  `age` (integer, can allow NULL values)  
--- First, create the table without the NOT NULL constraint.  
--- Then, use `ALTER TABLE` to apply the NOT NULL constraint to the `id` column.  

CREATE TABLE dbo.student(
    id INT,
    name NVARCHAR(50),
    age TINYINT
);
GO

ALTER TABLE dbo.student
ALTER COLUMN id INT NOT NULL; 
GO

-- 2. UNIQUE Constraint
-- Create a table named `product` with the following columns:  
--  `product_id` (integer, should be unique)  
--  `product_name` (string, no constraint)  
--  `price` (decimal, no constraint)  
-- First, define `product_id` as UNIQUE inside the `CREATE TABLE` statement.  
-- Then, drop the unique constraint and add it again using `ALTER TABLE`.  
-- Extend the constraint so that the combination of `product_id` and `product_name` must be unique.  

CREATE TABLE dbo.product(
    product_id INT CONSTRAINT UQ_product_id UNIQUE,
    product_name NVARCHAR(50),
    price FLOAT 
);
GO

ALTER TABLE dbo.product
DROP CONSTRAINT UQ_product_id;
GO

ALTER TABLE dbo.product
ADD CONSTRAINT UQ_product_id UNIQUE(product_id);
GO

ALTER TABLE dbo.product
ADD CONSTRAINT UQ_product_id_name UNIQUE(product_id, product_name);
GO

-- 3. PRIMARY KEY Constraint 
-- Create a table named `orders` with:  
--  `order_id` (integer, should be the primary key)  
--  `customer_name` (string, no constraint)  
--  `order_date` (date, no constraint)  
--- First, define the primary key inside the `CREATE TABLE` statement.  
--- Then, drop the primary key and add it again using `ALTER TABLE`.  

CREATE TABLE dbo.orders(
    order_id INT CONSTRAINT PK_order_id PRIMARY KEY,
    customer_name VARCHAR(50),
    order_date DATE
);
GO

ALTER TABLE dbo.orders
DROP CONSTRAINT PK_order_id;
GO

ALTER TABLE dbo.orders
ADD CONSTRAINT PK_order_id PRIMARY KEY(order_id);
GO
-- 4. FOREIGN KEY Constraint
-- Create two tables:  
--  `category`:  
--    `category_id` (integer, primary key)  
--    `category_name` (string)  
--  `item`:  
--    `item_id` (integer, primary key)  
--    `item_name` (string)  
--    `category_id` (integer, should be a foreign key referencing category_id in category table)  
-- First, define the foreign key inside `CREATE TABLE`.  
-- Then, drop and add the foreign key using `ALTER TABLE`.  

CREATE TABLE dbo.category(
    category_id INT CONSTRAINT PK_category_id PRIMARY KEY,
    category_name VARCHAR(50)
);
GO

CREATE TABLE dbo.item(
    item_id INT CONSTRAINT PK_item_id PRIMARY KEY,
    item_name VARCHAR(50),
    category_id INT CONSTRAINT FK_ctg_id FOREIGN KEY REFERENCES dbo.category(category_id)
);
GO


ALTER TABLE dbo.item
DROP CONSTRAINT FK_ctg_id;
GO

ALTER TABLE dbo.item
ADD CONSTRAINT FK_ctg_id FOREIGN KEY(category_id) REFERENCES dbo.category(category_id);
GO

-- 5. CHECK Constraint
-- Create a table named `account` with:  
--  `account_id` (integer, primary key)  
--  `balance` (decimal, should always be greater than or equal to 0)  
--  `account_type` (string, should only accept values `'Saving'` or `'Checking'`)  
-- Use `CHECK` constraints to enforce these rules.  
-- First, define the constraints inside `CREATE TABLE`.  
-- Then, drop and re-add the `CHECK` constraints using `ALTER TABLE`.  

CREATE TABLE dbo.account(
    account_id INT CONSTRAINT PK_acc_id PRIMARY KEY,
    balance DECIMAL CONSTRAINT CK_balance CHECK(balance >= 0),
    account_type VARCHAR(25) CONSTRAINT CK_acc_type CHECK(account_type = 'Saving' or account_type = 'Checking')
);
GO

ALTER TABLE dbo.account
DROP CONSTRAINT CK_balance;
GO

ALTER TABLE dbo.account
ADD CONSTRAINT CK_balance CHECK(balance>=0);
GO

-- 6. DEFAULT Constraint
-- Create a table named `customer` with:  
--  `customer_id` (integer, primary key)  
--  `name` (string, no constraint)  
--  `city` (string, should have a default value of `'Unknown'`)  
-- First, define the default value inside `CREATE TABLE`.  
-- Then, drop and re-add the default constraint using `ALTER TABLE`.  

CREATE TABLE dbo.customer(
    customer_id INT CONSTRAINT PK_customer_id PRIMARY KEY,
    name VARCHAR(50),
    city VARCHAR(50) CONSTRAINT DF_city DEFAULT('Unknown')
);
GO

ALTER TABLE dbo.customer
DROP CONSTRAINT DF_city;
GO

ALTER TABLE dbo.customer
ADD CONSTRAINT DF_city DEFAULT('Unknown') FOR city;
GO

-- 7. IDENTITY Column
-- Create a table named `invoice` with:  
--  `invoice_id` (integer, should auto-increment starting from 1)  
--  `amount` (decimal, no constraint)  
--- Insert 5 rows into the table without specifying `invoice_id`.  
--- Enable and disable `IDENTITY_INSERT`, then manually insert a row with `invoice_id = 100`.  

CREATE TABLE dbo.invoice(
    invoice_id INT IDENTITY(1,1),
    amount DECIMAL
);
GO

INSERT INTO dbo.invoice(amount)
VALUES (10),
       (20),
       (30),
       (40),
       (50);
GO

SELECT *
FROM dbo.invoice;
GO

SET IDENTITY_INSERT dbo.invoice ON
INSERT INTO dbo.invoice(invoice_id, amount)
VALUES (100, 60)
SET IDENTITY_INSERT dbo.invoice OFF;
GO

SELECT *
FROM dbo.invoice;
GO

-- 8. All at once
-- Create a `books` table with:  
--  `book_id` (integer, primary key, auto-increment)  
--  `title` (string, must not be empty)  
--  `price` (decimal, must be greater than 0)  
--  `genre` (string, default should be `'Unknown'`)  
-- Insert data and test if all constraints work as expected.  

CREATE TABLE dbo.books(
    book_id INT IDENTITY(1,1) CONSTRAINT PK_book_id PRIMARY KEY,
    title VARCHAR(50) NOT NULL,
    price DECIMAL CONSTRAINT CK_price CHECK(price > 0 ),
    genre VARCHAR(50) CONSTRAINT DF_genre DEFAULT('Unknown')
);
GO

-- Checking IDENTITY
-- Result: Cannot insert explicit value for identity column in table 'books' when IDENTITY_INSERT is set to OFF.
INSERT INTO books(book_id, title, price, genre)
VALUES (1, 'Atomic Habits', 15, 'Self development');

-- Checking NOT NULL
-- Result: Cannot insert the value NULL into column 'title', table 'MAAB_Projects.dbo.books'; column does not allow nulls. INSERT fails.
INSERT INTO books(price, genre)
VALUES (15, 'Self development');

-- Checking CHECK
-- Result: The INSERT statement conflicted with the CHECK constraint "CK_price". The conflict occurred in database "MAAB_Projects", table "dbo.books", column 'price'.
INSERT INTO books(title, price, genre)
VALUES ('Atomic Habits', -15, 'Self development');

-- 9. Scenario: Library Management System
-- You need to design a simple database for a library where books are borrowed by members.  

-- Tables and Columns:

--1.Book (Stores information about books)  
--   `book_id` (Primary Key)  
--   `title` (Text)  
--   `author` (Text)  
--   `published_year` (Integer)  

--2.Member (Stores information about library members)  
--   `member_id` (Primary Key)  
--   `name` (Text)  
--   `email` (Text)  
--   `phone_number` (Text)  

--3.Loan (Tracks which members borrow which books)  
--   `loan_id` (Primary Key)  
--   `book_id` (Foreign Key ? References `book.book_id`)  
--   `member_id` (Foreign Key ? References `member.member_id`)  
--   `loan_date` (Date)  
--   `return_date` (Date, can be NULL if not returned yet)  

--Tasks:  
--1.Understand Relationships 
--   A member can borrow multiple books.  
--   A book can be borrowed by different members at different times.  
--   The Loan table connects `Book` and `Member` (Many-to-Many).  

--2.Write SQL Statements  
--   Create the tables with proper constraints (Primary Key, Foreign Key).  
--   Insert at least 2-3 sample records into each table.

CREATE TABLE dbo.book(
    book_id INT CONSTRAINT PK_book_id PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    author VARCHAR(50) NOT NULL,
    published_year INT NOT NULL 
);
GO

CREATE TABLE dbo.member(
    member_id INT CONSTRAINT PK_member_id PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    email VARCHAR(100),
    phone_number VARCHAR(50)
);
GO

CREATE TABLE dbo.loan(
    loan_id INT CONSTRAINT PK_loan_id PRIMARY KEY,
    book_id INT CONSTRAINT FK_book_id FOREIGN KEY REFERENCES dbo.book(book_id),
    member_id INT CONSTRAINT FK_member_id FOREIGN KEY REFERENCES dbo.member(member_id),
    loan_date DATE NOT NULL,
    return_date DATE
);
GO

INSERT INTO book(book_id, title, author, published_year) VALUES
  (1, 'Clean Code', 'Robert C. Martin', 2008),
  (2, 'Atomic Habits', 'James Clear', 2018);

INSERT INTO member(member_id, name, email, phone_number) VALUES
  (1, 'Alice', 'alice@example.com', '010-0000-0001'),
  (2, 'Bob', 'bob@example.com', '010-0000-0002');

INSERT INTO loan(loan_id, book_id, member_id, loan_date, return_date) VALUES
  (1, 1, 1, '2025-01-10', '2025-01-20'),
  (2, 2, 1, '2025-02-01', NULL),
  (3, 2, 2, '2025-03-05', NULL);
