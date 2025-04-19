--Question 1
create table test_identity(
	id int primary key identity(1,1),
	name varchar(100)
)
insert into test_identity
values
	('Islom'),
	('Ronaldo'),
	('MAAB'),
	('SQL'),
	('Python')

select *from test_identity

delete from test_identity where id=2
--ID 2 of table was deleted

truncate table test_identity
--Deletes the data inside the table

drop table test_identity
--Table was completely deleted

--Question 2
create table data_types_demo(
	data1 smallint,
	data2 int, 
	data3 bigint,
	data4 decimal(10, 2),
	data5 varchar(40)
	);

insert into data_types_demo 
values
	(1, 11111111, 1111111111111111, 11.11, 'SQL'); 

select * from data_types_demo

--Question 3
create table photos(
	id int primary key identity,
	photo varbinary(MAX)
)

insert into photos 
select * from openrowset(
	BULK 'C:\Users\islom\OneDrive\??????? ????\SQL\SQL\lesson-2\homework\pc.jpg', SINGLE_BLOB
)as img

select * from photos

--Question 4
create table student(
	id int primary key identity,
	classes int not null,
	tuition_per_class decimal(10,2),
	total_tuition as (classes*tuition_per_class)
)
insert into student
values
	(7, 70000),
	(4, 40000);

SELECT * FROM student

--Question 5
create table worker(
	id int primary key identity,
	name varchar(100)
)
bulk insert worker
from 'C:\Users\islom\OneDrive\??????? ????\SQL\SQL\lesson-2\homework\worker.csv'
with(
	firstrow=2,
	fieldterminator=',',
	rowterminator='\n'
)

select * from worker

