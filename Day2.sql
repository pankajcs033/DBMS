--functions
--1. Single-row (one input, one output)
--2. Multi-row (multiple input, one output)

--Single-row functions -- aggregate function -- group function -- they eleminates null values
--char;number;date;general;conversion 

--Char functions 
--1. Case-conversion functions(upper,lower,initcap) 
--upper();lower()
select last_name,upper(last_name) name, job_id,lower(job_id) job
from employees
where department_id = 50;

select last_name,first_name 
from employees 
where last_name='grant';

select last_name,first_name 
from employees 
where lower(last_name)='grant';

--2. Char-Manipulation functions(concat;substr;length;instr;lpad;rpad;trim;replace)
--concat()
select concat('hello','world') from dual; -- index starts from 1

--substr()
select substr('Hello WOrld',1,5) from dual;
select substr('Hello WOrld',5) from dual;

--Length()
select length('Hello WOrld') from dual;

--instr() inside string
select instr('Hello WOrld','W') from dual;

--lpad()
select salary,lpad(salary,10,'#') as sal
from employees;

--Rpad()
select salary,Rpad(salary,10,'#') as sal
from employees;

select last_name,concat('job category is  ', job_id) as Job 
from employees
where substr(job_id,4) ='REP';

select employee_id,concat(first_name,last_name) Name,length(last_name),instr(last_name,'a') "Contains a?"
from employees
where substr(last_name,-3,2) = 'nd'

--Nesting functions
select last_name,
upper(concat(substr(last_name,1,8),'_UK')) EMP_name_uk
from employees;

--Number functions (round;trunc;ceil;mod;floor)
select round(48.926,2) from dual;

select trunc(45.926,2) from dual;

select mod(1600,300) from dual;

select floor(2.83) from dual;

select ceil(2.83) from dual;

select round(45.923,-1) from dual; -- in case of -1 it goes before the point value and than roundoff <= 5 goes towards lower else higher
select round(48.923,-1) from dual;
select round(42.923,-1) from dual;

select trunc(45.923,2),trunc(45.923,1),trunc(45.923,-1) -- always goes lower
from dual;

select trunc(45.923,-1) from dual;
select trunc(48.923,-1) from dual;
select trunc(42.923,-1) from dual;

--Date()
--default date format is :DD-MON-RR
--yy --Previous 
--RR --current 

select first_name,hire_date
from employees
where hire_date < '01-Feb-2013';

select sysdate from dual;

select sessiontimezone,current_date,current_timestamp from dual;

select last_name,round((sysdate-hire_date)/7,1) as weeks
from employees;

--Months_between();add_months();next_day(),last_day()

select months_between(sysdate,'11-jan-20') from dual;

select add_months(sysdate,6) from dual;

select next_day('01-jul-22','Friday') from dual; -- next friday from current date

select last_day('15-jul-22') from dual; -- last day on current month

--round();Trunc() with dates
select round(sysdate,'day') from dual; -- roundoff week
select round(sysdate,'month') from dual; -- roundoff month
select round(sysdate,'year') from dual; -- roundoff year

select trunc(sysdate,'month') from dual;
select trunc(sysdate,'year') from dual;

--conversion functions ()
--implict 
select last_name,department_id 
from employees
where department_id < concat('9','0');

select first_name,salary
from employees
where instr(salary,'5') > 0; -- implicitly converted 0 into string '0'

--explict function : to_char;to_date;to_number
--to_char()

select employee_id,hire_date,to_char(hire_date,'MM/YY') month_year
from employees
where department_id = 50;

--yyyy ;year; mm;yy;month;mon;day;dy;dd
--HH24:MI:SS AM  1:40:23 AM

--converting from date to string
select first_name,
to_char(hire_date,'dd Month yyyy') as hirdedate
from employees;

--converting from number to string
select salary,to_char(salary,'$99,999.00') as salary_usd -- any number can be represent by 9
from employees;

--display all the employees who got hired before 2010
select first_name,hire_date,to_char(hire_date,'DD-Mon-YYYY') as hiredate
from employees 
where hire_date < to_date('01 Jan,10','DD Mon,RR') 

--cast():converts from one data type to another.
select first_name,last_name,department_id 
from employees
where department_id < cast(concat('9','0') as decimal(2,0));

select first_name,last_name,salary
from employees
where instr(cast(salary as varchar2(30)),'5') >0;

