--DML (Insert; Update; Delete)
--Insert 
insert into departments 
(department_id,manager_id,location_id,department_name)
values (280,100,1700,'DS');

select * from departments;

insert into departments 
(department_id,department_name)
values (290,'DA');

--sysdate();curdate()
insert into employees (EMPLOYEE_ID,LAST_NAME,EMAIL,HIRE_DATE,JOB_ID)
values (250,'xyz','xyz@',SYSDATE,'SA_REP')

select * from employees;

create table copy_dept as select * from departments;

select * from copy_dept;

insert into copy_dept
select * from departyments;

insert into copy_dept(department_id,department_name)
select department_id,department_name from departyments;

create table copy_dept as select * from departments
where department_id = 0;

--Update 
update copy_dept 
set department_id =300;
where department_name ='DA';

select * from departments;

update copy_dept 
set department_id =(select department_id from departments where department_name ='DS')
where department_name = (select department_name from departments  where department_id =280)

--delete 
--spedific rows deletion 
delete from copy_dept 
where department_name ='DS'

--all rows from table gets deleted
delete from copy_dept;

--Truncate
--data of the table is gone,structure remains as it is
truncate  table copy_dept;


select count(*) from departments;

--Transactions
start transaction;

update copy_dept 
set department_id = 300
where department_name = 'IT';

commit;

start transaction;

update copy_dept
set location_id =1200
where department_id = 300;

savepoint up_done;

insert into copy_dept(department_id,department_name)
values(400,'xyz')

savepoint in_done;

rollback to up_done;

rollback to in_done;

commit;

select * from copy_dept

--DDL(Create;alter;truncate;drop)
--Database object(Tables,Views,Index,sequence,synonym)

create table customer
( 
cust_id number(6),
last_name varchar2(20),
join_date date 
);

--Constraints

create table copy_emp
(
emp_id number(6)
constraint empid_pk primary key,
f_name varchar2(20)
constraint f_name_nn not null,
l_name varchar2(20),
salary number(10,2) 
constraint sal_ck check (salary >1000),
email varchar2(20)
constraint email_uk unique,
department_id number(4),
constraint dept_fk foreign key(department_id) references departments(department_id)
);

--alter
alter table copy_emp
add job_id varchar2(20)

--modify 
alter table copy_emp
modify (l_name varchar2(15));

alter table copy_emp
drop column l_name;

alter table customer
add constraint cust_uq unique (last_name)

alter table customer read only;
alter table customer read write;


--drop table 
drop table customer 

select * from customer

--user_constraints
--user_cons_columns

select * from user_constraints
where table_name = 'COPY_EMP'

--=============================================================

CREATE TABLE job_grades (
grade 		CHAR(1),
lowest_sal 	NUMBER(8,2) NOT NULL,
highest_sal	NUMBER(8,2) NOT NULL
);

ALTER TABLE job_grades
ADD CONSTRAINT jobgrades_grade_pk PRIMARY KEY (grade);

INSERT INTO job_grades VALUES ('A', 1000, 2999);
INSERT INTO job_grades VALUES ('B', 3000, 5999);
INSERT INTO job_grades VALUES ('C', 6000, 9999);
INSERT INTO job_grades VALUES ('D', 10000, 14999);
INSERT INTO job_grades VALUES ('E', 15000, 24999);
INSERT INTO job_grades VALUES ('F', 25000, 40000);

COMMIT;

--==============================================================

--Non-equi joins 
select * from job_grades;

select * from employees;

-- must use between and in non-equi joins
select e.last_name,e.salary,jg.grade
from employees e join job_grades jg
on e.salary between jg.lowest_sal and jg.highest_sal;

--creating different database objects
--types of views(1. simple view; 2. complex view)
--1.simple view -- we can perform any dml operations -- it refects changes in base table as well
create view emp_90
as select employee_id,last_name,salary,department_id
from employees
where department_id = 90;

