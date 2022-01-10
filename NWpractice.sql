--see a list of countries where NorthWind has customers
SELECT DISTINCT 
	Country
FROM 
Customers
WHERE 
Country is not null

-- show a list of the count for all different contact titles
SELECT
	ContactTitle, 
	count(ContactTitle) as TotalContactTitle
FROM
Customers
GROUP BY 
ContactTitle
ORDER BY 
TotalContactTitle desc

--show the total number of products in each category
SELECT distinct 
	c.CategoryName, 
	p.product_count
FROM (
SELECT *,
	count(ProductID) OVER (partition by CategoryID) as product_count
FROM 
Products) p
INNER JOIN
Categories c
on p.CategoryID = c.CategoryID
ORDER BY
p.product_count desc

--Return the top 3 countries with the highest average freight
SELECT top 3 
	ShipCountry, 
	avg(Freight) as avg_Freight
FROM 
Orders
WHERE
OrderDate between '1/1/1996' and '1/1/1998'
GROUP BY 
ShipCountry
ORDER BY 
avg_Freight desc

--see the customers who have spent more than $10000 on orders in 1998
SELECT 
	c.CustomerID, 
	c.CompanyName,
	o.OrderID, 
	round(sum((od.UnitPrice * od.Quantity) - (1-od.Discount)),2) as TotalOrderAmount
FROM 
Customers c
INNER JOIN
Orders o
on c.CustomerID = o.CustomerID
INNER JOIN
[Order Details] od
on o.Orderid = od.OrderID
WHERE
datepart(year, o.OrderDate) = 1998
GROUP BY 
c.CustomerID, c.CompanyName, o.OrderID
HAVING
sum((od.UnitPrice * od.Quantity) - (1-od.Discount)) >= 10000
ORDER BY
TotalOrderAmount desc

--Show a random set of 2% of all orders
SELECT top 2 percent
	OrderID
FROM
Orders
Order by
NEWID()

--Find the nth highest UnitPrice for a product
SELECT DISTINCT
	ProductID, 
	UnitPrice
FROM(
SELECT *,
	DENSE_RANK() OVER (order by UnitPrice desc) as rank_price
FROM 
[Order Details])od
WHERE
rank_price = n

--check to see if there are any duplicate contact names
SELECT 
	ContactName
FROM 
(Select *,
row_number() OVER (partition by ContactName order by CustomerID) as rn
FROM Customers) c
WHERE rn > 1
