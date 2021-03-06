-- Northwind 
--Table: Customers
--1. Display the ?Company Name? and ?Contact Name? from Customers table
SELECT COMPANYNAME, CONTACTNAME FROM CUSTOMERS
--2. Find the Customers who are staying wither in USA, UK, Germany, France
SELECT * FROM CUSTOMERS WHERE COUNTRY IN ('USA', 'UK', 'GERMANY')
--3. Find the Customers whose ?Company Name? starts with G
SELECT * FROM CUSTOMERS WHERE COMPANYNAME LIKE 'G%'
--4. List all the Customers who are located in Paris
SELECT * FROM CUSTOMERS WHERE CITY='PARIS'
--5. List the Customer details whose postal code start with 4
SELECT * FROM CUSTOMERS WHERE POSTALCODE LIKE '4%'
--6. List all the Customers who neither stay in Canada nor in Brazil
SELECT * FROM CUSTOMERS WHERE COUNTRY NOT IN ('CANADA', 'BRAZIL')
--7. Print total number of Customers for each country.
SELECT COUNTRY, COUNT(CUSTOMERID) AS #OFCUST FROM CUSTOMERS GROUP BY COUNTRY
--8. List Customers detail based on Country and City
SELECT * FROM CUSTOMERS ORDER BY COUNTRY, CITY
--9. List all the manager from the Customers table
SELECT * FROM CUSTOMERS WHERE CONTACTTITLE LIKE '%MANAGER%'
--10. List all Customers details where ?company name? contains aphostophy (?)
SELECT * FROM CUSTOMERS WHERE COMPANYNAME LIKE '%''%' 

--Table: Products
--11. List all the products for CategoryID 4 and UnitsInStock is more then 50
SELECT * FROM PRODUCTS WHERE CATEGORYID=4 AND UNITSINSTOCK>50
--12. List ProductName, UnitPrice, UnitsInStock, NetStock (i.e. UnitPrice * UnitsInStock)
SELECT PRODUCTNAME, UNITPRICE, UNITSINSTOCK, UNITPRICE * UNITSINSTOCK AS NETSTOCK FROM PRODUCTS
--13. List Maximum and Minimum UnitPrice
SELECT MAX(UNITPRICE), MIN(UNITPRICE) FROM PRODUCTS
--14. Count the number of products whose UnitPrice is more then 50
SELECT COUNT(PRODUCTID) FROM PRODUCTS WHERE UNITPRICE>50
--15. List product count base on CategoryID. List the data where count is more then 10
SELECT COUNT(PRODUCTID) AS COUNT FROM PRODUCTS GROUP BY CategoryID HAVING COUNT(PRODUCTID)>10
--16. Find all the products where UnitsInStock in less than Reorder Level
SELECT * FROM PRODUCTS WHERE UnitsInStock < ReorderLevel
--17. List Category wise, Supplier wise product count
SELECT CATEGORYID,SUPPLIERID,COUNT(PRODUCTID) FROM PRODUCTS GROUP BY CategoryID, SupplierID
--18. All Products whose UnitsInStock is less than 5 units are entitles for placing order by 50 units for
--others place the order by 30 units. Display ProductID, ProductName, UnitsInStock,
--OrderedUnits.
SELECT PRODUCTID, PRODUCTNAME, UNITSINSTOCK, UNITSONORDER, CASE
	WHEN UnitsInStock < 5 THEN 50
	ELSE 30
END AS ORDERR FROM PRODUCTS		
--19. List 3 costliest product
SELECT TOP 3 * FROM PRODUCTS ORDER BY UnitPrice DESC
--20. List all the products whose CategoryID is 1 and SupplierID is either 10 or 12 or CategoryID is 4
--and SupplierID is either 14 or 15.
SELECT * FROM PRODUCTS WHERE (CategoryID=1 AND SupplierID IN (10,12)) OR (CategoryID=4 AND SupplierID IN (14,15)) 

