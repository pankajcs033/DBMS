set serveroutput on

--if
declare
     my_age number := 13;
begin 
    if my_age < 11
    then 
        dbms_output.put_line('I am a child');
    end if;
end;

--if-else
declare
     my_age number := 13;
begin 
    if my_age < 11
    then 
        dbms_output.put_line('I am a child');
    else
        dbms_output.put_line(' I am not a child');
    end if;
end;


--null values in the IF stmt
declare
     my_age number;
begin 
    if my_age < 11
    then 
        dbms_output.put_line('I am a child');
    else
        dbms_output.put_line(' I am not a child');
    end if;
end;

--CASE Expression in PL/SQL
declare 
    grade char(1) := upper('&grade');
    appraisal varchar2(20);
begin
    appraisal :=
    case grade 
        when 'A' then 'Excellent'
        when 'B' then 'Very Good'
        when 'C' then 'Good'
        else 'No such grade'
    end;
dbms_output.put_line('Grade: ' ||grade||'Appraisal: '||appraisal);
end;

--searched case expression
declare 
    grade char(1) := upper('&grade');
    appraisal varchar2(20);
begin
    appraisal :=
    case  
        when grade = 'A' then 'Excellent'
        when grade in ('B', 'C') then 'Good'
        else 'No such grade'
    end;
dbms_output.put_line('Grade: ' ||grade||' Appraisal: '||appraisal);
end;

--Loops 
/*
1. Basic loop
2. For loop
3. While loop
*/

--Basic loop
declare 
    countryid locations.country_id%type := 'CA';
    loc_id locations.location_id%type;
    counter number(2) :=1;
    new_city locations.city%type := 'Monteral';
begin 
    select max(location_id) into loc_id 
    from locations
    where country_id = countryid;
    Loop
        insert into locations(location_id,city,country_id)
        values((loc_id+counter),new_city,countryid);
        counter := counter + 1;
    exit when counter > 3;
    end loop;
end;

select * from locations
where country_id ='CA';

--while loop
declare 
    countryid locations.country_id%type := 'CA';
    loc_id locations.location_id%type;
    counter number(2) :=1;
    new_city locations.city%type := 'xyz';
begin 
    select max(location_id) into loc_id 
    from locations
    where country_id = countryid;
    while counter <= 3 loop
        insert into locations(location_id,city,country_id)
        values((loc_id+counter),new_city,countryid);
        counter := counter + 1;
    end loop;
end;

--For loop
--when we know the number of iterartions
--define the counter value to know the number of iterations
--lower_bound .. upper_bound
declare 
    countryid locations.country_id%type := 'CA';
    loc_id locations.location_id%type;
    --counter number(2) :=1;
    new_city locations.city%type := 'abc';
begin
     select max(location_id) into loc_id 
    from locations
    where country_id = countryid;
for i in 1..3 loop
    insert into locations(location_id,city,country_id)
    values((loc_id+i),new_city,countryid);
        --counter := counter + 1;
end loop;
end;

--practice
--greatest of two
declare
    num1 number := &num1;
    num2 number := &num2;
begin
    if num1 > num2
    then 
        dbms_output.put_line('Number 1 is greater');
    else
        dbms_output.put_line('Number 2 is greater');
    end if;
end;

--print 10 numbers seq.
declare
    num number := &num;
begin
    for i in num..num+10 loop
        dbms_output.put_line(i);
    end loop;
end;

set autoprint on
variable row_count varchar2(20);
declare 
    e_id copy_emp.emp_id%type := 124;
    
begin
    delete from copy_emp
    where emp_id = e_id;
    :row_count := (SQL%ROWCOUNT || ' : rows deleted');
end;

declare 
    v_rows_deleted varchar2(20);
    v_empno copy_emp.emp_id % type := 152;
BEGIN
  DELETE FROM copy_emp
  WHERE emp_id = v_empno;
 
  IF SQL%FOUND THEN
    DBMS_OUTPUT.PUT_LINE (
      'Delete succeeded:  ' ||v_empno
    );
  ELSE
    DBMS_OUTPUT.PUT_LINE ('No such employee number: ' || v_empno);
  END IF;
