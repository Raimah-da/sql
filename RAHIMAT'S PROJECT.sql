use ecommerce;
-- RAHIMAT AJOKE ABDULRAHAMAN 

-- Q1 1. Total Sales by Employee: 
-- Write a query to calculate the total sales (in dollars) made by each employee, 
-- considering the quantity and unit price of products sold.

-- SOLU

SELECT  E.EmployeeID ,
CONCAT (FIRSTNAME,',', LASTNAME ) AS "EMPLOYEE_NAME",
CONCAT ('$', SUM(OD.QUANTITY * OD.UNITPRICE)) AS "TOTAL SALES"
FROM EMPLOYEES E
JOIN ORDERS O ON E.EmployeeID = O.EmployeeID
JOIN ORDERDETAILS OD ON O.OrderID = OD.OrderID
JOIN PRODUCTS P ON OD.ProductID = P.ProductID
GROUP BY E.EmployeeID, E.FIRSTNAME, E.LASTNAME ;


-- Q2Top 5 Customers by Sales:
   -- Identify the top 5 customers who have generated the most revenue. Show the customer’s name and the total amount they’ve spent.
   SELECT c.CustomerID,
	c.CustomerName,
    SUM(OD.QUANTITY * OD.UNITPRICE) AS 'TOTAL SPENT'
	FROM  Customers c
		join ORDERS O on C.CustomerID = o.customerID
		JOIN Orderdetails od on o.orderID = od.orderID
		group by c.customerID, c.customername
		order by 'total spent' DESC
		limit 5;
        
-- q3 Monthly Sales Trend:
   -- Write a query to display the total sales amount for each month in the year 1997.
   
   -- solu

select 
   year(o.orderdate) as year,
   month(o.orderdate) as month,
    sum(od.quantity * od.unitprice) as "totalsales"
FROM orders o
join orderdetails od on O.orderID = od.OrderID
where year(orderDate) = 1997  
Group by year, month (O.OrderDate)
order by month; 

-- q4 Order Fulfilment Time:
   -- Calculate the average time (in days) taken to fulfil an order for each employee. Assuming shipping takes 3 or 5 days respectively
   -- depending on if the item was ordered in 1996 or 1997.

-- solu
  SELECT e.employeeID , 
  concat(',',firstname, lastname) as "employeename" ,
  AVG (
       case
       when  year(o.orderdate) = 1996 then 3
		 when year (o.orderdate) = 1997 then 5
         end
        ) as AvgFULFILMENTDAYS
  from orders o
  join employees e on o.employeeID = e.employeeID  
  group by e.employeeID, employeeName; 


-- 	Q5 Products by Category with No Sales:
   -- List the customers operating in London and total sales for each. 
   

SELECT C.customerID,
	c.contactName as CustomerName, 
	SUM( OD.quantity * od.unitprice) AS "TOTALSALES" 
from Customers C
	join orders o on c.CustomerID = o.CustomerID 
	join orderdetails od on o.orderID = od.orderID
WHERE C.CITY = 'london'
GROUP BY c.customerID
;
   
   
   -- Q6 Customers with Multiple Orders on the Same Date:
	-- Write a query to find customers who have placed more than one order on the same date.
    
    SELECT C.CustomerID , 
    o.orderdate , 
	c.customername, 
        count(o.orderdate) AS "ORDERSCOUNT"
	from Customers c
    join orders o on c.customerID = O.CustomerID
    group by c.customerID, c. contactname, o.orderdate 
    having COUNT(o.orderdate) > 1 
    ;
    DESC CUSTOMERS;
    DESC ORDERS;
    
    -- Q7 Average Discount per Product:Calculate the average discount given per product across all orders. Round to 2 decimal places.

 -- SOLU
 
 SELECT P.productID,
  productName,
 avg ( od.discount) as avgdiscount
 from products p 
 join orderdetails od on p.productID = od.productID
 group by p.productID ;
        