--Table: Orders
--21. List all the orders placed in month of February
SELECT * FROM ORDERS WHERE DATEPART(MM, ORDERDATE)=2
--22. List year wise order count
SELECT DATEPART(YY, ORDERDATE) YEAR, COUNT(ORDERID) #ORDERS FROM ORDERS GROUP BY DATEPART(YY, ORDERDATE)
--23. List the ShipCountry for which total order placed is more than 100
--Example
--ShipCountry OrderCount
--USA 122
--...
SELECT SHIPCOUNTRY AS ShipCountry, COUNT(ORDERID) AS OrderCount FROM ORDERS GROUP BY SHIPCOUNTRY HAVING COUNT(ORDERID) > 100
--24. List the data as per the order month (Jan ? Dec)
SELECT * FROM ORDERS ORDER BY DATEPART(MM, ORDERDATE)
--25. List unique country name in ascending order where product is shipped
SELECT DISTINCT ShipCountry FROM ORDERS WHERE ShippedDate IS NOT NULL ORDER BY ShipCountry
--26. List CustomerID, ShipCity, ShipCountry, ShipRegion from Ordrs table. If ShipRegion is null than
--display message as ?No Region?
SELECT CustomerID, ShipCity, ShipCountry, CASE
	WHEN SHIPREGION IS NULL THEN 'NO REGION'
	ELSE SHIPREGION	
END AS SHIPREGION FROM ORDERS	
--27. List the detail of first order placed
SELECT TOP 1 * FROM ORDERS ORDER BY ORDERDATE
--28. List Customer wise, Year wise (Order date) order placed
--Example
--CustomerID Year OrderCount
--ANATR 1996 1
--BONAP 1997 8
--...
SELECT CustomerID, Year(ORDERDATE)AS YEAR, Count(ORDERID) AS ORDERCOUNT FROM ORDERS GROUP BY CustomerID, Year(ORDERDATE)
--29. List all the orders handled by employeeid 4 for the month of December
SELECT * FROM ORDERS WHERE EmployeeID=4 AND MONTH(ORDERDATE)=12
--30. List employee wise , year wise, month wise ordercount
SELECT EMPLOYEEID, YEAR(ORDERDATE), MONTH(ORDERDATE), COUNT(ORDERID) AS COUNT FROM ORDERS GROUP BY EMPLOYEEID, YEAR(ORDERDATE), MONTH(ORDERDATE)

--Table: [Order Details]
--31. List all the data of [Order Details] table
SELECT * FROM [Order Details]
--32. List ProductID, UnitPrice, Qty and Total. Sort data on Total column with highest value on top
SELECT ProductID, UnitPrice, QUANTITY, (UNITPRICE*QUANTITY) AS Total FROM [Order Details] ORDER BY (UNITPRICE*QUANTITY) DESC
--33. In above query,
--If Total is more than 10000 display 10% discount on Total cost
--If Total is more than 5000 display 5% discount on Total cost
--If Total is more than 3000 display 2% discount on Total cost
--else Rs. 300 as discount if total is more than 1000
--No discount for Total less than 1000
SELECT ProductID, UnitPrice, QUANTITY, (UNITPRICE*QUANTITY) AS Total, CASE 
	WHEN (UNITPRICE*QUANTITY) > 10000 THEN 0.1 * (UNITPRICE*QUANTITY)
	WHEN (UNITPRICE*QUANTITY) > 5000 THEN 0.05 * (UNITPRICE*QUANTITY)
	WHEN (UNITPRICE*QUANTITY) > 3000 THEN 0.02 * (UNITPRICE*QUANTITY)
	WHEN (UNITPRICE*QUANTITY) > 1000 THEN 300
	--ELSE NULL
END AS DISCOUNT
FROM [Order Details] ORDER BY (UNITPRICE*QUANTITY) DESC
--34. List Total order placed for each OrderId
SELECT ORDERID, COUNT(ORDERID) AS #ORDERS FROM [Order Details] GROUP BY ORDERID
--35. List minimum cost and maximum cost order value
SELECT MIN(UNITPRICE*QUANTITY) MINORDER, MAX(UNITPRICE*QUANTITY) MAXORDER FROM [Order Details]


--JOIN AND SUBQUERY ASSIGNMENT

