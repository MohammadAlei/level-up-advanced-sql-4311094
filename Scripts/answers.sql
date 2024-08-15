--All tables 

SELECT * FROM employee LIMIT 10;
SELECT * FROM customer LIMIT 10;
SELECT * FROM model LIMIT 10;
SELECT * FROM inventory LIMIT 10;
SELECT * FROM sales LIMIT 10;



first chapter
--### Create a list of employees and their immediate managers.

SELECT emp.firstName,
    emp.lastName,
    emp.title,
    mng.firstName AS ManagerFirstName,
    mng.lastName AS ManagerLastName
FROM employee emp
INNER JOIN employee mng
    ON emp.managerId = mng.employeeId

--### Find sales people who have zero sales

SELECT emp.firstName, emp.lastName, emp.title, emp.startDate, sls.salesId
FROM employee emp
LEFT JOIN sales sls
    ON emp.employeeId = sls.employeeId
WHERE emp.title = 'Sales Person'
AND sls.salesId IS NULL;

--### List all customers & their sales, even if some data is gone

SELECT cus.firstName, cus.lastName, cus.email, sls.salesAmount, sls.soldDate
FROM customer cus
INNER JOIN sales sls
    ON cus.customerId = sls.customerId
UNION
-- UNION WITH CUSTOMERS WHO HAVE NO SALES
SELECT cus.firstName, cus.lastName, cus.email, sls.salesAmount, sls.soldDate
FROM customer cus
LEFT JOIN sales sls
    ON cus.customerId = sls.customerId
WHERE sls.salesId IS NULL
UNION
-- UNION WITH SALES MISSING CUSTOMER DATA
SELECT cus.firstName, cus.lastName, cus.email, sls.salesAmount, sls.soldDate
FROM sales sls
LEFT JOIN customer cus
    ON cus.customerId = sls.customerId
WHERE cus.customerId IS NULL;

2nd chapter
--## How many cars has been sold per employee
SELECT emp.employeeId, emp.firstName, emp.lastName, count(*) as NumOfCarsSold
FROM sales sls
INNER JOIN employee emp
    ON sls.employeeId = emp.employeeId
GROUP BY emp.employeeId, emp.firstName, emp.lastName
ORDER BY NumOfCarsSold DESC;

--## Find the least and most expensive car sold by each employee this year

SELECT MIN(s.salesAmount) as minAmount , MAX(s.salesAmount) as maxAmount , e.firstName  from employee e inner join sales s on s.employeeId = e.employeeId WHERE s.soldDate >= date('now','start of year') GROUP BY e.employeeId ORDER by maxAmount;
select MAX(s.soldDate) from sales s 

-- Display report for employees who have sold at least 5 cars

SELECT e.employeeId , count(*) as saleCount FROM employee e inner JOIN sales s on s.employeeId = e.employeeId  GROUP by s.employeeId HAVING  saleCount >= 5  ;


3rd chapter
-- Summarise sales per year by using a CTE
WITH SalePerYear AS (
SELECT strftime('%Y' , soldDate) as soldYear, salesAmount  FROM sales
)
SELECT soldYear,  FORMAT('$%.2f', SUM(salesAmount)) as   TotalSum FROM SalePerYear GROUP BY soldYear ORDER BY soldYear;

SELECT * from sales
-- Display cars sold for each employee by month




