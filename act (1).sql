create table books
(
  book_id int not null,
  title varchar(20),
  author_last_name varchar(20),
  author_first_name varchar(20),
  rating char(1) check (rating in ('1', '2', '3')),
  
  constraint books_pk primary key (book_id)
);


create table patrons
(
  patron_id int not null,
  last_name varchar(20),
  first_name varchar(20),
  street_address varchar(30),
  city varchar(10),
  zip char(7),
  constraint patrons_pk primary key (patron_id)
);

create table transactions
(
  transaction_id int not null,
  patron_id int,
  book_id int,
  transaction_date date,
  transaction_type char(1) check (transaction_type  in ('1', '2', '3')),
  constraint transactions_pk primary key (transaction_id),
  constraint transactions_fk1 foreign key (book_id) references books (book_id),
  constraint transactions_fk2 foreign key (patron_id) references patrons (patron_id)

);

create sequence books_seq
start with 1
increment by 1;


insert into books
values (books_seq.nextval, 'Intro to probability',
 'Bertsekas', 'Dimitri', '1');


insert into books
values (books_seq.nextval, 'Chemistry',
 'DeCoste', 'Donald', '1');

insert into books
values (books_seq.nextval, 'Clean Code',
 'Cecil Martin
', 'Robert', '2');
insert into books
values (books_seq.nextval, 'CRC ',
 'Lide', 'David', '2');

insert into books
values (books_seq.nextval, 'Harry Potter',
 'Rowling', 'J.K.', '3');

insert into books
values (books_seq.nextval, 'Alchemist',
 'Coelho', 'Paulo', '3');

select * from books;



alter table patrons
add (DOB date);


alter table patrons 
add (LAST_MODIFIED timestamp, MODIFIED_BY varchar(20));


create sequence patrons_seq
start with 10
increment by 1;


insert into patrons (patron_id, last_name, first_name, street_address, city, zip, DOB, LAST_MODIFIED, MODIFIED_BY)
values (patrons_seq.nextval, 'Pecker', 'Peter', '141-victoria st', 'Kamloops', 'V2J9O3', TO_DATE('19-11-2000', 'DD-MM-YYYY'), systimestamp, 'user020');





insert into patrons values
       (patrons_seq.nextval, 'Knowns', 'Kerry', '1055 dalhousie', 'kamloops', 'V3R0Y0', TO_DATE('01-10-1992', 'DD-MM-YYYY'), systimestamp, 'user119');

insert into patrons values
       (patrons_seq.nextval, 'Graves', 'Mellow', '190 skie dr', 'Vancouver', 'B3R5T7', TO_DATE('21-01-2003', 'DD-MM-YYYY'), systimestamp, 'user001');
       
insert into patrons values
       (patrons_seq.nextval, 'Moody', 'Hiachi', '15 kelio st', 'Waterloo', 'M2E5R6', TO_DATE('13-08-1988', 'DD-MM-YYYY'), systimestamp, 'user100');


select * from patrons;

select patron_id, upper(substr(first_name, 1, 1)) || '.' || ', ' || last_name as "names", to_char(DOB, 'YYYY-MM-DD') AS "DOB"
from patrons
where trunc(LAST_MODIFIED) = trunc(sysdate)
order by last_name;


select patron_id, round(months_between(sysdate, DOB) / 12) AS "age"
from patrons
order by "age" asc;

create sequence transactions_seq
start with 30
increment by 1;

insert into transactions
values(transactions_seq.nextval,13,25,TO_DATE('01-10-2015', 'DD-MM-YYYY'),'1');

select patrons.patron_id, patrons.last_name, patrons.first_name
from patrons
where patrons.patron_id IN (SELECT DISTINCT patron_id from transactions)


insert into books
values (books_seq.nextval, 'data base and oracle',
 'Shikhar', 'Raj', '1');

 insert into books
values (books_seq.nextval, 'Intro to Databases',
'Kaguma', 'Paul', '2');

 select author_last_name, title 
from books
where upper(title) like '%DATABASE%' or UPPER(title) like '%DATA BASE%'or upper(title) like '%DATABASES%'
order by rating;


select patrons.patron_id, last_name, first_name
from patrons
join transactions on patrons.patron_id = transactions.patron_id;


insert into transactions
values(transactions_seq.nextval,12,1,TO_DATE('21-11-2020', 'DD-MM-YYYY'),'3');

select books.book_id, substr(books.title, 1, 10) as "title", 
coalesce(count(transactions.book_id), 0) as "transactions"
from books
left join transactions
on books.book_id = transactions.book_id
and to_char(transactions.transaction_date, 'YYYY') = '2020'
group by books.book_id, substr(books.title, 1, 10)
order by "transactions" DESC;

select * from transactions;

/*ACTIVITY 4*/
select patron_id from transactions where transaction_date = TO_DATE('21-11-2020', 'DD-MM-YYYY');

select patron_id
from transactions
where transaction_id in (select transaction_id
                        from transactions
                        where transaction_date = TO_DATE('21-11-2020', 'DD-MM-YYYY'));
                        
insert into transactions
values(transactions_seq.nextval,11,3,TO_DATE(current_date, 'DD-MM-YYYY'),'3');

insert into transactions
values(transactions_seq.nextval,12,4,TO_DATE(current_date, 'DD-MM-YYYY'),'1');

insert into transactions
values(transactions_seq.nextval,12,2,TO_DATE('22-09-2014', 'DD-MM-YYYY'),'1');

insert into transactions
values(transactions_seq.nextval,11,1,TO_DATE('12-09-2014', 'DD-MM-YYYY'),'1');

SELECT patron_id from transactions where transaction_type  = '3' and transaction_date = to_date(current_date, 'DD-MM-YYYY');

select patron_id
from transactions
where transaction_id in (select transaction_id
                        from transactions
                        where transaction_type  = '3' and transaction_date = to_date(current_date, 'DD-MM-YYYY'));
                        
select *
from books
where book_id in (select book_id
                        from transactions
                        where transaction_type  = '1');
                        


                        
                        
select *
from books
where book_id in (select book_id
                        from transactions
                        where TO_CHAR(transaction_date, 'MM/YYYY') = '09/2014' and transaction_type = '1' );
                        
  select * from patrons;                      
SELECT patron_id AS "Patron ID", last_name || ' ' || first_name AS Fullname,  street_address AS "Place of residence", city AS "City", zip AS "PostalCode", DOB AS "Birthday"
FROM patrons;

ALTER TABLE transactions ADD fine NUMBER;


select * from books where book_id in
(select cnt1.book_id
from (select COUNT(*) as total, book_id
      from transactions
      group by book_id) cnt1,
     (select MAX(total) as maxtotal
      from (select COUNT(*) as total, book_id from transactions group by book_id)) cnt2
where cnt1.total = cnt2.maxtotal);


select b.*
from books b
join (select book_id, count(book_id) AS transaction_count
      from transactions
      group by book_id
      order by transaction_count DESC
      FETCH FIRST 1 ROW ONLY) t ON b.book_id = t.book_id;
      
      
      SELECT b.*, t.transaction_count, t.transaction_count as rating
FROM books b
JOIN (SELECT book_id, COUNT(book_id) AS transaction_count
      FROM transactions
      GROUP BY book_id) t ON b.book_id = t.book_id
ORDER BY t.transaction_count DESC;


select b.*
from books b
join (select book_id, count(book_id) AS transaction_count
      from transactions
      group by book_id) t on b.book_id = t.book_id
where t.transaction_count = (select max(transaction_count)
                             from (select count(book_id) AS transaction_count
                                   from transactions
                                   group by book_id)
                            );


CREATE VIEW book_status_by_year AS
SELECT EXTRACT(YEAR FROM transaction_date) AS year,
       CASE
         WHEN transaction_type = '1' THEN '1'
         WHEN transaction_type = '2' THEN '2'
         ELSE '3'
       END AS status,
       COUNT(book_id) AS count
FROM transactions
GROUP BY EXTRACT(YEAR FROM transaction_date),
         CASE
           WHEN transaction_type = '1' THEN '1'
           WHEN transaction_type = '2' THEN '2'
           ELSE '3'
         END;
         
         SELECT *
FROM book_status_by_year;

alter table patrons
add fine number;
update patrons set fine = 100 where sysdate > last_modified + 1;
select patron_id, last_name || ' ' || first_name AS Fullname, fine as finePaid from patrons;
select * from patrons;

select  patron_id || last_name || ' ' || first_name AS Fullname,  (extract (year from sysdate) - extract (year from DOB)) as age , fine  from patrons order by age desc;

SELECT patron_id, MAX(extract (year from sysdate) - extract (year from DOB)) as age
FROM patrons
GROUP BY patron_id;

select patron_id, last_name || ' ' || first_name AS Fullname, fine as finePaid from patrons where patron_id in(select min (extract (year from sysdate) - extract (year from DOB)) from patrons);

select * from transactions;
select transaction_type from transactions where extract (year from transaction_date) = 2023; 

SELECT COUNT(book_id) as "Number of Books Issued"
FROM transactions;

select * from patrons;
SELECT *
FROM staff020
WHERE dept LIKE 'A%s';

SELECT *
FROM staff020
WHERE desig LIKE 'M%r' OR desig LIKE 'M%s';

SELECT last_name || ' ' || first_name AS Fullname
FROM patrons
WHERE state = 'BC' OR zip LIKE 'V2%';


SELECT *
FROM staff020
WHERE REGEXP_LIKE(fname, '(.)\\1');








