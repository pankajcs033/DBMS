--PL/SQL
--stands for procedural language for SQL
--database language which is used for RDBMS
--integrated with SQL
--PL/SQL : block structure 
--variable,constants,different types
--conditional operators (if-else);control structures (loops)
--reusable codes
--improved performance
--modular programming language
--integrate with other oracle tools
--exception handling 

--SQL stmt executor
--PL/SQL stmt executor

/* Declare (optional)
    -varaible,cursors,user-defined exceptions
Begin (Mandatory)
    --SQL stmts
    --PL/SQL
Exception (optional)
    --Actions to perform when an exception occurs
End; (Mandatory) */

--Types of blocks 
--1.Anonymous block: Unnamed block ; will not store in the database
    /* declare
    ------
    begin 
    ----
    ---
    end; */

--Named blocks: will have for every object; they get stored in the database; compile once run multiple times.
--2.Procedures
    /*procedure name 
    is
    begin
    -----
    -----
    exception
    -----
    ----
    end; */

--3.Functions
--4.Packages
--5.Triggers

--example 1
SET SERVEROUTPUT ON -- to print using DBMS_OUTPUT (execute only once)

DECLARE 
    v_fname varchar2(20);
BEGIN
    SELECT first_name into v_fname
    FROM employees
    WHERE employee_id = 100;
    DBMS_OUTPUT.PUT_LINE('The first name of the eployee is: '||v_fname); -- server must ON
END;

SELECT FIRST_NAME 
FROM EMPLOYEES 
WHERE EMPLOYEE_ID =100;

--Declaring varaibles in PL/SQL
/*--Temporary storage of data 
--reusability
--Manipulation of the stored values */

--identifiers
/*-- the names that you give to the variables are called identifiers eg:v_fname
--Must start with a letter
--can include numbers 
--special chars like $,#,_
--shouldnt exceed more than 30 chars
--name of the varaible should not be a reserved word (begin,insert,update..etc)

--usage of variables
/* 1) you can declare variables in declaration block
2) assigned a value to a varaible in declaration or executable block
3) pass the parameters using variables
4) you can also use varaibles to print output */

declare
    myname varchar2(20);
begin
    dbms_output.put_line('My name is :' || myname);
    myname := 'John'; -- := Assignment operator <--------------------------------------------
    dbms_output.put_line('My name is : '||myname);
end;

--reusability
declare
    myname varchar2(20) :='John';
begin
    dbms_output.put_line('My name is :' || myname);
    myname := 'Steve';
    dbms_output.put_line('My name is : '||myname);
end;

--example for delimiters with strings
declare
    event varchar2(15);
begin 
    event := q'!Father's day!'; -- q'!...!' <----------------------------------
    dbms_output.put_line('3rd sunday in june is :' ||  event);
    event := q'!Mother's day!';
    dbms_output.put_line('2nd sunday in May is :'||event);
end;

--Types of Variables 
/*
--PL/SQL Variables
1. Scalar : which holds single value
--data types for scalar(char,number,date,decimal,Bool)
2. composite : which holds multiple values(ex:record type;table type etc)
--(%rowtype;%type,PL/SQL Record;index by tables etc)
3. Referance : called pointers (ex:cursors)
--(implict curosr; explicit cursor)
4. LOB(Large object type) (ex:images;video;audio;docs etc)

--Non-PL/SQL variables 
1. Bind variables 
*/

--Scalar -- normal variables
declare 
    v_employee_id number(10);
begin
    select employee_id 
    into v_employee_id
    from employees
    where last_name ='Kochhar';
    dbms_output.put_line(v_employee_id);
end;

--Bind variables: global variables
/* 
1)created in the environment 
2) all called them as host varaibles
3) use VARAIBLE KEYWORD to create them
4) use PRINT stmt to print the bind varaible
5) used in SQL stmts
6) accessed even after the PL/SQL blcok is executed

-- for bind variable we dont have to define size of number ex number(5) else use only number but works normally in normal variables
*/

set autoprint on -- executes only once to print bind variables automatically

variable emp_sal number

begin 
    select salary into :emp_sal -- use :variable_name to refer bind variable
    from employees
    where employee_id = 200;
end;

print emp_sal

select first_name,last_name,salary
from employees
where salary = :emp_sal;

--substitution variables 
declare
    empno number(6):= &empno;
begin
    select salary  into :emp_sal
    from employees 
    where employee_id = empno;
end;

--prompt for substitution variable
ACCEPT empno PROMPT 'Please enter a vild employee id: ' -- custom msg for prompt
declare
    empno number(6):= &empno;
begin
    select salary  into :emp_sal
    from employees 
    where employee_id = empno;
end;