--1 LIST ALL THE PRODUCTS DETAILS WHOSE CATEGORY IS SAME AS 'TOFU'
--SELECT * FROM Categories
--SELECT * FROM PRODUCTS
SELECT * FROM PRODUCTS WHERE CATEGORYID = (SELECT CATEGORYID FROM Products WHERE ProductName='TOFU')
--2 LIST ALL THE PRODUCTS DETAILS FOR THE CATEGORY 'BEVERAGES'
SELECT * FROM PRODUCTS WHERE CATEGORYID = (SELECT CategoryID FROM CATEGORIES WHERE CATEGORYNAME='BEVERAGES')
--3 LIST ALL THE ORDERS PLACED BY THE COMPANY NAME "ISLAND TRADING"
SELECT * FROM ORDERS WHERE CUSTOMERID = (SELECT CUSTOMERID FROM CUSTOMERS WHERE CompanyName='ISLAND TRADING')
--4 LIST COMPANY NAME AND NO OF ORDER COUNT PLACED BY EACH COMPANY
SELECT C.COMPANYNAME, COUNT(O.OrderID) #ORDERS FROM CUSTOMERS C JOIN ORDERS O ON O.CUSTOMERID=C.CUSTOMERID GROUP BY C.COMPANYNAME
--5 LIST ORDERID, CUSTOMER_COMAPNAYNAME FOR ALL THE ORDERS WHICH ARE HANDLE BY THE EMPLOYEES WHOSE TITLE IS "SALES MANAGER"
SELECT O.ORDERID, C.CompanyName FROM ORDERS O JOIN CUSTOMERS C ON O.CustomerID=C.CustomerID WHERE O.EmployeeID IN (SELECT EmployeeID FROM Employees WHERE Title='SALES MANAGER')
--6 LIST 3RD HIGHEST COSTLIEST PRODUCT
SELECT * FROM (SELECT *,DENSE_RANK() OVER (ORDER BY	UNITPRICE DESC) AS R FROM PRODUCTS) AS T WHERE R=3
--7 FOR THE PRODUCT TABLE DISPLAY PRODUCTNAME AND CATEGORYNAME. ARRANGE AS PER THE CATEGORYNAME
SELECT P.PRODUCTNAME, C.CATEGORYNAME FROM PRODUCTS P JOIN Categories C ON P.CategoryID=C.CategoryID ORDER BY C.CategoryName
--8 FOR THE ORDERS TABLE DISPLAY ORDERID CUSTOMER_COMPANYNAME AND EMPLOYEE_FULLNAME
SELECT O.ORDERID, C.COMPANYNAME, E.FIRSTNAME+' '+E.LASTNAME AS FULLNAME FROM ORDERS O JOIN CUSTOMERS C ON O.CUSTOMERID=C.CUSTOMERID JOIN EMPLOYEES E ON O.EMPLOYEEID=E.EMPLOYEEID
--9 LIST ORDERID, EMPLOYEE_FULLNAME, CUSTOMER_COMPANYNAME, CATEGORYNAME, SUPPLIER_COMPANYNAME, PRODUCTNAME, ORDERDETAIS_UNIRPRICE, ORDERDETAILS_QUANTITY , NETSTOCK
SELECT O.ORDERID, E.FIRSTNAME+' '+E.LASTNAME AS FULLNAME,  C.COMPANYNAME, CTG.CategoryName, S.CompanyName, P.ProductName, OD.UnitPrice, OD.Quantity, OD.UNITPRICE * OD.Quantity AS NETSTOCK
FROM ORDERS O JOIN CUSTOMERS C ON O.CUSTOMERID=C.CUSTOMERID JOIN 
EMPLOYEES E ON O.EMPLOYEEID=E.EMPLOYEEID JOIN
[Order Details] OD ON OD.OrderID=O.OrderID JOIN
PRODUCTS P ON P.PRODUCTID=OD.PRODUCTID JOIN
CATEGORIES CTG ON CTG.CATEGORYID=P.CATEGORYID JOIN
Suppliers S ON S.SupplierID=P.SupplierID
--10 LIST ALL THE ORDERS (ORDERID, PRODUCTNAME) PLACED BY THE CUSTOMER IN LONDON
SELECT O.ORDERID,P.ProductName FROM 
ORDERS O JOIN [Order Details] OD ON O.ORDERID=OD.OrderID JOIN
PRODUCTS P ON OD.ProductID=P.ProductID
JOIN CUSTOMERS C ON C.CustomerID=O.CustomerID WHERE C.City='LONDON'
--11 FOR THE COSTLIEST PRODUCT DISPLAY PRODUCTNAME, UNITPRICE, CATEGORYNAME, SUPPLIER_CONTACTNAME
SELECT P.PRODUCTNAME, P.UNITPRICE, CTG.CATEGORYNAME, S.CONTACTNAME FROM 
PRODUCTS P JOIN
Categories CTG ON P.CategoryID=CTG.CategoryID JOIN
Suppliers S ON S.SupplierID=P.SupplierID
WHERE P.ProductID=(SELECT TOP 1 PRODUCTID FROM PRODUCTS ORDER BY UnitPrice DESC) 
--12 LIST ALL THE PRODUCTNAME WHOSE ORDER PLACED IN MONTH OF AUGUST
SELECT PRODUCTNAME FROM PRODUCTS WHERE PRODUCTID IN (SELECT ProductID FROM [ORDER DETAILS] WHERE ORDERID IN (SELECT ORDERID FROM ORDERS WHERE DATEPART(MM, ORDERDATE)=8))
--13 LIST ORDERID, QUANTITY FOR ALL THE ORDERS. ASSIGNED RANK AS PER THE HIGHEST OT LOWEST QUANTITY. DO NOT MISS ANY NUMBER WHILE ASSIGNING THE RANK
SELECT DENSE_RANK() OVER (ORDER BY QUANTITY DESC) AS RNK, ORDERID, QUANTITY FROM [Order Details]
--14 List all the products for the category ?Dairy Product?
SELECT * FROM PRODUCTS WHERE CATEGORYID = (SELECT CATEGORYID FROM Categories WHERE CategoryName='DAIRY PRODUCTS')
--15 List all the products which is supplied by the company ?Bigfoot Breweries? for the category ?Beverages?
SELECT * FROM PRODUCTS WHERE SUPPLIERID = (SELECT SUPPLIERID FROM SUPPLIERS WHERE CompanyName='Bigfoot Breweries') AND CATEGORYID=(SELECT CATEGORYID FROM Categories WHERE CategoryName='BEVERAGES')
--16 Print CategoryName , Supplier Comapny name and product count for each category and supplier
SELECT CTG.CATEGORYNAME, S.CompanyName, COUNT(P.PRODUCTID) FROM CATEGORIES CTG JOIN PRODUCTS P ON CTG.CATEGORYID=P.CATEGORYID JOIN SUPPLIERS S ON S.SUPPLIERID=P.SUPPLIERID GROUP BY CTG.CategoryName, S.COMPANYNAME
--17 PRINT REGION AND TERRITORYDESCRIPTION NAME IN ASCENDING ORDER
SELECT R.REGIONID, T.TerritoryDescription FROM REGION R JOIN Territories T ON R.RegionID=T.RegionID ORDER BY R.RegionID
--18 PRINT EMPLOYEES NAME, REGION NAME, CITY AND COUNTRY --(check for the error, no region relationship)
SELECT E.FIRSTNAME, R.REGIONDESCRIPTION, E.CITY, E.COUNTRY FROM Employees E JOIN
EmployeeTerritories ET ON E.EmployeeID=ET.EmployeeID JOIN
Territories T ON ET.TerritoryID=T.TerritoryID JOIN
Region R ON T.RegionID=R.RegionID
--19 FOR EACH CATEGORIES PRINT CATEGORYNAME AND SUPPLIERS NAME
SELECT CTG.CategoryName, S.CONTACTNAME FROM 
PRODUCTS P JOIN
Categories CTG ON P.CategoryID=CTG.CategoryID JOIN
Suppliers S ON S.SupplierID=P.SupplierID
--20 PRINT EMPLOYEE TITLEOFCOURTESY, EMPLOYEE FIRST + LASTNAME ,
--EMPLOYEE TITLE, MANAGER TITLEOFCURTASY, MANAGER FIRSTNAME +
--LASTNAME, MANAGER TITLE
SELECT E.TitleOfCourtesy, E.FIRSTNAME+' '+E.LASTNAME AS EMPFULLNAME, E.Title, M.TitleOfCourtesy, M.FIRSTNAME+' '+M.LASTNAME AS MGRFULLNAME, M.Title FROM Employees E JOIN Employees M ON E.ReportsTo=M.EmployeeID