END;

--Composite 
declare
    type trec is record
    (
        v_fname employees.first_name%type,
        v_sal number(8),
        v_hire_date employees.hire_date%type
    );
    v_myrec trec;
Begin 
    select first_name,salary,hire_date into v_myrec
    from employees 
    where employee_id =100;
    dbms_output.put_line('First Name: '||v_myrec.v_fname||'Salary:' ||v_myrec.v_sal||'Hire date:' || v_myrec.v_hire_date);
end;

declare
    type t_rec is record
    (
        v_sal number(8),
        v_minsal number(8) default 1000,
        v_hiredate employees.hire_date%type,
        v_rec1 employees%rowtype
    );
    v_myrec t_rec;
begin
    v_myrec.v_sal := v_myrec.v_minsal + 500;
    v_myrec.v_hiredate := sysdate;
    select * into v_myrec.v_rec1
    from employees
    where employee_id = 100;
    dbms_output.put_line(v_myrec.v_rec1.last_name||' '||v_myrec.v_hiredate||' '||v_myrec.v_sal);
end;

--example for %rowtype 
declare
    v_empno number :=124;
    v_emp_rec employees%rowtype;
begin 
    select * into v_emp_rec 
    from employees
    where employee_id = v_empno;
    insert into copy_emp(emp_id,f_name,salary,email,department_id,job_id)
    values
    (
        v_emp_rec.employee_id,
        v_emp_rec.first_name,
        v_emp_rec.salary,
        v_emp_rec.email,
        v_emp_rec.department_id,
        v_emp_rec.job_id
    );
end;

select * from copy_emp;

-- coping record and then save into table
declare
    v_empno number:= 124;
    v_emp_rec copy_emp%rowtype;
begin
    select * into v_emp_rec 
    from copy_emp
    where emp_id =v_empno;
    update copy_emp set row = v_emp_rec
    where emp_id = v_empno;
end;
    
select * from employees;

--Index by ( Associative arrays)
-- single dimensional array 
--Index(unique key) ; value pair 
--upto 2GB
declare 
    type email_data is table of employees.email%type index by pls_integer;
    --pl_integer;binary_integer
    email_list email_data;
begin
    email_list(100) := 'sking';
    email_list(105) := 'Dustin';
    email_list(110) := 'Bhavani';
    dbms_output.put_line(email_list(100));
    dbms_output.put_line(email_list(105));
    dbms_output.put_line(email_list(110));
end;

declare 
    type email_data is table of employees.email%type index by VARCHAR2(20);
    --pl_integer;binary_integer
    email_list email_data;
begin
    email_list('A') := 'sking';
    email_list('B') := 'Dustin';
    email_list('C') := 'Bhavani';
    dbms_output.put_line(email_list('A'));
    dbms_output.put_line(email_list('B'));
    dbms_output.put_line(email_list('C'));
end;

declare 
    type email_table is table of employees.email%type index by pls_integer;
    email_list email_table;
begin
    email_list(100) := 'Sking';
    email_list(105) := 'Dustin';
    email_list(110) := 'Bhavani';
    dbms_output.put_line('The number of elements in the list'|| email_list.count);
    dbms_output.put_line('The first index in the list '||email_list.first);
    dbms_output.put_line('The last index in the list '||email_list.last);
end;

--index by methods with  for loop
declare
    type emp_table_type is table of employees%rowtype index by pls_integer;
    myemp_table emp_table_type;
    max_count number(10):= 104;
begin
    for i in 100..max_count
    loop
        select * into myemp_table(i)
        from employees
        where employee_id = i;
    end loop;
    for i in myemp_table.first..myemp_table.last
    loop
    dbms_output.put_line(myemp_table(i).last_name);
    end loop;
end;