-- Q8 Products Ordered by Each Customer:
   -- For each customer, list the products they have ordered along with the total quantity of each product ordered.
   
   -- SOLU
   
   SELECT C.CustomerID ,
		  P.ProductName,
	contactname as customername ,
    sum( od.quantity ) as 'totalquantity'
    from CUSTOMERS C 
    join orders o on c.customerID = O.customerID
     join orderdetails od on o.orderid = od.orderid
    join products p on od.productID = p.productID
    group by c.customerID, p.productName, c.customername
    order by 'totalquantity'
    ;
    
    -- Q9 Employee Sales Ranking:
   -- Rank employees based on their total sales. Show the employeename, total sales, and their rank.
   
   -- SOLU 
    SELECT E.employeeID ,
    concat(firstname,',', lastname ) as employeename ,
    SUM(od.Quantity * od.unitprice) as 'totalsales' ,
    rank () OVER (order by 'totalsales') as 'rankposition'
    from employees e 
    join orders o on e.employeeid = o.employeeid
    JOIN orderdetails od on o.orderid = od.orderid 
    group by e.employeeid , employeename
    ;
    
    -- Q10 Sales by Country and Category:
    -- Write a query to display the total sales amount for each product category, grouped by country.
    
    -- solu
    
    select cat.categoryname,
			C.COUNTRY,
		SUM(OD.QUANTITY * OD.UNITPRICE) AS 'totalsales'
	from customers c
    join orders o on c.customerID = o.customerID
    join orderdetails od on o.OrderID = od.orderid
    join products p on od.productid = p.productid
    join categories cat on p.categoryid = cat.categoryid
    group by c.country, cat.categoryname
    order by 'totalsales' desc;
    
    -- Q11 Year-over-Year Sales Growth:Calculate the percentage growth in sales from one year to the next for each product.

-- SOLU

SELECT P.productID ,
	p.productname,
    year(orderdate) as year,
    sum(od.quantity * od.unitprice ) as 'totalsales' ,
    concat(',','totalsales' * 100, 2) as growthpercent
    FROM orders o
join orderdetails od on o.orderID= od.orderID
join products p on od.productid = p.productid 
group by p.productID, p.productname, year(o.orderdate);        
        

-- Q12 Order Quantity Percentile:- Calculate the percentile rank of each order based on the total quantity of products in the order. 

		-- solu

select o.orderID, 
 sum(od.quantity) as 'totalquantity' , 
 percent_rank () OVER (order by sum(od.quantity)) 
 from Orders o 
 join orderdetails od on o.orderID = od.orderID
 GROUP BY o.orderID
 ;
 
 -- Q13 Products Never Reordered:Identify products that have been sold but have never been reordered (ordered only once). 
  
  -- SOLU 
  SELECT 	p.productID,
			p.productname
from products p
join orderdetails od on p.productID = od.productID
GROUP BY P.PRODUCTID, P.PRODUCTNAME
HAVING COUNT(OD.ORDERID)=1;


-- Q14 Most Valuable Product by Revenue:
    -- Write a query to find the product that has generated the most revenue in each category.
    
-- SOLU
SELECT 
cat.categoryname,
p.productname,
sum(od.quantity * od.unitprice ) as totalsales
from categories cat
join products p on cat.categoryID = p.categoryID
join orderdetails od on p.productID =od.productID
group by cat.categoryname, p.productname;


-- Q15 Complex Order Details:
    -- Identify orders where the total price of all items exceeds $100 and contains at least one product with a discount of 5% or more.

-- SOLU
  SELECT O.ORDERID,
  SUM(OD.QUANTITY * OD.UNITPRICE) AS TOTALorder
  FROM ORDERS o
  JOIN ORDERDETAILS OD ON O.ORDERID = OD.ORDERID
  GROUP BY O.ORDERID
  HAVING TOTALOrder > 100
		AND MAX(OD.DISCOUNT) >= 0.05; 



        

    

    
    
    