--NORTHWIND DATABASE ? PROGRAMMING ASSIGNMENT
--1. WRITE A PROCEDURE WHICH TAKES CATEGORY NAME AS A PARAMETER AND RETURN
--ALL PRODUCTS WHICH MATCH WITH THE CATEGORY NAME. IF NAME NOT EXIST PRINT
--MESSAGE
CREATE proc PRODUCTSBYCATEGORY(@CTG AS VARCHAR(80)) AS
BEGIN
	DECLARE @CTGID INT	
	SELECT @CTGID=CATEGORYID FROM CATEGORIES WHERE CategoryName=@CTG
	IF @CTGID IS NULL
		PRINT 'NO SUCH CATEGORY'
	ELSE
		SELECT * FROM PRODUCTS WHERE CATEGORYID = @CTGID
END

EXEC PRODUCTSBYCATEGORY 'DAIRY PRODUCTS'
--2. TAKE COUNTRY NAME AS THE PARAMETER AND RETURN ALL CUSTOMERS FROM THAT
--COUNTRY
CREATE proc CUSTBYCOUNTRY(@COUNTRY AS VARCHAR(80)) AS
BEGIN		
	SELECT * FROM CUSTOMERS WHERE COUNTRY = @COUNTRY
END

EXEC CUSTBYCOUNTRY 'USA'
--3. WRITE INSERT, UPDATE AND DELETE PROCEDURE FOR EMPLOYEES TABLE. IF ANY
--STATEMENT FAIL RAISE PROPER ERROR MESSAGE
--PARAMETER :
--EMPLOYEEID, LASTNAME, FIRSTNAME, TITLE, TITLEOFCOURTESY, BIRTHDATE, HIREDATE, ADDRESS, CITY, REGION, POSTALCODE, COUNTRY
CREATE PROC INSEMP(@EID INT, @ELNAME VARCHAR(80), @EFNAME VARCHAR(80), @ETITLE VARCHAR(80), @ETITLEOFCOURTESY VARCHAR(80), @BDATE DATETIME, @HDATE DATETIME, @ADDR VARCHAR(80),
@CITY VARCHAR(20), @REGION VARCHAR(80), @POSTALCODE VARCHAR(10), @COUNTRY VARCHAR(80)) AS
BEGIN
	BEGIN TRY
		INSERT INTO EMPLOYEES(EMPLOYEEID, LASTNAME, FIRSTNAME, TITLE, TITLEOFCOURTESY, BIRTHDATE, HIREDATE, ADDRESS, CITY, REGION, POSTALCODE, COUNTRY) 
		VALUES(@EID, @ELNAME,@EFNAME, @ETITLE, @ETITLEOFCOURTESY, @BDATE, @HDATE, @ADDR, @CITY, @REGION, @POSTALCODE, @COUNTRY)
		PRINT 'INSERTED'
	END TRY
	BEGIN CATCH
		PRINT 'FAILED'
		RAISERROR ('COULD NOT INSERT DATA',16,1)
	END CATCH
