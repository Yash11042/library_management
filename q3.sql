select * from books
where isbn ='978-0-09-957807-9';
update books
set status ='NO'
where isbn ='978-0-330-25864-8';

select * from issued
where issued_book_isbn='978-0-09-957807-9';



-- IS112 calling functions

 call return_records('RS158','IS112','good');
 select * from return_status;


 /* Q15 BRANCH PERFORMANCE REPORT , 
 CEATE A QUERY THAT GENERATE A PERFORMANCE REPORT FOR EACH BRANCH, SHOWING THE NUMBER OF BOOKS ISSUED,THE NUMBER OF
 BOOK RETURNED , AND THE TOTAL REVENUE GENERATED FROM BOOK RENTALS.
 */
 
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


/* Q16 CTAS: CREATE A TABLE OF ACTIVE MEMBERS
USE THE CREATE TABLE AS (CTAS) STATEMENT TO CREATE A NEW TABLE ACTIVE_MEMBERS CONTAINING MEMBERS WHO HAVE ISSUED AT LEAST
ONE BOOK IN PAST 6 MONTHS
*/

create table active_members
as
select * from members
where member_id in(select distinct issued_member_id from issued
                     where issued_date > current_date - interval 6 month);
                     
select * from active_members;


/*  Q17  FIND THR EMPLOYEE WITH THE MOST BOOK ISSUES PROCESSED WRITE A QUERY TO FIND THE TOP 3 EMPLOYEES WHO HAVE PROCESSED THR MOST
BOOK ISSUES.
DISPLAY THE EMPLOYEE NAME,NUMBER OF BOOKS PROCESSED , AND THEIR BRANCH
*/

select e.emp_name,count(i.issued_id) as no_book_issued,b.branch_address from issued as i
join employee as e
on e.emp_id=i.issued_emp_id
join
branch as b
on e.branch_id=b.branch_id
group by e.emp_name,i.issued_id;


-- Q18 STORE PROCRDURE :

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

