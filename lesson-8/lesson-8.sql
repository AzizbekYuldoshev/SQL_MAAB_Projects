--1. Write an SQL statement that counts the consecutive values in the Status field.
CREATE TABLE dbo.Groupings (
    StepNumber INT,
    Status VARCHAR(10)
);

INSERT INTO dbo.Groupings VALUES
(1,  'Passed'),
(2,  'Passed'),
(3,  'Passed'),
(4,  'Passed'),
(5,  'Failed'),
(6,  'Failed'),
(7,  'Failed'),
(8,  'Failed'),
(9,  'Failed'),
(10, 'Passed'),
(11, 'Passed'),
(12, 'Passed');

--Expected Output:

--| **Min Step Number** | **Max Step Number** | **Status** | **Consecutive Count** |
--| ------------------- | ------------------- | ---------- | --------------------- |
--| 1                   | 4                   | Passed     | 4                     |
--| 5                   | 9                   | Failed     | 5                     |
--| 10                  | 12                  | Passed     | 3                     |

WITH cte AS (SELECT *,
       StepNumber - ROW_NUMBER() OVER(PARTITION BY Status ORDER BY StepNumber) AS diff
FROM dbo.Groupings)
SELECT MIN(StepNumber) AS [Min Step Number], 
       MAX(StepNumber) AS [Max Step Number], 
       Status,
       [Consecutive Count] = COUNT(*)
FROM cte
GROUP by Status, diff;

--2. Find all the year-based intervals from 1975 up to current when the company did not hire employees.

CREATE TABLE [dbo].[EMPLOYEES_N]
(
    [EMPLOYEE_ID] [int] NOT NULL,
    [FIRST_NAME] [varchar](20) NULL,
    [HIRE_DATE] [date] NOT NULL
);

INSERT INTO dbo.EMPLOYEES_N VALUES
(1,  'John',    '1975-03-15'),
(2,  'Sarah',   '1976-07-22'),
(3,  'Mike',    '1977-11-05'),
(4,  'Lisa',    '1979-04-18'),
(5,  'David',   '1980-09-30'),
(6,  'Emma',    '1982-02-14'),
(7,  'James',   '1983-06-25'),
(8,  'Anna',    '1984-10-08'),
(9,  'Robert',  '1985-01-19'),
(10, 'Claire',  '1990-05-27'),
(11, 'Thomas',  '1997-08-13'),
(12, 'Sophie',  '1997-12-03');


--Expected Output:

--| Years       |
--| ----------- |
--| 1978 - 1978 |
--| 1981 - 1981 |
--| 1986 - 1989 |
--| 1991 - 1996 |
--| 1998 - 2025 |


WITH cte1 AS (
    SELECT *,
           YEAR(HIRE_DATE) - ROW_NUMBER() OVER(ORDER BY HIRE_DATE) AS diff,
           LEAD(HIRE_DATE) OVER(ORDER BY HIRE_DATE) AS NextHireDate
    FROM dbo.EMPLOYEES_N
),
cte2 AS (
    SELECT diff,
           MAX(HIRE_DATE) AS IslandEnd,
           MIN(HIRE_DATE) AS IslandStart
    FROM cte1
    GROUP BY diff
),
cte3 AS (
    SELECT YEAR(c2.IslandEnd) + 1 AS GapStart,
           YEAR(c1.NextHireDate) - 1 AS GapEnd
    FROM cte2 AS c2
    JOIN cte1 AS c1 ON c2.IslandEnd = c1.HIRE_DATE
    WHERE c1.NextHireDate IS NOT NULL
    AND YEAR(c1.NextHireDate) - 1 >= YEAR(c2.IslandEnd) + 1
)
SELECT CONCAT_WS(' - ', CAST(GapStart AS VARCHAR(10)),
                        CAST(GapEnd AS VARCHAR(10))) AS Years
FROM cte3
UNION ALL
SELECT CONCAT_WS(' - ', CAST(YEAR(MAX(HIRE_DATE)) + 1 AS VARCHAR(10)),
                        CAST(YEAR(GETDATE()) AS VARCHAR(10)))
FROM dbo.EMPLOYEES_N;