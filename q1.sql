create database library;
use library;

-- PROECT LIBRARY MANAGEMENT SYSTEM:

-- creation of table:

create table branch (
branch_id varchar(5) primary key, -- fk
	manager_id varchar(5),  -- fk
	branch_address varchar(20),	
    contact_no varchar(20));
    
 alter table branch   
 modify column contact_no varchar(20);
    
create table employee(
emp_id varchar(10) primary key,
	emp_name varchar(20),
	position varchar(20),
	salary int,
	branch_id varchar(10) 
);

create table books(
isbn varchar(25) primary key,
	book_title varchar(75),	
    category varchar(20),
	rental_price float,
	status varchar(10),
	author varchar(30),
	publisher varchar(50)
);
    
create table members(
member_id varchar(20) primary key,
	member_name varchar(30),
	member_address varchar(80),
	reg_date date
);

create table issued(
issued_id varchar(10) primary key, 
	issued_member_id varchar(10),-- fk
	issued_book_name varchar(75),
	issued_date date,	
    issued_book_isbn varchar(25), -- fk
	issued_emp_id varchar(10) -- fl
);
   
create table return_status(
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




   
