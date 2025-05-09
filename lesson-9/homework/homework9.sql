CREATE TABLE Employees1
(
	EmployeeID  INTEGER PRIMARY KEY,
	ManagerID   INTEGER NULL,
	JobTitle    VARCHAR(100) NOT NULL
);
INSERT INTO Employees1 (EmployeeID, ManagerID, JobTitle) 
VALUES
	(1001, NULL, 'President'),
	(2002, 1001, 'Director'),
	(3003, 1001, 'Office Manager'),
	(4004, 2002, 'Engineer'),
	(5005, 2002, 'Engineer'),
	(6006, 2002, 'Engineer');

--Task 1
--Given this Employee table below, find the level of depth each employee from the President.

with  employee_hierarchy as (
	select EmployeeId, ManagerId,Jobtitle,0 as depth
    from Employees1
    where managerid is null
		union all
	select e.Employeeid,e.Managerid, e.Jobtitle, eh.depth + 1 as depth
    from Employees1 e
    join employee_hierarchy eh on e.managerid = eh.employeeid
)
select * from employee_hierarchy
order by depth;

--Task 2
--Find Factorials up to N

with factorial as (
    select 1 as Num, 1 as Factorials
		 union all
    select Num + 1, Factorials * (Num + 1)
    from factorial
    where Num < 10
)
select * from factorial

--Task 3
--Find Fibonacci numbers up to N
with fibonacci as (
    select 1 as n, 1 as a, 1 as b
		union all
    select n + 1, b, a + b
    from fibonacci
    where n < 10
)
select n, a as fib
from fibonacci;

