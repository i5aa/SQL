CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100)
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE
);

CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY,
    OrderID INT FOREIGN KEY REFERENCES Orders(OrderID),
    ProductID INT,
    Quantity INT,
    Price DECIMAL(10,2)
);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50)
);


INSERT INTO Customers VALUES 
(1, 'Alice'), (2, 'Bob'), (3, 'Charlie');

INSERT INTO Orders VALUES 
(101, 1, '2024-01-01'), (102, 1, '2024-02-15'),
(103, 2, '2024-03-10'), (104, 2, '2024-04-20');

INSERT INTO OrderDetails VALUES 
(1, 101, 1, 2, 10.00), (2, 101, 2, 1, 20.00),
(3, 102, 1, 3, 10.00), (4, 103, 3, 5, 15.00),
(5, 104, 1, 1, 10.00), (6, 104, 2, 2, 20.00);

INSERT INTO Products VALUES 
(1, 'Laptop', 'Electronics'), 
(2, 'Mouse', 'Electronics'),
(3, 'Book', 'Stationery');

select * from Customers
select * from Orders
select * from OrderDetails
select * from Products

--Task 1
--Use an appropriate JOIN to list all customers, their order IDs, and order dates.
--Ensure that customers with no orders still appear.

select c.CustomerName, o.OrderID, o.OrderDate
from Customers c
left join Orders o
	on c.CustomerID=o.CustomerID

--Task 2
--Return customers who have no orders.

select c.CustomerName 
from Customers c
left join Orders o
	on c.CustomerID=o.CustomerID
	where o.CustomerID is Null

--Task 3
--List All Orders With Their Products

select od.OrderID,string_agg(p.ProductName, ',') as ProductName
from OrderDetails od
join Products p
	on od.ProductID=p.ProductID
group by od.OrderID

--Task 4
--Find Customers With More Than One Order

select c.CustomerName, count(o.OrderID)
from Customers c
left join Orders o
	on c.CustomerID=o.CustomerID
group by c.CustomerName
having count(o.OrderID)>1
	
--Task 5
--Find the Most Expensive Product in Each Order

select *
from (select p.ProductName, od.Price,
		max(od.Price) over(partition by od.OrderID ) as MaxPrice
	from Products p
	join OrderDetails od
		on p.ProductID=od.ProductID) as t
where Price=MaxPrice

--Task 6
--Find the Latest Order for Each Customer

select c.CustomerName, 
	max(o.OrderDate) as LatestOrderDate
from Orders o
join Customers c
	on c.CustomerID = o.CustomerID
group by c.CustomerID, c.CustomerName

--Task 7
--List customers who only purchased items from the 'Electronics' category

select c.CustomerName
from Customers c
join Orders o
	on c.CustomerID=o.CustomerID
join OrderDetails od
	on od.OrderID=o.OrderID
join Products p
	on p.ProductID=od.ProductID

group by c.CustomerName
having count(distinct Category)=1 and max(Category)='Electronics'

--Task 8
--List customers who have purchased at least one product from the 'Stationery' category.

select c.CustomerName
from Customers c
join Orders o
	on c.CustomerID=o.CustomerID
join OrderDetails od
	on od.OrderID=o.OrderID
join Products p
	on p.ProductID=od.ProductID

group by c.CustomerName
having sum(case when p.Category='Stationery' then 1 else 0 end)>=1

--Task 9
--Find Total Amount Spent by Each Customer Show CustomerID, CustomerName, and TotalSpent.

select c.CustomerID, c.CustomerName, sum(Price*Quantity)  as TotalSpent
from Customers c
join Orders o
	on o.CustomerID=c.CustomerID
join OrderDetails od
	on od.OrderID=o.OrderID
group by c.CustomerID,c.CustomerName