--Define 
define lname = Urman;
declare
    fname varchar2(24);
begin 
    select first_name into fname 
    from employees
    where last_name ='&lname';
    dbms_output.put_line(fname);
end;

--practice
ACCEPT num1 PROMPT 'Please enter first number: ';
ACCEPT num2 PROMPT 'Please enter second number: ';

DECLARE
    num1 number;
    num2 number;
    tot number;
BEGIN
    select &num1 + &num2 into tot
    from dual;
    dbms_output.put_line('Total is :' || tot);
END;

--practice
ACCEPT radius PROMPT 'Please enter radius: ';

DECLARE
    radius number(4,2) := &radius;
BEGIN
    dbms_output.put_line('Area of circle is :' || (radius * radius * 3.14) );
END;

--Nested blocks
declare 
    o_var varchar2(20) :='Global variiable';
begin
    declare 
        in_var varchar2(20) :='Local variable';
    begin
        dbms_output.put_line(in_var);
        dbms_output.put_line(o_var);
    end;
    dbms_output.put_line(o_var);
end;

--variable scope 
declare 
    father_name varchar2(20):= 'Patrick';
    date_of_birth date := '20-Apr-1973';
begin 
    declare
        child_name varchar2(10) := 'Mike';
        date_of_birth date := '1-Dec-2002';
    begin
        dbms_output.put_line('Fathers name:'||father_name);
        dbms_output.put_line('date of birth:'||date_of_birth);
        dbms_output.put_line('child name:'|| child_name);
    end;
    dbms_output.put_line('date of birth:' ||date_of_birth);
end;

begin <<outer>> -- for naming the block
declare 
    father_name varchar2(20):= 'Patrick';
    date_of_birth date := '20-Apr-1973';
begin 
    declare
        child_name varchar2(10) := 'Mike';
        date_of_birth date := '1-Dec-2002';
    begin
        dbms_output.put_line('Fathers name:'||father_name);
        dbms_output.put_line('date of birth:'||outer.date_of_birth);
        dbms_output.put_line('child name:'|| child_name);
        dbms_output.put_line('date of birth:' ||date_of_birth);
    end;
end;
end outer;

--using sequences in PL/SQL block
create SEQUENCE my_seq
increment by 1
start with 1;

declare 
    v_new number(10);
begin
    v_new := my_seq.nextval;
    dbms_output.put_line(v_new);
    dbms_output.put_line(my_seq.nextval);
end;


--%type attribute 
declare 
    emp_sal employees.salary%type;
    emp_hiredate employees.hire_date%type;
begin
    select hire_date,salary
    into emp_hiredate,emp_sal
    from employees
    where employee_id = 100;
    dbms_output.put_line(emp_sal || ' '|| emp_hiredate);
end;

--group functions in PL/SQL
declare 
    sumsal number (10,2);
    deptno number(8) not null :=60;
begin
    select sum(salary) -- group functions
    into sumsal 
    from employees
    where department_id = deptno;
    dbms_output.put_line('The sum of salary is: '||sumsal);
end;

--DML (Insert;Update;Delete)
--insert 
begin
insert into copy_emp(emp_id,f_name,salary) 
values(121,'Mike',2900);
end;

select * from copy_emp;

--update 
declare 
    sal_in copy_emp.salary%type:= 1000;
begin 
    update copy_emp
    set salary = salary+sal_in
    where emp_id = 121;
end;

--delete 
declare
    empid  copy_emp.emp_id%type:=120;
begin
    delete from copy_emp
    where emp_id = empid;
end;

--Merging rows
--copy_emp:emp_id,f_name,salary,email,department_id,job_id
begin 
    merge into copy_emp c
    using employees e
    on(e.employee_id = c.emp_id)
    when matched then
    update set 
    c.f_name = e.first_name,
    c.salary = e.salary,
    c.email = e.email,
    c.department_id = e.department_id,
    c.job_id = e.job_id
    when not matched then
    insert values (e.employee_id,e.first_name,e.last_name,e.salary,e.email,e.department_id,e.job_id); -- it must matched with destination table columns 
end;

select * from employees
where first_name is null;

update employees 
set first_name ='abc'
where employee_id = 250;

select * from copy_emp;

--curosor : pointer to a memory locations in the database storage 
--types of cursors
/* 1. implicit cursor
2. explict cursor*/

--implicit cursor
--attributes 
/* 1. SQL%FOUND
2.SQL%NOTFOUND
3.SQL%ROWCOUNT*/

variable rows_deleted varchar2(20);

declare
    empno copy_emp.emp_id%type :=121;
begin
    delete from copy_emp
    where emp_id =empno;
    :rows_deleted := (SQL%ROWCOUNT || ' row deleted');
end;

print rows_deleted;

















