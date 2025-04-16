--Question 1
create table student(
	id int,
	name varchar(50),
	age int)

alter table student
alter column id int not null;


--Question 2
drop table if exists product

create table product(
	product_id int unique,
	product_name varchar(50),
	price decimal,)

alter table product
add constraint unique_product_id unique(product_id)

alter table product 
drop constraint unique_product_id

alter table product
add constraint unique_product_id unique(product_id)

alter table product
add constraint unique_product_name unique(product_name)

--Question 3
create table orders(
	order_id int primary key,
	customer_name varchar(50),
	order_date date)

alter table orders
drop constraint orders_pkey

alter table orders
add constraint orders_pkey PRIMARY KEY (order_id)

--Question 4

create table category(
	category_id int primary key,
	category_name varchar(50),
	)
create table item(
	item_id int primary key,
	item_name varchar(50),
	category_id int, 
	constraint fk_category foreign key(category_id) references category(category_id)
	)
alter table item
drop constraint fk_category
alter table item
add constraint fk_category
foreign key (category_id) references category(category_id)

--Question 5
drop table if exists account

create table account(
	account_id int primary key,
	balance decimal,
	constraint account_balance_check check(balance>=0),
	account_type varchar(50),
	constraint account_type_check check (account_type in ('Saving','Checking'))
)
alter table account
drop constraint account_balance_check

alter table account
drop constraint account_type_check

alter table account
add constraint chk_balance check(balance>=0)

alter table account
add constraint chk_account_type check(account_type in('Saving','Checking'))

--Question 6

create table customer(
	customer_id int primary key,
	name varchar(255),
	city varchar(50),
	constraint df_city default 'Uknown' for city,
)
alter table customer
drop constraint df_city

alter table customer
add default 'Unknown' for city

--Question 7
create table invoice(
	invoice_id int identity(1,1),
	amount decimal(10,2),
)
insert into invoice 
values 
(1.1),
(2.2),
(3.3),
(4.4),
(5.5)

set identity_insert invoice on

insert into invoice(invoice_id,amount) values(6,7.7)

set identity_insert invoice off

--Question 8
create table books(
	book_id int primary key identity,
	title varchar(100) not null check(title <> ''),
	price decimal(10,2) check (price>0),
	genre varchar(50) default 'Unknown'
)

insert into books(title,price,genre)
values
('Pride and prejudice',15.99,'Romantic fiction')

insert into books(title,price)
values
('Zubi Dubi', 100000)

--Question 9
CREATE TABLE Book(
	book_id int primary key Identity,
	title varchar(255),
	author varchar(255),
	published_year int check(published_year>0)
)

CREATE TABLE Member(
	member_id int primary key Identity,
	name varchar(55),
	email varchar(55) NOT NULL UNIQUE,
	phone_number varchar(20)
)

CREATE TABLE Loan(
	loan_id int primary key Identity,
	book_id int foreign key references book(book_id),
	member_id int foreign key references member(member_id),
	loan_date DATE,
	return_date DATE NULL,
)

INSERT INTO Book (title, author, published_year) VALUES 
('The Fault in Our Stars', 'John Green', 2012),
('It starts with us', 'Colleen Hoover', 2022),
('Me before you', 'Jojo Moyes', 2012);

-- Insert sample members
INSERT INTO Member (name, email, phone_number) VALUES 
('Islombek Sharipov', 'sharipov.isaa@gmail.com', '+998 94 526 29 06'),
('Ruxshona Farmonqulova', 'rux1w@gmail.com', '+998 91 234 56 78');

INSERT INTO Loan (book_id, member_id, loan_date, return_date) VALUES 
(1, 1, '2025-29-07', '2024-01-08'),
(2, 2, '2025-01-11', NULL),        
(3, 1, '2025-03-27', NULL);    