select first_name,last_name,salary
from employees
where instr(cast(salary as varchar2(30)),'5') =2;
from employees 
where hire_date < to_date('01 Jan,10','DD Mon,RR') 


--General Functions 
--NVL();NVL2();NULLIF(),COALESCE()
--nvl(arg1,agr2)
--accpets only two arguments 
select last_name,commission_pct,nvl(commission_pct,0) comm
from employees;

-- NVL() -- if arg1 == null put arg2
select 
last_name,salary,nvl(commission_pct,0),(salary*12) +(salary*12*nvl(commission_pct,0)) as annual_salary
from employees;

--nvl2(agr1,agr2,agr3) -- if arg1 == null goes to arg3 else arg2
select 
last_name,salary,commission_pct,nvl2(commission_pct,'sal+comm','sal') income
from employees;

--nullif() --if arg1 == arg2 than it returns null
select 
first_name,length(first_name) exp1,last_name,length(last_name) exp2,
nullif(length(first_name),length(last_name)) as result
from employees

--COALESCE(arg1,arg2,arg3....agrn) -- calculates every argument until gets not null value -- must have one not null value
select first_name,salary,commission_pct,
coalesce(salary+(commission_pct*salary),salary+1000) as sal
from employees 

--CASE and Decode 

--case function

select last_name,salary,
case when salary <5000 then 'Low'
     when salary <10000 then 'Medium'
     when salary <20000 then 'Good'
else 'Excellent'
end as sal_info
from employees;

--80 sales;90 hr ;50 training; else marketing 
select last_name,salary,department_id,
case when department_id = 80 then 'Sales'
     when department_id = 90 then 'Hr'
     when department_id = 50 then 'Training'
else 'Marketing'
end as department_name
from employees;

--80 sales;90 hr ;50 training; else marketing

select first_name, salary, department_id,
case department_id 
    when '80' then 'sales'
    when '90' then 'hr'
    when '50' then 'training'
    else 'marketing'
end
from employees;

--decode()
select last_name,job_id,salary,
decode (job_id, 'IT_PROG', 1.10*salary,
                 'ST_CLERK',1.15*salary,
                 'SA_REP',1.20*salary,
                 salary) revised_sal
from employees;

--Monthly Salary Range		Tax Rate	
--$0.00–1,999.99		00%	
--$2,000.00–3,999.99		09%	
--$4,000.00–5,999.99		20%	
--$6,000.00–7,999.99		30%	
--$8,000.00–9,999.99		40%	
--$10,000.00–11,999.99		42%	
--$12,200.00–13,999.99		44%	
--$14,000.00 or greater		45%

select first_name, salary,
decode (salary, (between '0.00' and '1999.99'), 0.0,
                (between '2000' and '3999.99'), .09,
                (between '4000' and '5999.99'), .2,
                (between '6000' and '7999.99'), .3,
                (between '8000' and '9999.99'), .4,
                (between '10000' and '11999.99'), .42,
                (between '12200' and '13999.99'), .44,
                .45) as 'Tax(%)'
from employees
where department_id = 80;


SELECT last_name, salary,
       DECODE (TRUNC(salary/2000, 0),
                         0, 0.00,
                         1, 0.09,
                         2, 0.20,
                         3, 0.30,
                         4, 0.40,
                         5, 0.42,
                         6, 0.44,
                            0.45) TAX_RATE
FROM   employees
WHERE  department_id = 80;


--=========================================================================
--=========================================================================




--if aggregate and non-aggregate both are present in select list than non-aggregate column must present in group by clause
--we do not apply goup by on primary keys




--in having clause we must have column with aggregate function
--if we have group by and having both clause then group by comes first
--order by must always be last clause
--if we have nested group function than must add group by function

--when we have more than one common column then we use using clause

--if internal query return empty then outer query will also returns empty

--Group functions (avg,sum,min,max,count)
select round(avg(salary),2),min(salary),max(salary),sum(salary) 
from employees;

select min(first_name),max(first_name)
from employees;

--count returns only non-null values
select count(commission_pct) from employees;
--gives the total number of records from a table
select count(*) from employees;

select count(distinct department_id) from employees;

select round(avg(commission_pct),2) from employees;

select avg(nvl(commission_pct,0)) from employees;

--group by clause 
select manager_id,department_id,avg(salary) avg_sal
from employees 
group by department_id,manager_id;

