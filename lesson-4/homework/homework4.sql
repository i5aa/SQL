--Question 1
CREATE TABLE [dbo].[TestMultipleZero]
(
    [A] [int] NULL,
    [B] [int] NULL,
    [C] [int] NULL,
    [D] [int] NULL
);
GO

INSERT INTO [dbo].[TestMultipleZero](A,B,C,D)
VALUES 
    (0,0,0,1),
    (0,0,1,0),
    (0,1,0,0),
    (1,0,0,0),
    (0,0,0,0),
    (1,1,1,0);

SELECT *
FROM [dbo].[TestMultipleZero]
WHERE (A!= 0) or (B!=0) or (C!=0) or (D!=0);

--Question 2
CREATE TABLE TestMax
(
    Year1 INT
    ,Max1 INT
    ,Max2 INT
    ,Max3 INT
);
GO
 
INSERT INTO TestMax 
VALUES
    (2001,10,101,87)
    ,(2002,103,19,88)
    ,(2003,21,23,89)
    ,(2004,27,28,91);
SELECT *,
	CASE 
        WHEN Max1 >= Max2 AND Max1 >= Max3 THEN Max1
        WHEN Max2 >= Max1 AND Max2 >= Max3 THEN Max2
        ELSE Max3
    END AS MaxValue
from TestMax
order by Year1

--Question 3
CREATE TABLE EmpBirth(
    EmpId INT  IDENTITY(1,1),
    EmpName VARCHAR(50), 
    BirthDate DATETIME 
);
 
INSERT INTO EmpBirth(EmpName,BirthDate)
SELECT 'Pawan' , '12/04/1983'
UNION ALL
SELECT 'Zuzu' , '11/28/1986'
UNION ALL
SELECT 'Parveen', '05/07/1977'
UNION ALL
SELECT 'Mahesh', '01/13/1983'
UNION ALL
SELECT'Ramesh', '05/09/1983';

select EmpName,Birthdate from EmpBirth
where (month(BirthDate)=5) and (day(BirthDate) between 7 and 15)

--Question 4
create table letters
(letter char(1));

insert into letters
values ('a'), ('a'), ('a'), 
  ('b'), ('c'), ('d'), ('e'), ('f');

select letter from letters
order by 
case 
when letter = 'b' then 0 else 1 
end, letter;

select letter
from letters
order by 
case when letter = 'b' then 1 else 0 
end, letter;


