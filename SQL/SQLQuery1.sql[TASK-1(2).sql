SELECT * FROM dbo.Swiggy_sales_sample_dataset;
---•	What is the year of the earliest order?
SELECT MIN( YEAR([Order Date])) AS EarliestOrderYear
FROM [Orders$];
-----•	What are the total sales for each quarter of 2022? 2023 AS 2024
SELECT DATEPART(QUARTER, [Order Date]) AS Quarter,
    SUM([Sales]) AS TotalSales
FROM [Orders$]
WHERE YEAR([Order Date]) = 2024
GROUP BY 
    DATEPART(QUARTER, [Order Date])
ORDER BY  Quarter;
	----•	How many orders were placed on the first day of each month in 2024?
	SELECT  DATEPART(MONTH, [Order Date]) AS Month,
    COUNT([Sales]) AS NumberOfOrders
FROM  [Orders$]
WHERE YEAR([Order Date]) = 2024 AND DAY([Order Date]) = 1
GROUP BY 
    DATEPART(MONTH, [Order Date])
ORDER BY 
    Month;
	-----•	What is the difference in days between the earliest and latest order dates?
	SELECT 
	DATEDIFF(DAY, MIN([Order Date]), MAX([Order Date])) AS Date_diffrence
	FROM [Orders$]
	----•	What is the average order value for each day of the week?
	SELECT 
    DATEpart(WEEKDAY, [Order Date]) AS DayOfWeek,
    AVG([Sales]) AS AverageOrderValue
FROM 
    [Orders$]
GROUP BY 
    DATEpart(WEEKDAY, [Order Date])
ORDER BY 
    DATEPART(WEEKDAY, [Order Date]);
	-------•	What are the total sales for orders placed in the month of July across all years?
	SELECT YEAR([Order Date]) As YEAR,
	SUM([Sales]) AS TotalSales
FROM  [Orders$]
WHERE MONTH([Order Date]) = 7
	GROUP BY YEAR([Order Date])
	ORDER BY YEAR;
	--------•	Which month had the highest total sales in 2023? 2024
	SELECT TOP 1 MONTH([Order Date]) AS Month,
   SUM([Sales]) AS TotalSales
FROM  [Orders$]
WHERE  YEAR([Order Date]) = 2024 
GROUP BY  MONTH([Order Date])
ORDER BY 
    TotalSales DESC;
	----------------------•	How many orders were placed on weekends (Saturday and Sunday) in 2018?   2014
	SELECT COUNT([Order ID]) AS NumberOfWeekendOrders
FROM [Orders$]
WHERE 
    YEAR([Order Date]) = 2014 AND DATEPART(WEEKDAY, [Order Date]) IN (1, 7);
	---------------•	What is the average order value for each quarter?
	SELECT  DATEPART(QUARTER, [Order Date]) AS Quarter,
    AVG([Sales]) AS AverageOrderValue
FROM  [Orders$]
GROUP BY DATEPART(QUARTER, [Order Date])
ORDER BY 
    Quarter;
------------------•	What is the earliest order date for each year?
SELECT 
    YEAR([Order Date]) AS Year,
    MIN([Order Date]) AS EarliestOrderDate
FROM [ Orders$]
GROUP BY YEAR([Order Date])
ORDER BY 
    Year;
   ----customer wise total sale ,the total sale should be greater than avg SALE
   ----------------------------------------SUB QUERY-------------------------------------------------
	 Select BG.CustomerID, BG. TSales from (Select C. CustomerID, sum(C. Sales) as TSales from
(select O. CustomerID, UnitPrice*Quantity as Sales from [Order Details] OD inner join
Orders O on OD. OrderID = O. OrderID) C
group by C. CustomerID) BG
where BG.TSales > (Select AVG(AG. TSales)from (Select C.CustomerID, sum(C. Sales) as TSales from
(select O. CustomerID, UnitPrice *Quantity as Sales from [Order Details] OD INNER JOIN
Orders O on OD. OrderID = O. OrderID) C
group by C. CustomerID) AG);
---------------------------------------View-----------------------------------------
Select C1. CustomerID, C1.TSales From CUSTSALES C1 
where C1. TSales > (Select AVG(C2. TSales)
From CUSTSALES C2);
------------------------------------------WITH(CTE)-----------------------------------
WITH CUST_SALES AS( 

     SELECT OD. CustomerID, SUM(OD.UnitPrice*OD.Quantity) AS TSales
     FROM [Order.Details] OD
     INNER JOIN Orders O ON OD.OrderID = O.OrderID
     Group BY OD.CustomerID
)
SELECT C1.CustomerID, C1. TSales 
FROM CUST_SALES C1
WHERE C1. TSales > (Select AVG(C2. TSales)FROM CUST_SALES C2) ;
-----Identify the employes who have the proces more than 50 orders
WITH EmployeeOrderCount AS( 
 SELECT EmployeeID, COUNT(OrderID) AS OrderCount
 FROM [Orders$]
 GROUP BY EmployeeID
 )
    SELECT EmployeeID, OrderCount
     FROM EmployeeOrderCount
      WHERE OrderCount > 50;

---Find customers who placed orders in more than 10 unique months	 
WITH CustomerOrderMonths AS (
    SELECT CustomerID, COUNT(DISTINCT DATEPART(YEAR, OrderDate) * 100 + DATEPART(MONTH, OrderDate)) AS UniqueMonths
    FROM [Orders$]
    GROUP BY CustomerID)
SELECT CustomerID, UniqueMonths
FROM CustomerOrderMonths
WHERE UniqueMonths > 10;

-----identify the top 5 products genarating the higest toteals sales revenu
WITH ProductRevenue AS
( SELECT  P.ProductID, P.ProductName, SUM(OD.UnitPrice * OD.Quantity) AS TotalRevenue
    FROM Products P
    JOIN [Order Details] OD ON P.ProductID = OD.ProductID
    GROUP BY P.ProductID, P.ProductName)
SELECT ProductID, ProductName, TotalRevenue
FROM  ProductRevenue
ORDER BY  TotalRevenue DESC
OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY;


------list orders that ware placed and shiped with in the same month
	WITH OrdersSameMonth AS (
    SELECT OrderID,[CustomerID], OrderDate, [ShippedDate]
    FROM [Orders$]
    WHERE DATEPART(YEAR, OrderDate) = DATEPART(YEAR,[ShippedDate] )
      AND DATEPART(MONTH, OrderDate) = DATEPART(MONTH, [ShippedDate]))
SELECT OrderID, OrderDate, [ShippedDate],[CustomerID]
FROM Orders SameMonth;
 
	

