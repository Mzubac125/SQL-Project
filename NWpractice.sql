--see a list of countries where NorthWind has customers
SELECT distinct 
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
select 
	c.CustomerID, 
	c.CompanyName,
	o.OrderID, 
	round(sum((od.UnitPrice * od.Quantity) - (1-od.Discount)),2) as TotalOrderAmount
from 
Customers c
INNER JOIN
Orders o
on c.CustomerID = o.CustomerID
INNER JOIN
[Order Details] od
on o.Orderid = od.OrderID
WHERE
datepart(year, o.OrderDate) = 1998
group by 
c.CustomerID, c.CompanyName, o.OrderID
having
sum((od.UnitPrice * od.Quantity) - (1-od.Discount)) >= 10000
order by
TotalOrderAmount desc

--Show a random set of 2% of all orders
select top 2 percent
	OrderID
From Orders
Order by NEWID()