select avg(salary) avg_sal
from employees
group by manager_id;

--having clause
select avg(salary) avg_sal,department_id
from employees
group by department_id
having avg(salary) > 2500;

select avg(salary) avg_sal
from employees
having avg(salary) >5000
group by department_id;

--order of claues 
select job_id,sum(salary) as sum_sal
from employees
where job_id in ('IT_PROG','SA_REP','ST_CLERK')
group by job_id
having sum(salary) >5000
order by sum_sal desc;

--nesting group functions 

select max(avg(salary)) as sal
from employees
group by department_id;

select avg(salary),department_id
from employees
group by department_id
having avg(salary) >= 19333


--Joins 
--Types of joins in oracle database
--1.Inner joins(Natural joins); 2. cross join; 3. self join; 4.outer joins(LOJ;ROJ;FOJ)

--Natural joins -- no need to mention column name
select first_name,employee_id,job_id,job_title 
from employees natural join jobs;

--using clause 
select employee_id,last_name
from employees join departments
using (department_id);

select employee_id,last_name
from employees join departments
using (manager_id);


select employee_id,last_name,manager_id,department_id
from employees join departments
using (manager_id,department_id);

--Qualifying Ambiguous Column Names
select d.department_id,e.employee_id
from employees e join departments d
on(d.department_id = e.department_id)

select d.department_id,e.employee_id
from employees e join departments d
on(d.manager_id = e.manager_id);

--3 table join
select employee_id,department_name,city
from employees e join departments d 
on(e.department_id = d.department_id)
join locations l
on(l.location_id = d.location_id)



select employee_id,department_name
from employees  join departments  
on(employees.department_id = departments.department_id)

--additional condition 
--and;or;where
select employee_id,department_name
from employees e join departments  d
on(e.department_id = d.department_id)
and d.department_id = 90;

select employee_id,department_name
from employees e join departments  d
on(e.department_id = d.department_id)
where d.department_id = 90;

--self join  -- check for similarity in table
select manager_id,employee_id
from employees;

select mgr.last_name,emp.last_name
from employees emp join employees mgr
on(emp.manager_id = mgr.employee_id);

--outer joins (LOJ;ROJ;FOJ)
--mathced data + unmatched 
--LOJ
select employee_id,department_name
from employees e left outer join departments d 
on(e.department_id = d.department_id);

--ROJ
select employee_id,department_name
from employees e right outer join departments d 
on(e.department_id = d.department_id);

--FOJ
select employee_id,department_name
from employees e full outer join departments d 
on(e.department_id = d.department_id);

--cross join 
-- 2 * 3 = 6
select count(*) from departments;

select count(*) from employees;

select 27*107 from dual;

select first_name,department_name
from employees cross join departments


--subquery : query with in a query or nested query
--1. single row and 2. multi row 

select salary,first_name,last_name
from employees
order by last_name ;

select salary 
from employees
where first_name = 'Alexis'

select salary,first_name
from employees
where salary > 4100;

--1. single row subquery(=,<>,<,>,<=,>=)
select first_name,salary
from employees
where salary > (select salary
                from employees
                where first_name = 'Alexis')

select last_name,hire_date
from employees
where hire_date > (select hire_date
                    from employees
                    where last_name ='Davies')

--2.Multi row subquery (IN,ANY,ALL)
--ANY
select employee_id,last_name,job_id,salary
from employees
where salary < ANY (select salary
                    from employees
                    where job_id ='IT_PROG') --4200; 6000;9000
and job_id <> 'IT_PROG';

select employee_id,last_name,job_id,salary
from employees
where salary > ANY (select salary
                    from employees
                    where job_id ='IT_PROG') --4200; 6000;9000
and job_id <> 'IT_PROG';

--ALL
select employee_id,last_name,job_id,salary
from employees
where salary > ALL (select salary
                    from employees
                    where job_id ='IT_PROG') --4200; 6000;9000
and job_id <> 'IT_PROG';

select employee_id,last_name,job_id,salary
from employees
where salary < ALL (select salary
                    from employees
                    where job_id ='IT_PROG') --4200; 6000;9000
and job_id <> 'IT_PROG';

--IN with multi column
--display all employees whose is earning lowest salary
select first_name,department_id,salary
from employees
where (salary,department_id) IN (select min(salary),department_id
                                from employees
                                group by department_id)
order by department_id;






