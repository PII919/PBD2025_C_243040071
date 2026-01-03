USE RetailStoreDB2;


SELECT * FROM HumanResources.Department;
SELECT * FROM HumanResources.Shift;

SELECT 
d.Name AS DepartementName,
s.Name AS ShiftName
FROM HumanResources.Department AS d
CROSS JOIN HumanResources.Shift AS s;


SELECT * FROM Production.Product;
SELECT * FROM Production.ProductCategory;
SELECT * FROM Production.ProductSubcategory;

SELECT 
p.Name AS ProductName, 
pc.Name AS CategoryName 
FROM Production.Product AS p 
JOIN Production.ProductSubcategory AS ps ON p.ProductSubcategoryID = 
ps.ProductSubcategoryID 
JOIN Production.ProductCategory AS pc ON ps.ProductCategoryID = 
pc.ProductCategoryID; 


SELECT * FROM Sales.Customer;
SELECT * FROM Sales.SalesOrderHeader;

SELECT 
c.CustomerID, 
soh.SalesOrderID 
FROM Sales.Customer AS c 
LEFT JOIN Sales.SalesOrderHeader AS soh ON c.CustomerID = 
soh.CustomerID;

SELECT * FROM sales.SalesOrderDetail;
SELECT * FROM sales.SpecialOfferProduct;

SELECT od.SalesOrderID,
sop.CardType
FROM Sales.SalesOrderDetail AS od
JOIN Sales.SpecialOfferProduct AS sop
ON od.ProductID = sop.ProductID;

SELECT 
ps.Name AS Subcategory, 
top_products.Name, 
top_products.ListPrice 
FROM Production.ProductSubcategory AS ps 
CROSS APPLY ( 
	SELECT TOP(3) Name, ListPrice 
	FROM Production.Product 
	WHERE ProductSubcategoryID = ps.ProductSubcategoryID
	ORDER BY ListPrice DESC 
) AS top_products;


SELECT 
	ps.Name AS Subcategory, 
	top_products.Name 
FROM Production.ProductSubcategory AS ps 
OUTER APPLY ( 
	SELECT TOP(3) Name 
	FROM Production.Product 
	WHERE ProductSubcategoryID = ps.ProductSubcategoryID 
	ORDER BY ListPrice DESC 
) AS top_products; 


SELECT 
soh.SalesOrderID, 
calc.DaysDiff, 
calc.Status 
FROM Sales.SalesOrderHeader AS soh 
CROSS APPLY ( 
SELECT DATEDIFF(day, OrderDate, ShipDate) AS DaysDiff, 
CASE WHEN DATEDIFF(day, OrderDate, ShipDate) > 7 THEN 
'Late' ELSE 'OnTime' END AS Status 
) AS calc; 


-- Hanya jalan di SQL Server 2016+ 
SELECT p.Name, tags.value 
FROM Production.Product AS p 
CROSS APPLY STRING_SPLIT(p.Color, ',') AS tags -- Asumsi Color bisa 
multivalue (simulasi) 
WHERE p.Color IS NOT NULL; 


SELECT TerritoryID, [2011], [2012], [2013] 
FROM ( 
SELECT TerritoryID, YEAR(OrderDate) AS OrderYear, TotalDue 
FROM Sales.SalesOrderHeader 
) AS SourceTable 
PIVOT ( 
SUM(TotalDue) 
FOR OrderYear IN ([2011], [2012], [2013]) 
) AS PivotTable; 


SELECT Gender, [M] AS Married, [S] AS Single 
FROM ( 
	SELECT Gender, MaritalStatus, BusinessEntityID 
	FROM HumanResources.Employee 
) AS Source 
PIVOT ( 
	COUNT(BusinessEntityID) 
	FOR MaritalStatus IN ([M], [S]) 
) AS Pvt; 


SELECT TerritoryID, 
	ISNULL([2011], 0) AS Sales2011, 
	ISNULL([2012], 0) AS Sales2012 
FROM ( -- Source Query 
	SELECT TerritoryID, YEAR(OrderDate) AS OrderYear, TotalDue 
	FROM Sales.SalesOrderHeader 
) AS Src 
PIVOT ( 
	SUM(TotalDue) FOR OrderYear IN ([2011], [2012]) 
) AS Pvt; 


-- Query yang "Salah" / Tidak Optimal 
SELECT * FROM Sales.SalesOrderHeader 
PIVOT (SUM(TotalDue) FOR YEAR(OrderDate) IN ([2011])) AS pvt 


