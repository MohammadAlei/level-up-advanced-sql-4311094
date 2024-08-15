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
-- Q Summarise sales per year by using a CTE
WITH SalePerYear AS (
SELECT strftime('%Y' , soldDate) as soldYear, salesAmount  FROM sales
)
SELECT soldYear,  FORMAT('$%.2f', SUM(salesAmount)) as   TotalSum FROM SalePerYear GROUP BY soldYear ORDER BY soldYear;

SELECT * from sales limit 10;
SELECT * from employee LIMIT 10;

--Q Display cars sold for each employee by month


SELECT e.employeeId as EmpId, e.firstName , e.lastName , s.soldDate as soldDate , s.salesAmount,
  sum(CASE when strftime('%m','01') = '01' THEN salesAmount END) as janSales ,
 sum(CASE when strftime('%m','02') = '02' THEN salesAmount END) as febSales ,
 sum(CASE when strftime('%m','03') = '03' THEN salesAmount END) as marchSales ,
 sum(CASE when strftime('%m','04') = '04' THEN salesAmount END) as AprSales ,
  sum(CASE when strftime('%m','05') = '05' THEN salesAmount END) as MaySales ,
 sum(CASE when strftime('%m','06') = '06' THEN salesAmount END) as  JuneSales ,
 sum(CASE when strftime('%m','07') = '07' THEN salesAmount END) as JulySales ,
  sum(CASE when strftime('%m','08') = '08' THEN salesAmount END) as AugSales ,
  sum(CASE when strftime('%m','09') = '09' THEN salesAmount END) as SepSales ,
 sum(CASE when strftime('%m','10') = '10' THEN salesAmount END) as OctSales ,
 sum(CASE when strftime('%m','11') = '11' THEN salesAmount END) as NovSales ,
  sum(CASE when strftime('%m','12') = '12' THEN salesAmount END) as DecSales 
  from employee e INNER JOIN sales s
 on e.employeeId = s.employeeId where soldDate BETWEEN '2021-01-01' AND '2021-12-31' GROUP BY s.employeeId    order by EmpId;

-- Q Find sales of cars which are electric by using a subquery

select * from sales s WHERE inventoryId in 
(SELECT inventoryId from inventory i INNER JOIN model m on m.modelId = i.modelId where m.EngineType = 'Electric');

-- or this way

select s.soldDate , s.salesAmount , i.colour , i.year from sales s INNER JOIN inventory i  on s.inventoryId = i.inventoryId
where i.modelId in (SELECT modelId from model as m where m.EngineType = 'Electric');