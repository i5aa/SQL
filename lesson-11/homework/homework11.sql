-- ==============================================================
--                          Puzzle 1 DDL                         
-- ==============================================================

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(50),
    Department VARCHAR(50),
    Salary DECIMAL(10,2)
);

INSERT INTO Employees (EmployeeID, Name, Department, Salary)
VALUES
    (1, 'Alice', 'HR', 5000),
    (2, 'Bob', 'IT', 7000),
    (3, 'Charlie', 'Sales', 6000),
    (4, 'David', 'HR', 5500),
    (5, 'Emma', 'IT', 7200);


create table #EmployeeTransfers (
    EmployeeID int primary key,
    Name varchar(50),
    Department varchar(50),
    Salary decimal(10,2)
);


insert into #EmployeeTransfers (EmployeeID, Name, Department, Salary)
select EmployeeID, Name,
    case
        when Department = 'HR' then 'IT'
        when Department = 'IT' then 'Sales'
        when Department = 'Sales' then 'HR'
        else Department
    end as Department,
    Salary
from Employees;

select * from #EmployeeTransfers;






-- ==============================================================
--                          Puzzle 2 DDL
-- ==============================================================

CREATE TABLE Orders_DB1 (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(50),
    Product VARCHAR(50),
    Quantity INT
);

INSERT INTO Orders_DB1 VALUES
(101, 'Alice', 'Laptop', 1),
(102, 'Bob', 'Phone', 2),
(103, 'Charlie', 'Tablet', 1),
(104, 'David', 'Monitor', 1);

CREATE TABLE Orders_DB2 (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(50),
    Product VARCHAR(50),
    Quantity INT
);

INSERT INTO Orders_DB2 VALUES
(101, 'Alice', 'Laptop', 1),
(103, 'Charlie', 'Tablet', 1);


declare @missingorders table (
    orderid int primary key,
    customername varchar(50),
    product varchar(50),
    quantity int
);

insert into @missingorders
select *
from orders_db1 o1
where not exists (
    select 1
    from orders_db2 o2
    where o1.orderid = o2.orderid
);

select * from @missingorders;





-- ==============================================================
--                          Puzzle 3 DDL
-- ==============================================================

CREATE TABLE WorkLog (
    EmployeeID INT,
    EmployeeName VARCHAR(50),
    Department VARCHAR(50),
    WorkDate DATE,
    HoursWorked INT
);

INSERT INTO WorkLog VALUES
(1, 'Alice', 'HR', '2024-03-01', 8),
(2, 'Bob', 'IT', '2024-03-01', 9),
(3, 'Charlie', 'Sales', '2024-03-02', 7),
(1, 'Alice', 'HR', '2024-03-03', 6),
(2, 'Bob', 'IT', '2024-03-03', 8),
(3, 'Charlie', 'Sales', '2024-03-04', 9)

create view vw_monthlyworksummary as
select
    w.employeeid,
    w.employeename,
    w.department,
    sum(w.hoursworked) as totalhoursworked,
    d.totalhoursdepartment,
    d.avghoursdepartment
from worklog w
join (
    select
        department,
        sum(hoursworked) as totalhoursdepartment,
        avg(cast(hoursworked as decimal(10,2))) as avghoursdepartment
    from worklog
    group by department
) d on w.department = d.department
group by w.employeeid, w.employeename, w.department, d.totalhoursdepartment, d.avghoursdepartment;

select * from vw_monthlyworksummary;
