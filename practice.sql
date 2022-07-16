
1) Display the first name and join date of the employees who joined between 2002 and 2005. 
select first_name, hire_date
from employees
where to_char(hire_date,'YYYY') between 2002 and 2005;

2) Display employees who joined in the month of May. 
select first_name, hire_date
from employees
where to_char(hire_date,'Mon') = 'May';

3) Display first name and experience of the employees.
select first_name, hire_date, round(((sysdate - hire_date)/365),0) Year_of_Experience
from employees

4) Display first name of employees who joined in 2001.
select first_name, hire_date
from employees
where to_char(hire_date,'YYYY') = 2001;

5) Display first name and last name after converting the first letter of each name to upper case and the rest to lower case.
select upper(substr(first_name,1,1)) || lower(substr(first_name, 2)) FirstName, upper(substr(last_name,1,1)) || lower(substr(last_name, 2)) LastName
from employees

6) Display first name in upper Case and email address in lower Case for employees where the first name and 
email address are same irrespective of the case.
select upper(first_name) FirstName, lower(email) Email
from employees
where lower(first_name) = lower(email)

7) Display number of employees joined after 15th of the month.
select count(*)
from employees
where to_char(hire_date,'DD') > 15;

8) Display job ID, number of employees, sum of salary, and difference between highest salary and 
lowest salary of the employees of the job.
select job_id, count(*), sum(salary), max(salary) - min(salary) salary_difference
from employees
group by job_id

9) Display departments in which more than five employees have commission percentage.
select department_id
from employees
group by department_id
having sum(nvl(commission_pct,0)) > 0

10) Display department name, manager name, and City.
select d.department_name Department_Name, e.first_name || ' ' || e.last_name Manager_Name, l.city City
from departments d, employees e, locations l
where d.manager_id = e.employee_id and d.location_id = l.location_id

--Display the first name and join date of the employees who joined between 2002 and 2005. 
SELECT FIRST_NAME, HIRE_DATE 
FROM EMPLOYEES 
WHERE TO_CHAR (HIRE_DATE, 'YYYY') BETWEEN 2002 AND 2005 
ORDER BY HIRE_DATE

--Display employees who joined in the month of May. 

SELECT * FROM EMPLOYEES 
WHERE TO_CHAR (HIRE_DATE,'MON') = 'MAY'

--Display first name and experience of the employees. 
SELECT FIRST_NAME, HIRE_DATE, FLOOR((SYSDATE-HIRE_DATE)/365) 
FROM EMPLOYEES

--Display first name of employees who joined in 2001. 
SELECT FIRST_NAME, HIRE_DATE 
FROM EMPLOYEES 
WHERE TO_CHAR (HIRE_DATE,'yyyy') =2001

--Display first name and last name after converting the first letter of each name to upper case and the rest to lower case.
SELECT INITCAP(FIRST_NAME), INITCAP(LAST_NAME) FROM EMPLOYEES

--Display first name in upper Case and email address in lower Case for employees where 
--the first name and email address are same irrespective of the case.
SELECT UPPER(FIRST_NAME), LOWER(EMAIL) 
FROM EMPLOYEES 
WHERE UPPER(FIRST_NAME) = UPPER(EMAIL)

--Display number of employees joined after 15th of the month.
SELECT COUNT (*) FROM EMPLOYEES 
WHERE TO_CHAR(HIRE_DATE,'DD') > 15

--Display job ID, number of employees, sum of salary, and difference between highest 
--salary and lowest salary of the employees of the job.
SELECT JOB_ID, COUNT (*), SUM(SALARY), MAX(SALARY), MIN(SALARY) SALARY 
FROM EMPLOYEES 
ORDER BY JOB_ID

--Display departments in which more than five employees have commission percentage.
SELECT DEPARTMENT_ID 
FROM EMPLOYEES 
WHERE COMMISSION_PCT IS NOT NULL 
GROUP BY DEPARTMENT_ID 
HAVING COUNT(COMMISSION_PCT)>5

--Display department name, manager name, and City.
SELECT DEPARTMENT_NAME, FIRST_NAME, CITY 
FROM DEPARTMENTS D JOIN EMPLOYEES E 
ON (D. MANAGER_ID=E.EMPLOYEE_ID) JOIN LOCATIONS L USING (LOCATION_ID)


