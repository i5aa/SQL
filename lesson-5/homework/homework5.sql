CREATE TABLE Employees (
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    Department VARCHAR(50) NOT NULL,
    Salary DECIMAL(10,2) NOT NULL,
    HireDate DATE NOT NULL
);

INSERT INTO Employees (Name, Department, Salary, HireDate) VALUES
    ('Alice', 'HR', 50000, '2020-06-15'),
    ('Bob', 'HR', 60000, '2018-09-10'),
    ('Charlie', 'IT', 70000, '2019-03-05'),
    ('David', 'IT', 80000, '2021-07-22'),
    ('Eve', 'Finance', 90000, '2017-11-30'),
    ('Frank', 'Finance', 75000, '2019-12-25'),
    ('Grace', 'Marketing', 65000, '2016-05-14'),
    ('Hank', 'Marketing', 72000, '2019-10-08'),
    ('Ivy', 'IT', 67000, '2022-01-12'),
    ('Jack', 'HR', 52000, '2021-03-29');

--Task 1
select *,
row_number() over(order by Salary)
from Employees
order by EmployeeID

--Task 2
select EmployeeID, Name, Department, Salary, HireDate,SalaryRank
from (
    select *,
           dense_rank() over (partition by Department order by Salary asc) as SalaryRank
    from Employees
) as RankedEmployees
where SalaryRank = 1
order by Department;

select EmployeeID, Name, Department, Salary, HireDate,SalaryRank
from (
    select *,
           dense_rank() over (partition by Department order by Salary asc) as SalaryRank
    from Employees
) as RankedEmployees
where SalaryRank = 2
order by Department;

select EmployeeID, Name, Department, Salary, HireDate,SalaryRank
from (
    select *,
           dense_rank() over (partition by Department order by Salary asc) as SalaryRank
    from Employees
) as RankedEmployees
where SalaryRank = 3
order by Department;

--Task 3
select EmployeeID, Name, Department, Salary, HireDate, SalaryRank
from(
	select *,
		dense_rank() over(partition by Department order by Salary asc) as SalaryRank
	from Employees
) as Ranked_emp
where SalaryRank<=2
order by Department

--Task 4
select EmployeeID, Name, Department, Salary, HireDate, SalaryRank
from(
	select *,
		dense_rank() over(partition by Department order by Salary desc) as SalaryRank
	from Employees
) as Ranked_emp
where SalaryRank=1
order by Department

--Task 5
select *,
	sum(Salary) over(partition by Department order by Salary) as [Running Total]
from Employees

--Task 6
select *,
	sum(Salary) over(partition by Department ) as Totals
from Employees

--Task 7
select *,
	avg(Salary) over(partition by Department) as Averages
from Employees

--Task 8
select *,
	Salary-avg(Salary) over(partition by Department) as DifferenceAverages
from Employees

--Task 9
select *,
    avg(Salary) over(order by EmployeeID rows between 1 preceding and 1 following) as MovingAverageSalary
from Employees
order by EmployeeID

--Task 10
select sum(Salary) as TotalSalary
from(
	select Top 3 Salary from Employees
    order by HireDate desc
) as Last3Hired;

--Task 11
select *,
	avg(Salary) over(partition by Department order by EmployeeID) as [Running Average]
from Employees

--Task 12
select *,
	max(Salary) over(order by EmployeeID rows between 2 preceding and 2 following)
from Employees

--Task 13
select *,
	cast((Salary/sum(Salary) over(partition by Department))*100 as decimal(10,2)) as PercentageContribution
from Employees