END
CREATE PROC DELEMP(@EID INT) AS
BEGIN
	BEGIN TRY
		DELETE FROM EMPLOYEES WHERE EmployeeID=@EID
		PRINT 'DELETED'
	END TRY
	BEGIN CATCH
		PRINT 'FAILED'
		RAISERROR ('ID DOES NOT EXIST',16,1)
	END CATCH
END
CREATE PROC UPDEMP(@EID INT, @ELNAME VARCHAR(80), @EFNAME VARCHAR(80), @ETITLE VARCHAR(80), @ETITLEOFCOURTESY VARCHAR(80), @BDATE DATETIME, @HDATE DATETIME, @ADDR VARCHAR(80),
@CITY VARCHAR(20), @REGION VARCHAR(80), @POSTALCODE VARCHAR(10), @COUNTRY VARCHAR(80)) AS
BEGIN
	BEGIN TRY
		EXEC DELEMP @EID
		EXEC INSEMP @EID, @ELNAME,@EFNAME, @ETITLE, @ETITLEOFCOURTESY, @BDATE, @HDATE, @ADDR, @CITY, @REGION, @POSTALCODE, @COUNTRY
		PRINT 'UPDATED'
	END TRY
	BEGIN CATCH
		PRINT 'FAILED'
	END CATCH
