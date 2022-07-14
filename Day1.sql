-- this is sql statement
select * from employees;
select * from departments;

-- select specific 
select 
first_name,email,phone_number
from employees;

--selecting data from dual
--dual is a table automatically created by Oracle Database.
--dual has one column called DUMMY, of data type VARCHAR(1), and contains one row with a value x.
select * from dual;
select sysdate from dual;
select 2+3 from dual;

-- Arithmetic operations
select first_name,salary,salary+200
from employees;

--Defining a Null Value
--Arithmetic Expressions contain null value evaluate to null
select last_name,commission_pct
from employees;

select first_name,12*salary+commission_pct
from employees;

-- Defining a column alias
-- 1st way
select first_name,12*salary+commission_pct sal_comm
from employees;

-- 2nd way
select first_name,12*salary+commission_pct "Sal_comm"
from employees;

-- 3rd way
select first_name,12*salary+commission_pct as "Sal_comm"
from employees;

-- Concatination operator
select first_name || ' ' || last_name as "Employee_name"
from employees;


-- Literal character string
select first_name || ' is a ' || job_id as "Employee_details"
from employees

-- Alternative quote (q) operator
select department_name || q'[ Department's Manager id: ]' || Manager_id as "Department_Manager"
from departments;


-- Duplicate rows
select department_id
from employees

select distinct department_id -- only for particular column
from employees 

select distinct first_name,department_id
from employees

--The WHERE claus
select 
employee_id,first_name,salary,department_id,hire_date
from employees 
where department_id = 50;

select 
employee_id,first_name,salary,department_id,job_id
from employees 
where job_id = 'SH_CLERK'; -- data within table is case sensitive

select 
employee_id,first_name,salary,department_id,hire_date
from employees 
where hire_date = '18-JUL-04';

--Comparison Operators(=,<=;>=;<>;<;>;Between and ; IN; Like; IS NULL)
select first_name,salary
from employees
where salary <> 2500;

-- Between and
select first_name,salary
from employees
where salary between 1000 and 10000; -- inclusive of upper and lower limit

select first_name
from employees
where first_name between 'A' and 'Cu';

-- IN
select first_name,department_id
from employees
where department_id IN (50, 60, 80);

select first_name,department_id
from employees
where department_id not IN (50,90,80);

select first_name,department_id
from employees
where first_name IN ('Oliver','Patrick');

select first_name,department_id
from employees
where first_name not IN ('Oliver','Patrick');

--Like 
--%  denotes zero or more characters
-- _ denotes one charcter

select first_name
from employees
where first_name like 'S%'

select last_name
from employees 
where last_name like '_o%'

--is null

select first_name,commission_pct
from employees
where commission_pct is null;

select first_name,commission_pct
from employees
where commission_pct is not null;

select first_name,manager_id
from employees
where manager_id is null;

-- Logical operator (AND, OR, NOT)
-- AND
select first_name,job_id,salary
from employees
where salary>1000 and job_id like '%REP%';

-- OR
select first_name,job_id,salary
from employees
where salary>1000 or job_id like '%REP%';

-- NOT
select first_name,job_id,salary
from employees
where job_id not in ('AD_PRES', 'IT_PROG');

-- Order by clause (ASC, DESC)
-- default ASC
select first_name,job_id,salary
from employees
order by first_name;

select first_name,job_id,salary*12 as AnnualSalary
from employees
order by AnnualSalary;

-- sorting using position of column
select first_name,job_id,salary
from employees
order by 3;

-- sorting using multiple column
select first_name,job_id,salary,department_id,manager_id
from employees
order by department_id,manager_id;

-- Row limiting clause
--FETCH
select first_name,job_id
from employees
fetch first 10 rows only;

-- OFFSET
select first_name,job_id
from employees
offset 5 rows fetch next 10 rows only;


-- IMPORTANT --
--Substitution variables 
--changing columns, conditions, and their values at runtime
--where; order by; column expression; table name
-- &; &&

select employee_id,department_id,salary
from employees 
where department_id = &deptid;

select employee_id,department_id,salary,job_id
from employees 
where job_id = '&jobid'; -- for string variables for matching

--column names, expression, column to the order by clause
select 
employee_id,last_name,job_id,&col_name
from employees
where &condition
order by &order_column;

--&& -- prompt only once for col_name 
select 
employee_id,last_name,job_id,&&col_name
from employees
order by &order_column;

--Assigning values to variables
--Define & Undefine
--constants values

define employee_num = 174

select employee_id,last_name,salary
from employees
where employee_id = &employee_num;

undefine employee_num
