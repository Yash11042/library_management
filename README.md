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

```sql
delete from issued
where issued_id="IS104";

select * from issued;
```
#### Task 4: Retrieve All Books Issued by a Specific Employee -- Objective: Select all books issued by the employee with emp_id = 'E101'.

```sql
select * from issued
 where issued_emp_id ="E101";
 
 
```

#### Task 5: List Members Who Have Issued More Than One Book -- Objective: Use GROUP BY to find members who have issued more than one book.

```sql

select issued_emp_id, count(issued_id) as total_book_issued
 from issued 
group by issued_emp_id
having count(issued_id)>1 
order by total_book_issued desc;
```
### CTAS (Create Table As Select)
#### Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**

```sql
create table book_cnts
  as
    select a.isbn ,book_title,
    count(b.issued_id) as no_issue
    from books as a
    join
    issued as b
    on a.isbn = b.issued_book_isbn
    group by a.isbn;
    
    select * from book_cnts;
    drop table book_counts;
```
### 4. Data Analysis & Findings
The following SQL queries were used to address specific questions:

#### Task 7. Retrieve All Books in a Specific Category:

```sql

    select min(book_title) , category,count(isbn) as count_isbn
    from books 
    group by category;
```
#### Task 8: Find Total Rental Income by Category:
```sql
select a.category, sum(a.rental_price) as total,count(*)
   from
   books as a
   join 
   issued as b
   on a.isbn=b.issued_book_isbn
   group by category;
```
#### List Members Who Registered in the Last 180 Days:
```sql
 insert into members(member_id,member_name,member_address,reg_date)
    values
    ("C120","Sam","145 main st","2024-06-01"),
    ("C121","Jonny","133 main st","2024-07-03");
    
	update members
    set reg_date="2024-12-12"
    where reg_date="2024-07-03";
    
    
    select * from members
    where reg_date>= current_date - interval 180 day;
```
#### List Employees with Their Branch Manager's Name and their branch details:
```sql
select a.*,b1.emp_name as manager,
b.branch_id
 from employee as a
join branch as b
on a.branch_id=b.branch_id
join
employee as b1
on b.manager_id=b1.emp_id;
```
#### . Create a Table of Books with Rental Price Above a Certain Threshold
```sql
create table books_price_greater
as
select * from books 
where rental_price>=7;

select * from books_price_greater;
```
####  Retrieve the List of Books Not Yet Returned
```sql
select 
distinct a.issued_book_name
from issued as a
 left join return_status as b
on a.issued_id=b.issued_id
where return_id is null;
```
## Advanced SQL Operations
#### Task 13: Identify Members with Overdue Books
#### Write a query to identify members who have overdue books (assume a 30-day return period). Display the member's_id, member's name, book title, issue date, and days overdue.
```sql
-- issued == members table == books==return_status
 -- filter books that are returned
 -- overduw > 30 days
 
 select i.issued_member_id,
 m.member_name,
 b.book_title,
 i.issued_date,
 r.return_date,
 current_date - i.issued_date as overdues_day
 
 from issued as i
 join members as m
 on m.member_id=i.issued_member_id
 join
 books as b
 on b.isbn=i.issued_book_isbn
left join
 return_status as r
 on i.issued_id=r.issued_id
where return_date is null;
```
#### Task 14: Update Book Status on Return
Write a query to update the status of books in the books table to "Yes" when they are returned (based on entries in the return_status table).
```sql
select * from issued;


select * from books
where isbn='978-0-06-440055-8';

update books
set status="NO"
where isbn='978-0-06-440055-8';

select * from return_status
where  issued_id='IS130'; -- this book is not returned.

insert into return_status(return_id,issued_id,return_date,book_quality)
values
('RS125','IS130',current_date,'good');
select * from return_status
where issued_id='IS130';

update books
set status="YES"
where status='NO';

select * from books;

-- other method(store procedure)

delimiter $$
 create  procedure  return_records(in p_return_id varchar(10),p_issued_id varchar(10),p_book_quality varchar(10))
 
begin -- inserting into returns based on user input
declare
 v_isbn varchar(25); 
 
 
	insert into return_status(return_id,issued_id,return_date,book_quality)
    values
    (p_return_id,p_issued_id,current_date,p_book_quality);
	
    select issued_book_isbn
    into v_isbn 
    from issued
    where issued_id=p_issued_id;
    update books
set status="Yes"
where isbn=v_isbn;

-- RAISE A NOTICE OR MESSAGE USING signal:

signal sqlstate '45001' set message_text ='thank you for returning thebook';

 end;
 $$
 -- reset the delimiter
 
 -- calling functions
 call return_records('RS148','IS140','good');
```
#### Task 15: Branch Performance Report
#### Create a query that generates a performance report for each branch, showing the number of books issued, the number of books returned, and the total revenue generated from book rentals.
```sql
select * from branch; -- branch_id
 select * from issued; -- issued_emp_id
 select * from employee; -- branch_id -- emp_id
 select * from books; 
 select * from return_status;
 
 create table branch_reports 
 as
 select b.branch_id ,
 b.manager_id,
 count(i.issued_id) as number_of_books_issued,
 count(rs.return_id) as number_of_books_returned,
 sum(bk.rental_price) as total_rev
 from issued  as i
 join
 employee as e
 on e.emp_id=i.issued_emp_id
 join
 branch as b
 on e.branch_id=b.branch_id
left join
 return_status as rs
 on rs.issued_id=i.issued_id
 join
 books as bk
 on i.issued_book_isbn=bk.isbn
 
 group by b.branch_id,b.manager_id;
 
select * from branch_reports;
```
#### Task 16: CTAS: Create a Table of Active Members
#### Use the CREATE TABLE AS (CTAS) statement to create a new table active_members containing members who have issued at least one book in the last 2 months.
```sql
create table active_members
as
select * from members
where member_id in(select distinct issued_member_id from issued
                     where issued_date > current_date - interval 6 month);
                     
select * from active_members;
```
#### Task 17: Find Employees with the Most Book Issues Processed
#### Write a query to find the top 3 employees who have processed the most book issues. Display the employee name, number of books processed, and their branch.
```sql
select e.emp_name,count(i.issued_id) as no_book_issued,b.branch_address from issued as i
join employee as e
on e.emp_id=i.issued_emp_id
join
branch as b
on e.branch_id=b.branch_id
group by e.emp_name,i.issued_id;
```