--nested tables 
-- upto 2GB
declare
    type dept_mail is table of varchar2(20);
    mails dept_mail := dept_mail('sking','Bhavani','Steven','Mark');
begin
    for i in mails.first..mails.last
    loop
    dbms_output.put_line(mails(i));
    end loop;
end;

--VARRAY or Variable-sized array 
-- 2 GB
declare 
    type emp_email is varray(7) of varchar2(20);
    mails emp_email := emp_email('Bhavani','Mark','Seteve','Fan','Fredy','Adi','Pranjal');
begin
    for i in mails.first..mails.last
    loop
    dbms_output.put_line(mails(i));
    end loop;
end;

--1. declare the cursor
--2. open the curson
--3. fetch the data
--4. close the cursor
--cursor with %type attribute
declare
    cursor emp_cur is 
    select employee_id,last_name
    from employees 
    where department_id = 30;
    empno employees.employee_id%type;
    lname employees.last_name%type;
begin 
    open emp_cur;
    loop
        fetch emp_cur into empno,lname;
        exit when emp_cur%notfound;
        dbms_output.put_line(empno ||' '||lname);
    end loop;
end;

--cursor with %rowtype attribute 
declare
    cursor emp_cur is 
    select employee_id,last_name
    from employees 
    where department_id = 30;
    emp_rec emp_cur%rowtype;
begin 
    open emp_cur;
    loop
        fetch emp_cur into emp_rec;
        exit when emp_cur%notfound;
        dbms_output.put_line(emp_rec.employee_id||' '||emp_rec.last_name);
    end loop;
end;

--cursor for loops 
declare 
    cursor emp_cur is 
    select employee_id,job_id 
    from employees
    where job_id ='SA_REP';
begin 
    for emp_rec in emp_cur
    loop
        dbms_output.put_line(emp_rec.employee_id||' '||emp_rec.job_id);
    end loop;
end;

--explicit cursor attributes
-- implicit cursor starts with SQL and explicit cursor starts with %
-- %isopen
-- %rowcount
-- %found
-- %notfound

declare
    cursor c_dept_cur is
    select department_id,department_name
    from departments;
    v_dept_rec c_dept_cur%rowtype;
begin
    open c_dept_cur;
    loop
        fetch c_dept_cur into v_dept_rec;
        exit when c_dept_cur%rowcount>15 or 
            c_dept_cur%notfound;
        dbms_output.put_line(v_dept_rec.department_id||' '||v_dept_rec.department_name);
    end loop;
end;

--curosor subquery using for loop
begin
    for emp_rec in (select employee_id,last_name
                    from employees 
                    where department_id = 10)
    loop
        dbms_output.put_line(emp_rec.employee_id||' '||emp_rec.last_name);
    end loop;
end;

--cursor with parameters --using cursor multiple times
declare
    cursor c_emp_cur(deptno number)
    is
    select employee_id,last_name
    from employees
    where department_id = deptno;
    v_empno employees.employee_id%type;
    v_lname employees.last_name%type;
begin 
    open c_emp_cur(30);
    loop
        fetch c_emp_cur into v_empno,v_lname;
        exit when c_emp_cur%notfound;
        dbms_output.put_line(v_empno||' '||v_lname);
    end loop;
    close c_emp_cur;
    dbms_output.put_line('Opening the cursor for the second time');
    open c_emp_cur(50);
    loop
        fetch c_emp_cur into v_empno,v_lname;
        exit when c_emp_cur%notfound;
        dbms_output.put_line(v_empno||' '||v_lname);
    end loop;
    close c_emp_cur;
end;

select employee_id,salary
from employees
where department_id = 30;

--where current of clause example
-- jumps directly to 30 and starts updating
declare 
    cursor c_emp_cur is
    select employee_id,salary
    from employees
    where department_id = 30 for update;
begin
    for emp_rec in c_emp_cur
    loop
        dbms_output.put_line(emp_rec.employee_id||'  '||emp_rec.salary);
        update employees 
        set salary = 50000
        where current of c_emp_cur;
    end loop;
end;

rollback;