select * from emp_90;

select employee_id,salary from emp_90;

--view modify
create or replace view emp_90
(empid,l_name,f_name,sal,deptid)
as select employee_id,last_name,first_name,salary,department_id
from employees
where department_id = 90;

select * from emp_90;

--complex view-- we do not perform any dml operations
--complex view -- due to complex function or aggregate functions -- group by, distinct, join, group functions
create or replace view dept_sum_vu
(dname,min_sal,max_sal,avg_sal)
as
select d.department_name,min(e.salary),
max(e.salary),avg(e.salary)
from employees e join departments d 
using (department_id)
group by d.department_name;

select * from dept_sum_vu;

update dept_sum_vu
set avg_sal = 10000
where dname = 'IT'

select * from emp_90;

--user_views
select * from user_views;

select text from user_views
where view_name = 'EMP_90'

--check constraints 
create or replace view emp_20
as 
select * from employees 
where department_id = 20
with check option constraint emp_20_ck;

insert into view emp_20 (first_name, last_name, employee_id)
values ('abc', 'def', 19)

--read only option
create or replace view view_rep
as
select * from employees 
where job_id like '%REP%'
with read only ;

select * from view_rep;

update view_rep
set salary =28000
where first_name = 'Pat';

--drop view
drop view view_rep;

--sequence
--its generates unique values automatically 
--is a sharable object
--it can be used to create primary key values 
--we dont sequence generating routine in applications 
--speeds up the accessing the data 

create sequence test_seq
start with 1
increment by 10
maxvalue 9
nocache
nocycle

-- 2 pseudocolumns 
--NEXTVAL AND CURRVAL
select * from copy_dept;
truncate table copy_dept;

insert into copy_dept (department_id,department_name,manager_id,location_id)
values
(test_seq.nextval,'HR',100,1200);

insert into copy_dept (department_id,department_name,manager_id,location_id)
values
(test_seq.nextval,'Training',101,1300);

select.currval from dual;


--adding a sequence while table creation 
CREATE TABLE SAMPLE
(
sapid number default id_seq.nextval not null,
name varchar2(20)
)

insert into sample (name)
values ('Bhavani')

insert into sample (name)
values ('Aditya')

select * from sample;

--GAPS in sequence 
--when your getting NEXTVAL from dual table
--When a rollback occors 
--when system/ application crash
--when a sequence is used in other table

--alter sequence 
alter sequence id_seq 
increment by 5
maxvalue 9999;

select * from sample;

insert into sample (name)
values ('Vivek')

insert into sample (name)
values ('Mark')

--drop sequence
drop sequence id_seq;

--drop sequence
drop sequence id_seq;

--user_sequences 
select sequence_name,min_value,max_value,increment_by,last_number
from user_sequences;

--Synonyms 
--is used for database objects
create synonym dept1 
for departments;

select * from dept1;

desc dept1;

select * from dept1;

--drop synonym 
drop synonym dept1;

--indexes
--to speed up the retrival process

--atomatic index: when ever you define primary key or unique constraint 

--creating index manually -- btree indexes
create index last_name_index
on employees(last_name);

--creating index along with table creation
create table new_emp
(
employee_id number(5)
primary key using index (create index new_emp_indx on new_emp(employee_id)),
name varchar2(10)
)

--user_indexes
select index_name,table_name
from user_indexes
where table_name ='NEW_EMP'



--function based index 
create index upper_dept_index
on copy_dept(upper(department_name))

select * from copy_dept
where upper(department_name) = 'SALES';

--drop index 
drop index upper_dept_index;

select * from copy_dept;

--composite index
create index copy_indx
on copy_dept(manager_id,location_id);

--user_indexes
select index_name,table_name
from user_indexes
where table_name = 'COPY_DEPT';

--user_ind_columns 
select index_name,column_name,table_name
from user_ind_columns
where table_name = 'COPY_DEPT';




























