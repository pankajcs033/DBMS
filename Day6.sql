--Exceptions:
declare 
    lname varchar2(17);
begin 
    select last_name into lname 
    from employees
    where first_name ='John';
    dbms_output.put_line('King''s last name is :'||lname);
end;


select last_name,first_name
from employees
where first_name = 'John';

set serveroutput on;
--example of an exception
declare 
    lname varchar2(17);
begin 
    select last_name into lname 
    from employees
    where first_name ='John';
    dbms_output.put_line('King''s last name is :'||lname);
exception
    when too_many_rows then
    dbms_output.put_line('your select stmt retrived multiple rows. consider using cursors...');
end;


--Types of exceptions
/* 
1. Implicit exceptions
    a) predefined exceptions
    b) Non-pre defined exceptions 
2. Explicit exceptions or user defined exceptions
*/

--no_data_found
--too_many_rows
--zero_divide
--invalid_cursor
--dup_val_on_index

--Non-predefined exceptions
--pragma_exception_init -- it holds the codes for every error
--exception section
declare
    insert_excep exception;
    pragma exception_init(insert_excep,-01400);
begin
    insert into departments 
    (department_id,department_name)
    values(2800,null);
exception 
    when insert_excep then
    dbms_output.put_line('insert operation failed!');
    dbms_output.put_line(SQLERRM);
end;

