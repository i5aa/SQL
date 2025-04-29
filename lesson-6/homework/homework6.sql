-- Create the Departments table
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(50) NOT NULL
);

-- Create the Employees table

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    DepartmentID INT NULL,
    Salary DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID) ON DELETE SET NULL
);

-- Create the Projects table
CREATE TABLE Projects (
    ProjectID INT PRIMARY KEY,
    ProjectName VARCHAR(50) NOT NULL,
    EmployeeID INT NULL,
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID) ON DELETE SET NULL
);

-- Insert sample data into Departments table
INSERT INTO Departments (DepartmentID, DepartmentName) VALUES
(101, 'IT'),
(102, 'HR'),
(103, 'Finance'),
(104, 'Marketing');

-- Insert sample data into Employees table
INSERT INTO Employees (EmployeeID, Name, DepartmentID, Salary) VALUES
(1, 'Alice', 101, 60000),
(2, 'Bob', 102, 70000),
(3, 'Charlie', 101, 65000),
(4, 'David', 103, 72000),
(5, 'Eva', NULL, 68000);

-- Insert sample data into Projects table
INSERT INTO Projects (ProjectID, ProjectName, EmployeeID) VALUES
(1, 'Alpha', 1),
(2, 'Beta', 2),
(3, 'Gamma', 1),
(4, 'Delta', 4),
(5, 'Omega', NULL);

--Inner join
select name, d.departmentName
from Employees as e
join Departments as d on e.DepartmentID=d.DepartmentID

--Left join
select name, d.DepartmentName
from Employees as e
left join Departments as d on e.DepartmentID=d.DepartmentID

--Right join
select Name, d.DepartmentName
from Employees as e
right join Departments as d on e.DepartmentID=d.DepartmentID

--Full outer join
select Name, d.DepartmentName
from Employees as e
full outer join Departments as d on e.DepartmentID=d.DepartmentID

--Join with aggregation
select d.DepartmentName, sum(Salary) as Salaries
from Employees as e
right join Departments as d on e.DepartmentID=d.DepartmentID
group by d.DepartmentName

--Cross join
select *  from departments
cross join Projects

--Multiple joins
select Name, d.DepartmentName, p.ProjectName
from Employees as e
left join Departments as d on e.DepartmentID=d.DepartmentID
left join Projects as p on p.EmployeeID=e.EmployeeID