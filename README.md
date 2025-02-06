# library_management
## Library Management System using SQL Project --P2
## project Overview
### Project Title: Library Management System
### Level: Intermediate
### Database: library_db

This project demonstrates the implementation of a Library Management System using SQL. It includes creating and managing tables, performing CRUD operations, and executing advanced SQL queries. The goal is to showcase skills in database design, manipulation, and querying.

![Library_project](https://github.com/najirh/Library-System-Management---P2/blob/main/library.jpg)

## Objectives

1. **Set up the Library Management System Database**: Create and populate the database with tables for branches, employees, members, books, issued status, and return status.
2. **CRUD Operations**: Perform Create, Read, Update, and Delete operations on the data.
3. **CTAS (Create Table As Select)**: Utilize CTAS to create new tables based on query results.
4. **Advanced SQL Queries**: Develop complex queries to analyze and retrieve specific data.


## Project Structure


### 1. Database Setup
![image](https://github.com/Yash11042/library_management/blob/495934c979fbb2fae53d6c0727b4a0f9b72ceb70/Screenshot%202025-02-02%20203132.png)

- **Database Creation**: Created a database named `library_db`.
- **Table Creation**: Created tables for branches, employees, members, books, issued status, and return status. Each table includes relevant columns and relationships.

```sql

create database library;
use library;

-- PROECT LIBRARY MANAGEMENT SYSTEM:

-- creation of table:

create table branch (                    -- branch table
branch_id varchar(5) primary key, -- fk
	manager_id varchar(5),  -- fk
	branch_address varchar(20),	
    contact_no varchar(20));
    
 alter table branch   
 modify column contact_no varchar(20);
    
create table employee(                 -- employee table
emp_id varchar(10) primary key,
	emp_name varchar(20),
	position varchar(20),
	salary int,
	branch_id varchar(10) 
);

create table books(                   -- books tables
isbn varchar(25) primary key,
	book_title varchar(75),	
    category varchar(20),
	rental_price float,
	status varchar(10),
	author varchar(30),
	publisher varchar(50)
);
    
create table members(                 -- members table
member_id varchar(20) primary key,
	member_name varchar(30),
	member_address varchar(80),
	reg_date date
);

create table issued(                   -- issued table
issued_id varchar(10) primary key, 
	issued_member_id varchar(10),-- fk
	issued_book_name varchar(75),
	issued_date date,	
    issued_book_isbn varchar(25), -- fk
	issued_emp_id varchar(10) -- fl
);
   
create table return_status(             -- return status table
return_id varchar(10) primary key,
	issued_id varchar(10) ,
	return_book_name varchar(75),
	return_date date,
	return_book_isbn varchar(25)
);

-- foreign key

alter table issued
add constraint fk_members
foreign key(issued_member_id)
references members(member_id);


 alter table issued
add constraint fk_books
foreign key(issued_book_isbn)
references books(isbn);

alter table issued
add constraint fk_employee
foreign key(issued_emp_id)
references employee(emp_id);

alter table employee
add constraint fk_branch
foreign key(branch_id)
references branch(branch_id);


alter table return_status
add constraint fk_issued
foreign key (issued_id)
references issued(issued_id);


select * from books;
select * from branch;
select *  from employee;
select *  from issued;
select *  from members;
select *  from return_status;
```

2. CRUD Operations
Create: Inserted sample records into the books table.
Read: Retrieved and displayed data from various tables.
Update: Updated records in the employees table.
Delete: Removed records from the members table as needed.

#### Task 1: CREATE A NEW BOOK RECORD -- "978-1-60129-456-2 ", " TO KILL A MOCKING BIRD", "CLASSIC",6.00,"YES","HARPER LEE","JB LIPPINCOTT AND CO."

``` sql
insert into books(isbn,book_title,category,rental_price,status,author,publisher)
values
('978-1-60129-456-2','TO KILL A MOCKING BIRD','classic',6.00,'yes','harper lee','JB LIPPINCOTT AND CO.')
select * from books;
```

#### Task 2: Update an Existing Member's Address

```sql
set sql_safe_updates=1
update members
set member_address = "JB road"
where member_address="123 Main St";
```
#### Task 3: Delete a Record from the Issued Status Table -- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.