--SQLERRM (error with codes), SQLCODE (only codes) functions which are used for trapping exceptions
-- when others then (when we don't know thw error) must be the last statement in exception
declare 
    lname varchar2(17);
begin 
    select last_name into lname 
    from employees
    where first_name ='King';
    dbms_output.put_line('King''s last name is :'||lname);
exception
    when too_many_rows then
    dbms_output.put_line('your select stmt retrived multiple rows. consider using cursors...');
    when others then
    dbms_output.put_line('No such employees....');
end;

--user-defined exception
--declare
--raise the exception using raise keyword
--exception handling the exception in exception section
accept deptno prompt 'Please enter the department number:'
accept name prompt 'Please enter the department name:'
declare
    invalid_department exception;
    name varchar2(20) := '&name';
    deptno number :=&deptno;
begin
    update departments 
    set department_name = name
    where department_id = deptno;
    if sql%notfound then
        raise invalid_department;
    end if;
exception
    when invalid_department then
    dbms_output.put_line('No such department id.');
end;

--raise_applicatio_error this is a procedure 
--error_number : -20000 to -20999 -- can be use these numbers for custom error
--message 

declare
    invalid_mgr exception;
    --name varchar2(20) := '&name';
    v_mgr number :=&v_mgr;
begin
    delete from employees
    where manager_id = v_mgr;
    if sql%notfound then
        raise invalid_mgr;
    end if;
exception
    when invalid_mgr then
    raise_application_error(-20202,'No such manager id.'); -- raise only used for user defined exceptions
end;

select * from employees
where manager_id = 1000;


--Stroed PROCEDURES or subprograms which perform certain task or action in database 
--stored as database objects 
--compile them once and run multiple times
--promotes reusability 
--easy to mantain
--3 types of parameters 
/*
1.IN (default mode)  -- input by user
2.OUT -- returns values
3.IN OUT  --use for both input and output
*/

CREATE OR REPLACE PROCEDURE RAISE_SALARY
    (
        id in employees.employee_id%type, -- (in) input by user
        percent in number
    )
AS 
BEGIN
    update employees
    set salary = salary *(1+percent/100)
    where employee_id = id;
END RAISE_SALARY;

select salary
from employees
where employee_id = 110;

-- to execute procedure
execute raise_salary(110,10)

--procedure with in and out 
create or replace procedure query_emp
( -- parameters
      id in employees.employee_id%type,
      name out employees.last_name%type,
      sal out employees.salary%type
) 
is 
begin
    select last_name,salary into name,sal
    from employees 
    where employee_id =id;
end query_emp;

set serveroutput on;

--Anonmous block
declare 
    emp_name employees.last_name%type;
    emp_sal employees.salary%type;
begin
    query_emp(171,emp_name,emp_sal);
    dbms_output.put_line(emp_name||' '||emp_sal);
end;

--bind variables to print the procedure output
variable name varchar2(20);
variable sal number;
execute query_emp(171,:name,:sal)
print name sal

--create procedure without parameters
create or replace procedure add_dept 
is -- 'as' or 'is' same
    v_dept_id copy_dept.department_id%type;
    v_dept_name copy_dept.department_name%type;
begin
    v_dept_id := 30;
    v_dept_name := 'St-curriculum';
    insert into copy_dept(department_id,department_name)
    values(v_dept_id,v_dept_name);
    dbms_output.put_line('Inserted:' || sql%rowcount || 'row');
end;

--anonmous block
begin
    add_dept;
end;

select * from copy_dept;


--in out parameters
--1234567890
--(123)456-7890
create or replace procedure format_phone
(phone_no in out varchar2) 
is
begin
    phone_no := '(' || substr(phone_no,1,3)||
                ')' || substr(phone_no,4,3)||
                '-' || substr(phone_no,7);
end format_phone;

--bind variables 
variable phone varchar2(20);
execute :phone:= '8006330575'
print phone
execute format_phone(:phone)
print phone

--anonmous block
declare
    phone varchar2(20) := '1234567890';
begin
    format_phone(phone);
    dbms_output.put_line(phone);
end;


--create procedure with 'in' parameters
create or replace procedure add_emp 
(
    v_emp_id in copy_emp.emp_id%type,
    v_f_name in copy_emp.f_name%type
)
is 
begin
    insert into copy_emp(emp_id,f_name)
    values(v_emp_id,v_f_name);
    dbms_output.put_line('Inserted:' || sql%rowcount || 'row');
end add_emp;

begin
    add_emp(124,'XYZ');
end;

select *
from copy_emp
where emp_id = 124;

-- handling exceptions in procedures
create or replace procedure add_department
(
    name varchar2,
    mgr number,
    loc number
)
is 
begin
    insert into departments(department_id,department_name,manager_id,location_id)
    values(departments_seq.nextval,name,mgr,loc);
    dbms_output.put_line('Added dept: ' || name);
exception
    when others then
    dbms_output.put_line('Err: adding the dept: '||name);
end;

create or replace procedure create_department 
is
begin
    add_department('Media',100,1800);
    add_department('Editing',99,1800);
    add_department('Advertising',101,1800);
end;


execute create_department()

select manager_id from employees;

select * from departments;

--dictionary views of procedures
--user_source 
--user_objects

select object_name
from user_objects
where object_type = 'PROCEDURE';

select text
from user_source
where name = 'ADD_DEPT'
and type = 'PROCEDURE';

--========================================================================
--function example
create or replace function get_sal
(
    id employees.employee_id%type
)
return number is --return clause acts like a out mode 
sal employees.salary%type := 0;
begin
    select salary
    into sal
    from employees
    where employee_id = id;
    return sal;
end;

--invoke the functions
--1.Method
execute dbms_output.put_line(get_sal(100));

--2.Method
variable sal number;
execute :sal := get_sal(100);
print sal;

--3.Method
declare
    sal employees.salary%type;
begin
    sal :=get_sal(176);
    dbms_output.put_line(sal);
end;

--4.Method (using a select stmt) 
select 
    job_id,get_sal(employee_id) 
from employees;

--complex SQL with lot of computations can be created as functions
--increases the efficiency when used in the where clause
--data manipulation
create or replace function tax(value in number)
return number is 
begin 
    return (value*0.08);
end tax;

select employee_id,last_name,salary,tax(salary)
from employees
where department_id = 100;

--function example
create or replace function check_sal
return boolean is
    v_department_id employees.department_id%type;
    v_empno employees.employee_id%type;
    v_sal employees.salary%type;
    v_avg_sal employees.salary%type;
begin
    v_empno :=205;
    select salary,department_id into v_sal,v_department_id
    from employees
    where employee_id = v_empno;
    select avg(salary) into v_avg_sal
    from employees
    where department_id = v_department_id;
    if v_sal > v_avg_sal then
        return true;
    else 
        return false;
    end if;
exception
    when no_data_found then
        return null;
end;

--invoke the function
begin
    if (check_sal is null) then
        dbms_output.put_line('The function returned NULL dur to exception');
    elsif (check_sal) Then
        dbms_output.put_line('salary greater than average');
    else 
        dbms_output.put_line('salary less then average');
    end if;
end;

select department_id from employees
where employee_id = 205;

select department_id,avg(salary) from employees
group by department_id;

select salary 
from employees
where employee_id =205;

--function example to demonstrate side effets ///////////////////////////////////////////////////////////////
create or replace function dml_fun(p_sal number)
return number is
begin
    insert into employees(employee_id,last_name,email,hire_Date,job_id,salary)
    values(1,'Forst','jforst@',sysdate,'SA_MAN',p_sal);
return (p_sal +100);
end;

update employees -- we cannot use any DML (except select) command on functions it throws error
set salary = dml_fun(2000)
where employee_id = 176;

--////////////////////////////////////////////////////////////////////////////////////////////////////////////

--function example
create or replace function tax_new 
(
    p_id in employees.employee_id%type,
    p_allowances number default 500
)
return number is
v_sal employees.salary%type;
begin
    select salary into v_sal
    from employees
    where employee_id = p_id;
    v_sal := v_sal-p_allowances;
    return(v_sal*0.08);
end tax_new;

--invoking the function 
execute dbms_output.put_line(tax_new(100));

execute dbms_output.put_line(tax_new(100,1500)); --postitional parameter passing 

execute dbms_output.put_line(tax_new(p_allowances => 1600,p_id => 100)); --named or mixed notation 

execute dbms_output.put_line(tax_new(p_id =>100)); --named notation 

--user_source
--user_objects

select text
from user_source 
where type ='FUNCTION'
and name = 'TAX_NEW'
order by line;

select object_name
from user_objects
where object_type = 'FUNCTION';

--drop function tax;

rollback;