#### Task 19: Stored Procedure Objective: Create a stored procedure to manage the status of books in a library system. Description: Write a stored procedure that updates the status of a book in the library based on its issuance. The procedure should function as follows: The stored procedure should take the book_id as an input parameter. The procedure should first check if the book is available (status = 'yes'). If the book is available, it should be issued, and the status in the books table should be updated to 'no'. If the book is not available (status = 'no'), the procedure should return an error message indicating that the book is currently not available.
```sql
select * from books;
select * from issued;

delimiter $$
create procedure issue_book(p_issued_id varchar(20),p_issued_member_id varchar(10),p_issued_book_isbn int,p_issued_emp_id varchar(10) )
begin -- insert the query
declare  -- all the variable
v_status varchar(20);
-- checking if book is avialble

select status
into v_status
 from books
where isbn= p_issued_book_isbn;

if v_status='yes' then 
	insert into issued(issued_id,issued_member_id,issued_date,issued_book_isbn,issued_emp_id)
    values
    (p_issued_id,p_issued_member_id,current_date,p_issued_book_isbn,p_issued_emp_id);
    
    update books
    set status='NO'
    where isbn=issued_book_isbn;
    
    signal sqlstate '45001' set message_text ='book record added succesfully for book: %';
      
else
	signal sqlstate '45001' set message_text ='book not avaialable: %';

end if ;
	
end;
$$

-- 978-0-553-29698-2 -- yes
-- 978-0-375-41398-8 -- no

call issue_book('IS155','C108','978-0-553-29698-2','E104');

```
## Reports

- **Database Schema**: Detailed table structures and relationships.
- **Data Analysis**: Insights into book categories, employee salaries, member registration trends, and issued books.
- **Summary Reports**: Aggregated data on high-demand books and employee performance.

## Conclusion

This project demonstrates the application of SQL skills in creating and managing a library management system. It includes database setup, data manipulation, and advanced querying, providing a solid foundation for data management and analysis.