END
--4. TAKE REGIONDESCRIPTION AS A PARAMETER
--PRINT REGIONDESCRIPTION, TERRITORY DESCRIPTION, AND EMPNAME
CREATE PROC DTLSBYRDESC(@RDESC VARCHAR(80)) AS
BEGIN
	SELECT E.FIRSTNAME, R.REGIONDESCRIPTION, T.TerritoryDescription FROM Employees E JOIN
	EmployeeTerritories ET ON E.EmployeeID=ET.EmployeeID JOIN
	Territories T ON ET.TerritoryID=T.TerritoryID JOIN
	Region R ON T.RegionID=R.RegionID WHERE R.RegionDescription=@RDESC
END
--5. PRODUCTS TABLE
--WRITE A PROCEDURE WHICH CHECKS UNITSINSTOCK AND UNITSONORDER
--DISPLAY ALL PRODUCTS DETAILS (PRODUCTNAME, UNITPRICE, UNITSINSTOCK,
--UNITSONORDER, DIFFERENCE ) where UNITSONORDER is more then UNITSINSTOCK
CREATE PROC SCARCEPROD AS
	SELECT * FROM PRODUCTS WHERE UnitsOnOrder>UnitsInStock
--6. ORDER DETAILS TABLE
--TAKE ORDERID AS PARAMETER
--FOR THE ORDERID PRINT PRODUCTNAME, UNITPRICE, QUANTITY, DISCOUNT, TOTAL I.E
--UNITPRICE * QUNATITY, DISCOUNTAMOUNT, FINAL PRICE I.E. TOTAL ?DISCOUNT AMOUNT
CREATE PROCEDURE ORDDTL(@ORDID AS INT) AS
BEGIN
	SELECT P.PRODUCTNAME, O.UNITPRICE, O.Quantity, O.Discount, O.UnitPrice*O.Quantity AS TOTAL, O.Discount*O.UnitPrice*O.Quantity AS DISCAMT, O.UnitPrice*O.Quantity-O.Discount*O.UnitPrice*O.Quantity AS FINALPRICE FROM PRODUCTS P JOIN [Order Details] O ON P.PRODUCTID=O.ProductID
END
--7. WRITE A PROCEDURE WHICH INSERT IN PRODUCTTABLE
--PARAMETER FOR PROCEDURE PRODUCTNAME, UNITPRICE AND CATEGORYNAME
--CHECK IF CATEGORYNAME EXIST THEN ADD PRODUCTS WITH EXISTING CATEGORYID
--IF CATEGORYNAME DOES NOT EXIST FIRST INSERT IN CATEGORY TABLE
--READ CATEGORYID WHICH IS IDENTITY FIELD
--AND INSERT NEW INSERTED ID IN PRODUCT TABLE AS CATEGORYID
CREATE PROC INSPROD(@PNAME VARCHAR(80), @UPRICE INT, @CTGNAME VARCHAR(80)) AS
BEGIN
	DECLARE @CTGID INT
	SELECT @CTGID=CATEGORYID FROM CategorieS WHERE CATEGORYNAME=@CTGNAME
	IF @CTGID IS NULL
	BEGIN 
		INSERT INTO Categories(CategoryName) VALUES(@CTGNAME)
		SELECT @CTGID=CATEGORYID FROM CategorieS WHERE CATEGORYNAME=@CTGNAME
	END
	INSERT INTO PRODUCTS(PRODUCTNAME, UnitPrice, CategoryID) VALUES(@PNAME, @UPRICE, @CTGID)
