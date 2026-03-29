-- Task 1: 
-- If all the columns having zero value then don't show that row.

CREATE TABLE [dbo].[TestMultipleZero]
(
    [A] [int] NULL,
    [B] [int] NULL,
    [C] [int] NULL,
    [D] [int] NULL
);
GO

INSERT INTO [dbo].[TestMultipleZero](A,B,C,D)
VALUES 
    (0,0,0,1),
    (0,0,1,0),
    (0,1,0,0),
    (1,0,0,0),
    (0,0,0,0),
    (1,1,1,0);
GO

SELECT *
FROM dbo.TestMultipleZero
WHERE NOT (A=0 AND B=0 AND C=0 AND D=0);

-- Task 2
-- Write a query which will find maximum value from multiple columns of the table.

CREATE TABLE dbo.TestMax
(
    Year1 INT
    ,Max1 INT
    ,Max2 INT
    ,Max3 INT
);
GO
 
INSERT INTO dbo.TestMax 
VALUES
     (2001,10,101,87)
    ,(2002,103,19,88)
    ,(2003,21,23,89)
    ,(2004,27,28,91);
GO

SELECT Year1
FROM dbo.TestMax
GROUP BY Year1;

SELECT Year1,
       CASE
            WHEN Max1 > Max2 AND Max1 > Max3 THEN Max1
            WHEN Max2 > Max1 AND Max2 > Max3 THEN Max2
            ELSE Max3
       END AS MaxValue
FROM dbo.TestMax

-- Task 3
--Write a query which will find the Date of Birth of employees whose birthdays lies between May 7 and May 15.

CREATE TABLE EmpBirth
(
     EmpId INT  IDENTITY(1,1) 
    ,EmpName VARCHAR(50) 
    ,BirthDate DATETIME 
);
GO

INSERT INTO EmpBirth(EmpName,BirthDate)
SELECT 'Pawan' , '12/04/1983'
UNION ALL
SELECT 'Zuzu' , '11/28/1986'
UNION ALL
SELECT 'Parveen', '05/07/1977'
UNION ALL
SELECT 'Mahesh', '01/13/1983'
UNION ALL
SELECT'Ramesh', '05/09/1983';
GO

SELECT *
FROM dbo.EmpBirth
WHERE FORMAT(BirthDate, 'MM/dd') BETWEEN '05/07' AND '05/15';

-- Task 4
--  Order letters but 'b' must be first/last

CREATE TABLE dbo.letters(
    letter CHAR(1)
);
GO

INSERT INTO dbo.letters
VALUES 
  ('a'), ('a'), ('a'), ('b'), 
  ('c'), ('d'), ('e'), ('f');
GO

-- b as 1st value
SELECT letter, 
       CASE 
            WHEN letter = 'b' THEN 1
            ELSE 2
       END AS Ranking
FROM dbo.letters
ORDER BY Ranking, letter;
GO

-- b as last value

SELECT letter, 
       CASE 
            WHEN letter = 'b' THEN 2
            ELSE 1
       END AS Ranking
FROM dbo.letters
ORDER BY Ranking, letter;
GO