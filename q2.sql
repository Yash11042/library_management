select * from books;

-- Q1  CREATE A NEW BOOK RECORD -- "978-1-60129-456-2 ", " TO KILL A MOCKING BIRD", "CLASSIC",6.00,"YES","HARPER LEE","JB LIPPINCOTT AND CO."

insert into books(isbn,book_title, category,rental_price,status,author,publisher)
values 
(978-1-60129-456-2,"To kill a mocking bird","classic",6.00,"yes","Harper lee","JB LIPPINCOTT AND CO.");
select *  from books;


-- Q2 UPDATE AN EXISTING MEMBERS ADDRESS?

SET SQL_SAFE_UPDATES= 0;
update members
set member_address = "JB road"
where member_address="123 Main St";

select * from members;

-- Q3 DELETE A RECORD FROM THE ISSUED ISSUED STATUS TABLE -- OBJECTIVE: DELETE THE RECORD WITH ISSUED_ID ="IS104" FROM ISSUED_STATUS TABLE

delete from issued
where issued_id="IS104";

select * from issued;

-- Q5  RETRIVE ALL THE BOOKS IISUED BY A SPECIFIC EMPLOYEE -- OBJECTIVE: SELECT ALL THE BOOKS ISSUED BY THE EMPLOYEE WITH EMP_ID - E101?

select * from issued
 where issued_emp_id ="E101";
 
 select issued_emp_id, count(issued_id) as total_book_issued
 from issued 
group by issued_emp_id
having count(issued_id)>1 
order by total_book_issued desc;

 
 --  Q6 CTAS (create table as select statement)
	-- CREATE SUMMARYTABLES: USED CTAS TO GENERATE NEW TABLES BASED ON QUERY RESULT - EACH BOOK AND TOTAL BOOK_ISSUED_CNT?
  
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
    -- Q7 RETRIVE ALL BOOK IN SPECIFIC CATEGORY:
    
    select min(book_title) , category,count(isbn) as count_isbn
    from books 
    group by category;
    
    -- Q8 FIND THE TOTAL RENTAL INCOME by each category?
    
   select a.category, sum(a.rental_price) as total,count(*)
   from
   books as a
   join 
   issued as b
   on a.isbn=b.issued_book_isbn
   group by category;
   
   
   -- Q9 LIST THE MEMBER WHO REGISTERED IN THE LAST 180 DAYS:
   
   
   
    insert into members(member_id,member_name,member_address,reg_date)
    values
    ("C120","Sam","145 main st","2024-06-01"),
    ("C121","Jonny","133 main st","2024-07-03");
    
	update members
    set reg_date="2024-12-12"
    where reg_date="2024-07-03";
    
    
    select * from members
    where reg_date>= current_date - interval 180 day;
    
-- Q10 LIST EMPLOYEE WITH THEIR BRANCH MANAGER'S NAME AND THEIR BRANCH DETAILS:

select a.*,b1.emp_name as manager,
b.branch_id
 from employee as a
join branch as b
on a.branch_id=b.branch_id
join
employee as b1
on b.manager_id=b1.emp_id;

-- Q11 CREATE A TABLE OF BOOKS WITH RENTAL PRICE ABOVE CERTAIN THRESHOLD $6:

create table books_price_greater
as
select * from books 
where rental_price>=7;

select * from books_price_greater;


-- Q12 RETRIVE THE LIST OF BOOKS THAT HAS NOT BEEN RETURNED:

select 
distinct a.issued_book_name
from issued as a
 left join return_status as b
on a.issued_id=b.issued_id
where return_id is null;
 
 -- ADVANCE SQL OPEATIONS
 
 -- Q13 IDENTIFY MEMBERS WITH OVERDUE BOOKS WRITE A QUERY TO IDENTIFY MEMBERS WHO HAVE OVERDUE BOOKS. DISPLAY THE MEMBERS NAME,BOOK TITLE ISSUE DATE, AND DATA OVERVIEW:
 
 
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

/*
 Q 14 UPDATE THE BOOK STATUS ON RETURN  WRITE A QUERY TO UPDATE THE STATUS OF BOOKS IN THE BOOKS TABLE TO "YES"
 WHEN THEY ARE RETURNED(BASED ON THE CURRENT ENTRIES IN THE RETURN_STATUS TABLE)
 */
 
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
 
 
 
 

  



    
    
    

    
    
    
    