END
--8. ORDERS TABLE
--TAKE YEAR AS PARAMETER TO PROCEDURE
--PRINT IN EACH QUARTER HOW MANY ORDERS BOOKED,
--EXAMPLE IN Q-1 100
-- Q-2 150 ?.
--IF YEAR NOT EXIST PRINT ERROR MESSAGE
CREATE PROC QUART(@YEAR AS INT) AS
BEGIN	
	DECLARE @Q1 INT, @Q2 INT, @Q3 INT, @Q4 INT
	DECLARE @T INT
	SELECT @T=1 FROM ORDERS WHERE YEAR(ORDERDATE)=@YEAR
	IF @T IS NOT NULL
	BEGIN
		SELECT @Q1=COUNT(ORDERID) FROM ORDERS WHERE YEAR(ORDERDATE)=@YEAR AND MONTH(ORDERDATE) BETWEEN 1 AND 3
		SELECT @Q2=COUNT(ORDERID) FROM ORDERS WHERE YEAR(ORDERDATE)=@YEAR AND MONTH(ORDERDATE) BETWEEN 4 AND 6
		SELECT @Q3=COUNT(ORDERID) FROM ORDERS WHERE YEAR(ORDERDATE)=@YEAR AND MONTH(ORDERDATE) BETWEEN 7 AND 9
		SELECT @Q4=COUNT(ORDERID) FROM ORDERS WHERE YEAR(ORDERDATE)=@YEAR AND MONTH(ORDERDATE) BETWEEN 10 AND 12
		PRINT 'Q1: ' + CAST(@Q1 AS VARCHAR) + 'Q2: ' + CAST(@Q2 AS VARCHAR) + 'Q3: ' + CAST(@Q3 AS VARCHAR) + 'Q4: ' + CAST(@Q4 AS VARCHAR)
	END
	ELSE 
	BEGIN
		PRINT 'YEAR NOT FOUND'
	END
END

--9. TABLE ORDERS AND ORDER DETAILS ?OUT PARAMETER
--TAKE YEAR AND MONTH AS PARAMETER AND RETURN
--TOTAL REVENUE GENERATED SUM(UNITPRICE * QTY ? DISCOUNT)
CREATE PROC REVENUE(@MNTH INT, @YR INT, @REV FLOAT) AS
BEGIN
	SELECT @REV=SUM(UnitPrice*Quantity-Discount) FROM [Order Details] OD JOIN ORDERS O ON OD.OrderID=O.OrderID WHERE YEAR(ORDERDATE)=@YR AND MONTH(ORDERDATE)=@MNTH
END
--10. FOR EACH EMPLOYEE PRINT EMPLOYEE FULL NAME, BIRTHDATE, HIREDATE, AGE (IN
--YEARS) AT THE TIME OF HIRING, RETIREMENT DATE. (60 YEARS)
create proc empdet AS
BEGIN	
	SELECT FIRSTNAME+' '+LASTNAME AS FULLNAME, BirthDate, HireDate, DATEDIFF(YY, BirthDate, HireDate) AGE, DATEADD(YY, 60, BirthDate) RETIRDATE  FROM Employees
END

-- functions
--1. TAKE PRODUCTNAME AS PARAMETER AND RETURN UNITPRICE
CREATE FUNCTION UPRICE(@PNAME VARCHAR(80)) RETURNS FLOAT AS 
BEGIN
	DECLARE @UPRICE FLOAT
	SELECT @UPRICE=UNITPRICE FROM Products WHERE ProductName=@PNAME
	RETURN @UPRICE
END
SELECT DBO.UPRICE('TOFU')
--2. TAKE PRODUCTNAME AS PARAMETER AND RETURN UNITSINSTOCK AND
--UNINTSONORDER
CREATE FUNCTION UNITSDET(@PNAME VARCHAR(80)) RETURNS table AS 
	return (select unitsinstock, unitsonorder from Products where ProductName=@pname)
SELECT * FROM  UNITSDET('TOFU')
--3. TAKE POSTALCODE AS PARAMETER AND RETURN CUSTOMER NAME. IF POSTAL CODE IS
--NOT VALID DISPLAY ERROR MESSAGE
CREATE FUNCTION CNAMEBYPSTLCD(@PSTL VARCHAR(80)) RETURNS VARCHAR(80) AS
BEGIN
	DECLARE @CNAME VARCHAR(80)
	SELECT @CNAME=ContactName FROM CUSTOMERS WHERE PostalCode=@PSTL
	IF @@rowcount=0
	BEGIN
		PRINT 'INVALID POSTAL CODE'
		RAISERROR('INVALID/NO POSTAL CODE',16,1)
	END
	RETURN @CNAME
END
SELECT DBO.CNAMEBYPSTLCD('28023')
--4. TAKE COUNTRY AS PARAMETER AND RETURN CITY AND POSTALCODE FOR A
--CUSTOMERS
CREATE FUNCTION CITYPSTLBYCNTRY(@CNTRY VARCHAR(80)) RETURNS TABLE AS
	RETURN (SELECT CITY, PostalCode FROM CUSTOMERS WHERE Country=@CNTRY)	
SELECT * FROM CITYPSTLBYCNTRY('USA')
--5. TAKE EMPLOYEE FIRSTNAME AND LASTNAME AS PARAMETER AND RETURN ALL
--CUSTOMERS COMPANY NAME, CONTACTNAME, CONTACTTILE
CREATE FUNCTION CUSTDET(@FNAME VARCHAR(80),@LNAME VARCHAR(80)) RETURNS TABLE AS
	RETURN (SELECT CompanyName, ContactName, ContactTitle FROM CUSTOMERS WHERE ContactName=(@FNAME+' '+@LNAME))
SELECT * FROM DBO.CUSTDET('JOHN','MARTIN')
--6. TAKE YEAR AND EMPLOYEENAME AND DISPLAY AMOUNT OF ORDERS HANDLE BY THE
--EMPLOYEE IN A YEAR (SUM OF QUANTITY)
CREATE FUNCTION ORDSUM(@ENAME VARCHAR(80), @YR INT) RETURNS INT AS
BEGIN
	DECLARE @COUNT INT
	SELECT @COUNT=COUNT(O.OrderID) FROM Employees E JOIN ORDERS O ON E.EmployeeID=O.EmployeeID WHERE E.FirstName=@ENAME AND YEAR(O.OrderDate)=@YR
	RETURN @COUNT
END
SELECT DBO.ORDSUM('JANET', 1996)
--7. TAKE YEAR AND MONTH AS PARAMETER AND RETURN NO OF ORDERS SHIPPED IN THE
--GIVEN MONTH
CREATE FUNCTION ORDSUMBYMNTHYR(@YR INT, @MNTH INT) RETURNS INT AS
BEGIN
	DECLARE @COUNT INT
	SELECT @COUNT=COUNT(ORDERID) FROM ORDERS WHERE YEAR(ORDERDATE)=@YR AND MONTH(ORDERDATE)=@MNTH
	RETURN @COUNT
END
SELECT DBO.ORDSUMBYMNTHYR(1996, 3)
--8. TAKE PRODUCTNAME AS PARAMTER AND RETURN TOTLA UNITS OF ORDER PLACED FOR
--THE PRODUCT (SUM(ORDERED QUANTITY)
--Hint: use Products and [Order Details] table
CREATE FUNCTION UNTORDPLACED(@PNAME VARCHAR(80)) RETURNS INT AS 
BEGIN
	DECLARE @COUNT INT
	SELECT @COUNT=SUM(O.Quantity) FROM Products P JOIN [Order Details] O ON P.ProductID=O.ProductID WHERE ProductName=@PNAME
	RETURN @COUNT
END
SELECT DBO.UNTORDPLACED('TOFU')
--9. TAKE ORDERID AS PARAMETER AND RETURN TOTAL UNITS OF ORDER PLACE FOR THE
--ORDERID
SELECT * FROM [Order Details]
CREATE FUNCTION UNTOFORDER(@OID INT) RETURNS INT AS 
BEGIN
	DECLARE @COUNT INT
	SELECT @COUNT=SUM(Quantity) FROM [Order Details] WHERE OrderID=@OID
	RETURN @COUNT
END
SELECT DBO.UNTOFORDER(10248)